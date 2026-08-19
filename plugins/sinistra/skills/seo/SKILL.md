---
name: seo
description: >
  Descobre o que os clientes procuram, quem está aparecendo no lugar da empresa e monta o
  plano pra ela aparecer: no Google, no mapa, e também nas respostas do ChatGPT e afins.
  Use quando a pessoa disser "quero aparecer no Google", "por que meu concorrente aparece e
  eu não", "ninguém me acha na internet", "meu negócio não aparece no mapa", "como as pessoas
  me procuram", "quero aparecer no ChatGPT", "meu Google Meu Negócio está parado",
  "o que eu faço pra vender pela internet", "seo", "gmb", ou /seo.
---

# /seo: SEO completo + GEO + Google Ads

## Dependências

- **Contexto do negócio:** `_memoria/empresa.md`
- **Tom de voz:** `_memoria/preferencias.md`
- **Estratégia atual:** `_memoria/estrategia.md`
- **Ferramentas:** WebSearch, WebFetch (nativos)
- **Outputs vão em:** `marketing/seo/`

---

## Workflow

### Passo 1: DEMANDA: O que as pessoas buscam nesse nicho?

**Objetivo:** Entender se existe demanda real e como as pessoas buscam.

1. Ler `_memoria/empresa.md` pra extrair: produtos/serviços, região, público-alvo, diferenciais
2. Gerar uma lista inicial de **30-50 termos-semente** baseados em:
   - Categorias de produto/serviço
   - Intenção de busca (informacional, comercial, transacional)
   - Localização (cidade, região, estado)
   - Uso final / contexto do cliente
3. Usar **WebSearch** pra cada grupo de termos:
   - Buscar `"[termo] site:trends.google.com"` pra ver sazonalidade
   - Buscar `"[termo]"` pra ver o que aparece (orgânico, ads, maps)
   - Buscar `"[termo] related searches"` pra expandir a lista
4. Classificar cada termo por:
   - **Volume estimado:** alto / médio / baixo / micro
   - **Intenção:** informacional, comercial, transacional, navegacional
   - **Dificuldade:** quantos concorrentes fortes aparecem?
   - **Relevância:** direto (produto exato) / indireto (nicho relacionado) / tangencial

**Output:** Salvar em `marketing/seo/01-pesquisa-demanda.md` com:
- Tabela de termos classificados
- Top 10 termos prioritários (volume + intenção transacional + baixa concorrência)
- Termos sazonais
- Termos descartados e por quê

---

### Passo 2: CONCORRÊNCIA: Quem aparece pra essas buscas?

**Objetivo:** Mapear quem domina os resultados e onde estão os gaps.

1. Pegar os **top 10 termos** do Passo 1
2. Pra cada termo, usar **WebSearch** e analisar:
   - **Top 5 resultados orgânicos:** quem são, que tipo de página (site institucional, marketplace, blog, diretório)
   - **Resultados do Maps/Local Pack:** quem aparece, quantas avaliações, nota
   - **Google Ads:** alguém anuncia? qual a copy?
3. Pra cada concorrente relevante (máx 5-8), usar **WebFetch** pra analisar:
   - Estrutura do site (páginas, blog, catálogo)
   - Meta titles e descriptions das páginas principais
   - Conteúdo: falam de quê? com que profundidade?
   - Schema markup: usam dados estruturados?
   - GMB: perfil completo? fotos? posts? avaliações?
4. Identificar:
   - **Gaps:** o que nenhum concorrente faz bem
   - **Oportunidades:** termos onde ninguém domina
   - **Ameaças:** concorrentes fortes demais pra competir de frente
   - **Benchmark:** o padrão mínimo que o negócio precisa atingir

**Output:** `marketing/seo/02-analise-concorrencia.md` com:
- Tabela de concorrentes
- Mapa de gaps e oportunidades
- Recomendações: onde atacar primeiro

---

### Passo 3: GMB: Google Meu Negócio (resultado mais rápido)

**Objetivo:** Montar o perfil completo do Google Business Profile pra aparecer no Maps e Local Pack.

1. Pesquisar como está o perfil atual (se existir): buscar o nome da empresa no Google
2. Criar documento com **tudo que precisa ser preenchido/otimizado:**

   **Informações básicas:**
   - Nome (idêntico ao registrado)
   - Categoria principal + secundárias (sugerir as melhores pro nicho)
   - Endereço, telefone, site
   - Horário de funcionamento
   - Área de atendimento

   **Descrição do negócio:**
   - Descrição otimizada (750 caracteres) com palavras-chave naturais
   - Tom: conforme `_memoria/preferencias.md`

   **Atributos e serviços:**
   - Serviços relevantes
   - Atributos (entrega, atacado, produção própria, etc.)

   **Fotos recomendadas:**
   - Checklist (fachada, interior, produtos, equipe, produção)
   - Especificações

   **Posts GMB:**
   - 4 posts iniciais sugeridos
   - Calendário de posts recorrentes

   **Estratégia de avaliações:**
   - Como pedir avaliações dos clientes atuais
   - Template de resposta (positivas e negativas) usar `/responder-avaliacoes`

   **Citações e diretórios:**
   - Lista de diretórios relevantes pro nicho
   - NAP consistente (Name, Address, Phone) pra todas as listagens

**Output:** `marketing/seo/03-google-meu-negocio.md`

---

### Passo 4: ON-PAGE: Otimizar o site

**Objetivo:** Garantir que cada página esteja otimizada pras palavras-chave certas.

1. Ler a estrutura atual do site. Se `site/` não existir, achar o endereço em
   `_memoria/empresa.md` e ler as páginas direto da internet. Só perguntar se não houver
   endereço em lugar nenhum, e assim: "Qual é o endereço do seu site? Se você não tiver site,
   me fala que eu monto o plano contando com isso." Sem site, o trabalho todo vai pro perfil
   do Google e pro Instagram, que rendem mais rápido pra quem está começando
2. Pra cada página:

   **Mapeamento de palavras-chave por página**

   **Meta tags otimizadas:**
   - Title (50-60 caracteres, keyword no início)
   - Meta description (150-160 caracteres, com CTA)
   - H1, H2, H3 sugeridos

   **Schema Markup (dados estruturados):**
   - LocalBusiness schema (JSON-LD)
   - Product schema pros produtos
   - FAQ schema se tiver seção de perguntas

   **Checklist técnico:**
   - URLs amigáveis
   - Alt text das imagens
   - Velocidade de carregamento
   - Mobile-friendly
   - Sitemap.xml, robots.txt, canonical, Open Graph

   **Internal linking:** mapa de links internos sugerido

**Output:** `marketing/seo/04-otimizacao-on-page.md` com:
- Tabela: página → keyword principal → title → description → H1
- Schema markup pronto pra copiar (JSON-LD)
- Checklist técnico com status (feito / pendente)

---

### Passo 5: CONTEÚDO: Estratégia de autoridade

**Objetivo:** Criar plano de conteúdo que posicione a empresa como referência no nicho.

1. Baseado nos termos do Passo 1 (especialmente os informacionais):

   **Páginas/posts evergreen:**
   - 5-10 ideias que respondem dúvidas reais do público
   - Pra cada ideia: título otimizado, keyword-alvo, estrutura de headings, estimativa de tamanho

   **Cluster de conteúdo:**
   - Página pilar
   - Páginas satélite que linkam pra pilar
   - Estrutura de internal linking

   **Calendário editorial:**
   - Prioridade de publicação
   - Frequência sugerida
   - Formato (blog post, guia, FAQ, comparativo)

   **Conteúdo local:**
   - Páginas de área de atendimento (se fizer sentido)
   - Conteúdo com referências locais

**Output:** `marketing/seo/05-estrategia-conteudo.md`

> Essa lista é o insumo da skill `/publicar-tema`, cada item dessa estratégia vira artigo + carrossel + legendas com um único comando.

---

### Passo 6: GOOGLE ADS: Campanhas prontas pra rodar

**Objetivo:** Estruturar campanhas baseadas nos dados reais da pesquisa.

1. Definir **objetivo das campanhas:**
   - Geração de leads (ligações, WhatsApp, formulário)
   - Visitas ao site
   - Alcance local

2. **Estrutura de campanhas:**

   **Search:**
   - Grupos de anúncios (1 por cluster de keyword)
   - Pra cada grupo: 10-15 palavras-chave, lista de negativas, 3 RSAs, extensões
   - Orçamento diário, estratégia de lance, segmentação geográfica

   **Local (se aplicável):** anúncios pra Google Maps, segmentação por proximidade

   **Display/Remarketing (opcional):** públicos, formatos

3. **Copies dos anúncios:**
   - Seguir tom de `_memoria/preferencias.md`
   - Incluir diferenciais concretos
   - CTAs específicos
   - 15 headlines, 4 descriptions

4. **Landing page:** avaliar se o site atual serve ou precisa de página específica

**Output:** `marketing/seo/06-google-ads.md` com estrutura completa, palavras-chave organizadas, copies prontas, orçamento e configurações.

> A skill `/anuncio-google` consome esse arquivo e gera o CSV pronto pra importar no Google Ads.

---

### Passo 7: MONITORAMENTO: Checklist mensal

**Objetivo:** Garantir que o trabalho continue dando resultado.

**Semanal:**
- Posição nos top 10 termos
- Responder avaliações no GMB
- Postar no GMB (1x/semana mínimo)

**Mensal:**
- Revisar métricas do Google Ads (CTR, CPC, conversões, custo/lead) usar `/relatorio-ads`
- Verificar tráfego orgânico (Google Search Console)
- Atualizar palavras-chave negativas
- Publicar 1-2 conteúdos do calendário editorial
- Verificar citações/diretórios

**Trimestral:**
- Refazer pesquisa de concorrência (Passo 2 resumido)
- Atualizar fotos e posts do GMB
- Revisar estratégia de conteúdo
- Avaliar novas oportunidades de keywords

**Output:** `marketing/seo/07-checklist-monitoramento.md`

---

### Passo 8: GEO: Aparecer nas respostas de IAs

**Objetivo:** Otimizar a presença pra que IAs generativas (ChatGPT, Gemini, Perplexity, Copilot) citem a empresa quando alguém perguntar sobre o nicho.

**Por que importa:** Cada vez mais clientes perguntam pra IAs "qual o melhor fornecedor/serviço de X em Y?", quem aparece ganha lead qualificado sem pagar ads.

1. **Auditoria GEO:**
   - WebSearch nos top 10 termos em engines de IA (Perplexity, etc.)
   - Verificar se a empresa (ou concorrentes) aparece
   - Mapear quais fontes as IAs citam pra esse nicho

2. **Conteúdo otimizado pra IA:**
   - Cada artigo do Passo 5 deve ter **respostas diretas** nas primeiras linhas
   - Incluir **dados concretos** (números, certificações, endereços, fatos verificáveis)
   - Estruturar com **perguntas como H2/H3** (formato Q&A)
   - Evitar texto vago, IAs descartam genérico

3. **FAQ Schema no site:**
   - Seção de FAQ com perguntas reais do nicho
   - Implementar FAQPage schema (JSON-LD)
   - 5-10 perguntas sugeridas baseadas no que o público pergunta

4. **Citações externas (menções):**
   - As IAs pesam menções em fontes confiáveis
   - Ações: diretórios, sites de avaliação, guest posts, menções em blogs do nicho, aparições em mídia

5. **Dados estruturados reforçados:**
   - LocalBusiness, FAQPage, Product, Article schemas

6. **Monitoramento GEO:**
   - A cada 30 dias, testar os top 5 termos no ChatGPT, Gemini, Perplexity
   - Registrar: a empresa apareceu? quem apareceu? fonte citada?
   - Ajustar conteúdo com base nos resultados

**Output:** `marketing/seo/08-geo-otimizacao-ia.md` com auditoria, FAQ + schema JSON-LD, lista de ações pra aumentar citações, checklist de monitoramento.

---

## Execução

Executar **os 8 passos em sequência**, salvando cada resultado no arquivo correspondente.
Entre um passo e outro, dizer em uma linha o que apareceu de mais interessante, pra ele
acompanhar sem precisar esperar calado, e seguir sozinho: não é pra pedir autorização a
cada passo.

Se ele pedir só uma parte ("só o Google Meu Negócio", "quero saber dos concorrentes",
"quero aparecer no ChatGPT"), rodar só o passo correspondente. Ele nunca vai dizer
"passo 3", vai dizer o assunto.

### Como entregar no fim

Oito documentos técnicos não se leem. O que ele precisa ouvir é o diagnóstico e a ordem
das coisas:

> "Terminei o levantamento. Resumo do que achei:
>
> **O que as pessoas procuram:** [os 3 termos mais buscados, em linguagem de gente]
>
> **Quem está aparecendo no seu lugar:** [1 ou 2 concorrentes e o motivo]
>
> **A coisa mais rápida de resolver:** [normalmente o perfil do Google, que dá resultado em
> semanas e não custa nada]
>
> Deixei tudo detalhado, e a gente pode ir fazendo junto na ordem. Quer começar pelo perfil
> do Google?"

Prioridade quase sempre nessa ordem: perfil do Google primeiro (rápido e de graça), conteúdo
depois (lento e composto), anúncio por último (rápido, mas só enquanto tiver dinheiro entrando).

---

## Regras

- Toda pesquisa deve ser real (usar WebSearch/WebFetch), nunca inventar dados de volume ou concorrência
- Copies e textos seguem `_memoria/preferencias.md` estritamente
- Termos em português do Brasil, como o público busca
- Quando um dado não puder ser obtido (ex: volume exato), deixar claro que é estimativa e explicar a lógica
- Focar em termos com intenção comercial/transacional pra negócio B2C/B2B local
- Schema markup em formato JSON-LD (padrão Google)
- Google Ads: nunca inventar CPC ou estimativas de custo sem base real
- **Jargão fica nos documentos, nunca na conversa.** Schema, on-page, cluster, intenção
  transacional, GEO e NAP são palavras de trabalho interno. Pro dono: "o que as pessoas
  procuram", "quem aparece na sua frente", "seu perfil no Google", "textos que respondem
  a dúvida do cliente"
- Nunca mandar ele mexer em código do site, em dados estruturados ou no Search Console. Isso
  é trabalho de quem cuida do site, e a entrega tem que estar pronta pra essa pessoa receber
