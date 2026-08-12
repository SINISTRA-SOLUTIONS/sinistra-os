---
name: verificar-sistema
description: >
  Confere se está tudo funcionando na máquina da pessoa e devolve um diagnóstico curto em
  português, sem consertar nada.
  Use quando a pessoa disser "não está funcionando", "deu erro", "parou de funcionar",
  "não consegui gerar a imagem", "ta lento", "não abre", "verifica aí", "está tudo certo?",
  "testa pra mim", "o que ta faltando", "acho que quebrou", "não to conseguindo",
  "/verificar-sistema", ou quando alguém da Sinistra pedir um diagnóstico da máquina dela.
---

# /verificar-sistema: diagnóstico

Uma passada só, sem consertar nada. Serve pro usuário antes de reclamar e pra Sinistra
descobrir o que houve sem precisar entrar na máquina.

**Essa skill não conserta.** Conserto é sempre trabalho da Sinistra. Se ela começar a tentar
arrumar as coisas sozinha, vai mexer em credencial e configuração na máquina de um cliente,
sem ninguém olhando, que é exatamente o que o sistema inteiro foi desenhado pra evitar.

## O que conferir

Rodar tudo, mesmo que algo falhe no meio. O diagnóstico vale pelo conjunto.

| O que | Como conferir | Código se falhar |
|---|---|---|
| Versão instalada | `cliente` e `versao` em `.sinistra/estado.json` | `SETUP-04` |
| Programa de base | `git --version` | `SETUP-03` |
| A pasta é um repositório | `git rev-parse --is-inside-work-tree` responde `true` | `SETUP-02` |
| Cópia de segurança | `git remote get-url origin` e `git ls-remote --exit-code origin` | `SALVAR-01` sem canal, `SALVAR-02` se não responde |
| Canal de atualizações | `bash .sinistra/atualizar.sh verificar` | o `ERRO=` que ele devolver |
| Motor de imagem, parte 1 | `node --version` | `CFG-08` |
| Motor de imagem, parte 2 | `~/.sinistra/runtime/node_modules/playwright` existe | `CFG-09` |
| Publicação em redes | `META_PAGE_ACCESS_TOKEN` e `META_IG_USER_ID` no `.env` | `META-01` |
| Memória do negócio | `_memoria/empresa.md`, `preferencias.md`, `estrategia.md` e `regras.md` preenchidos | não é erro, é pendência |
| Identidade visual | `identidade/design-guide.md` preenchido | não é erro, é pendência |

**Nunca imprimir a saída crua de nenhum comando.** O endereço dos canais carrega credencial
dentro, e o `.env` carrega token. Conferir se existe e se responde, nunca mostrar o conteúdo.

## Como responder

Lista curta, em linguagem de resultado, na ordem: o que está funcionando primeiro, o que está
faltando depois. Nada de tabela e nada de nome de arquivo.

Tudo certo:

> "Conferi tudo, está funcionando:
>
> ✓ Versão 1.3, a mais recente
> ✓ Cópia de segurança ligada
> ✓ Recebendo as melhorias da Sinistra
> ✓ Criação de carrossel pronta
> ✓ Publicação no Instagram e Facebook ligada
> ✓ Sei quem é a [nome do negócio] e como vocês falam
>
> Pode pedir o que quiser."

Com alguma coisa faltando, separar o que é problema do que é pendência dele:

> "Quase tudo certo. Duas coisas:
>
> ✓ Cópia de segurança ligada
> ✓ Recebendo as melhorias da Sinistra
> ✓ Sei quem é a [nome do negócio]
>
> **A criação de carrossel não está pronta.** É do nosso lado. Chama a Sinistra e passa a
> referência CFG-09.
>
> **Ainda não tenho sua identidade visual.** Essa é comigo e com você: quando tiver cor, fonte
> e logo definidos, me manda que eu guardo, e a partir dali todo visual sai com a sua cara."

A separação entre as duas importa: uma ele repassa e espera, a outra ele resolve sozinho em
dois minutos. Misturar as duas faz ele achar que tudo depende da Sinistra e parar de usar.

Se sair versão nova durante a checagem, mencionar no fim:

> "Aproveitando: saiu a versão X. Quer que eu instale?"

## Erros

Todos os códigos são os mesmos que as outras skills já usam, e a tradução deles está em
`/atualizar-sistema` (família `REDE`, `ACESSO`, `SETUP`, `INTERNO`), em `/configurar`
(`CFG`) e em `/salvar` (`SALVAR`). Não inventar código novo aqui.

O único que nasce nessa skill:

| Código | Causa real | Ação |
|---|---|---|
| `META-01` | `.env` sem token da Meta | a configuração da Meta não foi feita, ver `dev/roteiro-meta.md` |

## Regras

- Nunca consertar, nunca instalar, nunca reconfigurar. Só olhar e reportar
- Nunca citar git, credencial, token, arquivo ou caminho numa fala pro usuário
- Nunca mostrar saída crua de comando
- Se a pasta não for um Sinistra OS configurado, dizer que a instalação não foi concluída e
  mandar chamar a Sinistra com `SETUP-02`
