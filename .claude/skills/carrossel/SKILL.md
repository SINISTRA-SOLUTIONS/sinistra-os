---
name: carrossel
description: >
  Cria post e carrossel pro Instagram, Facebook, LinkedIn e TikTok com a cara da marca:
  as imagens prontas pra postar e a legenda escrita junto.
  Use quando a pessoa disser "faz um post", "preciso postar alguma coisa hoje", "me ajuda
  com o instagram", "cria uma arte pra promoção", "quero divulgar o produto novo",
  "faz um carrosel", "post pro insta", "poste sobre o lançamento", "preciso de conteúdo
  pra semana", "monta uma arte bonita", "cria uma imagem", "faz uma foto pro post",
  "quero mostrar isso pros clientes", "to sem ideia do que postar", ou /carrossel.
---

# /carrossel: Carrossel e posts visuais

Skill central de criação de conteúdo visual. Pega um tema → entrega HTMLs estilizados + PNGs prontos pra postar + legenda no padrão da marca.

## Dependências

- **Identidade visual:** `identidade/design-guide.md`, LER ANTES de criar qualquer visual
- **Contexto do negócio:** `_memoria/empresa.md`
- **Tom de voz:** `_memoria/preferencias.md`
- **Node e Playwright:** pra renderizar o HTML em imagem, instalados pelo `/configurar` em
  `~/.sinistra/runtime/`, fora da pasta do cliente. Sem eles a skill entrega texto e legenda,
  mas não gera imagem
- **OpenAI API (opcional):** pra gerar fotos realistas, só se o cliente tiver chave configurada
- **Outputs vão em:** `marketing/conteudo/<tipo>-<tema>-<YYYY-MM-DD>/`

---

## Tipos de conteúdo

Ao receber um pedido, identificar qual tipo se encaixa:

### 1. CARROSSEL TEXTO PURO
- **Quando usar:** posts educacionais, dicas, listas, explicações
- **Formato:** 1080x1350 (4:5) sempre
- **Estilo:** tipografia clean, cores da marca alternadas, sem fotos

### 2. CARROSSEL COM FOTO
- **Quando usar:** apresentação visual, conteúdo aspiracional, capa com personagem
- **Formato:** 1080x1350 (4:5)
- **Estilo:** foto como capa com gradient overlay + slides internos no padrão alternado
- **Foto:** pode ser IA (gerada por OpenAI) ou real (passada pelo usuário)

### 3. POST ÚNICO
- **Quando usar:** frase de impacto, dado/estatística, depoimento, bastidores
- **Formato:** 1080x1350
- **Estilo:** varia conforme o conteúdo (citação, número grande, foto com overlay)

**Deduzir, não perguntar.** O dono da empresa não sabe (nem quer saber) qual é o formato
certo, e questionário faz ele desistir antes de ver a primeira imagem:

- pediu foto, imagem realista, "com uma foto" → tipo 2
- pediu uma frase, um aviso, um dado solto, "só uma arte" → tipo 3
- qualquer outra coisa, e na dúvida → tipo 1, que é o que serve pra quase tudo

Escolher, criar, e mostrar. Se ele quiser outro formato, ele diz na hora que vê.

---

## Estilo visual base

O Sinistra OS tem um estilo próprio, editorial, calmo, premium. Sem clip-art, sem emoji decorativo, sem gradiente arco-íris, sem template genérico de IA. `identidade/design-guide.md` sobrescreve esses padrões; quando o design-guide for vago ou estiver em branco, usar o que tá aqui (não parar pra pedir `/instalar`, o `/carrossel` funciona com defaults bons).

### Tipografia padrão

- **Fonte:** Inter (Google Fonts), pesos 400/500/600/700/800/900
- **Título de capa:** 90-100px, weight 900, line-height 0.98, letter-spacing **-0.04em**
- **H2 (slides internos):** 60-72px, weight 800, line-height 1.04, letter-spacing **-0.035em**
- **Corpo:** 20-24px, weight 500, line-height 1.5
- **Eyebrow/kicker:** 13-16px, weight 700-800, **UPPERCASE**, letter-spacing **0.22-0.32em**, cor de destaque
- **Page counter (canto sup. dir.):** 14-16px, weight 500-600, letter-spacing 0.18em, cor muted
- **Meta/handle (@):** 15-18px, weight 600

Regra do tipo: títulos grandes com kerning **apertado** (-0.035em), eyebrows pequenos com kerning **aberto** (0.22em+). Esse contraste é o coração do estilo.

### Cores padrão (quando design-guide for vago)

Paleta sóbria: fundo dark + off-white + **UMA** cor de destaque. Nunca quatro cores brigando.

- Fundo escuro: `#0E1116` ou `#1A1A1A`
- Fundo claro alternativo: `#F5ECD7` (cream) ou `#FAFAF7`
- Texto sobre escuro: `#FAFAF7`
- Texto sobre claro: `#1A1A1A` (h2) e `#444` (corpo)
- Destaque: cor da marca (uma só)

### Elementos visuais recorrentes

- **Régua fina** (3-4px de altura, 60-80px de largura, cor de destaque) entre kicker e h2 ou como divisor
- **Logo top-left + page counter top-right** em todos os slides
- **Border-top 1px** `rgba(255,255,255,0.12)` separando rodapé do conteúdo (em slides escuros)
- **Stamps circulares** (200x200, border 3px translúcida, rotate -10deg) pra selos/datas/dados
- **Tags/pills** uppercase, padding generoso, kerning 0.2em, pra rotular categoria do slide
- Padding base: 70-100px nas laterais

### Layouts nomeados

Vocabulário de layout, cada slide tem um nome. Variar entre eles pra criar ritmo:

- **CAPA**: eyebrow + título grande + subtítulo + @handle. Fundo: foto com gradient overlay (`rgba(12,10,9,0.55)` → `rgba(12,10,9,0.85)`) OU sólido (escuro/claro/destaque)
- **SOLO**: split horizontal: foto à esquerda 50% + texto à direita 50% (kicker + h2 + régua + parágrafo)
- **DUO**: texto em cima (kicker + h2 + régua + p) + 2 fotos lado a lado embaixo (ou 1 foto larga)
- **NÚMERO**: numeral gigante (200-320px, weight 800, cor de destaque) como elemento gráfico + h2 + parágrafo de apoio
- **CITAÇÃO**: aspas grandes em watermark + frase em h2 + atribuição
- **CTA FINAL**: fundo na cor de destaque, logo centralizado, headline curta, botão/CTA, telefone/@handle

**Ritmo de slide a slide:** alternar fundo escuro ↔ claro ↔ destaque. Nunca dois slides seguidos com o mesmo fundo.

---

## Padrão do carrossel

**Estrutura base (5 a 10 slides):**
- **Slide 1:** layout `CAPA`
- **Slides internos:** usar 2-3 layouts diferentes entre `SOLO` / `DUO` / `NÚMERO` / `CITAÇÃO`
- **Slide final:** layout `CTA FINAL`

Antes de criar HTML: ler `identidade/design-guide.md`. Se estiver em branco, usar o "Estilo visual base" acima como default.

### Sequência de capas no feed (planejamento de grade)

Antes de definir a capa, considerar a **última capa publicada** pra alternar:
- claro → próxima é foto/escuro
- foto/escuro → próxima é cor da marca
- cor da marca → próxima é claro
- nunca duas capas iguais em sequência

A última capa se descobre olhando o conteúdo mais recente em `marketing/conteudo/`. Não
perguntar isso pro usuário: ele não guarda essa informação na cabeça e a pergunta só atrasa.

### Linguagem (regra crítica)

Seguir `_memoria/preferencias.md`. Em geral: frases naturais, sem jargão de marketing, sem corporativês. O público real raramente fala "ticket médio", "performance", "B2B". Falar como ele fala.

### Legenda: sempre gerar junto

Ao terminar de renderizar os PNGs, gerar **automaticamente** a legenda do post e salvar em `legenda.md` na mesma pasta. **Não esperar o usuário pedir.** Estrutura padrão:

1. Hook (pergunta ou afirmação)
2. Contexto (1-2 frases sobre o conteúdo)
3. CTA pra arrastar ("Arraste pro lado e confere")
4. Bloco de oferta (diferenciais da empresa, contato)
5. Hashtags (10-15, público + nicho + local se aplicável)

---

## Workflow

### Passo 1: Entender e planejar

1. Ler `_memoria/preferencias.md` e `_memoria/empresa.md`
2. Ler `identidade/design-guide.md` pra cores, fontes e logo
3. Identificar o tipo de conteúdo (1, 2 ou 3)
4. Definir o tema e o ângulo

### Passo 2: Texto

Escrever o conteúdo seguindo as regras de tom:

**Pra carrossel (5-10 slides):**
- Slide 1 (Capa): título impactante, máx 8 palavras. Escolher o melhor, não oferecer lista
  de opções pra ele decidir
- Slides internos: um insight por slide, frases naturais, sem bullet points
- Slide final: CTA + logo

**Pra post único:**
- Frase principal em destaque
- Contexto de apoio (se necessário)
- CTA sutil

**CHECKPOINT:** mostrar o texto completo, do jeito que vai sair nas imagens, e perguntar
se pode seguir. Uma pergunta só, aberta:

> "É esse o texto? Se quiser mudar alguma coisa, fala. Se estiver bom, eu já monto as imagens."

### Passo 3: Gerar fotos (se tipo 2)

Só se o usuário pediu carrossel com foto IA.

1. Montar prompt em inglês (a API funciona melhor em inglês)
2. Padrão genérico de prompt:

```
Professional [TIPO] photography of [ASSUNTO],
[DETALHES], [AMBIENTE/CONTEXTO],
[ESTILO DE LUZ] lighting, shallow depth of field,
shot from [ÂNGULO], [ESTILO/ESTÉTICA],
editorial quality
```

3. Gerar via script (se `scripts/gerar-imagem.js` existir):
```bash
node --env-file=.env scripts/gerar-imagem.js "PROMPT" "marketing/conteudo/<pasta>/foto-<nome>.png"
```

Se o script não existir ou a chave de imagem não estiver configurada nessa máquina, **não
pedir nada técnico pro usuário**. Seguir sem a foto, com um layout de texto que fique bom
sozinho, e avisar em uma linha:

> "A parte que cria foto por inteligência artificial não está ligada na sua conta. Fiz o
> post sem foto, ficou bom assim. Se quiser essa parte ligada, chama a Sinistra e passa a
> referência CFG-11."

4. Mostrar a foto pro usuário antes de continuar.

**CHECKPOINT:** foto aprovada → seguir. Se ele pedir mudança, ajustar e gerar de novo.

### Passo 4: Criar visuais (HTML + PNG)

1. Criar **um único `carrossel.html`** com TODOS os slides como `<div class="slide">` dentro do mesmo arquivo. Inline CSS, Google Fonts como única dependência externa. Aplicar:
   - Cores e tipografia de `identidade/design-guide.md`
   - Mínimo 2 layouts diferentes (não repetir o mesmo em todos os slides)
   - Logo top-left + slide-counter top-right em todos os slides
   - Slide final: logo + CTA, fundo na cor principal

   **Pra incluir foto IA no HTML:**
   ```html
   <div class="slide" style="
     background-image: linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.7)), url('foto-xxx.png');
     background-size: cover;
     background-position: center;
   ">
     <div class="content">
       <h2>Texto sobre a foto</h2>
     </div>
   </div>
   ```

2. **Copiar** `templates/carrossel/render.js` pra mesma pasta do `carrossel.html`. Não
   escrever esse arquivo do zero: o molde já está pronto, testado, e resolve duas armadilhas
   que quebram em silêncio (o endereço do arquivo precisa sair do `pathToFileURL`, senão
   falha no Windows por causa das barras invertidas, e as fontes precisam ter carregado antes
   do screenshot, senão o primeiro slide sai com a fonte errada sem dar erro nenhum).

   Ele grava cada slide em dois formatos numa passada só:

   - `instagram/slide-NN.png`, que é o que o cliente baixa e usa em qualquer lugar
   - `instagram/jpg/slide-NN.jpg`, que é o único formato que a API da Meta publica

   Sem o JPEG, a publicação automática falha no último passo, depois de já ter feito tudo
   certo.

   Rodar apontando pro Playwright que o `/configurar` instalou fora do projeto:

   ```bash
   NODE_PATH="$HOME/.sinistra/runtime/node_modules" node render.js
   ```

   Pra formato diferente do feed (TikTok em 9:16, por exemplo), copiar o molde e ajustar
   `LARGURA` e `ALTURA` no topo dele.

   Se `~/.sinistra/runtime/node_modules/playwright` não existir, o motor de imagem não foi
   instalado. **Não tentar instalar aqui**, parar e falar:

   > "A parte que transforma o layout em imagem não está instalada nessa máquina. O texto e a
   > legenda estão prontos, só as imagens que eu não consigo gerar. Chama a Sinistra e passa a
   > referência CFG-09."

3. Mostrar os slides prontos, todos, na ordem. Não entregar em partes pedindo aprovação a
   cada pedaço: ele quer ver o post inteiro, como o cliente dele vai ver.

### Passo 5: Salvar e organizar

```
marketing/conteudo/<tipo>-<tema>-<YYYY-MM-DD>/
  texto.md              ← texto aprovado + legenda
  foto-<nome>.png       ← fotos geradas por IA (se houver)
  carrossel.html
  render.js
  instagram/
    slide-01.png → slide-NN.png     ← o que o cliente baixa e usa
    jpg/
      slide-01.jpg → slide-NN.jpg   ← o que o /publicar-redes manda pra Meta
  tiktok/ (se pedido, formato 9:16)
    slide-01.png → ...
  legenda.md            ← legenda Insta+FB
  legenda-linkedin.md   ← (se pedido, mais formal)
```

### Passo 6: entregar

Fechar mostrando as imagens e a legenda, e dizendo o que ele faz agora. Nunca citar pasta,
arquivo ou caminho:

> "Ficou pronto. As imagens estão na ordem certa e a legenda está aqui embaixo, é só copiar.
>
> Quando quiser colocar no ar, me fala que eu te passo do jeito certo pro Instagram."

**Só oferecer a versão de artigo** (`/publicar-tema`) se o negócio tiver site com blog, o que
se descobre em `_memoria/empresa.md`. Se não tiver, essa oferta é ruído: ele não tem onde
publicar artigo nenhum. Tendo site, oferecer em uma linha, sem falar em SEO:

> "Esse mesmo assunto dá um texto pro site, que ajuda a aparecer no Google. Quer que eu escreva?"

---

## Regras

- Sempre ler `identidade/design-guide.md` antes de criar qualquer visual
- Carrossel: 1080x1350 (4:5 retrato) sempre. TikTok/Reels: 1080x1920 (9:16) só quando pedido explicitamente
- Linguagem segue `_memoria/preferencias.md` estritamente
- Sempre considerar a sequência de capa no feed antes de definir capa nova
- Sempre gerar legenda automaticamente ao final, salvando em `legenda.md`
- Fotos IA: sempre pedir aprovação antes de usar no carrossel
- Fotos IA: prompts em inglês
- Fotos IA: nunca gerar fotos de pessoas/rostos identificáveis
- HTMLs: um único arquivo `carrossel.html` com todos os slides + `render.js` na mesma pasta. Inline CSS
- Render: sempre pelo `NODE_PATH` apontando pra `~/.sinistra/runtime/node_modules`. Nunca rodar `npm install` dentro da pasta do cliente
- Render: sempre gravar PNG e JPEG. O JPEG é o que a Meta publica, e a falta dele só aparece lá na frente, na hora de postar
- Não repetir layout entre slides, usar variação visual
