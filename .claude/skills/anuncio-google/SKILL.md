---
name: anuncio-google
description: >
  Monta a campanha de anúncio do Google inteira, pronta pra subir: as buscas que a empresa
  quer aparecer, os textos do anúncio, o que evitar e quanto investir por dia.
  Use quando a pessoa disser "quero anunciar no Google", "fazer propaganda no Google",
  "aparecer patrocinado", "quero investir em anúncio", "como faço pra aparecer em primeiro",
  "campanha de anúncio", "quero pagar pra aparecer", "google ads", "anúncio pago",
  "quero mais gente me achando", ou /anuncio-google.
---

# /anuncio-google: Estrutura de campanha Google Ads

Skill que monta a campanha inteira em CSV pronto pra importar no Google Ads Editor. Sai do briefing direto pro CSV, sem montar grupo por grupo na mão na interface do Google.

## Dependências

- **Contexto do negócio:** `_memoria/empresa.md` (produto/serviço, público, região, diferenciais)
- **Tom de voz:** `_memoria/preferencias.md`
- **Pesquisa SEO (se existir):** `marketing/seo/01-pesquisa-demanda.md`, `06-google-ads.md`, usar como insumo
- **Outputs vão em:** `marketing/campanhas/google-ads-<YYYY-MM-DD>/`

---

## Workflow

### Passo 1: Briefing, quase todo deduzido

Quatro dos seis itens saem de `_memoria/empresa.md` sem perguntar nada: o que a empresa vende,
quem é o cliente dela, de onde ela atende e se tem site. Se `marketing/seo/06-google-ads.md`
já existir, ele responde o resto também.

Sobram **duas perguntas**, e só elas:

> "Duas coisas antes de montar: quanto você topa investir por dia? E o que você quer que
> aconteça, o cliente te chamar no WhatsApp, ligar, ou ir até a loja?"

Se ele responder só uma, assumir a outra: WhatsApp como destino (é o que mais converte em
pequeno negócio no Brasil) e um valor conservador de teste, dizendo qual foi:

> "Montei considerando R$ 30 por dia pra começar e o cliente te chamando no WhatsApp. Se o
> valor for outro, me fala que eu ajusto, o resto não muda."

Se o negócio não tiver site nem página, montar mesmo assim apontando pro WhatsApp, e avisar
numa linha que o anúncio rende mais com uma página, sem transformar isso em obstáculo.

### Passo 2: Pesquisa de palavras-chave

Se já existe `marketing/seo/01-pesquisa-demanda.md`, usar o top 10-20 de termos prioritários (intenção transacional + comercial).

Se não existe, gerar:
- 30-50 termos-semente baseados no briefing
- WebSearch pra cada grupo: ver concorrência, sazonalidade
- Filtrar pelos de **intenção comercial/transacional** (descartar informacionais)
- Agrupar em **clusters** (ex: "feijoada-buffet", "feijoada-restaurante", "feijoada-evento")

### Passo 3: Estrutura de campanha

**Padrão recomendado pra B2B local:**

```
Campanha 1: <Negócio>, Search Geral
├── Grupo: <Cluster 1>
│   ├── 10-15 keywords (mix de exata, frase, ampla modificada)
│   ├── 3 RSAs (15 headlines + 4 descriptions cada)
│   └── 10-15 keywords negativas no grupo
├── Grupo: <Cluster 2>
│   └── ...
└── ... (1 grupo por cluster do Passo 2)

Campanha 2: <Negócio>, Local (opcional)
├── Anúncios pra Google Maps
└── Segmentação por proximidade

Lista de negativas globais: termos genéricos descartados, marcas concorrentes
```

### Passo 4: Copies (RSAs)

Pra cada grupo, gerar 3 RSAs (Responsive Search Ads):

**15 headlines** por anúncio:
- 5 com keyword principal
- 3 com diferenciais concretos (certificações, prazo, garantia)
- 3 com CTA ("Solicite cotação", "Peça pelo WhatsApp", "Fale agora")
- 2 com prova social (anos no mercado, número de clientes)
- 2 com proposta de valor genérica

**4 descriptions** (90 caracteres cada):
- 1 institucional + CTA
- 1 com diferencial técnico + CTA
- 1 com urgência/escassez (se aplicável)
- 1 com prova social + CTA

**Restrições do Google:**
- Headline: 30 caracteres
- Description: 90 caracteres
- Sem emojis, sem caps lock, sem repetição de palavras
- Sem afirmações superlativas não-comprovadas ("o melhor", "número 1") sem fonte

Seguir `_memoria/preferencias.md` pra tom.

### Passo 5: Extensões

Gerar CSVs separados pra cada tipo de extensão:

- **Sitelinks** (4-6): "Sobre nós", "Catálogo", "Cases", "WhatsApp", "Localização"
- **Chamadas** (telefone): puxar de `_memoria/empresa.md`
- **Snippets estruturados:** lista de serviços, categorias de produto
- **Preço** (se aplicável): faixas de preço dos serviços principais
- **Promoção** (se aplicável): desconto, condição especial

### Passo 6: Configurações da campanha

Gerar arquivo `configuracoes.md` com:

- **Estratégia de lance:** "Maximizar conversões" pra começar (depois migrar pra "Maximizar conversões com tCPA" quando tiver 30+ conversões)
- **Orçamento diário:** conforme briefing
- **Segmentação geográfica:** raio em km a partir do endereço
- **Idioma:** Português
- **Dispositivos:** ajustes de lance recomendados (mobile +0%, desktop +0%, tablet -20%)
- **Programação:** dias e horários conforme negócio
- **Conversões a configurar:** clique no WhatsApp, envio de formulário, ligação telefônica, tempo no site

### Passo 7: Gerar os CSVs

Estrutura de pastas final:

```
marketing/campanhas/google-ads-<YYYY-MM-DD>/
  campanhas.csv          ← linha por campanha
  grupos.csv             ← linha por grupo de anúncio
  keywords.csv           ← keywords + match type
  keywords-negativas.csv ← negativas por grupo + lista global
  anuncios.csv           ← RSAs (headlines + descriptions)
  extensoes-sitelinks.csv
  extensoes-chamadas.csv
  extensoes-snippets.csv
  extensoes-preco.csv (se aplicável)
  configuracoes.md       ← config + checklist de import
  README.md              ← passo a passo pra importar no Google Ads Editor
```

**Formato dos CSVs:** seguir o padrão de importação do Google Ads Editor (colunas: Campaign, Ad group, Keyword, Match type, Status, Max CPC, etc.).

### Passo 8: Resumo + próximos passos

O passo a passo de importação é técnico e **não é trabalho dele**. Quem sobe a campanha é
quem cuida da conta de anúncios: a Sinistra, uma agência, ou o sobrinho que mexe com isso.
Esse roteiro fica gravado no `README.md` da pasta da campanha, pra essa pessoa ler.

Pro dono, falar de negócio:

> "A campanha está pronta. Ela cobre [N] tipos de busca de quem procura [o que a empresa
> vende] em [região], com [N] variações de anúncio escritas do seu jeito.
>
> Também deixei a lista do que NÃO deve disparar o anúncio, que é o que evita você pagar por
> quem está procurando outra coisa. É onde a maioria queima dinheiro.
>
> Ela vai subir pausada, ninguém gasta nada até você mandar ativar. Investindo R$ [X] por dia,
> dá pra ter leitura em mais ou menos duas semanas.
>
> Quem sobe isso é a Sinistra. Quando você quiser, é só falar."

Se ele mesmo cuida da conta de anúncios, aí sim entregar o roteiro de importação, que já está
escrito na pasta.

---

## Regras

- **Nunca inventar dados de CPC.** Se o cliente perguntar quanto vai custar, falar que depende da concorrência real e dar uma faixa baseada em WebSearch.
- **Sempre começar pausado.** Cliente revisa, ativa quando aprovar.
- **Não anunciar pra termos informacionais.** "Como fazer X" raramente converte, deixar pra SEO orgânico.
- **Match type:** começar com Phrase Match na maioria. Exact pra termos premium. Broad só com dados consistentes.
- **Lista de negativas global** é obrigatória, sem ela, queima dinheiro em buscas irrelevantes.
- **Conversões antes de tudo.** Sem conversão configurada, o Google não otimiza, relatar isso e pedir setup antes de ativar.
- Copies seguem `_memoria/preferencias.md` estritamente. Sem jargão de marketing se o público não usa.
- **Nunca falar RSA, match type, CPC, tCPA ou negativação numa fala pro dono.** Ele entende
  "variação de anúncio", "quanto custa cada clique", "lista do que não deve disparar o anúncio"
- **Nunca mandar ele mexer no Google Ads Editor, no Tag Manager ou em conversão.** Isso é
  trabalho de quem cuida da conta. Pedir isso pra ele é a forma mais rápida de a campanha nunca
  entrar no ar
