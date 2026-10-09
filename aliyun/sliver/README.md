# sliver

## 场景说明

该场景会在阿里云创建一套独立的 VPC、VSwitch、安全组和一台 ECS，并部署 Sliver C2 服务端与配套工具链。

部署完成后可直接通过 `ssh` 登录，在 `/root` 下使用 `sliver-server` 与 `sliver-client`；同时预装 MinGW 交叉编译工具链（`mingw-w64`、`binutils-mingw-w64`、`g++-mingw-w64`）与 `simplehttpserver`，可在服务端直接生成 Windows 载荷并托管。

该模板适用于已获得授权的渗透测试与红队演练环境，请勿用于未授权目标。

## 前置条件

- 阿里云账号需已配置可用凭据，并具备创建 ECS、VPC、VSwitch 和安全组的权限。
- 账号余额需大于 200 元，否则可能无法创建实例。
- 需准备可用的 GitHub 加速地址（默认 `https://ghfast.top/github.com`），用于下载 sliver 与 simplehttpserver 发行包；国内网络直连 GitHub 可能失败。
- 默认部署在 `cn-beijing`，使用 `ecs.c7a.large`、20 GiB ESSD 系统盘和 100 Mbps 公网带宽；该规格在部分地域可能售罄或下架，请提前确认库存。

## 快速使用

拉取场景：

```bash
redc pull aliyun/sliver
```

使用默认参数启动：

```bash
redc run aliyun/sliver
```

查看运行状态：

```bash
redc status [uuid]
```

停止场景：

```bash
redc stop [uuid]
```

登录后导入客户端配置（`sliver.cfg` 位于实例 `/root` 下）：

```bash
scp root@<public_ip>:/root/sliver.cfg ./sliver.cfg
sliver import ./sliver.cfg
sliver
```

## 参数说明

| 参数名 | 是否必填 | 默认值 | 示例 | 行为影响 |
|--------|----------|--------|------|----------|
| `instance_name` | 否 | `sliver` | `sliver-test` | 控制 ECS 实例名；留空时使用 `sliver`。 |
| `github_proxy` | 是 | 无 | `https://ghfast.top/github.com` | 用于拼接 sliver 与 simplehttpserver 的下载地址；留空会导致下载失败。 |
| `instance_password` | 否 | 自动生成 | `StrongPass123!` | 控制 root 登录密码；留空时自动生成。 |

> 实例规格、镜像、系统盘与带宽当前在 `main.tf` 中固定（`ecs.c7a.large`、Debian 11、20 GiB、100 Mbps），未通过变量暴露。

## 输出说明

- `public_ip`：ECS 公网 IP。
- `ssh_user`、`ssh_command`、`ssh_password`：标准 SSH 连接信息。
- `ecs_ip`、`ecs_password`：兼容旧模板的输出别名，与 `public_ip`、`ssh_password` 取值相同。

## 注意事项

- 安全组默认放行全部 TCP/UDP 端口（`0.0.0.0/0`），仅应在隔离且已授权的测试环境中使用；生产使用前必须按来源 IP 和实际端口收紧。
- `sliver-server` 以 systemd 服务 `sliver` 的 daemon 模式运行，可通过 `systemctl status sliver` 查看。
- 客户端配置 `/root/sliver.cfg` 的 `lhost` 取自实例 EIP，需实例已分配公网 IP 才有意义。
- 启动失败常见原因：账号余额不足、与阿里云 API 网络超时、地域售罄或规格下架、Sliver 上游部署方式变更导致 `user_data` 配置过时。

## 附录

静态资源可通过 `github_proxy` 替换。若需更换版本，请修改 `main.tf` 中的下载地址与 `terraform.tfvars` 中的加速地址：

- Sliver server/client：[BishopFox/sliver releases](https://github.com/BishopFox/sliver/releases)（当前为 `v1.6.6`）。
- simplehttpserver：[projectdiscovery/simplehttpserver](https://github.com/projectdiscovery/simplehttpserver)（当前为 `v0.0.6`）。
- GitHub 加速地址：`terraform.tfvars` 中的 `github_proxy`，默认 `https://ghfast.top/github.com`。
