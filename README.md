# gabrielsdl.com

Esse site foi construido como uma aplicacao Ruby on Rails fullstack, com renderizacao server-side, navegacao dinamica via Hotwire e uma estrutura simples de manutencao por codigo.

## Stack

- Ruby 3.3
- Ruby on Rails 8.1
- PostgreSQL
- ERB views
- Hotwire/Turbo
- Stimulus
- Tailwind CSS 4
- Active Storage
- Action Mailer
- Minitest
- System tests com Capybara/Selenium
- Docker e Docker Compose
- Kamal para deploy
- GitHub Actions para CI/CD

## Arquitetura

A aplicacao segue o padrao Rails tradicional:

- `app/controllers`: controle das rotas publicas, filtros e formulario de contato.
- `app/models`: regras de dominio, traducoes, portfolio, projetos, imagens e mensagens.
- `app/views`: templates ERB renderizados no servidor.
- `app/assets`: imagens versionadas e CSS Tailwind.
- `app/javascript/controllers`: controllers Stimulus para interacoes leves.
- `config/locales`: textos em portugues e ingles.
- `db/seeds.rb`: conteudo inicial do portfolio.
- `test`: testes automatizados.
- `config/deploy.yml`: configuracao Kamal.

Nao existe SPA, build separado de frontend ou API publica para consumo externo. O Rails entrega HTML, assets e comportamento interativo no mesmo app.

## Funcionalidades

- Rotas localizadas em `pt` e `en`.
- Conteudo bilingue via I18n.
- Portfolio filtravel por categoria.
- Projetos destacados e ordenacao manual.
- Imagens gerenciadas por Active Storage.
- Lightbox com Stimulus.
- Formulario de contato persistido no banco.
- Envio de email via SMTP.
- SEO basico com title, description, canonical, Open Graph e alternates.
- Layout responsivo com Tailwind.

## Banco e arquivos

O banco principal e PostgreSQL.

As imagens publicas usadas no portfolio ficam versionadas em `app/assets/images`. Quando necessario, os seeds anexam essas imagens aos registros via Active Storage.

Uploads e arquivos persistentes em producao dependem do volume configurado no deploy. Essa parte nao deve ficar dentro da imagem Docker.

## Ambiente local

Subir o ambiente:

```bash
docker compose up -d web
```

Acessar:

```txt
http://localhost:3000/pt
```

Preparar banco:

```bash
docker compose exec web bin/rails db:prepare
```

Rodar seeds:

```bash
docker compose exec web bin/rails db:seed
```

Compilar Tailwind:

```bash
docker compose exec web bin/rails tailwindcss:build
```

## Testes

Lint:

```bash
docker compose exec web bin/rubocop
```

Testes Rails:

```bash
docker compose exec -e RAILS_ENV=test -e DATABASE_URL=postgres://postgres:postgres@db:5432 web bin/rails test
```

System tests:

```bash
docker compose exec -e RAILS_ENV=test -e DATABASE_URL=postgres://postgres:postgres@db:5432 web bin/rails test:system
```

Build de assets:

```bash
docker compose exec web bin/rails assets:precompile
```

## CI/CD

A esteira roda no GitHub Actions em pushes para `main`, pull requests e execucao manual.

Jobs principais:

- `scan_ruby`: Brakeman e bundler-audit.
- `scan_js`: audit do importmap.
- `lint`: RuboCop.
- `test`: testes Rails com PostgreSQL.
- `system_test`: testes de navegador.
- `assets`: precompile de assets.
- `deploy`: deploy via Kamal, somente apos todos os jobs anteriores passarem.

O deploy acontece apenas em push para `main`.

## Deploy

O deploy usa Kamal com Docker.

Fluxo geral:

1. GitHub Actions valida o codigo.
2. Kamal cria a imagem Docker.
3. A imagem e enviada para o registry local temporario.
4. A VPS baixa a nova imagem.
5. Kamal executa migracoes e sobe o novo container.
6. Volumes persistentes preservam banco e arquivos.

Secrets esperados no GitHub:

- `KAMAL_SSH_PRIVATE_KEY`
- `RAILS_MASTER_KEY`
- `GABRIELSDL_DATABASE_PASSWORD`
- `SMTP_USERNAME`
- `SMTP_PASSWORD`

## Variaveis de ambiente

O arquivo `.env.example` documenta as variaveis usadas localmente e em producao.

SMTP padrao:

```txt
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=gmail.com
CONTACT_FROM_EMAIL=
CONTACT_TO_EMAIL=
SMTP_USERNAME=
SMTP_PASSWORD=
```

## Observacoes

- `insum/` e uma pasta local de insumos e nao deve ser versionada.
- `tmp/`, logs, storage local e arquivos gerados nao devem entrar no repositorio.
- Alteracoes de conteudo podem ser feitas via seeds enquanto nao houver painel administrativo.
- Mudancas visuais devem ser validadas localmente antes do deploy.
