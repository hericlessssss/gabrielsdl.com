# gabrielsdl.com

Portfolio Rails fullstack de Gabriel SDL, quadrinista e ilustrador.

## Stack

- Ruby on Rails 8.1
- PostgreSQL
- Hotwire/Turbo
- Stimulus
- Tailwind CSS
- Active Storage
- Minitest

## Desenvolvimento com Docker

O ambiente local atual nao tem Ruby instalado. Use Docker para rodar PostgreSQL e Rails.

```powershell
docker run -d --name gabrielsdl-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 55432:5432 postgres:16-alpine
```

```powershell
$repo = (Get-Location).Path -replace '\\','/'
docker run --rm -it -v "${repo}:/app" -v gabrielsdl-bundle:/usr/local/bundle -w /app -p 3000:3000 -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:55432/gabrielsdl_development ruby:3.3-bookworm bash
```

Dentro do container:

```bash
apt-get update
apt-get install -y --no-install-recommends libpq-dev
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server -b 0.0.0.0
```

Acesse `http://localhost:3000/pt`.

## Testes

```bash
bin/rails test
bin/rubocop
bin/rails assets:precompile
```

## Insumos Locais

A pasta `insum/` e os arquivos originais do briefing/artes sao locais e ignorados pelo Git.
