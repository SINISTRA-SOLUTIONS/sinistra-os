---
name: salvar-memoria
description: >
  Revisa o que o sistema sabe sobre a empresa e corrige o que ficou velho: cliente que entrou,
  foco que mudou, jeito de trabalhar que virou outro.
  Use quando a pessoa disser "atualiza o que você sabe da minha empresa", "mudou uma coisa
  aqui", "agora a gente faz diferente", "revisa o que você sabe de mim", "você ainda acha que
  eu faço X", "meu foco mudou", "entrou cliente novo", "salvar memória", ou /salvar-memoria.
  Não confundir com `/atualizar-sistema`, que instala melhorias novas do sistema, nem com
  `/salvar`, que guarda a cópia de segurança do trabalho.
---

# /salvar-memoria: Varredura e atualização do contexto do negócio

Compara o que está nos arquivos de contexto com o estado real do workspace e propõe atualizações.

## Workflow

### Passo 1: Levantamento

Listar:
- Pastas na raiz (cada uma representa uma área de trabalho)
- Subpastas em `clientes/` (se existir) cada uma é um cliente
- Skills em `.claude/skills/`, quais existem hoje
- Arquivos recentes (últimos 30 dias) em pastas como `propostas/`, `conteudo/`, `clientes/<x>/`

### Passo 2: Comparação

Ler os arquivos de contexto e identificar:

- **Em `_memoria/empresa.md`:** lista de clientes / serviços / ferramentas, bate com a realidade do workspace?
- **Em `_memoria/estrategia.md`:** o foco atual ainda faz sentido (datas, prioridades)?
- **Em `_memoria/regras.md`:** as regras de organização e a estrutura de pastas listada batem com o que existe?
- **Em `identidade/design-guide.md`:** continua coerente com o que foi gerado nas últimas peças (carrosséis, slides)?

### Passo 3: Proposta de mudanças

Apresentar pro usuário uma lista curta, falando do negócio e nunca de arquivo:

> "Reparei em três coisas que mudaram e eu ainda não sabia:
>
> 1. Você começou a atender a Acme, e eu não tinha esse cliente anotado
> 2. Eu ainda achava que seu foco era fechar o primeiro cliente, mas você já tem três
> 3. Suas propostas mudaram de lugar, agora ficam separadas por cliente
>
> Posso corrigir isso na minha cabeça? Se alguma estiver errada, me fala qual."

Três itens no máximo por vez. Se tiver mais, mostrar os três mais importantes e guardar o
resto pra próxima.

### Passo 4: Aplicação

Se o usuário aprovar, editar os arquivos com cirurgia, só a linha relevante, sem reformatar o
documento todo.

Confirmar em uma frase, sem mostrar arquivo, linha nem comparação técnica:

> "Anotado. Agora eu sei da Acme, que seu foco virou [x], e que as propostas ficam separadas
> por cliente. Daqui pra frente eu já considero isso sozinho."

## Regras

- Não inventar fatos, só registrar o que tem evidência no workspace
- Se a evidência for ambígua (ex: pasta vazia chamada "Cliente Novo"), perguntar antes de adicionar
- Não apagar conteúdo dos arquivos de contexto, só atualizar e adicionar
- Se nenhuma mudança for necessária, responder "Tá tudo coerente, nada pra atualizar"
- Nunca gravar regra de negócio, preferência ou informação da empresa em arquivo da
  Sinistra (`CLAUDE.md`, `README.md`, `templates/`, `scripts/`, skills oficiais). Esses
  são substituídos na próxima atualização do sistema e a informação se perde. Lista
  completa da fronteira em `.sinistra/sistema.txt`
