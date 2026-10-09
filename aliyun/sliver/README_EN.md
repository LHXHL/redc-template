# sliver

## Scene Description

This scenario creates an isolated VPC, VSwitch, security group and a single ECS instance on Alibaba Cloud, then deploys the Sliver C2 server together with its toolchain.

After deployment you can log in over `ssh` and use `sliver-server` and `sliver-client` under `/root`. The MinGW cross-compilation toolchain (`mingw-w64`, `binutils-mingw-w64`, `g++-mingw-w64`) and `simplehttpserver` are pre-installed so Windows payloads can be generated and hosted directly on the server.

This template is intended for authorized penetration testing and red team exercises. Do not use it against unauthorized targets.

## Prerequisites

- An Alibaba Cloud account with working credentials and permission to create ECS, VPC, VSwitch and security group resources.
- An account balance above 200 CNY, otherwise instance creation may fail.
- A working GitHub acceleration prefix (default `https://ghfast.top/github.com`) for downloading the sliver and simplehttpserver release archives; direct GitHub access from mainland China may fail.
- Defaults deploy to `cn-beijing` with `ecs.c7a.large`, a 20 GiB ESSD system disk and 100 Mbps public bandwidth. This instance type may be sold out or delisted in some regions, so verify availability in advance.

## Quick Start

Pull the scenario:

```bash
redc pull aliyun/sliver
```

Start with default parameters:

```bash
redc run aliyun/sliver
```

Check status:

```bash
redc status [uuid]
```

Stop the scenario:

```bash
redc stop [uuid]
```

After logging in, import the client config (`sliver.cfg` lives in `/root` on the instance):

```bash
scp root@<public_ip>:/root/sliver.cfg ./sliver.cfg
sliver import ./sliver.cfg
sliver
```

## Parameters

| Parameter | Required | Default | Example | Behavior |
|-----------|----------|---------|---------|----------|
| `instance_name` | No | `sliver` | `sliver-test` | Controls the ECS instance name; falls back to `sliver`. |
| `github_proxy` | Yes | none | `https://ghfast.top/github.com` | Prefix used to build the sliver and simplehttpserver download URLs; an empty value breaks downloads. |
| `instance_password` | No | auto-generated | `StrongPass123!` | Controls the root login password; auto-generated when empty. |

> Instance type, image, system disk and bandwidth are currently fixed in `main.tf` (`ecs.c7a.large`, Debian 11, 20 GiB, 100 Mbps) and are not exposed as variables.

## Outputs

- `public_ip`: ECS public IP address.
- `ssh_user`, `ssh_command`, `ssh_password`: standard SSH connection details.
- `ecs_ip`, `ecs_password`: legacy aliases retained from the source template, with the same values as `public_ip` and `ssh_password`.

## Notes

- The security group opens all TCP/UDP ports to `0.0.0.0/0` by default. Use it only in isolated, authorized test environments and restrict by source IP and actual ports before any production use.
- `sliver-server` runs as a systemd service named `sliver` in daemon mode; check it with `systemctl status sliver`.
- The `lhost` in `/root/sliver.cfg` is derived from the instance EIP, so it is only meaningful once a public IP is attached.
- Common start failures: insufficient account balance, network timeouts to the Alibaba Cloud API, region sold out or instance type delisted, and upstream Sliver deployment changes that make the `user_data` configuration outdated.

## Appendix

Static resources can be swapped via `github_proxy`. To change versions, edit the download URLs in `main.tf` and the acceleration prefix in `terraform.tfvars`:

- Sliver server/client: [BishopFox/sliver releases](https://github.com/BishopFox/sliver/releases) (currently `v1.6.6`).
- simplehttpserver: [projectdiscovery/simplehttpserver](https://github.com/projectdiscovery/simplehttpserver) (currently `v0.0.6`).
- GitHub acceleration prefix: `github_proxy` in `terraform.tfvars`, default `https://ghfast.top/github.com`.
