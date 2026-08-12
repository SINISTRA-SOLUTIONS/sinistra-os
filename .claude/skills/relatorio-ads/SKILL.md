---
name: relatorio-ads
description: >
  Explica como foram os anúncios do Google e do Instagram na semana: quanto saiu, o que
  voltou, o que está queimando dinheiro e o que mexer antes da semana que vem.
  Use quando a pessoa disser "como foram os anúncios", "meu anúncio está dando resultado?",
  "quanto eu gastei essa semana", "vale a pena continuar anunciando", "to gastando e não vejo
  resultado", "relatório de campanha", "e o Google Ads?", "como está o impulsionamento",
  "o anúncio ta funcionando", ou /relatorio-ads.
---

# /relatorio-ads: Relatório semanal de Google Ads + Meta Ads

Skill que transforma exports brutos das plataformas em relatório executivo que o dono entende sem precisar abrir a interface do Google ou da Meta.

## Dependências

- **Contexto:** `_memoria/empresa.md`, `_memoria/estrategia.md`
- **Tom de voz:** `_memoria/preferencias.md`
- **Inputs:** CSVs do Google Ads e/ou Meta Ads Manager. Print também aceito (transcrever)
- **Histórico:** `marketing/campanhas/relatorios/` (criar se não existir)

---

## De onde vêm os números

**Procurar sozinho antes de pedir qualquer coisa.** Olhar em `dados/` e em
`marketing/campanhas/` por arquivo recente de Google ou de Meta. Se achar, usar e começar o
relatório, sem perguntar nada.

Se não achar nada, pedir de um jeito que ele consiga fazer, sem falar em exportar, em CSV nem
em relatório da plataforma:

> "Pra te dizer como foram os anúncios eu preciso ver os números da conta. Pode ser print
> mesmo: abre o Gerenciador de Anúncios no celular, tira foto da tela de resumo e joga aqui.
> Se quem cuida dos seus anúncios te manda uma planilha, arrasta ela aqui que serve também."

Print funciona. Ler a imagem e transcrever antes de analisar.

## Workflow

### Passo 1: Ler os exports

**Google Ads:** colunas mínimas esperadas, Campanha, Grupo, Impressões, Cliques, CTR, CPC médio, Custo, Conversões, CPA, Conv. rate.

**Meta Ads:** colunas mínimas esperadas, Campanha, Conjunto, Impressões, Alcance, Cliques no link, CTR, CPM, Frequência, Custo, Resultados, Custo por resultado.

Se faltar coluna crítica (Conversões / Resultados), avisar e seguir só com tráfego.

### Passo 2: Comparar com a semana anterior

Buscar em `marketing/campanhas/relatorios/` o relatório anterior. Se existir, calcular variação semana vs semana:

- Investimento total
- Cliques / Impressões
- CTR (clique / impressão)
- CPC / CPM
- Conversões totais (Google + Meta)
- CPA (custo / conversão)
- Custo por canal

Se não existir, é a primeira leitura, sinalizar como baseline.

### Passo 3: Resumo executivo (topo do relatório)

Uma página, leitura de 2 minutos. Estrutura:

```markdown
# Como foram os anúncios: <DD/MM> a <DD/MM>

## O resumo

**Você investiu:** R$ X.XXX (Y% a mais/menos que na semana passada)
**Chegaram:** N contatos (Y% a mais/menos)
**Cada contato custou:** R$ X,XX em média (Y% a mais/menos)

**Onde o dinheiro foi:**
- Google: R$ X.XXX, trouxe N contatos, a R$ X,XX cada
- Instagram e Facebook: R$ X.XXX, trouxe N contatos, a R$ X,XX cada

**A frase da semana:** uma linha com o que mais importa (o anúncio que decolou, o que queimou
dinheiro sem trazer ninguém, a queda que não era esperada).
```

Falar em "contato" ou "cliente novo", não em conversão, a menos que `_memoria/preferencias.md`
mostre que ele usa o termo. Vale o mesmo pra CPA, CTR, CPM, criativo e conjunto: só usar o
termo técnico se ele mesmo usar.

### Passo 4: Detalhamento por canal

Pra cada canal, listar:

**Top 3 campanhas/grupos por performance** (menor CPA, maior conv. rate)
**Bottom 3** (maior CPA, menor conv. rate) sinalizar pra pausar ou ajustar
**Top criativos** (Meta): impressões + CTR + custo por resultado
**Bottom criativos** (Meta): pra trocar ou pausar
**Palavras-chave com mais custo e zero conversão** (Google) virar negativas

### Passo 5: Alertas automáticos

Varrer os dados e gerar alertas em vermelho/amarelo:

| Alerta | Critério |
|---|---|
| 🔴 Queima de orçamento | Campanha gastou >R$X com 0 conversões |
| 🔴 CTR despencou | CTR caiu >30% vs semana anterior |
| 🟡 Frequência alta (Meta) | Conjunto com freq > 3.0, público saturado |
| 🟡 Conv. rate baixa | <1% em campanha Search |
| 🟡 CPC subindo | CPC médio +20% vs semana anterior |
| 🟢 Oportunidade | Campanha com CTR/conv acima da média + orçamento limitado → considerar aumentar |

### Passo 6: Recomendações pra semana

Lista curta (3-5 itens) de ações concretas:

```markdown
## Pra fazer na próxima semana

1. **Pausar** Grupo "X", gastou R$ 230 sem conversão em 7 dias
2. **Adicionar negativas:** [lista de termos que apareceram nos search terms e não convertem]
3. **Trocar criativo Meta** do conjunto "Y", frequência 4.2, performance caindo
4. **Aumentar orçamento** da campanha "Z", CPA R$ 12, abaixo do alvo
5. **Testar** novo RSA com headline "<sugestão baseada em concorrência atual>"
```

### Passo 7: Salvar

```
marketing/campanhas/relatorios/<YYYY-MM-DD>-relatorio.md
```

Frontmatter com:
```yaml
---
periodo_inicio: YYYY-MM-DD
periodo_fim: YYYY-MM-DD
investimento_total: 0000.00
conversoes_total: 0
cpa_medio: 00.00
canais: [google-ads, meta-ads]
---
```

Esse frontmatter facilita comparações futuras com scripts e a leitura de longo prazo.

### Passo 8: Entrega

Mostrar o resumo executivo direto no chat (Passos 3 + 5 + 6). Salvar o relatório completo em
`marketing/campanhas/relatorios/<data>-relatorio.md`, mas **sem citar o caminho pro usuário**:

> "Guardei o relatório completo junto com as campanhas. Quer que eu escreva o email pra mandar?"

Se sim, chamar `/email-profissional` com o resumo executivo + link/anexo.

---

## Regras

- **Nunca inventar números.** Se o export tá truncado ou ilegível, dizer "dados incompletos" e seguir só com o que dá.
- **Comparação é o que importa.** Número solto ("R$ 1.200 essa semana") não significa nada sem o comparativo.
- **Alertas em ordem.** Vermelho primeiro, amarelo depois, verde por último.
- **Recomendações concretas.** "Pausar Grupo X" > "Otimizar campanhas". Nome da campanha, valor, motivo.
- **Linguagem do dono.** Seguir `_memoria/preferencias.md`. CPM, CTR, CPA são OK se o dono já entende; se não, traduzir ("custo por mil pessoas que viram", "% de quem clicou", "quanto custou cada cliente").
- **Frequência boa pra Meta:** 1.5 a 3.0. Acima de 3.0 já satura. Acima de 4.0 vira ruído.
- **Quando reportar perda:** não amenizar. "A campanha X queimou R$ 200 sem trazer venda" é mais útil que "a campanha X teve performance abaixo do esperado".
