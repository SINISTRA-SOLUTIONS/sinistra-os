#!/bin/sh
# =============================================================================
# Motor de imagem do Sinistra OS: Node LTS + Chromium headless. macOS.
#
# Roda como usuario comum. Nao usa sudo, nao usa Homebrew, nao escreve em
# /usr/local. Tudo mora em ~/.sinistra/runtime, fora da pasta do cliente, pra
# atualizacao nunca encostar e uma segunda pasta reaproveitar.
#
# Chamado pelo /instalar. Nao e' pra rodar na mao.
# =============================================================================
set -eu

RAIZ="$HOME/.sinistra/runtime"
NODE_DIR="$RAIZ/node"
BRW_DIR="$RAIZ/browsers"
TMP="$RAIZ/.tmp"

# --- 0. Piso de versao -------------------------------------------------------
# O Playwright exige macOS 14 (Sonoma) ou mais novo, e o install falha com erro
# explicito abaixo disso, nao degrada. Melhor falhar aqui do que no primeiro
# carrossel. (O Node 24 tambem so' tem alvo a partir do 13.5.)
OSV="$(sw_vers -productVersion)"
case "${OSV%%.*}" in
  1[4-9]|[2-9][0-9]) : ;;
  *) echo "SINISTRA-RUNTIME: MACOS-ANTIGO $OSV"; exit 2 ;;
esac

mkdir -p "$RAIZ" "$NODE_DIR" "$BRW_DIR" "$TMP"

# --- 1. Arquitetura, a prova de Rosetta --------------------------------------
# `uname -m` mente sob Rosetta: devolve x86_64 num Apple Silicon, e ai o Node
# baixado seria o errado. O sysctl.proc_translated e' documentado pela Apple:
# 0 = nativo, 1 = traduzido.
TRAD="$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)"
if [ "$(uname -m)" = "arm64" ] || [ "$TRAD" = "1" ]; then ARCH="arm64"; else ARCH="x64"; fi

# --- 2. Achar a ultima LTS ---------------------------------------------------
# Nao existe endereco fixo de "ultima LTS": /dist/latest e' a Current e
# /dist/latest-lts da 404. O index.tab traz o campo lts na coluna 10, com "-"
# quando nao e' LTS. Usa awk porque o macOS nao vem com jq.
VER="$(curl -fsSL https://nodejs.org/dist/index.tab \
  | awk -F'\t' 'NR>1 && $10 != "-" { print $1; exit }')"
[ -n "$VER" ] || { echo "SINISTRA-RUNTIME: LTS-NAO-ENCONTRADA"; exit 3; }

BASE="https://nodejs.org/dist/${VER}"
TARBALL="node-${VER}-darwin-${ARCH}.tar.gz"

cd "$TMP"

# --- 3. Baixar ---------------------------------------------------------------
# Baixar por curl e' o que mantem o Gatekeeper fora do caminho: quem marca
# arquivo com quarentena e' quem baixa por navegador, nao o curl. O binario do
# Node no tarball e' assinado mas NAO notarizado (so' o .pkg e'), entao se um
# dia isso virar download de navegador, o Mac passa a bloquear.
curl -fSL --retry 3 -o "$TARBALL" "${BASE}/${TARBALL}"
curl -fsSL -o SHASUMS256.txt "${BASE}/SHASUMS256.txt"

# --- 4. Conferir integridade -------------------------------------------------
# shasum vem no macOS. gpgv nao vem, por isso a conferencia e' de integridade,
# nao de autenticidade.
shasum -a 256 --check SHASUMS256.txt --ignore-missing >/dev/null 2>&1 \
  || { echo "SINISTRA-RUNTIME: CHECKSUM-NAO-BATE"; exit 3; }

# --- 5. Descompactar ---------------------------------------------------------
# bin/npm e bin/npx sao symlinks relativos, entao o pacote e' relocavel:
# funciona em qualquer pasta, sem instalador.
rm -rf "$NODE_DIR" && mkdir -p "$NODE_DIR"
tar -xzf "$TARBALL" -C "$NODE_DIR" --strip-components=1
cd "$RAIZ" && rm -rf "$TMP"

export PATH="$NODE_DIR/bin:$PATH"

# --- 6. Playwright, na raiz do runtime ---------------------------------------
# node_modules fica em ~/.sinistra/runtime/node_modules porque e' pra la' que o
# NODE_PATH do render.js aponta.
[ -f "$RAIZ/package.json" ] || printf '%s\n' '{ "name": "sinistra-runtime", "private": true }' > "$RAIZ/package.json"
npm install playwright --no-audit --no-fund --silent

# --- 7. So' o Chromium headless ----------------------------------------------
# --only-shell baixa so' o headless shell em vez do Chromium completo mais o
# shell. O render.js chama chromium.launch() sem `channel`, que e' a unica
# condicao pra isso funcionar. Nao usar --with-deps: no macOS nao faz nada.
export PLAYWRIGHT_BROWSERS_PATH="$BRW_DIR"
npx playwright install --only-shell chromium

# --- 8. Arquivo de ambiente --------------------------------------------------
# E' o que o /carrossel carrega antes de renderizar. $HOME fica literal de
# proposito: quem resolve e' o bash na hora de rodar.
cat > "$RAIZ/env.sh" <<'ENV'
# Ambiente do motor de imagem do Sinistra OS. Escrito na instalacao.
export PATH="$HOME/.sinistra/runtime/node/bin:$PATH"
export NODE_PATH="$HOME/.sinistra/runtime/node_modules"
export PLAYWRIGHT_BROWSERS_PATH="$HOME/.sinistra/runtime/browsers"
ENV

echo "SINISTRA-RUNTIME: OK $VER $ARCH"
