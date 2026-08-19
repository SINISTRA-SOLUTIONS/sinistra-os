---
name: publicar-redes
description: >
  Coloca no ar um post que já foi criado: entrega as imagens na ordem certa com a legenda
  pronta pra colar, ou publica direto no Instagram e no Facebook quando essa conta tem a
  publicação automática ligada.
  Use quando a pessoa disser "publica", "pode postar", "quero postar isso", "manda pro feed",
  "como eu posto isso", "sobe pro instagram", "ta aprovado", "gostei, pode ir", "aprovado",
  "posta ai", "manda ver", "como faz pra por no ar", "quero isso no meu perfil",
  "/publicar-redes", ou aprovar um post que acabou de ser criado.
---

# /publicar-redes: colocar o carrossel no ar

Dois caminhos, e o normal é o primeiro.

**Manual, que é o padrão.** As imagens ficam organizadas numa pasta, na ordem certa, e o
usuário posta pelo celular como sempre postou. Sem configuração, sem depender de nada.

**Automático, quando a Sinistra ligou.** Publica direto no Instagram e no Facebook.

Sempre conferir qual dos dois está disponível antes de responder. Prometer publicação
automática numa conta que não tem isso ligado é a pior resposta possível: o usuário fecha o
computador achando que o post está no ar.

## Caminho 1: entregar pra ele postar

### Passo 1: conferir o que existe

Achar a pasta em `marketing/conteudo/`. Precisa ter as imagens dos slides e a `legenda.md`.

Se só existir o HTML e nenhuma imagem, o carrossel não foi renderizado. Rodar o `render.js`
daquela pasta antes de continuar.

### Passo 2: entregar

Mostrar os slides na ordem, a legenda inteira, e **abrir a pasta pra ele**:

```bash
# Windows
explorer "marketing\conteudo\<pasta>\instagram"
# Mac
open "marketing/conteudo/<pasta>/instagram"
```

E falar assim:

> "Abri a janela com as imagens do post, numeradas na ordem em que devem aparecer.
>
> Pra postar: manda essas imagens pro seu celular (mandar no WhatsApp pra você mesmo
> resolve), abre o Instagram, escolhe todas na ordem e cola a legenda abaixo.
>
> [legenda inteira, pronta pra copiar]"

Numerar na ordem importa mais do que parece: carrossel postado fora de ordem é o erro mais
comum de quem posta na mão, e não dá pra corrigir sem apagar o post.

Se existir `legenda-linkedin.md`, oferecer depois, não junto: uma coisa de cada vez.

## Caminho 2: publicar automático

Só quando o `.env` tiver `META_PAGE_ACCESS_TOKEN`, `META_PAGE_ID` e `META_IG_USER_ID`, e os
scripts existirem em `scripts/`. Quem configura é a Sinistra, uma vez por conta, seguindo
`dev/roteiro-meta.md`.

**Nunca pedir token, senha ou acesso de rede social pro usuário.** Se não estiver configurado,
seguir pelo caminho 1 e, só se ele perguntar, dizer que publicar direto daqui é possível e que
a Sinistra liga isso pra ele.

### Como funciona

O Instagram exige JPEG e busca a imagem por endereço público, então os scripts sobem os
arquivos antes de publicar. Limites: no máximo 10 imagens por carrossel, e o carrossel conta
como uma publicação.

### Passo 1: mostrar o que vai sair, e esperar

**Publicar é irreversível e sai na marca do cliente.** Post errado no feed de uma empresa não
se apaga sem deixar rastro: gente já viu, print já foi tirado.

Mostrar os slides, a legenda inteira e onde vai sair. Depois:

> "Vou publicar isso agora no Instagram e no Facebook da [nome]. Depois de publicado, não dá
> pra desfazer sem deixar rastro. Confirma?"

Só seguir com um sim explícito. "Acho que sim", "pode ser" e silêncio não são sim.

### Passo 2: publicar

```bash
node --env-file=.env scripts/postar-instagram.js marketing/conteudo/<pasta>
node --env-file=.env scripts/postar-facebook.js  marketing/conteudo/<pasta>
```

Se o Instagram falhar, **não seguir pro Facebook**. Publicar num lugar e não no outro é pior
que não publicar em lugar nenhum, porque o usuário acha que está tudo no ar.

### Passo 3: fechar

> "No ar.
>
> Instagram: [link]
> Facebook: [link]"

Registrar no arquivo do conteúdo a data e os links, pra não republicar sem querer depois.

## Erros

| Código | O que o usuário lê | Causa real |
|---|---|---|
| `META-01` | Não é erro. Seguir pelo caminho 1 sem alarde | `.env` sem token, publicação automática não ligada |
| `META-02` | "Não consegui publicar. Nada foi para o ar. As imagens estão prontas, dá pra postar pelo celular normalmente. Chama a Sinistra e passa a referência META-02." | API do Instagram recusou, normalmente token invalidado |
| `META-03` | "Publiquei no Instagram, mas o Facebook recusou. O post do Instagram está no ar. Chama a Sinistra e passa a referência META-03." | API do Facebook recusou |

Token invalidado é o erro mais comum depois de alguns meses, e quase sempre é o cliente que
trocou a senha do Facebook. O `dev/roteiro-meta.md` tem uma seção sobre renovar.

**Nunca mostrar a resposta crua da API**, que devolve o token em alguns erros.

## Regras

- Na dúvida entre os dois caminhos, o manual. Ele sempre funciona
- Nunca publicar sem confirmação explícita, nem quando quem está dirigindo é a Sinistra
- Nunca publicar dois conteúdos seguidos sem parar e confirmar entre um e outro
- Nunca republicar um conteúdo que já tem data de publicação registrada sem perguntar
- Se o Instagram falhar, não tentar o Facebook
- Nunca pedir token, senha ou acesso de rede social pro usuário
