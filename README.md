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

O ambiente local atual nao tem Ruby instalado. Use Docker Compose para rodar PostgreSQL e Rails.

```powershell
docker compose up -d web
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
