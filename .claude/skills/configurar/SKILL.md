---
name: configurar
description: >
  Confere se o computador ficou pronto pra usar o sistema e diz o que faltou, sem instalar nada.
  Use quando a pessoa disser "cheguei agora", "primeira vez aqui", "como eu começo",
  "e agora, o que eu faço", "recebi isso da Sinistra", "está pronto?",
  "não sei o que fazer aqui", "por onde eu começo", "isso aqui funciona?", "/configurar",
  ou quando ela aparecer pela primeira vez sem pedir nada específico.
---

# /configurar: conferir se está tudo no lugar

**A preparação da máquina acontece antes dessa skill existir, e quem faz é a
Sinistra.** Git, Node, motor de imagem, as duas chaves e o clone da pasta já
estão prontos quando o cliente abre o app pela primeira vez.

Não é preferência, é obrigação: **no Windows a aba Code do app do Claude não abre
sem Git instalado**. Se a instalação do Git dependesse de uma skill, ela nunca
rodaria, porque o cliente não conseguiria chegar até aqui pra pedir.

Então essa skill **confere** e diz o que faltou. Não instala nada, não configura
nada, não pede nada técnico pro cliente.

## O que conferir

| O que | Como | Se faltar |
|---|---|---|
| A pasta é um repositório | `git rev-parse --is-inside-work-tree` | `CFG-10` |
| Canal de cópia de segurança | `git remote get-url origin` responde | `CFG-10` |
| Canal de atualizações | `bash .sinistra/atualizar.sh verificar` não devolve erro de acesso | o código que vier |
| Motor de imagem | `node --version` e `~/.sinistra/runtime/node_modules/playwright` | `CFG-08` / `CFG-09` |
| Memória do negócio | `_memoria/` existe e está preenchida | não é erro, é a próxima conversa |

Se estiver tudo certo:

> "Está tudo pronto por aqui. Falta a parte mais importante: eu ainda não conheço o seu
> negócio. Quando tiver uns 10 minutos, me chama que eu te faço umas perguntas rápidas, e a
> partir dali tudo que eu produzir já sai com a sua cara.
>
> É só me dizer: quero instalar."

**`CFG-10`**
> "A preparação desse computador não terminou, e isso é do nosso lado, não do seu. Chama a
> Sinistra e passa a referência CFG-10, que é rápido de resolver."

**`CFG-08` ou `CFG-09`** não travam nada. Avisar numa linha:
> "Um detalhe: a parte que cria as imagens dos carrosséis não terminou de instalar. Todo o
> resto funciona normal. Avisa a Sinistra e passa a referência CFG-08 (ou CFG-09)."

## A caixa `worktree`

A barra da sessão tem uma caixa chamada `worktree`, e ela nasce desmarcada. É
assim que tem que ficar: marcada, o app trabalha numa cópia separada e o
carrossel que o sistema gerar não aparece na pasta que o cliente abriu.

Se em algum diagnóstico ficar claro que a sessão está isolada (o que o sistema
grava não aparece onde deveria), não tentar consertar por comando. Falar assim:

> "Tem uma caixinha marcada aí em cima escrita 'worktree'. Desmarca ela e me chama de novo,
> que aí o que eu criar aparece direitinho pra você."

## Regras

- Nunca instalar nada. Quem prepara a máquina é a Sinistra, antes de o app abrir
- Nunca pedir credencial, token ou senha pro usuário
- Nunca rodar `git init` na pasta: se ela não for repositório, o problema é a
  preparação, e quem resolve é a Sinistra
- Nunca mostrar saída crua de comando: o endereço dos canais carrega credencial
