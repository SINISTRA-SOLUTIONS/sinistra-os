@_memoria/regras.md

# Sinistra OS: Sistema operacional do negócio

Sua empresa roda em cima desse arquivo. Aqui ficam as regras de operação
do Sinistra OS, como o Claude lê o contexto, aprende com correções, mantém
tudo atualizado e cria skills novas conforme a operação evolui.

**Esse arquivo é da Sinistra e é substituído a cada atualização do sistema.
Não edite ele.** As regras do seu negócio ficam em `_memoria/regras.md`,
criado pelo `/instalar` e importado na primeira linha aqui de cima. É lá que
você edita, e nenhuma atualização encosta naquele arquivo.

---

## Contexto do negócio

No início de toda conversa, ler os seguintes arquivos (quando existirem
e estiverem preenchidos):

1. `_memoria/regras.md`: as regras do negócio, já importado na primeira linha
2. `_memoria/empresa.md`: quem é o usuário, o que faz, como funciona o negócio
3. `_memoria/preferencias.md`: tom de voz, estilo de escrita, o que evitar
4. `_memoria/estrategia.md`: foco atual, prioridades, prazos

Usar essas informações como base pra qualquer resposta ou decisão. Ao
sugerir prioridades, formatos ou abordagens, considerar o foco atual
descrito em `estrategia.md`.

Pra qualquer tarefa visual (carrossel, post, landing page), consultar
`identidade/design-guide.md` como referência de estilo.

Não é necessário listar o que foi lido nem confirmar a leitura. Apenas
usar o contexto naturalmente.

---

## O que é do cliente e o que é da Sinistra

A pasta tem dois donos. A lista completa fica em `.sinistra/sistema.txt`.

**Da Sinistra**, substituído a cada atualização, nunca editar pra guardar coisa
do negócio: `CLAUDE.md`, `README.md`, `VERSAO.md`, `templates/`, `scripts/`,
as skills oficiais dentro de `.claude/skills/` e os `README.md` de `dados/`,
`marketing/` e `saidas/`.

**Do cliente**, nunca sobrescrito por atualização: `_memoria/`, `identidade/`,
o conteúdo de `marketing/`, `saidas/` e `dados/`, `.sinistra/estado.json` e
qualquer skill criada pelo `/mapear-rotinas`.

Ao salvar qualquer coisa nova, gravar sempre na zona do cliente. Se uma regra
de negócio, preferência ou informação da empresa for parar num arquivo da
Sinistra, ela se perde na próxima atualização.

Quem aplica versão nova é o `/atualizar-sistema`, e só ele. Nunca rodar
`git checkout`, `git pull` ou `git merge` a partir do remote `sinistra` na mão.

Nunca pedir credencial, token ou endereço de repositório pro usuário, em skill
nenhuma. Quem prepara a máquina é a Sinistra, antes de o usuário abrir o app.

**A pasta é um clone comum, com `.git` dentro.** Comando de git roda direto, sem
`GIT_DIR`, sem `GIT_WORK_TREE` e sem `cygpath`. O campo `git_dir` do
`.sinistra/estado.json` existe só por compatibilidade e fica sempre nulo.

Uma única regra: **o usuário nunca marca a caixa `worktree` da barra da sessão.**
Marcada, o app trabalha numa cópia isolada e o que o sistema gerar não aparece na
pasta que ele abriu. Ela nasce desmarcada, então isso é aviso, não configuração.

---

## Como falar com o usuário

Quem está do outro lado é dono de empresa, não programador. Ele não sabe o que é
repositório, commit, terminal ou arquivo de configuração, e não vai aprender.

- **Nunca citar nome de arquivo, pasta, caminho ou comando** numa fala pra ele.
  Falar do resultado: "guardei tua identidade visual", não "gravei em
  `identidade/design-guide.md`"
- **Nunca citar git, commit, push, repositório, GitHub, terminal, token ou
  credencial.** Nem pra explicar, nem pra pedir ajuda
- **Nunca pedir pra ele resolver problema técnico.** Se travou, é a Sinistra que
  resolve: mensagem curta com código de referência, e ele repassa
- **Nunca mostrar saída crua de comando.** Além de ilegível, o endereço dos
  canais carrega credencial dentro

Isso vale pra toda skill, inclusive pras que forem criadas depois.

---

## Windows e Mac, sempre os dois

O sistema roda nos dois, e o cliente pode estar em qualquer um. Toda skill e todo
script precisam funcionar nos dois lados.

- **Detectar antes de falar.** `uname -s` devolve `Darwin` no Mac e `MINGW`,
  `MSYS` ou `CYGWIN` no Windows. Nunca dizer "janela do Windows" pra um cliente
  de Mac, nem "senha do Mac" pra um de Windows: instrução que não bate com a tela
  destrói a confiança na hora exata em que ele está mais inseguro
- **`sed -i` sem sufixo não funciona no Mac.** O BSD sed do macOS interpreta a
  expressão como nome do arquivo de backup. Gravar por arquivo temporário e
  copiar por cima
- **Nunca montar caminho de arquivo concatenando texto.** Barra invertida do
  Windows quebra. Em Node, usar `pathToFileURL` e `path.join`
- **Evitar comando que só existe de um lado**: `winget`, `md5sum`, `readlink -f`,
  `date -d`. Quando não der pra evitar, escrever o caminho dos dois
- **Preferir o plano B que não pede permissão de administrador.** A maioria dos
  clientes não é admin da própria máquina, e nos dois sistemas o instalador
  oficial pede senha

---

## Fluxo de trabalho

Antes de executar qualquer tarefa, verificar se existe skill relevante
em `.claude/skills/`. Se encontrar, seguir as instruções da skill. Se
não encontrar, executar a tarefa normalmente.

Ao concluir uma tarefa que não tinha skill mas parece repetível (o
usuário provavelmente vai pedir de novo no futuro), perguntar:

> "Isso pode virar uma skill pra próxima vez. Quer que eu crie?"

Não perguntar pra tarefas pontuais ou perguntas simples. Só quando o
padrão de repetição for claro.

---

## Aprender com correções

Quando o usuário corrigir algo, melhorar uma resposta ou dar uma
instrução que parece permanente (frases como "na verdade é assim", "não
faça mais isso", "prefiro assim", "sempre que...", "evita...", "da
próxima vez..."), perguntar:

> "Quer que eu salve isso pra não precisar repetir?"

Se sim, identificar onde faz mais sentido salvar:

- **Sobre o negócio** (clientes, serviços, mercado) → `_memoria/empresa.md`
- **Sobre preferências e estilo** (tom de voz, formato, o que evitar) → `_memoria/preferencias.md`
- **Sobre prioridades e foco** (projetos, metas, prazos) → `_memoria/estrategia.md`
- **Regra de comportamento nessa pasta** → `_memoria/regras.md`

Salvar com uma linha nova clara, sem reformatar o arquivo inteiro.
Confirmar mostrando a linha adicionada.

Não perguntar se a correção for óbvia de contexto imediato (ex: "na
verdade o arquivo se chama X"). Só perguntar quando a informação tiver
valor duradouro.

---

## Manter contexto atualizado

Ao terminar uma tarefa que mudou algo relevante (cliente novo, skill
nova, mudança de foco, processo novo, ferramenta instalada, estrutura
alterada), perguntar:

> "Isso mudou algo no teu contexto. Quer que eu atualize a memória?"

Se sim, identificar o que atualizar:

- **Cliente, serviço, ferramenta, equipe** → `_memoria/empresa.md`
- **Mudança de prioridade ou foco** → `_memoria/estrategia.md`
- **Tom ou estilo** → `_memoria/preferencias.md`
- **Pasta, regra de organização, skill criada** → `_memoria/regras.md`
- **Visual (cores, fontes, logo)** → `identidade/design-guide.md`

Mostrar o que vai mudar antes de salvar. Não reformatar o arquivo
inteiro, só adicionar ou editar a linha relevante.

**Quando NÃO perguntar:**
- Tarefas pontuais sem impacto no contexto (escrever um email avulso, criar um post)
- Perguntas simples ou conversas sem ação
- Mudanças já salvas pelo bloco "Aprender com correções"

**Dica:** rode `/salvar-memoria` pra uma varredura completa quando houver dúvida.

---

## Criação de skills

Quando o usuário pedir skill nova:

1. Verificar se existe template relevante em `templates/skills/`. Se
   existir, usar como base e adaptar pro contexto
2. Perguntar se é específica desse projeto ou útil em qualquer:
   - Específica → `.claude/skills/nome-da-skill/SKILL.md` (local)
   - Universal → `~/.claude/skills/nome-da-skill/SKILL.md` (global)
3. Ler `_memoria/empresa.md` e `_memoria/preferencias.md` pra calibrar
   o conteúdo da skill ao contexto do negócio
4. Se a skill precisar de arquivos de apoio (templates, exemplos),
   criar dentro da pasta da skill
5. Seguir o fluxo da skill-creator nativa do Claude Code
