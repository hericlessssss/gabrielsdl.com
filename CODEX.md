# CODEX.md

Documentacao viva do projeto `gabrielsdl.com`.

## Objetivo do Projeto

Criar o portfolio oficial de Gabriel SDL, quadrinista com foco em arte sequencial para o mercado de quadrinhos, especialmente sample pages, ilustracoes, capas e commissions.

O site deve ser simples, rapido, bilingue, visualmente autoral e profissional. A direcao deve evitar aparencia generica de template ou site "feito por IA". O trabalho do artista deve ser o centro da experiencia.

## Leitura dos Insumos

Fonte principal: `insum/briefing biel o brabo (1) respondido.docx`.

Principais conclusoes do briefing:

- Nome/marca no site: `gabrielsdl.com`.
- Atuacao principal: quadrinista, com foco em paginas de historia em quadrinhos, sample pages para o mercado americano, commissions e capas quando possivel.
- Tom: direto, divertido, curto e objetivo.
- Idiomas: portugues e ingles.
- Objetivos: mostrar portfolio, conseguir clientes, divulgar redes sociais, receber propostas e construir presenca profissional.
- Publico principal: clientes, editoras e agencias.
- CTA principal: contato por email e Instagram.
- Estetica desejada: artistica, autoral, profissional, minimalista, escura/atmosferica, com impacto visual, galeria organizada e clima de capa/HQ.
- Efeitos desejados: sutis, com possibilidade de reticulas/halftone, textura de papel e elementos graficos de quadrinhos.
- Cores citadas: preto, branco, laranja e violeta. Evitar cores muito abertas, infantis ou excessivamente alegres.
- Conteudo atual: sample pages, ilustracoes, commissions, avatar e assinatura/logo.
- Conteudo protegido: projetos publicados nos EUA ainda nao podem aparecer publicamente.
- Atualizacao de conteudo: por enquanto sera feita via codigo/fluxo controlado; painel admin fica fora do MVP.

Assets disponiveis:

- `insum/assinatura e logo_`: 2 assinaturas/logos quadradas.
- `insum/avatar`: 3 ilustracoes/avatar do artista.
- `insum/Paginas sequenciais_`: sample pages verticais em sequencias de 3 paginas por projeto.
- `insum/ilustrações e comissions`: ilustracoes e commissions verticais, com artes coloridas e preto/branco.

Projetos/sample pages prioritarios para primeira leitura do artista:

- `runika`
- `the punisher (justiceiro)`

Referencias informadas pelo cliente:

- Rafael Albuquerque.
- Lucas Werneck.
- Pepe Larraz.
- Hailstone, pela atmosfera de capa/HQ com misterio, faroeste, terror e impacto visual.

## Stack Escolhida

Aplicacao Ruby on Rails fullstack:

- Ruby on Rails como framework principal.
- Rails Views com ERB para renderizacao server-side.
- Hotwire/Turbo para navegacao dinamica e atualizacoes parciais sem SPA.
- Stimulus para interacoes leves no frontend.
- Tailwind CSS para estilização, com design system proprio e componentes autorais. Nao usar UI kits genericos no MVP.
- PostgreSQL como banco de dados principal.
- Active Storage para gerenciamento das imagens do portfolio.
- I18n nativo do Rails para portugues e ingles.
- Minitest como suite de testes inicial, por ser o padrao mais simples e direto do Rails.
- System tests do Rails para fluxos principais, com Playwright reservado para validacao visual quando necessario.
- Deploy em plataforma compativel com Rails, preferencialmente Render ou Fly.io no MVP.

Motivo da decisao:

- Menor complexidade operacional.
- Menos boilerplate.
- Mais produtividade para um portfolio com backend simples.
- Menos necessidade de frontend separado.
- Melhor aderencia ao MVP.
- Mais economia de tokens e contexto durante desenvolvimento assistido por IA.
- Hotwire permite uma experiencia moderna sem criar uma SPA completa.

## Arquitetura Rails

Estrutura alvo:

```txt
gabrielsdl.com/
  app/
    controllers/
    models/
    views/
    helpers/
    javascript/
      controllers/
    assets/
    components/ ou partials/
  config/
    locales/
      pt.yml
      en.yml
    routes.rb
  db/
    migrate/
    seeds.rb
  test/
  storage/
  insum/
  CODEX.md
  README.md
```

## Modelo de Dados

PostgreSQL sera a fonte de verdade para o conteudo publico do portfolio. No MVP, o conteudo sera mantido por codigo, via `db/seeds.rb`, fixtures, arquivos versionados ou tasks Rails simples, sem painel admin.

Models planejados:

- `PortfolioCategory`
  - `id`
  - `slug`
  - `sort_order`
  - `is_active`
- `PortfolioCategoryTranslation`
  - `portfolio_category_id`
  - `locale`
  - `name`
- `Project`
  - `id`
  - `slug`
  - `portfolio_category_id`
  - `year`
  - `status`
  - `visibility`
  - `sort_order`
  - `is_featured`
  - `cover_artwork_id`, opcional
- `ProjectTranslation`
  - `project_id`
  - `locale`
  - `title`
  - `summary`
- `Artwork`
  - `id`
  - `project_id`
  - `portfolio_category_id`
  - `slug`
  - `dominant_color`
  - `sort_order`
  - `is_cover`
  - `visibility`
  - imagem anexada via Active Storage
- `ArtworkTranslation`
  - `artwork_id`
  - `locale`
  - `title`
  - `alt_text`
  - `caption`
- `ContactMessage`
  - `id`
  - `name`
  - `email`
  - `message`
  - `locale`
  - `source`
  - `status`
  - `created_at`

Categorias iniciais:

- `sample-pages`
- `illustrations`
- `covers`
- `commissions`

## Decisao Sobre Admin

Nao criar painel administrativo no MVP.

Motivo: o briefing indica incerteza sobre quem vai atualizar e o site precisa sair rapido, simples e confiavel. Um admin agora exigiria autenticacao, permissoes, formularios, upload, moderacao, tratamento de imagens e testes extras. Isso aumentaria o escopo sem necessidade imediata.

Fluxo escolhido para o MVP:

1. Conteudo novo entra em `db/seeds.rb`, fixtures ou task Rails dedicada.
2. Imagens finais entram em `app/assets/images/portfolio`.
3. `insum/` permanece apenas como fonte local ignorada pelo Git.
4. Active Storage anexa as imagens versionadas aos registros de `Artwork`.
5. Variants do Active Storage geram tamanhos adequados para web.
6. O site renderiza o conteudo com Rails Views/ERB, cache de fragmentos quando fizer sentido e Turbo para atualizacoes parciais.

Esse caminho permite atualizar via codigo agora e reaproveitar os mesmos models para um `/admin` no futuro, sem migracao conceitual.

## Frontend

Rotas principais:

- `/pt`
- `/en`
- `/pt/portfolio`
- `/en/portfolio`
- `/pt/about`
- `/en/about`
- `/pt/contact`
- `/en/contact`

Experiencia principal:

- Home com impacto visual usando arte sequencial como primeira leitura.
- Portfolio com filtros por categoria.
- Visualizador fullscreen/lightbox para imagens.
- Sample pages exibidas como sequencias, preservando leitura de pagina.
- Sobre com bio curta, avatar e assinatura.
- Contato com email, Instagram e formulario simples.
- Secao de commissions explicando de forma objetiva o que ele aceita: arte original/tradicional, lapis, nanquim, aquarela, marcadores, A3/A4.

Direcao visual:

- Fundo escuro com areas off-white pontuais para respiro editorial.
- Tipografia moderna e pesada para titulos, com leitura limpa nos textos.
- Grid inspirado em paineis de HQ, sem parecer conjunto de cards genericos.
- Reticulas/halftone e textura de papel usados com moderacao.
- Assinatura do artista como elemento de marca, nao como decoracao repetitiva.
- Animacoes sutis: revelacao de paineis, hover de tinta/contraste, transicoes de lightbox.

## Backend Rails

Uso no MVP:

- PostgreSQL para conteudo do portfolio e mensagens de contato.
- Active Storage para imagens originais e variants otimizadas.
- Controllers Rails convencionais para home, portfolio, sobre e contato.
- Validacoes ActiveRecord para formularios e conteudo.
- Escopos de visibilidade para publicar apenas conteudo marcado como publico.
- Hotwire/Turbo para filtros, navegacao parcial e feedback do formulario quando fizer sentido.
- Stimulus para lightbox, interacoes de galeria e pequenos efeitos visuais.

Fora do MVP:

- Painel `/admin`.
- Login/autenticacao de administradores.
- Upload direto pelo admin.
- Secao de projetos publicados/noticias.
- Loja, newsletter ou integracoes comerciais.

## Convencoes de Codigo

- Ruby e Rails idiomaticos, com controllers e models pequenos.
- Partials/componentes de view pequenos, nomeados pelo comportamento real.
- Nada de UI kit generico no MVP.
- Dados externos sempre validados por models, forms ou objects simples quando necessario.
- Textos bilingues versionados e revisaveis.
- Evitar comentarios obvios; comentar apenas decisoes nao evidentes.
- Assets sempre com `alt_text` nos dois idiomas.
- Estados vazios e erros devem existir, mesmo que simples.

## Testes

Testes esperados no MVP:

- `bin/rails test`
- `bin/rails test:system`
- `bin/rails assets:precompile`
- `bin/rails db:prepare`
- `bin/rubocop`

Cobertura minima:

- Filtros da galeria.
- Resolucao de idioma.
- Validacoes de models.
- Renderizacao das rotas principais.
- Abertura/fechamento do lightbox.
- Validacao do formulario de contato.

Validacao visual:

- Screenshot desktop e mobile da home.
- Screenshot desktop e mobile do portfolio.
- Conferir que imagens verticais nao cortam informacao importante.
- Conferir que texto nao sobrepoe arte ou controles.

## Como Rodar

O ambiente atual nao possui Ruby instalado no Windows. O fluxo validado usa Docker.

1. Subir PostgreSQL:

```powershell
docker run -d --name gabrielsdl-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 55432:5432 postgres:16-alpine
```

2. Abrir um container Ruby montando o projeto:

```powershell
$repo = (Get-Location).Path -replace '\\','/'
docker run --rm -it -v "${repo}:/app" -v gabrielsdl-bundle:/usr/local/bundle -w /app -p 3000:3000 -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:55432/gabrielsdl_development ruby:3.3-bookworm bash
```

3. Dentro do container:

```bash
apt-get update
apt-get install -y --no-install-recommends libpq-dev
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server -b 0.0.0.0
```

## Como Rodar Testes

Com PostgreSQL rodando:

```bash
bin/rails db:prepare
bin/rails test
bin/rubocop
bin/rails assets:precompile
```

## Definition of Done

Uma tarefa so termina quando:

- O comportamento solicitado foi entregue.
- O codigo segue os padroes do projeto.
- Testes relevantes foram criados ou atualizados quando fizer sentido.
- Testes relevantes foram executados e passaram.
- `CODEX.md` foi atualizado quando houve decisao tecnica ou mudanca de fluxo.
- O resumo final lista arquivos alterados, testes executados e observacoes.

## Pendencias Conhecidas

- Confirmar email publico de contato.
- Confirmar URL final do Instagram e demais redes.
- Confirmar dominio e conta de hospedagem.
- Definir traducoes finais em ingles.
- Definir quais ilustracoes entram no primeiro lancamento.
- Otimizar imagens grandes antes de qualquer deploy.
- Levantar capa/referencia visual exata de Hailstone para orientar a primeira proposta visual.

## Proximos Passos

1. Refinar a direcao visual real da home e do portfolio.
2. Criar lightbox com Stimulus.
3. Melhorar filtros do portfolio com Turbo.
4. Definir email publico e links finais.
5. Validar visual em desktop/mobile.
