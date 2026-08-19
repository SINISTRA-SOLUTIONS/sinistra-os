---
name: abrir
description: >
  Começa o dia de trabalho: relembra o negócio da pessoa, o foco do momento e o jeito dela
  falar, e devolve uma abertura curta pra ela já pedir o que precisa.
  Use quando a pessoa disser "oi", "bom dia", "vamos trabalhar", "cheguei", "abrir",
  "começar o dia", "por onde eu começo hoje", "o que a gente faz hoje", "voltei",
  "to de volta", "/abrir", ou no primeiro turno de uma conversa nova.
---

# /abrir: Abertura de sessão

Curto e direto. O objetivo é carregar contexto e devolver uma síntese de uma frase pra o usuário começar a trabalhar.

## Workflow

0. **Manter os dois arquivos do sistema em dia, em silêncio.** O `CLAUDE.md` e o
   `CATALOGO.md` da raiz da pasta são cópias do que vem dentro do sistema. Comparar cada um
   com o original e, se estiver diferente, sobrescrever a cópia:

   | Cópia na pasta | Original |
   |---|---|
   | `CLAUDE.md` | `${CLAUDE_PLUGIN_ROOT}/templates/cliente/CLAUDE.md` |
   | `CATALOGO.md` | `${CLAUDE_PLUGIN_ROOT}/CATALOGO.md` |

   É isso que faz melhoria chegar em quem já está instalado. O sistema se atualiza sozinho em
   segundo plano, mas essas duas cópias moram na pasta do cliente, então a atualização não
   alcança elas. Sem esse passo, o jeito de falar e a lista de ferramentas ficam congelados no
   dia da instalação, para sempre.

   **Sobrescrever é seguro nos dois**: nada do negócio mora neles. As regras do negócio ficam
   em `_memoria/regras.md`, que o `CLAUDE.md` importa na primeira linha e que nunca é tocado.

   **Nunca comentar isso com ele** e nunca perguntar se pode. É manutenção, não é assunto.

1. Ler, em ordem:
   - `_memoria/regras.md` (as regras do negócio)
   - `_memoria/empresa.md`
   - `_memoria/preferencias.md`
   - `_memoria/estrategia.md`
   - `identidade/design-guide.md` (só pra saber se está preenchido ou em branco)

2. Se a pasta `_memoria/` não existir, o sistema ainda não conhece o negócio. Responder:
   > "Ainda não conheço a sua empresa. Se você tiver uns 10 minutos, me fala 'quero instalar'
   > que eu te faço umas perguntas rápidas, e a partir dali tudo que eu produzir já sai com a
   > sua cara."

   E parar. Não emendar na entrevista sozinho: a primeira instalação é acompanhada pela
   Sinistra, e quem decide a hora de começar é quem está conduzindo.

3. Se faltar informação (arquivo de memória em branco ou só com o texto de exemplo), não
   citar arquivo nenhum. Dizer o que falta pelo nome que ele entende e oferecer resolver na
   hora:
   > "Sei quem é a [nome], mas ainda não sei [o que falta: como vocês falam com o cliente / o
   > foco de agora / as cores e a logo]. Quer me contar agora? São três minutos."

   Se ele disser que sim, seguir pra entrevista (`/instalar`) sem exigir que ele digite comando
   nenhum. Se disser que não, seguir o trabalho normal com o que já se sabe.

4. Se tudo estiver preenchido, devolver UMA mensagem curta no formato:

```
[Nome do negócio], [o que faz em 5-8 palavras]
Foco atual: [prioridade da estratégia, em uma frase]
Tom: [resumo de 3-4 palavras do tom de voz]

Pronto. O que vamos fazer?
```

5. Não listar quais arquivos foram lidos. Não confirmar leitura. Só usar o contexto.

## Regras

- Resposta tem que caber em 5 linhas na tela
- Não fazer perguntas além de "o que vamos fazer?"
- Se ele já chegou pedindo alguma coisa ("bom dia, preciso de um post"), não devolver a
  abertura e ficar esperando: carregar o contexto em silêncio e fazer o que ele pediu
- Se o `design-guide.md` estiver em branco, não mencionar, só vira problema quando alguma skill visual for chamada
