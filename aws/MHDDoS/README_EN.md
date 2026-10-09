# MHDDoS

## Scene Description

This scenario creates `node` ARM64 EC2 instances (`t4g.nano`) in AWS `ap-east-1` (Hong Kong) and starts the MHDDoS stress-testing tool inside a tmux session on each instance.

Each instance installs Python 3, a build toolchain and `hping3`, clones the `MHDDoS` and `PyRoxy` repositories, installs their Python dependencies, and then launches `start.py` in the `ds` session using `socks5.txt` as the proxy list. An SSH private key (`./pte-proxy-key.pem`) is also generated locally for login.

This tool is for stress testing and penetration testing with written authorization from the target only; flooding an unauthorized target is illegal. This scenario is expensive (default 1T traffic tier, roughly 1000 CNY), so evaluate the cost carefully.

## Prerequisites

- An AWS account with the `ap-east-1` (Hong Kong) region enabled and working redc credentials.
- The default instance type is the ARM64 `t4g.nano`; if you change it, replace the AMI with a matching architecture.
- Attack mode, target and related parameters must be supplied via `terraform.tfvars` or `-e`, otherwise `start.py` cannot start correctly after deployment.
- Confirm your account quota and cost tolerance; this scenario is billed on traffic and is comparatively expensive.

## Quick Start

Pull the scenario:

```bash
redc pull aws/MHDDoS
```

Start with an explicit target and mode:

```bash
redc run aws/MHDDoS \
  -e ddos_target=http://target.example.com:8000 \
  -e ddos_mode=APACHE \
  -e ddos_threads=1500 \
  -e ddos_time=300
```

Check status:

```bash
redc status [uuid]
```

Stop the scenario:

```bash
redc stop [uuid]
```

Log in to an instance (the private key is generated locally by the scenario):

```bash
ssh -i ./pte-proxy-key.pem admin@<public_ip>
```

## Parameters

| Parameter | Required | Default | Example | Behavior |
|-----------|----------|---------|---------|----------|
| `node` | Yes | `10` (from `terraform.tfvars`) | `3` | Number of EC2 nodes, directly affecting concurrency and cost. |
| `ddos_target` | Yes | `http://www.target.com:8000` (from `terraform.tfvars`) | `http://target.example.com:8000` | Attack target; replace with an authorized target. |
| `ddos_threads` | Yes | `1500` (from `terraform.tfvars`) | `500` | Threads per node, affecting stress level. |
| `ddos_time` | Yes | `300` (from `terraform.tfvars`) | `3600` | Duration in seconds. |
| `ddos_mode` | Yes | `APACHE` (from `terraform.tfvars`) | `POST` | Attack method; see `variables.tf` for valid values: `APACHE` / `COOKIE` / `BYPASS` / `DOWNLOADER` / `POST` / `XMLRPC`. |

> This template's `variables.tf` defines no `default` for any variable, so values must be supplied by `terraform.tfvars` or `-e` at deploy time; the Default column above reflects the in-repo `terraform.tfvars`.

## Outputs

- `public_ip`: list of public IPs for all nodes.
- `ecs_ip`: legacy alias retained from the source template, same value as `public_ip`.
- `ssh_user`: default SSH username, currently `admin`.
- `ssh_commands`: ready-to-use SSH command list including the private key path.

## Notes

**Region Configuration**

Enable the `ap-east-1` (Hong Kong) region in your AWS account:

![](../../img/redc-2.png)

![](../../img/redc-3.png)

**Usage Restrictions**

This tool is for **authorized penetration testing only**. DDoS attacks without target authorization are illegal.

**Troubleshooting**

Common start failures: network timeouts to the AWS API, region sold out or instance type delisted, and AMI architecture not matching `instance_type` (currently ARM64 / `t4g.nano`).

- The security group allows all inbound and outbound traffic by default; restrict it to your use case after deployment.
- The local private key `./pte-proxy-key.pem` is written by `local_file` into the working directory with `0600` permissions; never commit or share it.
- The user data writes empty SOCKS5 proxy lists to `MHDDoS/files/proxies/socks5.txt` and `/files/proxies/socks5.txt`; populate them yourself if you need proxies.
