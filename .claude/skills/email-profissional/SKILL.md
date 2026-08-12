---
name: email-profissional
description: >
  Escreve o email (ou a mensagem) que a pessoa precisa mandar, no tom certo pra quem vai
  receber: cobrança, proposta, resposta difícil, agradecimento, retomada de contato.
  Use quando a pessoa disser "escreve um email pra", "preciso mandar um email sobre",
  "como eu respondo isso", "não sei como falar isso pro cliente", "preciso cobrar um cliente",
  "me ajuda a responder essa mensagem", "escreve pra ele", "manda uma mensagem pro fornecedor",
  "como eu digo não pra ele", "faz um texto pra mandar", ou /email-profissional.
---

# /email-profissional: Rascunho de Email

## Dependências

- **Contexto do negócio:** `_memoria/empresa.md`
- **Tom de voz:** `_memoria/preferencias.md`

---

## Workflow

### Passo 1: Escrever primeiro, perguntar quase nunca

Quem pede um email já está com pressa. Extrair o que der do que ele falou, mesmo bagunçado, e
**escrever o rascunho**. Ver o texto pronto é o que faz ele lembrar do que faltou, muito mais
do que responder pergunta antes.

Deixar visível entre colchetes o que faltou, pra ele completar em cima: `[valor]`, `[data]`,
`[nome da empresa dele]`.

Uma única pergunta é permitida, e só quando a resposta muda o email inteiro (por exemplo,
não dá pra saber se é cobrança ou proposta):

> "Antes de escrever: você quer cobrar ele ou só lembrar sem pressionar?"

### Passo 2: Escrever o email

**Considerar:**
- Tom proporcional à relação (cliente novo = mais cuidado, parceiro antigo = mais direto)
- Objetivo claro na abertura (não enterrar o pedido no final)
- Uma ação pedida por vez
- Encerramento sem redundância ("Qualquer dúvida, fico à disposição" é padrão, só usar se fizer sentido)

**Estrutura:**
```
Assunto: [linha de assunto direta, sem clicbait]

[Nome],

[Parágrafo 1, contexto ou referência ao último contato]

[Parágrafo 2, o ponto principal ou o pedido]

[Parágrafo 3, próximo passo, se houver]

[Assinatura]
[Nome do usuário, de _memoria/empresa.md]
```

### Passo 3: Duas versões, só quando o assunto é delicado

Se for cobrança, recusa ou reclamação, entregar **duas versões prontas**, uma mais direta e
uma mais macia, e deixar ele escolher batendo o olho. Isso não é pergunta, é escolha entre
coisas prontas, que é o tipo de decisão que ele toma em dois segundos.

Pra email comum, entregar uma versão só. Oferecer opção em email trivial só atrasa.

---

## Regras

- Tom segue `_memoria/preferencias.md`
- Nunca usar linguagem corporativa genérica sem necessidade
- Assunto do email deve ser específico e descritivo, não vago ("Seguimento", "Proposta")
- Se for um email de cobrança, ser direto mas sem agressividade
- Se for resposta a algo, citar o contexto na primeira linha
- Entregar o texto pronto pra copiar, dentro da conversa. Nunca mandar ele abrir arquivo
- Serve pra WhatsApp também, e é o mais comum: se o pedido tiver cara de mensagem e não de
  email, cortar assunto e assinatura e escrever mais curto
