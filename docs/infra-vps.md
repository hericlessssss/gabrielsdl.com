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
- SSH host key: `ssh-ed25519 SHA256:17Tc+lwK4r1lLffTLUYqDF835VDPuZ8fTE0+CwtK1KA`.

## Recursos

- CPU: VPS KVM.
- Memoria: 3.8 GiB.
- Disco raiz: 48 GiB.
- Uso inicial do disco: 6%.
- Swap: nao configurado.

## Docker

- Docker instalado: sim.
- Docker version: 29.5.0.
- Docker Compose version: v5.1.3.
- Servico Docker: ativo.
- Containers existentes: nenhum.
- Imagens existentes: nenhuma.
- Volumes existentes: nenhum.

Conclusao: a opcao da Hostinger instalou Docker Engine e Docker Compose. Nao ha evidencias de Portainer, Coolify, CapRover, Dokploy, Easypanel, Traefik, Nginx ou Caddy rodando na VPS.

## Rede

- Portas abertas no sistema:
  - `22/tcp`: SSH.
  - `53`: resolver local do systemd.
- Firewall UFW: inativo.
- Servicos web ativos: nenhum.

## Estado Inicial

A VPS esta limpa e adequada para receber deploy via Docker/Kamal.

Antes do deploy publico, ajustar:

1. Criar usuario nao-root para deploy.
2. Configurar acesso SSH por chave.
3. Desabilitar login root por senha.
4. Ativar UFW liberando `22`, `80` e `443`.
5. Aplicar atualizacoes pendentes do Ubuntu.
6. Configurar swap pequeno se necessario.
7. Definir dominio e DNS.
8. Definir banco: PostgreSQL local em container ou servico externo.
9. Definir storage de imagens: volume persistente, S3 ou Cloudflare R2.
10. Configurar variaveis de ambiente do Rails.

## Decisao Recomendada

Usar Kamal para deploy Rails.

Motivo:

- Rails 8 ja vem preparado para Docker/Kamal.
- A VPS esta limpa.
- Docker ja esta instalado.
- Mantem deploy simples e reproduzivel.
- Permite usar proxy com SSL automatico.

## Seguranca

Nao registrar senhas neste repositorio.

A senha root deve ser rotacionada antes da entrada em producao, principalmente depois de qualquer compartilhamento fora de um cofre de senhas.
