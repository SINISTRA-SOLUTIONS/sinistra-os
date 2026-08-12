#!/usr/bin/env bash
#
# Motor de atualizacao do Sinistra OS.
# Chamado pela skill /atualizar-sistema. Nao e pra ser rodado a mao pelo cliente.
#
#   bash .sinistra/atualizar.sh verificar   # so olha, nao escreve nada
#   bash .sinistra/atualizar.sh aplicar     # aplica a versao nova
#
# A logica inteira e lista branca: so encosta no que esta declarado em
# .sinistra/sistema.txt. Tudo que nao esta la e do cliente e nunca e tocado.
#
# Codigos de saida:
#   0  ok (em verificar: tem versao nova / em aplicar: aplicou)
#   1  ja esta na ultima versao
#   2  falha de ambiente ou de acesso (mensagem em ERRO=)
#
# A saida e feita pra ser lida pela skill, nao pelo cliente. Linhas no formato
# CHAVE=valor e blocos delimitados. A skill traduz pra portugues.

set -uo pipefail

# O Git Bash do Windows converte caminho depois de dois pontos em `git show
# <ref>:<caminho>`. Sem isso, todo git show falha.
export MSYS_NO_PATHCONV=1

MODO="${1:-verificar}"
REMOTE="sinistra"
MANIFESTO=".sinistra/sistema.txt"
ESTADO=".sinistra/estado.json"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Toda falha sai por aqui, com um codigo de referencia. A skill traduz o codigo
# numa mensagem em portugues e mostra a referencia pro cliente repassar pro
# suporte. A saida crua do git NUNCA vai pro cliente, porque a URL do remote
# carrega o token dentro dela.
morrer() {
  echo "ERRO=$1"
  exit 2
}

# --- Onde ficam os metadados do git ----------------------------------------
#
# A pasta do cliente NAO tem `.git` dentro dela, de proposito. Os metadados vivem
# fora, e o caminho esta gravado no estado.json.
#
# Motivo: o app do Claude cria um "worktree" automatico pra cada sessao nova
# quando a pasta e um repositorio git. Isso poe o trabalho numa copia isolada,
# num branch separado, e o cliente abre o Explorer e nao acha o carrossel que
# acabou de ser gerado. Sem `.git` na pasta, isso simplesmente nao acontece.
#
# O git continua funcionando normal, so precisa ser chamado apontando pros dois
# caminhos. E o que o GIT_DIR e o GIT_WORK_TREE fazem aqui.

GIT_DIR_SINISTRA="$(sed -n 's/.*"git_dir"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$ESTADO" 2>/dev/null | head -1)"

if [ -n "$GIT_DIR_SINISTRA" ]; then
  [ -d "$GIT_DIR_SINISTRA" ] || morrer "SETUP-02"
  export GIT_DIR="$GIT_DIR_SINISTRA"

  # O caminho da pasta tem que ir no formato que o git entende. No Git Bash do
  # Windows o $PWD sai como /c/Users/..., e o MSYS_NO_PATHCONV la de cima (que
  # existe por causa do `git show`) impede a conversao automatica. Resultado: o
  # git nao acha a pasta e acusa "nao e um repositorio", que e um erro que nao
  # tem nada a ver com o problema. O cygpath resolve; no Mac ele nao existe e o
  # $PWD ja serve.
  if command -v cygpath >/dev/null 2>&1; then
    export GIT_WORK_TREE="$(cygpath -m "$PWD")"
  else
    export GIT_WORK_TREE="$PWD"
  fi
fi

# Classifica a falha de rede a partir da mensagem do git, sem nunca imprimir a
# mensagem. E o que separa "sua internet caiu" de "teu acesso foi revogado".
classificar_falha_de_rede() {
  local log="$1"
  if grep -qiE "could not resolve host|couldn't resolve host|name or service not known" "$log"; then
    echo "REDE-01"
  elif grep -qiE "failed to connect|connection timed out|timed out|network is unreachable|operation timed out" "$log"; then
    echo "REDE-02"
  elif grep -qiE "authentication failed|invalid username or password|403|bad credentials|terminal prompts disabled|could not read username" "$log"; then
    echo "ACESSO-01"
  elif grep -qiE "repository not found|404|does not exist|access denied" "$log"; then
    echo "ACESSO-02"
  else
    echo "ACESSO-03"
  fi
}

# core.autocrlf do Windows deixa \r no fim das linhas, e ai regex de linha
# inteira nao casa. Tira comentario e linha vazia junto.
limpar_manifesto() {
  tr -d '\r' | sed 's/#.*//' | sed 's/[[:space:]]*$//' | grep -v '^$'
}

# --- Pre-checagem de ambiente ---------------------------------------------

command -v git >/dev/null 2>&1                        || morrer "SETUP-03"
git rev-parse --is-inside-work-tree >/dev/null 2>&1   || morrer "SETUP-02"
[ -f "$MANIFESTO" ]                                   || morrer "SETUP-04"
git remote get-url "$REMOTE" >/dev/null 2>&1          || morrer "SETUP-01"

# --- Busca ----------------------------------------------------------------
#
# GIT_TERMINAL_PROMPT=0 impede o git de travar esperando usuario e senha num
# terminal que o cliente nao esta olhando. A falha vira erro classificavel.

export GIT_TERMINAL_PROMPT=0

if ! git fetch --quiet "$REMOTE" 2>"$TMP/git-err"; then
  morrer "$(classificar_falha_de_rede "$TMP/git-err")"
fi

git rev-parse --verify --quiet "$REMOTE/main" >/dev/null || morrer "ACESSO-02"

COMMIT_NOVO="$(git rev-parse "$REMOTE/main")"

# --- Base de comparacao ---------------------------------------------------
#
# Tem que ser o commit que o cliente recebeu por ultimo, gravado no estado.json.
# Usar o commit raiz do repositorio local acusa TODO arquivo de sistema como
# editado pelo cliente, porque a historia local nao tem parentesco com a do
# produto.

COMMIT_RECEBIDO="$(sed -n 's/.*"commit_recebido"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$ESTADO" 2>/dev/null | head -1)"

if [ -n "$COMMIT_RECEBIDO" ] && ! git cat-file -e "${COMMIT_RECEBIDO}^{commit}" 2>/dev/null; then
  # Gravado, mas o objeto nao esta aqui. Nao da pra detectar edicao do cliente,
  # mas a atualizacao em si continua segura.
  COMMIT_RECEBIDO=""
fi

echo "COMMIT_RECEBIDO=${COMMIT_RECEBIDO:-desconhecido}"
echo "COMMIT_NOVO=$COMMIT_NOVO"

# --- Versoes --------------------------------------------------------------

versao_de() {
  sed -n 's/.*\*\*Vers[^:]*:[[:space:]]*\([^*]*\)\*\*.*/\1/p' | tr -d '\r' | head -1
}

VERSAO_LOCAL="$(versao_de < VERSAO.md 2>/dev/null)"
VERSAO_NOVA="$(git show "$REMOTE/main:VERSAO.md" 2>/dev/null | versao_de)"

echo "VERSAO_LOCAL=${VERSAO_LOCAL:-desconhecida}"
echo "VERSAO_NOVA=${VERSAO_NOVA:-desconhecida}"

if [ "$COMMIT_RECEBIDO" = "$COMMIT_NOVO" ]; then
  echo "STATUS=em-dia"
  exit 1
fi

# --- Manifestos: o que o cliente tem hoje e o que a versao nova declara ----

limpar_manifesto < "$MANIFESTO" | sort > "$TMP/velho"
git show "$REMOTE/main:$MANIFESTO" 2>/dev/null | limpar_manifesto | sort > "$TMP/novo"
[ -s "$TMP/novo" ] || morrer "SETUP-05"

comm -13 "$TMP/velho" "$TMP/novo" > "$TMP/entram"
comm -23 "$TMP/velho" "$TMP/novo" > "$TMP/saem"
comm -12 "$TMP/velho" "$TMP/novo" > "$TMP/comuns"

echo "--- ENTRAM ---"; cat "$TMP/entram"
echo "--- SAEM ---";   cat "$TMP/saem"

# Conteudo que muda dentro do que ja existia nos dois lados.
echo "--- ALTERADOS ---"
if [ -s "$TMP/comuns" ]; then
  # shellcheck disable=SC2046
  git diff --name-only HEAD "$REMOTE/main" -- $(tr '\n' ' ' < "$TMP/comuns") 2>/dev/null
fi

# Arquivos de sistema que o proprio cliente editou desde que recebeu.
echo "--- EDITADOS_PELO_CLIENTE ---"
if [ -n "$COMMIT_RECEBIDO" ] && [ -s "$TMP/velho" ]; then
  # shellcheck disable=SC2046
  git diff --name-only "$COMMIT_RECEBIDO" HEAD -- $(tr '\n' ' ' < "$TMP/velho") 2>/dev/null
fi

echo "--- FIM ---"

if [ "$MODO" = "verificar" ]; then
  echo "STATUS=tem-novidade"
  exit 0
fi

if [ "$MODO" != "aplicar" ]; then
  morrer "INTERNO-02"
fi

# --- Aplicar --------------------------------------------------------------
#
# A partir daqui escreve na pasta. O commit de seguranca vem primeiro e nao e
# opcional: e ele que transforma a historia do git na rede de seguranca e
# permite sobrescrever arquivo de sistema sem medo de perder o que era do
# cliente.

if [ -n "$(git status --porcelain)" ]; then
  git add -A >/dev/null 2>&1
  git commit --quiet -m "Backup automatico antes de atualizar o Sinistra OS" >/dev/null 2>&1 \
    || morrer "INTERNO-01"
  echo "BACKUP=feito"
else
  echo "BACKUP=nada-pendente"
fi

# Traz o que a lista branca nova declara.
while IFS= read -r caminho; do
  [ -n "$caminho" ] || continue
  case "$caminho" in
    /*|*..*) continue ;;   # nunca sair da pasta do projeto
  esac
  case "$caminho" in
    */)
      # Pasta na lista e 100% da Sinistra: apaga antes de trazer, senao arquivo
      # que a Sinistra removeu na versao nova sobrevive na pasta do cliente.
      rm -rf "$caminho"
      git checkout "$REMOTE/main" -- "$caminho" 2>/dev/null
      ;;
    *)
      git checkout "$REMOTE/main" -- "$caminho" 2>/dev/null
      ;;
  esac
done < "$TMP/novo"

# Remove o que saiu do catalogo. A lista vem da comparacao entre os dois
# manifestos, nunca de varredura da pasta. E isso que impede apagar skill que o
# cliente criou pelo /mapear-rotinas.
while IFS= read -r caminho; do
  [ -n "$caminho" ] || continue
  case "$caminho" in
    /*|*..*) continue ;;
  esac
  rm -rf "$caminho"
  git rm -rq --cached --ignore-unmatch "$caminho" >/dev/null 2>&1
done < "$TMP/saem"

git add -A >/dev/null 2>&1
if [ -n "$(git status --porcelain)" ] || ! git diff --quiet --cached 2>/dev/null; then
  git commit --quiet -m "Atualiza o Sinistra OS para a versao ${VERSAO_NOVA:-nova}" >/dev/null 2>&1
fi

VERSAO_APLICADA="$(versao_de < VERSAO.md 2>/dev/null)"
VERSAO_APLICADA="${VERSAO_APLICADA:-${VERSAO_NOVA:-desconhecida}}"

# --- Grava o estado ---------------------------------------------------------
#
# O script grava, nao a skill. Se isso ficasse na mao do modelo e ele pulasse o
# passo, o commit_recebido continuaria velho e o cliente reaplicaria a mesma
# versao pra sempre. `cliente` e `instalado_em` nunca mudam.

if [ -f "$ESTADO" ]; then
  # Grava por arquivo temporario em vez de `sed -i`. O `-i` sem sufixo funciona
  # no GNU sed (Windows, Linux) e FALHA no BSD sed do macOS, que interpreta a
  # expressao como nome do arquivo de backup. Todo cliente de Mac quebraria
  # exatamente aqui, na hora de registrar a versao instalada.
  campo() {
    sed "s|\"$1\"[[:space:]]*:[[:space:]]*[^,}]*|\"$1\": \"$2\"|" "$ESTADO" > "$TMP/estado.json" \
      && cat "$TMP/estado.json" > "$ESTADO"
  }
  campo "versao"          "$VERSAO_APLICADA"
  campo "commit_recebido" "$COMMIT_NOVO"
  campo "atualizado_em"   "$(date +%F)"

  git add "$ESTADO" >/dev/null 2>&1
  git commit --quiet -m "Registra a versao ${VERSAO_APLICADA} instalada" >/dev/null 2>&1
  echo "ESTADO=gravado"
else
  echo "ESTADO=ausente"
fi

echo "NOVO_COMMIT=$COMMIT_NOVO"
echo "NOVA_VERSAO=$VERSAO_APLICADA"
echo "STATUS=aplicado"
exit 0
