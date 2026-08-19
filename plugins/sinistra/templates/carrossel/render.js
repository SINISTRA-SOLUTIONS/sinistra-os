// Molde do renderizador de carrossel do Sinistra OS.
//
// A skill /carrossel copia esse arquivo pra pasta do conteúdo e roda assim:
//
//   . "$HOME/.sinistra/runtime/env.sh" && node render.js
//
// Grava cada slide em dois formatos:
//   instagram/slide-NN.png       o que o cliente baixa e usa em qualquer lugar
//   instagram/jpg/slide-NN.jpg   o único formato que a API da Meta publica
//
// Não reescrever esse arquivo do zero a cada carrossel. Duas coisas aqui já
// custaram tempo pra descobrir e quebram silenciosamente no Windows:
//
// 1. o endereço do arquivo tem que sair do `pathToFileURL`. Montar "file://" +
//    caminho na mão quebra por causa das barras invertidas do Windows
// 2. o JPEG sai do próprio Playwright, com `type: 'jpeg'`. Não precisa de
//    biblioteca de conversão de imagem, e não vale a pena instalar uma

const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');
const { pathToFileURL } = require('url');

const LARGURA = 1080;
const ALTURA = 1350;      // 4:5, o formato de feed do Instagram
const QUALIDADE_JPEG = 92;

(async () => {
  const html = path.join(process.cwd(), 'carrossel.html');
  if (!fs.existsSync(html)) {
    console.error('ERRO: carrossel.html nao encontrado nessa pasta');
    process.exit(1);
  }

  fs.mkdirSync('instagram/jpg', { recursive: true });

  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: LARGURA, height: ALTURA } });
  await page.goto(pathToFileURL(html).href);

  // Espera as fontes carregarem. Sem isso, o primeiro slide sai com a fonte
  // de fallback e ninguém percebe até o post estar no ar.
  await page.evaluate(() => document.fonts.ready);

  const slides = await page.$$('.slide');
  if (slides.length === 0) {
    console.error('ERRO: nenhum elemento .slide no carrossel.html');
    await browser.close();
    process.exit(1);
  }

  for (let i = 0; i < slides.length; i++) {
    const n = String(i + 1).padStart(2, '0');
    await slides[i].screenshot({ path: `instagram/slide-${n}.png` });
    await slides[i].screenshot({
      path: `instagram/jpg/slide-${n}.jpg`,
      type: 'jpeg',
      quality: QUALIDADE_JPEG,
    });
  }

  await browser.close();
  console.log(`renderizou ${slides.length} slides em PNG e JPEG`);
})();
