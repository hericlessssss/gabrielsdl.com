# Infra VPS

Documento vivo da infraestrutura inicial do `gabrielsdl.com`.

## Servidor

- Provedor: Hostinger VPS.
- Hostname: `srv1672333`.
- IPv4 publico: `2.24.100.80`.
- IPv6 publico: `2a02:4780:75:6e6b::1`.
- Sistema operacional: Ubuntu 24.04.4 LTS.
- Kernel: Linux 6.8.0-111-generic.
- Virtualizacao: KVM.
- Usuario atual de acesso: `root`.
- Usuario de deploy: `deploy`.
- SSH host key: `ssh-ed25519 SHA256:17Tc+lwK4r1lLffTLUYqDF835VDPuZ8fTE0+CwtK1KA`.
- Chave local de deploy: `C:\Users\myPC\.ssh\gabrielsdl_vps_ed25519`.
- Fingerprint da chave de deploy: `SHA256:+F3uIa63Ib6VrVh7rMhuea8IR5jzDgfjfZiWqPgqOXo`.

## Recursos

- CPU: VPS KVM.
- Memoria: 3.8 GiB.
- Disco raiz: 48 GiB.
- Uso do disco apos configuracao: 10%.
- Swap: 2 GiB em `/swapfile`.

## Docker

- Docker instalado: sim.
- Docker version: 29.5.0.
- Docker Compose version: v5.1.3.
- Servico Docker: ativo.
- Usuario `deploy` pertence ao grupo `docker`.
- Containers existentes: nenhum.
- Imagens existentes: nenhuma.
- Volumes existentes: nenhum.

Conclusao: a opcao da Hostinger instalou Docker Engine e Docker Compose. Nao ha evidencias de Portainer, Coolify, CapRover, Dokploy, Easypanel, Traefik, Nginx ou Caddy rodando na VPS.

## Rede

- Portas abertas no sistema:
  - `22/tcp`: SSH.
  - `53`: resolver local do systemd.
- Firewall UFW: ativo.
- Politica UFW: negar entrada, permitir saida.
- Portas liberadas:
  - `22/tcp`: SSH.
  - `80/tcp`: HTTP.
  - `443/tcp`: HTTPS.
- Servicos web ativos: nenhum.

## DNS

- Dominio: `gabrielsdl.com`.
- Provedor DNS: Hostinger.
- Nameservers:
  - `aster.dns-parking.com`.
  - `helios.dns-parking.com`.
- Registro raiz:
  - Tipo: `A`.
  - Nome: `@`.
  - Valor esperado: `2.24.100.80`.
- Registro `www`:
  - Tipo: `CNAME`.
  - Nome: `www`.
  - Valor esperado: `gabrielsdl.com`.

Em 2026-05-14 foi removido o registro A antigo `2.57.91.91`.

Durante o primeiro deploy, alguns resolvers ainda respondiam `2.57.91.91`. A aplicacao ja responde corretamente quando o dominio e resolvido para `2.24.100.80`.

Validacao esperada:

```powershell
Resolve-DnsName gabrielsdl.com
Resolve-DnsName www.gabrielsdl.com
```

`gabrielsdl.com` deve resolver somente para `2.24.100.80`.

## Estado Inicial

A VPS esta limpa e adequada para receber deploy via Docker/Kamal.

Configurado em 2026-05-14:

1. Criado usuario `deploy`.
2. Configurado acesso SSH por chave.
3. Configurado `sudo` sem senha para `deploy`.
4. Adicionado `deploy` ao grupo `docker`.
5. Desabilitado login SSH por senha.
6. Desabilitado login root por senha.
7. Ativado UFW com `22`, `80` e `443`.
8. Criado swap de 2 GiB.
9. Aplicadas atualizacoes disponiveis nao retidas.

Pendencias antes do deploy publico:

1. Definir dominio e DNS.
2. Definir banco: PostgreSQL local em container ou servico externo.
3. Definir storage de imagens: volume persistente, S3 ou Cloudflare R2.
4. Configurar variaveis de ambiente do Rails.
5. Rotacionar senha root.
6. Avaliar atualizacoes retidas do kernel/cloud-init.

## Decisao Recomendada

Usar Kamal para deploy Rails.

Motivo:

- Rails 8 ja vem preparado para Docker/Kamal.
- A VPS esta limpa.
- Docker ja esta instalado.
- Mantem deploy simples e reproduzivel.
- Permite usar proxy com SSL automatico.

## Deploy Rails

Ferramenta escolhida: Kamal.

Arquitetura inicial:

- `kamal-proxy` publica HTTP/HTTPS.
- Rails roda em container Docker.
- PostgreSQL roda como accessory Docker.
- Active Storage usa volume local persistente.
- Imagem Docker e construida na propria VPS via remote builder.

Dominio principal:

- `https://gabrielsdl.com`.

Banco de producao:

- Host interno: `gabrielsdl-db`.
- Usuario: `gabrielsdl`.
- Banco principal: `gabrielsdl_production`.
- Bancos auxiliares Rails:
  - `gabrielsdl_production_cache`.
  - `gabrielsdl_production_queue`.
  - `gabrielsdl_production_cable`.

Volumes persistentes:

- `gabrielsdl_storage:/rails/storage`.
- Accessory PostgreSQL: `data:/var/lib/postgresql/data`.

Primeiro deploy executado em 2026-05-15.

Status apos deploy:

- `kamal-proxy`: ativo em `80` e `443`.
- `gabrielsdl-web`: ativo.
- `gabrielsdl-db`: ativo.
- HTTPS: ativo via Kamal Proxy/Let's Encrypt.
- Validacao direta para a VPS: `https://gabrielsdl.com/pt` retorna Rails quando resolvido para `2.24.100.80`.

Observacao operacional:

O deploy foi executado a partir de um container Ruby local com Docker socket e rede host, porque o ambiente Windows local nao possui Ruby instalado.

Validacao usada:

```powershell
curl.exe --resolve gabrielsdl.com:443:2.24.100.80 -I https://gabrielsdl.com/pt
curl.exe --resolve gabrielsdl.com:80:2.24.100.80 -I http://gabrielsdl.com/pt
```

Comandos uteis:

```powershell
ssh -i $env:USERPROFILE\.ssh\gabrielsdl_vps_ed25519 deploy@2.24.100.80
docker ps
docker logs kamal-proxy --tail 100
docker logs gabrielsdl-db --tail 100
```

Pendencia DNS:

Confirmar que todos os resolvers retornam somente `2.24.100.80` para `gabrielsdl.com`.

## Seguranca

Nao registrar senhas neste repositorio.

A senha root deve ser rotacionada antes da entrada em producao, principalmente depois de qualquer compartilhamento fora de um cofre de senhas.

SSH efetivo apos hardening:

- `PermitRootLogin without-password`.
- `PasswordAuthentication no`.
- `KbdInteractiveAuthentication no`.
- `PubkeyAuthentication yes`.

Comando de acesso:

```powershell
ssh -i $env:USERPROFILE\.ssh\gabrielsdl_vps_ed25519 deploy@2.24.100.80
```
