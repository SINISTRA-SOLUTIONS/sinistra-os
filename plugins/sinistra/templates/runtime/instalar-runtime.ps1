# =============================================================================
# Motor de imagem do Sinistra OS: Node LTS + Chromium headless. Windows.
#
# Roda como usuario comum. Nao pede senha de administrador, nao escreve no
# registro, nao mexe no PATH do sistema e nao instala nada em Program Files.
# Tudo mora em ~/.sinistra/runtime, fora da pasta do cliente, pra atualizacao
# nunca encostar e uma segunda pasta reaproveitar em vez de baixar de novo.
#
# Chamado pelo /instalar. Nao e' pra rodar na mao.
# =============================================================================

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'   # sem isso o download fica lentissimo
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raiz    = Join-Path $HOME '.sinistra\runtime'
$NodeDir = Join-Path $Raiz 'node'
$BrwDir  = Join-Path $Raiz 'browsers'
$Tmp     = Join-Path $Raiz '.tmp'

# --- 0. Windows 10 -----------------------------------------------------------
# A documentacao do Playwright pede Windows 11+, mas isso e' declaracao de
# suporte, nao trava tecnica: no registro de downloads o Windows tem uma entrada
# unica ("win64"), sem separacao por versao, entao o Chromium baixa e roda no 10
# do mesmo jeito. Diferente do macOS, que tem entrada por versao e a do 13 e'
# vazia, o que faz o download falhar de verdade.
# Por isso aqui e' aviso, nao bloqueio: barrar uma maquina que funciona custa
# mais caro que rodar fora do suporte declarado.
$build = [int](Get-CimInstance Win32_OperatingSystem).BuildNumber
if ($build -lt 22000) { Write-Output "SINISTRA-RUNTIME: AVISO windows-10 build=$build" }

New-Item -ItemType Directory -Path $Raiz,$BrwDir,$Tmp -Force | Out-Null

# --- 1. Achar a ultima LTS ---------------------------------------------------
# Nao existe endereco fixo de "ultima LTS" no nodejs.org: /dist/latest aponta
# pra Current, e /dist/latest-lts nao existe (404). O caminho oficial e'
# consultar o indice e pegar a primeira entrada cujo campo lts nao seja false.
$indice = Invoke-RestMethod -Uri 'https://nodejs.org/dist/index.json'
$Ver    = ($indice | Where-Object { $_.lts -ne $false } | Select-Object -First 1).version

# --- 2. Arquitetura ----------------------------------------------------------
# PROCESSOR_ARCHITEW6432 cobre o caso de um PowerShell 32-bit rodando em ARM64.
$archRaw = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
$Arch    = if ($archRaw -eq 'ARM64') { 'arm64' } else { 'x64' }

$Nome = "node-$Ver-win-$Arch"
$Zip  = "$Nome.zip"

# --- 3. Baixar ---------------------------------------------------------------
# Invoke-WebRequest nao grava o Zone.Identifier (a marca de "veio da internet"),
# ao contrario de download por navegador. Por isso o node.exe sai sem aviso do
# SmartScreen. Trocar isso por download manual reintroduz o problema.
$ZipPath = Join-Path $Tmp $Zip
$SumPath = Join-Path $Tmp 'SHASUMS256.txt'
Invoke-WebRequest -Uri "https://nodejs.org/dist/$Ver/$Zip"            -OutFile $ZipPath
Invoke-WebRequest -Uri "https://nodejs.org/dist/$Ver/SHASUMS256.txt"  -OutFile $SumPath

# --- 4. Conferir integridade -------------------------------------------------
$linha = Select-String -Path $SumPath -Pattern ([regex]::Escape("  $Zip") + '$')
if (-not $linha) { Write-Output "SINISTRA-RUNTIME: CHECKSUM-AUSENTE"; exit 3 }
$esperado = $linha.Line.Split(' ')[0]
$obtido   = (Get-FileHash -Path $ZipPath -Algorithm SHA256).Hash.ToLower()
if ($esperado -ne $obtido) {
    Remove-Item $ZipPath -Force
    Write-Output "SINISTRA-RUNTIME: CHECKSUM-NAO-BATE"
    exit 3
}

# --- 5. Descompactar ---------------------------------------------------------
# Expand-Archive nao propaga a marca de internet pros arquivos extraidos.
# O Explorer do Windows propaga. Nunca trocar isso por extracao manual.
if (Test-Path $NodeDir) { Remove-Item $NodeDir -Recurse -Force }
Expand-Archive -Path $ZipPath -DestinationPath $Tmp -Force
Move-Item -Path (Join-Path $Tmp $Nome) -Destination $NodeDir

# Cinto e suspensorio: se um dia a marca aparecer, isso limpa. Nao pede admin.
Get-ChildItem $NodeDir -Recurse -File -Include *.exe,*.dll,*.cmd,*.ps1 |
    Unblock-File -ErrorAction SilentlyContinue

Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue

# --- 6. Playwright, na raiz do runtime ---------------------------------------
# O node_modules fica em ~/.sinistra/runtime/node_modules porque e' pra la' que
# o NODE_PATH do render.js aponta.
if (-not (Test-Path (Join-Path $Raiz 'package.json'))) {
    '{ "name": "sinistra-runtime", "private": true }' |
        Set-Content -Path (Join-Path $Raiz 'package.json') -Encoding ascii
}
Push-Location $Raiz
& "$NodeDir\npm.cmd" install playwright --no-audit --no-fund --silent

# --- 7. So' o Chromium headless ----------------------------------------------
# --only-shell baixa so' o headless shell (~271 MB) em vez do Chromium completo
# mais o shell (~701 MB). O render.js chama chromium.launch() sem `channel`,
# que e' a unica condicao pra isso funcionar. Se um dia o render precisar de
# navegador com janela, essa flag tem que sair.
$env:PLAYWRIGHT_BROWSERS_PATH = $BrwDir
& "$NodeDir\npx.cmd" playwright install --only-shell chromium
Pop-Location

# --- 8. Arquivo de ambiente --------------------------------------------------
# E' o que o /carrossel carrega antes de renderizar. Escrito em quebra de linha
# do Unix e com $HOME literal, porque quem le e' o bash, nao o PowerShell.
$env_sh = @"
# Ambiente do motor de imagem do Sinistra OS. Escrito na instalacao.
export PATH="`$HOME/.sinistra/runtime/node:`$PATH"
export NODE_PATH="`$HOME/.sinistra/runtime/node_modules"
export PLAYWRIGHT_BROWSERS_PATH="`$HOME/.sinistra/runtime/browsers"
"@
[IO.File]::WriteAllText((Join-Path $Raiz 'env.sh'), ($env_sh -replace "`r`n", "`n"))

Write-Output "SINISTRA-RUNTIME: OK $Ver $Arch"
