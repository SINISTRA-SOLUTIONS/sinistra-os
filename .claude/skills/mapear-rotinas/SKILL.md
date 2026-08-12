---
name: mapear-rotinas
description: >
  Descobre o que a pessoa refaz toda semana e passa a fazer isso por ela daí em diante, do
  jeito dela, sem ela precisar explicar tudo de novo a cada vez.
  Use quando a pessoa disser "toda semana eu tenho que fazer isso", "me livra dessa tarefa",
  "isso aqui é chato demais", "dá pra você fazer isso sempre?", "sempre que chegar um pedido
  desse, faz assim", "quero automatizar", "o que dá pra você tirar das minhas costas",
  "cansei de fazer isso na mão", ou /mapear-rotinas.
---

# /mapear-rotinas: Mapeamento de tarefas repetitivas em skills

Skill de descoberta + criação. O objetivo é transformar o que o usuário repete em automações ativas.

## Workflow

### Passo 1: Entrevista de descoberta

**Uma pergunta, e o resto se descobre pedindo exemplo.**

Começar por `_memoria/estrategia.md`: a tarefa que ele odeia já foi registrada na conversa de
instalação. Se estiver lá, citar ela de volta em vez de perguntar do zero:

> "Você me falou que toda semana precisa [tarefa]. É essa que você quer tirar das costas, ou
> tem outra pior?"

Se não tiver nada registrado:

> "Me conta uma coisa que você faz toda semana e já cansou de fazer."

Depois que ele citar a tarefa, **não perguntar o que entra e o que sai**. Pedir um exemplo
real, que responde as duas coisas de uma vez e ainda mostra o padrão dele:

> "Me mostra a última vez que você fez isso. Manda o que você recebeu e o que você entregou,
> pode ser print ou o texto mesmo."

Com um exemplo na mão, o resto se deduz. Sem exemplo, a automação sai genérica e ele
abandona no primeiro uso.

### Passo 2: Conferir catálogo

Ler `templates/skills/catalogo.md` pra ver se alguma das tarefas mencionadas já é coberta por uma skill nativa do Claude Code ou validada pelo Sinistra OS. Se sim, sugerir a skill existente em vez de criar uma nova:

> "Isso eu já sei fazer, vem pronto no sistema. Quer que eu te mostre em vez de montar do zero?"

### Passo 3: Proposta de skills

Pra cada tarefa que NÃO tem cobertura existente, montar internamente a ficha (o que recebe,
o que entrega, de que contexto depende), mas **propor pro usuário em uma frase só**, no
formato "você me dá X, eu te devolvo Y":

> "Então fica assim: você me manda a planilha que o contador te envia, e eu te devolvo o
> resumo do mês escrito, do jeito que você mostrou. Sem você precisar explicar nada de novo.
>
> Fecha assim?"

Nunca mostrar nome de skill, barra, nem lista de dependências. Ele aprova a ideia do
resultado, não a estrutura.

Se houver mais de uma tarefa candidata, propor **uma por vez**, começando pela que ele mais
reclamou. Lista de propostas pra ele avaliar em bloco é decisão demais de uma vez.

### Passo 4: Criação das skills aprovadas

Pra cada skill aprovada:

1. Criar pasta `.claude/skills/<nome>/`
2. Criar `SKILL.md` com:
   - Frontmatter: `name`, `description` (descreve quando deve ser invocada)
   - Workflow estruturado em fases ou passos
   - Lista de dependências (arquivos de contexto, ferramentas externas)
   - Regras claras (o que sempre fazer, o que nunca fazer)
3. Se a skill precisar de templates ou exemplos, criar dentro da pasta da skill
4. Calibrar o tom e regras conforme `_memoria/preferencias.md` e `_memoria/empresa.md`

### Passo 5: Resumo

O que ele precisa saber é que aquilo saiu das costas dele, e como pedir de novo com as
palavras dele mesmo:

> "Feito. Daqui pra frente, quando você me disser [a frase que ele usaria: 'chegou a planilha
> do mês'], eu já faço isso sozinho, do jeito que a gente combinou agora.
>
> Se um dia você quiser mudar alguma coisa nesse jeito, é só me falar na hora e eu ajusto."

Nunca mandar ele digitar barra, nome de comando ou abrir arquivo pra editar.

## Regras

- Não criar skill pra tarefa que aconteceu uma vez só. Tem que ser repetível
- Não criar mais de 5 skills por sessão de mapeamento (se o usuário pedir mais, dividir em rodadas)
- Cada skill criada precisa ter um trigger claro (`description` precisa indicar quando invocar) sem isso a skill nunca é encontrada
- Se a skill depender de uma ferramenta que o usuário não tem (ex: API do Notion sem MCP configurado), avisar antes de criar e oferecer a versão simplificada
