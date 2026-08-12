---
name: salvar
description: >
  Guarda uma cópia de segurança do trabalho da pessoa fora do computador dela, pra nada se
  perder se a máquina pifar.
  Use quando ela disser "salvar", "guarda isso", "faz backup", "salva o trabalho",
  "não quero perder isso", "isso fica guardado?", "e se meu computador quebrar",
  "guarda pra mim", "salva ai", "/salvar", ou pedir pra garantir que nada se perde.
  Não confundir com `/salvar-memoria`, que revisa o que o sistema sabe do negócio, nem com
  `/atualizar-sistema`, que instala versão nova do Sinistra OS.
---

# /salvar: cópia de segurança

Uma função só: garantir que o trabalho do usuário está guardado fora da máquina dele.

Ele não sabe o que é commit nem push, e não precisa saber. Pra ele isso é "salvar", igual
salvar um documento.

## Antes de qualquer comando de git

A pasta do cliente é um clone comum, com `.git` dentro. Comando de git roda
direto, sem exportar nada.

Se a pasta não for um repositório, ou se não existir o canal `origin`, a
preparação da máquina não terminou. Parar com `SALVAR-01` e não tentar
consertar.

## Os dois canais

- **`origin`**: repositório privado de backup daquele cliente. É o único que essa skill toca
- **`sinistra`**: o produto, compartilhado entre todos os clientes. Só leitura, e só o
  `/atualizar-sistema` usa

**Nunca empurrar nada pro `sinistra`, em nenhuma circunstância.** Um push por engano ali joga
o dado de um cliente pra dentro da pasta de todos os outros. Se o `origin` não existir mas o
`sinistra` existir, não usar o `sinistra` como atalho.

## Workflow

### Se não existir o `origin`

Significa que a configuração inicial não foi concluída. **Não perguntar nada técnico, não
oferecer criar repositório, não mencionar GitHub.** Falar assim e parar:

> "A cópia de segurança automática ainda não foi ligada nessa máquina. Isso é um passo da
> instalação que ficou pendente do nosso lado. Chama a Sinistra e passa a referência SALVAR-01,
> que é rápido de resolver. Seu trabalho está seguro aqui na máquina enquanto isso."

### Fluxo normal

1. `git status`. Sem mudança, responder e parar:
   > "Está tudo guardado, nada novo desde a última vez."

2. Olhar o que mudou e resumir **pelo que aconteceu no negócio**, não por nome de arquivo:
   > "Vou guardar: o carrossel do lançamento, o plano de SEO e as alterações na tua memória.
   > Confirma?"

3. `git add -A`, commit com uma linha descritiva, `git push origin main`. Nomear o canal
   sempre, nunca deixar o `git push` sozinho escolher.

4. Confirmar sem link e sem jargão:
   > "Guardado. Se essa máquina pifar amanhã, não se perde nada."

## Erros

**Falha de autenticação.** Não tentar reconfigurar credencial:

> "Não consegui guardar agora, o acesso à cópia de segurança precisa ser renovado. É do nosso
> lado. Chama a Sinistra e passa a referência SALVAR-02. Seu trabalho continua aqui na máquina,
> nada foi perdido."

**Divergência** (alguém alterou o backup por fora). Não resolver sozinho:

> "A cópia de segurança tem uma alteração que não veio dessa máquina. Prefiro não mexer sem
> conferir. Chama a Sinistra e passa a referência SALVAR-03."

**Sem internet:**

> "Não consegui guardar agora, parece que a internet caiu. Me pede de novo daqui a pouco.
> (ref. SALVAR-04)"

### Tabela de referência (pra Sinistra, não pro cliente)

| Código | Causa real | Ação |
|---|---|---|
| `SALVAR-01` | remote `origin` ausente, ou a pasta não é repositório | a preparação da máquina não terminou, conferir o clone e os remotes |
| `SALVAR-02` | push recusado por credencial | conferir a deploy key de escrita no repo do cliente |
| `SALVAR-03` | histórico divergente | resolver na máquina, provavelmente commit feito por fora |
| `SALVAR-04` | sem rede | cliente tenta de novo |

## Regras

- Nunca usar `--force`
- Nunca fazer push pro `sinistra`
- Nunca rodar `git init` na pasta: se ela não for repositório, é a preparação da
  máquina que ficou pela metade, e quem resolve é a Sinistra
- Nunca rodar `git reset --hard`, `git pull --rebase` ou qualquer coisa destrutiva sem a
  Sinistra no meio
- Nunca citar git, commit, push, repositório, GitHub ou branch numa fala pro usuário
- Nunca mostrar a saída crua de comando: o endereço do canal pode carregar credencial
