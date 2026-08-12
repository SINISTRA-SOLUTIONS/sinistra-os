---
name: publicar-tema
description: >
  Pega um assunto e entrega o pacote inteiro de uma vez: o texto pro site, o post pras redes
  com as imagens, e a legenda de cada rede, tudo falando do mesmo assunto e apontando um pro
  outro.
  Use quando a pessoa disser "escreve um texto pro meu site", "faz um artigo sobre",
  "quero falar sobre isso no site e no instagram", "cria o conteúdo completo sobre",
  "material sobre o assunto X", "quero aparecer no google falando disso", "texto pro blog",
  "faz tudo sobre esse tema", "transforma isso em post e artigo", ou /publicar-tema.
---

# /publicar-tema: Pipeline de conteúdo SEO + redes sociais

Skill orquestradora. Pega um tema → entrega artigo no blog + carrossel + 3 legendas (Insta, FB, LinkedIn), tudo conectado.

## Dependências

- **Estratégia de conteúdo:** `marketing/seo/05-estrategia-conteudo.md` (lista mestra de temas, criada pelo `/seo`)
- **Outras pesquisas SEO:** `marketing/seo/01-pesquisa-demanda.md`, `02-analise-concorrencia.md`, `08-geo-otimizacao-ia.md`
- **Skill carrossel:** `.claude/skills/carrossel/SKILL.md`, usar pra fase do carrossel
- **Site (blog):** `site/`, destino dos artigos. Estrutura comum: Astro em `site/astro-site/src/content/blog/`, ou WordPress, ou outro. Se o negócio não tiver site (checar `_memoria/empresa.md`), não perguntar nada: entregar o texto pronto pra colar e seguir
- **Tom de voz:** `_memoria/preferencias.md`
- **Contexto:** `_memoria/empresa.md`, `identidade/design-guide.md`

---

## Workflow

### Passo 0: Escolher o tema

Se o usuário passou um tema explícito → usar.

Se não passou nada → ler `marketing/seo/05-estrategia-conteudo.md`, descartar os temas que
já viraram texto (checar o blog), e oferecer **no máximo três**, escritos como assunto e não
como palavra-chave:

> "Posso escrever sobre um desses três: [assunto 1], [assunto 2] ou [assunto 3]. Qual você
> prefere? Se tiver outro na cabeça, me fala."

Lista de quinze opções trava a decisão. Três resolve.

Se não existir estratégia de conteúdo nenhuma, escolher o assunto a partir do que a empresa
vende (`_memoria/empresa.md`) e da época do ano, e já começar. Ele corrige se não gostar.

### Passo 1: Pesquisa rápida

Antes de escrever, ler o que tem nas pesquisas SEO sobre esse tema:
- Keyword principal e variações (`01-pesquisa-demanda.md`)
- Como concorrentes tratam (`02-analise-concorrencia.md`) pra fugir do óbvio
- Ângulo GEO se aplicável (`08-geo-otimizacao-ia.md`) perguntas que IAs respondem

### Passo 2: Escrever o blog post

**Destino:** depende do stack do site. Padrões comuns:
- Astro: `site/astro-site/src/content/blog/<slug>.md`
- WordPress ou qualquer outro: gravar o texto em `saidas/` e entregar pronto pra colar

Na dúvida sobre o stack, gravar em `saidas/` e entregar pra colar. Isso sempre funciona, e
poupa uma pergunta que ele não saberia responder.

**Slug:** kebab-case curto, sem stopwords. Ex: "Como conservar carne salgada no restaurante" → `conservar-carne-salgada`.

**Frontmatter (se o stack usa markdown com frontmatter):**

```yaml
---
title: "Título atrativo, próximo da keyword"
description: "Meta description 150-160 caracteres, com keyword e benefício pro leitor"
publishedAt: YYYY-MM-DD
author: "<nome configurado em _memoria/empresa.md>"
keywords:
  - keyword principal
  - variação 1
  - variação 2
draft: true
---
```

**Sempre começar com `draft: true`.** O usuário revisa e flipa pra `false` quando aprovar.

**Estrutura do artigo (800-1500 palavras):**

1. **Lead (1-2 parágrafos):** problema concreto do público, sem enrolação
2. **H2 explicativo:** o quê e por quê
3. **H2 prático:** como fazer / o que olhar
4. **H2 comparativo ou de detalhe técnico** (opcional)
5. **H2 onde a empresa se encaixa:** conexão natural com o produto, sem ser propaganda
6. **CTA final:** link WhatsApp / formulário / contato configurado

**Regras de escrita** (seguir `_memoria/preferencias.md` estritamente):
- Sem jargão de marketing/inglês quando o público não usa
- Frases curtas, parágrafos de 2-4 linhas
- Concreto: números, certificações, datas, valores quando souber
- Markdown limpo: `##` pra H2, `###` pra H3, listas com `-`, links em `[texto](url)`

### Passo 3: Carrossel resumo

**Sem perguntar, partir direto pra criação do carrossel** chamando `.claude/skills/carrossel/SKILL.md` (tipo 1: carrossel texto puro).

**Pasta:** `marketing/conteudo/<slug-do-blog>-<YYYY-MM-DD>/`

Estrutura de slides do resumo:
- **Slide 1, capa:** mesmo título do blog (ou variação enxuta)
- **Slides 2-6:** os pontos-chave do blog (1 ideia por slide, frase natural, não bullet seco)
- **Slide final, CTA pro blog:** "Texto completo no nosso blog" + URL `<dominio>/blog/<slug>`

**Capa:** seguir sequência alternada do feed (claro → foto/escuro → cor principal → repete) checar `marketing/conteudo/` mais recente.

### Passo 4: Legendas (3 versões)

Salvar todas em `marketing/conteudo/<pasta-do-carrossel>/`:

**`legenda.md`** (Instagram + Facebook, mesmo texto):
- Hook na primeira linha
- 2-3 parágrafos de contexto (frases naturais, sem corporativês)
- CTA pro carrossel ("Arraste pro lado") + CTA pro blog ("Texto completo no link da bio" ou URL direta)
- Bloco oferta da empresa (diferenciais, contato)
- 10-15 hashtags (público + nicho + local)

**`legenda-linkedin.md`** (LinkedIn, mais formal, sem hashtags):
- Hook (pode ser provocativo, profissional)
- 3-5 parágrafos analíticos, LinkedIn aceita texto longo
- Sem "arraste pro lado" (público diferente, comportamento diferente)
- CTA: link direto pro blog
- Sem bloco de oferta agressivo, fechar com 1 linha de quem é a empresa
- Máx 3 hashtags no final, do nicho profissional

### Passo 5: Resumo de entrega

Conferir internamente, sem mostrar essa lista pro usuário (ela é cheia de nome de arquivo,
que é justamente o que ele não deve ver):

- texto do site gravado, ainda como rascunho
- imagens do post geradas, em PNG e em JPEG
- legenda de Instagram e Facebook, e a de LinkedIn

Pro usuário, fechar assim:

> "Ficou pronto:
>
> **O artigo**, escrito e formatado. Esse aqui você cola no seu site quando quiser,
> eu te entrego o texto na hora que pedir.
>
> **O carrossel**, com as suas cores, pronto pro feed.
>
> **As legendas** do Instagram, do Facebook e do LinkedIn.
>
> Quando quiser colocar o carrossel no ar, é só falar. O do LinkedIn ainda é
> manual, aí eu te passo o texto pra colar."

---

## Quando NÃO usar essa skill

- Pedido de carrossel avulso (sem blog) → usar `/carrossel` direto
- Atualização de artigo existente → editar direto o .md
- Post único, frase de impacto → `/carrossel`

## Princípios

1. **Blog é a peça-mãe.** Carrossel e legendas são derivados dele, não o contrário.
2. **Tudo conectado.** Cada peça referencia a outra (carrossel linka pro blog, blog tem CTA pro contato).
3. **Nunca publicar automaticamente.** Essa skill produz, não publica. Quem coloca o carrossel no ar é o `/publicar-redes`, e só com confirmação explícita.
4. **O artigo é entregue pra colar, não publicado.** O sistema não publica em site nem em WordPress. Prometer isso na resposta é criar uma expectativa que nada aqui cumpre.
5. **Linguagem do público real.** Sem corporativês. Sempre.
