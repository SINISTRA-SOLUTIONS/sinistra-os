---
name: atualizar-sistema
description: >
  Traz as melhorias novas que a Sinistra soltou (ferramentas novas, coisas que passaram a
  funcionar melhor), sem encostar na memória, na identidade e em nada que a pessoa produziu.
  Use quando ela disser "tem novidade?", "saiu coisa nova?", "atualiza aí", "o sistema
  atualizou", "vi que tem versão nova", "estou com a versão mais nova?", "instala a
  atualização", "pega as melhorias", "/atualizar-sistema", ou quando alguém da Sinistra pedir
  pra rodar a atualização na máquina dela.
  Não confundir com `/salvar-memoria`, que revisa o que o sistema sabe do negócio, nem com
  `/salvar`, que guarda a cópia de segurança do trabalho.
---

# /atualizar-sistema: instalar a versão nova

O motor mecânico vive em `.sinistra/atualizar.sh`. Essa skill é a camada de conversa: roda o
script, traduz o resultado, confirma e reporta. **Nunca refazer na mão o que o script faz.**
Ele é quem garante que só a zona da Sinistra é tocada, e improvisar comando de git em cima da
pasta do cliente é exatamente o risco que ele existe pra eliminar.

## Workflow

### Passo 1: verificar

```bash
bash .sinistra/atualizar.sh verificar
```

O script devolve linhas `CHAVE=valor` e blocos delimitados por `--- NOME ---`. Ler:

| Saída | O que é |
|---|---|
| `VERSAO_LOCAL` / `VERSAO_NOVA` | versão que ele tem e versão disponível |
| `--- ENTRAM ---` | caminhos que a versão nova acrescenta |
| `--- SAEM ---` | caminhos que saíram do catálogo e serão removidos |
| `--- ALTERADOS ---` | arquivos que existem nos dois lados e mudaram |
| `--- EDITADOS_PELO_CLIENTE ---` | arquivos da Sinistra que o próprio usuário editou |
| `STATUS` | `em-dia` ou `tem-novidade` |
| `ERRO` | falhou, ver a tabela de erros embaixo |

Se `STATUS=em-dia` (saída 1), responder e parar:

> "Você já está na última versão do Sinistra OS (versão X). Nada pra fazer."

### Passo 2: contar o que muda, em português

**Não listar caminho de arquivo.** O usuário não sabe nem quer saber o que é
`.claude/skills/`. Traduzir pra efeito.

A fonte da tradução é o histórico do `VERSAO.md` da versão nova, que é escrito em português
quando a Sinistra publica. Ler com:

```bash
MSYS_NO_PATHCONV=1 git show sinistra/main:VERSAO.md
```

Formato da resposta:

```
Saiu a versão 1.2 do Sinistra OS. O que vem junto:

• [o que mudou, na linguagem do VERSAO.md]
• [outro item]

Sua memória, sua identidade e tudo que você produziu ficam intactos.
Posso instalar?
```

Se o `VERSAO.md` novo não trouxer histórico legível, cair pro genérico contando quantidade:
"2 ferramentas novas e 1 melhorada". Nunca despejar a lista de caminhos.

### Passo 3: avisar sobre edição do usuário

Se `--- EDITADOS_PELO_CLIENTE ---` vier com alguma coisa, avisar **antes** de aplicar:

> "Um detalhe: você (ou alguém aqui) editou [N] arquivo(s) do sistema. A versão nova vai por
> cima dessas mudanças. Elas não se perdem, ficam guardadas no histórico e dá pra recuperar,
> mas o comportamento volta a ser o padrão da Sinistra. Sigo?"

Traduzir o nome do arquivo pro nome da ferramenta: `.claude/skills/carrossel/SKILL.md` vira
"a ferramenta de carrossel".

### Passo 4: aplicar

Só depois do usuário confirmar:

```bash
bash .sinistra/atualizar.sh aplicar
```

O script faz um commit de segurança antes de encostar em qualquer coisa, traz o que está na
lista branca, remove o que saiu do catálogo e commita o resultado.

### Passo 5: conferir o estado

O próprio script grava `versao`, `commit_recebido` e `atualizado_em` no
`.sinistra/estado.json` e devolve `ESTADO=gravado`. **Não editar esse arquivo na mão.**

Se vier `ESTADO=ausente`, o `.sinistra/estado.json` sumiu da pasta. A atualização em si
funcionou, mas a próxima vai se perder. Avisar a Sinistra e não tentar recriar improvisando.

O `commit_recebido` é o que vira a base de comparação da próxima atualização. Com ele errado,
a rodada seguinte acusa todo arquivo de sistema como editado pelo usuário.

### Passo 6: reportar

```
Pronto, atualizado pra versão 1.2.

[uma linha sobre o que ele ganhou de mais útil]

Tudo que era seu continua no lugar.
```

Se alguma ferramenta saiu do catálogo, dizer qual e por quê, se o `VERSAO.md` explicar.

## Erros

O script devolve `ERRO=<código>` e para com saída 2. Cada código tem uma mensagem própria.

Três regras que valem pra todas, sem exceção:

1. **Nunca mostrar a saída crua do git.** A URL do remote carrega o token de acesso dentro
   dela, e ela aparece na mensagem de erro do git.
2. **Nunca citar git, remote, repositório, token, credencial ou branch.** O usuário não pode
   saber que existe algo pra mexer ali, e nem tem como consertar.
3. **Sempre fechar com a referência entre parênteses.** É o que permite ele repassar pro
   suporte e a Sinistra saber exatamente o que quebrou sem precisar investigar.

### Problema na conexão do usuário (ele resolve sozinho)

**`REDE-01`**
> "Não consegui conectar. Parece que a internet caiu por aqui. Confere a conexão e me pede de
> novo. (ref. REDE-01)"

**`REDE-02`**
> "A conexão está instável e a busca não completou. Tenta de novo em alguns minutos. Se
> continuar, me avisa. (ref. REDE-02)"

### Acesso ao servidor de atualização (a Sinistra resolve)

**`ACESSO-01`**
> "Seu acesso às atualizações precisa ser renovado. Isso é do nosso lado, não do seu, e leva
> poucos minutos. Chama a Sinistra e passa a referência ACESSO-01."

**`ACESSO-02`**
> "Não encontrei o canal de atualizações desse sistema. Isso é uma configuração do nosso
> lado. Chama a Sinistra e passa a referência ACESSO-02."

**`ACESSO-03`**
> "O servidor de atualizações recusou a conexão por um motivo que não consigo identificar
> daqui. Chama a Sinistra e passa a referência ACESSO-03."

### Instalação incompleta (a Sinistra resolve)

Todas essas significam que o setup na máquina não foi concluído. O usuário não fez nada
errado, e é importante dizer isso, senão ele acha que quebrou o sistema.

**`SETUP-01`**
> "Esse Sinistra OS ainda não está conectado ao canal de atualizações. Falta um passo da
> instalação, e é do nosso lado. Chama a Sinistra e passa a referência SETUP-01."

**`SETUP-02`**
> "A instalação desse sistema ficou incompleta e não consigo atualizar sem isso. Você não fez
> nada errado. Chama a Sinistra e passa a referência SETUP-02."

**`SETUP-03`**
> "Falta um programa na máquina pra atualização funcionar. É rápido de instalar, mas quem faz
> é a Sinistra. Passa a referência SETUP-03."

**`SETUP-04` e `SETUP-05`**
> "Um arquivo de controle do sistema está faltando ou veio incompleto. Nada do seu trabalho
> foi afetado. Chama a Sinistra e passa a referência SETUP-04 (ou SETUP-05)."

### Falha durante a aplicação (a Sinistra resolve, com urgência)

**`INTERNO-01`**
> "Parei antes de mexer em qualquer coisa, porque não consegui guardar o ponto de restauração
> primeiro. Nada foi alterado e nada foi perdido. Chama a Sinistra e passa a referência
> INTERNO-01."

**`INTERNO-02`**
> "Erro interno na atualização. Nada foi alterado. Chama a Sinistra e passa a referência
> INTERNO-02."

### Tabela de referência (pra Sinistra, não pro cliente)

| Código | Causa real | Ação |
|---|---|---|
| `REDE-01` | DNS não resolveu, máquina sem internet | cliente resolve |
| `REDE-02` | timeout ou conexão recusada | cliente tenta de novo |
| `ACESSO-01` | token inválido, revogado ou expirado | gerar token novo |
| `ACESSO-02` | repositório não encontrado, 404, ou branch `main` ausente | conferir URL e permissão do token |
| `ACESSO-03` | falha de acesso não classificada | investigar na máquina |
| `SETUP-01` | remote `sinistra` não configurado | rodar o passo do `.sinistra/entrega.txt` |
| `SETUP-02` | git não enxerga a pasta como repositório | o clone da preparação não foi feito ou foi feito no lugar errado. Refazer o clone, **nunca `git init` por cima da pasta do cliente** |
| `SETUP-03` | git não instalado na máquina | instalar git |
| `SETUP-04` | `.sinistra/sistema.txt` ausente na pasta | restaurar do backup |
| `SETUP-05` | manifesto da versão nova veio vazio | bug na publicação, conferir o repo |
| `INTERNO-01` | commit de segurança falhou | ver `git status` na máquina |
| `INTERNO-02` | modo inválido passado pro script | bug da skill |

## Regras

- Nunca aplicar sem confirmação explícita, mesmo quando quem está dirigindo é a Sinistra
- Nunca rodar `git checkout`, `rm`, `git rm` ou `git reset` na mão pra "ajudar" o script
- Nunca fazer `push`. Essa skill só lê do remote `sinistra`
- Nunca mexer em `_memoria/`, `identidade/`, `marketing/`, `saidas/`, `dados/`, `learnings/`,
  `memory/` ou nos scripts configurados em `scripts/`. Se o script tentar, é bug dele, parar
  e avisar a Sinistra
- Se o usuário pedir pra pular a confirmação e "só atualizar", pode aplicar direto, mas ainda
  assim mostrar o resumo depois
