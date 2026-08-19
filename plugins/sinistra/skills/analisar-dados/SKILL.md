---
name: analisar-dados
description: >
  Lê uma planilha, uma lista ou um relatório e explica em português o que aqueles números
  estão dizendo, o que está indo bem, o que preocupa e o que fazer a respeito.
  Use quando a pessoa disser "olha esse arquivo pra mim", "o que esses números dizem",
  "me explica essa planilha", "recebi esse relatório e não entendi", "isso aqui está bom
  ou ruim?", "analisa isso", "tira uma conclusão disso", "o que dá pra ver aqui",
  "resume esses resultados", "/analisar-dados", ou simplesmente arrastar uma planilha
  ou um relatório na conversa.
---

# /analisar-dados: Análise de Arquivo

## Dependências

- **Contexto do negócio:** `_memoria/empresa.md` (pra entender o que os dados representam)
- **Tom de voz:** `_memoria/preferencias.md`

---

## Workflow

### Passo 1: Entender o contexto sozinho

**Abrir o arquivo antes de perguntar qualquer coisa.** O nome dele, os títulos das colunas e o
que a empresa vende (`_memoria/empresa.md`) quase sempre respondem o que ele é: venda, anúncio,
estoque, pesquisa. Quem arrasta uma planilha quer conclusão, não entrevista.

Só existe uma pergunta autorizada aqui, e só quando o arquivo for realmente ambíguo:

> "Já dei uma olhada. Tem alguma pergunta específica que você quer que eu responda com isso,
> ou eu te falo o que chamou minha atenção?"

Se ele não responder ou disser "pode falar", seguir com a análise completa.

### Passo 2: Ler o arquivo

Ler o arquivo fornecido. Se for Excel (.xlsx), ler com as ferramentas disponíveis pra extrair o conteúdo das células.

### Passo 3: Análise

Identificar e reportar:

**O que está bom:**
- Métricas acima da média ou em crescimento
- Padrões positivos nos dados
- Top performers (produtos, campanhas, períodos, etc)

**O que preocupa:**
- Quedas, anomalias ou tendências negativas
- O que está abaixo do esperado
- Gargalos ou desperdícios visíveis

**Comparações:**
- Período atual vs período anterior (se houver)
- Top vs bottom performers
- Distribuição entre categorias

**Insights não óbvios:**
- Correlações interessantes
- Padrões que não aparecem na leitura superficial

### Passo 4: Output

Gerar um resumo executivo em prosa (não só bullet points):

```markdown
# Análise: [Nome do Arquivo/Relatório]
*[Data da análise]*

## O que esses dados mostram
[2-3 parágrafos com o panorama geral]

## O que está funcionando
[lista com contexto]

## O que merece atenção
[lista com contexto]

## 3 recomendações
1. [ação concreta]
2. [ação concreta]
3. [ação concreta]

## Números-chave
| Métrica | Valor | Contexto |
|---------|-------|---------|
| ... | ... | ... |
```

Salvar em `saidas/analise-[nome]-[data].md`.

Na resposta, entregar a análise inteira na conversa mesmo, escrita, sem mandar ele abrir nada.
Não perguntar em que formato ele quer: se precisar de uma versão pra mandar pra alguém, ele
pede, e aí sim gerar.

---

## Regras

- Análise em prosa, não só listas, o usuário deve poder ler e entender sem abrir o arquivo original
- Nada de nome de coluna, fórmula ou termo de planilha na resposta. "Os clientes que compraram
  em maio voltaram menos em junho" funciona, "a coluna RECOMPRA caiu 12%" não
- Número sempre com a consequência junto. Ele não quer saber que caiu 14%, quer saber se isso
  é normal e o que fazer
- Nunca inventar dados que não estão no arquivo
- Se os dados estiverem incompletos ou com problemas, mencionar antes de analisar
- Tom conforme `_memoria/preferencias.md`
