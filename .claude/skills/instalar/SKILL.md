---
name: instalar
description: >
  A conversa em que o sistema aprende quem é a empresa: o que ela vende, pra quem, como a
  pessoa escreve, o que está travando o negócio e qual é a cara da marca. Depois disso, tudo
  que for produzido já sai com o jeito dela.
  Use quando a pessoa disser "quero instalar", "vamos configurar meu negócio", "te conto
  sobre a empresa", "me conhece", "quero que você aprenda o meu negócio", "vamos começar",
  "pode me perguntar", "configura aí", "/instalar", ou logo depois da conferência da máquina
  terminar.
---

# /instalar: a entrevista do negócio

É aqui que o sistema aprende quem é a empresa. Roda depois da `/configurar`, que já deixou a
máquina pronta.

**É o momento mais valioso do produto inteiro.** A qualidade dessas respostas define a
qualidade de tudo que o sistema vai produzir daqui pra frente. Trata como conversa de
descoberta, pergunta uma coisa por vez, escuta de verdade, não enfileira tudo.

## Pré-checagem

### 1. Arquivos de contexto

Numa instalação nova as pastas `_memoria/` e `identidade/` **ainda não existem**. Elas não
vêm no produto de propósito: são a zona do cliente e nascem aqui, no `/instalar`. Se elas não
existirem, é setup limpo, seguir direto.

Se já existirem e tiverem conteúdo real (não é placeholder), perguntar:
> "Eu já sei umas coisas da [nome]. Você quer começar do zero, como se fosse a primeira vez,
> ou prefere que eu só complete o que está faltando?"

### 2. A máquina está pronta?

Conferir se a pasta é um repositório (`git rev-parse --is-inside-work-tree`) e se existe o
canal `origin`. Quem prepara a máquina é a Sinistra, antes de o cliente abrir o app, então
faltar isso é problema nosso, nunca dele.

Se faltar, não tentar configurar nada aqui. Falar assim e parar:

> "Antes de te conhecer, falta um detalhe da preparação desse computador, e é do nosso lado.
> Chama a Sinistra e passa a referência CFG-10, que é rápido. Aí a gente começa."

Se `cliente` estiver preenchido mas faltar algum dos dois canais (`git remote -v` sem `origin`
ou sem `sinistra`), **não pedir nada técnico pro usuário e não tentar consertar**. Registrar e
seguir a entrevista normal: o sistema funciona sem eles, só fica sem cópia de segurança ou sem
receber melhorias. Avisar no fim, na Fase 4.

---

## Fase 1: O perfil, deduzido e não perguntado

O perfil decide qual gabarito de regras aplicar (`templates/perfis/regras-<perfil>.md`), mas
**não se pergunta**. Ninguém se autodenomina "solopreneur", e a pergunta faz o cliente parar
pra escolher uma categoria que não significa nada pra ele.

Deduzir das respostas da entrevista:

| Perfil | Como se reconhece na resposta |
|---|---|
| Solopreneur | uma pessoa só, marca no próprio nome, vende pra consumidor final |
| Freelancer | uma pessoa só, mas fala em "meus clientes" e trabalha por projeto |
| Agência | equipe pequena, entrega pra vários clientes ao mesmo tempo |
| Empresa | empresa estabelecida, funcionários, setores, produto próprio |

Na dúvida entre dois, escolher o mais simples dos dois. Regra a mais atrapalha mais que regra
a menos, e isso se ajusta depois sem custo nenhum.

---

## Fase 2: Entrevista

**Seis perguntas, uma por vez.** Esperar a resposta de cada uma antes de seguir. Se vier
resposta vaga, repetir uma vez pedindo concretude, e só uma. Depois disso registrar o que veio
e seguir: o setup travar numa pergunta é pior que uma resposta rasa.

Conversa, não formulário. Reagir ao que ele responde antes de fazer a próxima ("boa, isso já
me ajuda"), e cortar qualquer pergunta cuja resposta ele já tiver dado sozinho, o que acontece
bastante quando a pessoa é empolgada com o próprio negócio.

**Sobre o negócio:**
1. "Me conta o nome da empresa e o que vocês vendem, do jeito que você falaria pro vizinho."
2. "Quem compra de você? E você toca sozinho ou tem equipe?"

**Sobre voz:**
3. "Me cola um texto seu de verdade, uma legenda do Instagram, um email pra cliente, uma
   mensagem de WhatsApp. Qualquer coisa real e recente. É assim que eu aprendo a escrever
   parecido com você em vez de sair genérico."
4. "E o contrário: tem alguma coisa que te dá ranço quando você lê? (tipo 'vamos juntos!',
   'caro cliente', 'alavancar', emoji demais)"

**Sobre foco:**
5. "O que está travando o negócio hoje? E tem alguma coisa que você repete toda semana e
   odeia fazer?"

**Sobre a cara da marca:**
6. "Por último: se você já tem as cores da marca e a logo, me manda. Pode arrastar a logo
   aqui. Se ainda não tem, tudo bem, eu trabalho sem e a gente resolve depois."

Se ele mandar a logo, salvar em `identidade/logo.png` (ou a extensão que vier) sem citar o
caminho pra ele.

As perguntas 1, 2 e 5 são as que carregam mais informação por minuto. Se ele estiver com
pressa ou respondendo em uma palavra, garantir essas três e deixar as outras pra depois: com
elas o sistema já produz bem, e o resto se aprende no uso.

---

## Fase 3: Preenchimento dos arquivos

### Passo 0: criar a zona do cliente

Antes de escrever qualquer coisa, criar as pastas e copiar os gabaritos:

- `templates/memoria/empresa.md` → `_memoria/empresa.md`
- `templates/memoria/preferencias.md` → `_memoria/preferencias.md`
- `templates/memoria/estrategia.md` → `_memoria/estrategia.md`
- `templates/identidade/design-guide.md` → `identidade/design-guide.md`

Copiar, nunca mover: os gabaritos precisam continuar em `templates/` pra próxima instalação
e pra atualização do sistema.

A partir daqui, `_memoria/` e `identidade/` são do cliente e nenhuma atualização do Sinistra
OS encosta neles.

### `_memoria/empresa.md`
Preencher com base nas perguntas 1 e 2. Formato simples: nome, o que faz, perfil de cliente,
equipe. Registrar também o perfil deduzido na Fase 1.

### `_memoria/preferencias.md`
Preencher com base nas perguntas 3 e 4. Estrutura:
- **Tom de voz:** derivar do texto real que ele colou na pergunta 3 (descrever em 2-3 frases o jeito de escrever, com referência ao exemplo)
- **O que evitar:** lista direta da resposta 4
- **Estilo geral:** síntese do que combina e o que destoa

### `_memoria/estrategia.md`
Preencher com base na pergunta 5, que tem duas partes. Estrutura:
- **Gargalo atual:** o que está travando o negócio
- **Pra tirar das costas:** a tarefa repetida, registrar como candidata a virar automação
- **Próximas prioridades:** derivar do gargalo (o que ataca o gargalo direto)

### `identidade/design-guide.md`
Se ele mandou cores, fonte ou logo na pergunta 6, preencher os campos correspondentes. Se não, deixar como está e avisar:
> "Ainda não tenho tua identidade visual. Quando você tiver cor, fonte e logo definidos, me manda que eu guardo, e a partir dali todo visual que eu criar já sai com a tua cara."

### `_memoria/regras.md`
Pegar o gabarito do perfil escolhido na Fase 1 (`templates/perfis/regras-<perfil>.md`), adaptar com o nome do negócio e a estrutura de pastas mencionada nas respostas, e gravar como `_memoria/regras.md`.

**Nunca escrever no `CLAUDE.md` da raiz.** Ele é da Sinistra, é substituído a cada atualização
do sistema, e já importa o `_memoria/regras.md` na primeira linha. Regra de negócio gravada no
`CLAUDE.md` se perde na próxima atualização.

### `.sinistra/estado.json`
Quem preenche esse arquivo é a `/configurar`, não essa skill. Aqui, só conferir se o campo
`cliente` bate com o nome que veio na pergunta 1 e corrigir se estiver diferente.

**Não mexer no `commit_recebido`.** Ele é a base de comparação de toda atualização futura e
já veio certo da `/configurar`.

---

## Fase 4: Resumo

Devolver em linguagem de resultado, nunca em nome de arquivo. Ele não precisa saber onde as
coisas ficaram, precisa saber o que mudou:

> "Pronto, agora eu te conheço.
>
> Sei o que a [nome] faz e pra quem. Sei como você escreve e o que te dá ranço.
> Sei que o teu gargalo hoje é [gargalo].
> [Peguei tuas cores e tua fonte. | Ainda não tenho tua identidade visual, quando
> tiver me manda que eu guardo.]
>
> Tudo que eu produzir daqui pra frente já sai com essa cara."

Se algum dos dois canais estava faltando na pré-checagem, acrescentar uma linha só:

> "Um detalhe: a [cópia de segurança automática | conexão com as melhorias da Sinistra] ainda
> não está ligada. Avisa a Sinistra, é rápido de resolver do lado deles."

---

## Fase 5: O primeiro passo dele

> "Duas coisas que valem saber:
>
> Sempre que quiser começar o dia comigo, é só falar **bom dia** ou **vamos
> trabalhar** que eu carrego tudo que combinamos aqui antes da primeira frase.
>
> E você me disse que repete '<a tarefa que ele odeia, da pergunta 5>' toda semana. Quando quiser
> tirar isso das costas de vez, me fala que eu transformo isso numa coisa que eu
> faço sozinho daqui pra frente.
>
> Agora me diz: o que a gente resolve primeiro?"

---

## Regras

- Não inventar dados, se a resposta for vaga, registrar do jeito que veio (ou deixar placeholder claro)
- Tudo que sair da entrevista vai pra zona do cliente (`_memoria/`, `identidade/`). Nunca gravar nada disso em `CLAUDE.md`, `README.md`, `templates/` ou dentro de skill oficial. Lista completa da fronteira em `.sinistra/sistema.txt`
- Não escrever "este arquivo será preenchido pelo /instalar" nos arquivos finais, esse aviso só existe nos placeholders, sai depois do /instalar
- O setup deve durar 5-7 minutos no máximo. Se o usuário estiver enrolando numa pergunta, registra o que tem e segue
- Seis perguntas, e nenhuma a mais. Cada pergunta extra aumenta a chance de ele abandonar no
  meio, e o que falta se aprende sozinho nas primeiras semanas de uso
- Nunca perguntar qual é o perfil dele. Isso se deduz
- **Nunca citar nome de arquivo, pasta, comando ou barra numa fala pro usuário.** Ele fala em resultado, não em caminho. Isso vale pras perguntas e vale principalmente pro resumo do fim
- Nunca pedir pro usuário mexer em pasta, renomear nada ou fechar programa. A pasta chega pronta e com o nome certo, quem nomeia é a Sinistra
