---
name: novo-projeto
description: >
  Abre um espaço separado pra um trabalho novo (um cliente novo, uma linha de produto, uma
  campanha grande), pra esse assunto não se misturar com o resto.
  Use quando a pessoa disser "peguei um cliente novo", "vou começar um trabalho pra",
  "quero separar isso do resto", "novo projeto", "estou lançando um produto novo",
  "abre uma pasta pra esse cliente", "começar projeto pra X", ou /novo-projeto.
---

# /novo-projeto: Pasta de projeto novo com contexto dedicado

Quando o usuário começa um projeto novo (cliente, iniciativa, produto), cria uma pasta com `CLAUDE.md` próprio que herda contexto da raiz e adiciona o que é específico do projeto.

## Workflow

### Passo 1: Duas perguntas, no máximo

O nome quase sempre já veio no pedido ("peguei um cliente novo, a Ferragem Souza"). Se veio,
não perguntar de novo.

1. "Como você quer chamar esse trabalho?" (só se o nome não veio no pedido)
2. "Me conta em uma frase o que você quer que aconteça com ele, e o que a gente vai produzir
   por lá: conteúdo, anúncio, proposta, site?"

Uma frase de resposta já dá objetivo e entregas de uma vez. Não quebrar isso em três
perguntas.

### Passo 2: Decidir local

Deduzir do contexto, sem perguntar:

- **Cliente ou trabalho pra terceiro:** criar em `clientes/<Nome>/` (ou na pasta equivalente do perfil, ler `_memoria/regras.md` pra confirmar a convenção)
- **Coisa da própria empresa** (produto novo, campanha, iniciativa interna): criar em `projetos/<nome>/`, criando `projetos/` se não existir

Na dúvida, `projetos/`. Mover depois não custa nada e não vale uma pergunta.

### Passo 3: Estrutura básica

Criar a pasta com:

- `CLAUDE.md` do projeto (instruções herdadas + específicas)
- `briefing.md` (com o que foi coletado na entrevista)
- Subpastas conforme as entregas mencionadas (ex: se mencionou "ads e conteúdo", criar `ads/` e `conteudo/`)

### Passo 4: Conteúdo do `CLAUDE.md` do projeto

Template:

```markdown
# [Nome do projeto]

> Projeto criado em [data]. Pasta dedicada, instruções aqui sobrescrevem as da raiz quando relevantes.

## Sobre

[Objetivo da resposta 3]

## Tipo

[Cliente novo / Projeto interno / Iniciativa pessoal]

## Entregas previstas

- [entrega 1 da resposta 4]
- [entrega 2 da resposta 4]
- ...

## Onde salvar o que

- Briefings e contexto: nessa pasta na raiz
- Entregas: cada subpasta criada (ads/, conteudo/, site/, etc.)

## Contexto que herda da raiz

Esse projeto herda automaticamente o tom de voz, marca e contexto do negócio definidos em `_memoria/` e `identidade/` da raiz. Não duplicar essas informações aqui.

## Específico desse projeto

[Vazio, preencher com regras que valem só pra esse projeto, conforme for descobrindo]
```

### Passo 5: Resumo

Nada de caminho nem de nome de arquivo. Falar do resultado:

> "Pronto, [nome] agora tem lugar próprio. Anotei o que você me contou e separei o espaço
> pra [as entregas que ele citou].
>
> Quando for falar desse trabalho, é só me dizer o nome que eu já sei do que se trata, e o
> que a gente combinou pra ele não se mistura com o resto da empresa."

## Regras

- Nome de pasta: usar o nome como o usuário falou, sem normalizar agressivamente (manter acentos, espaços viram hífen, mas o nome reconhecível)
- Não criar subpastas que não foram pedidas ("pra organizar melhor"). Só o que foi mencionado nas entregas
- Se o cliente/projeto já existe (pasta com mesmo nome), avisar e perguntar se é pra adicionar dentro ou criar com sufixo
- Nunca mandar ele abrir, mover ou navegar em pasta nenhuma. O trabalho aparece quando ele
  cita o nome, e é assim que ele deve ser instruído
