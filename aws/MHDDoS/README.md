# MHDDoS

## 场景说明

该场景会在 AWS `ap-east-1`（香港）区域创建 `node` 台 ARM64 EC2（`t4g.nano`），并在每台实例上以 tmux 会话启动 MHDDoS 压测工具。

实例会安装 Python3、编译工具链与 `hping3`，克隆 `MHDDoS` 与 `PyRoxy` 仓库并安装其 Python 依赖，随后在 `ds` 会话中以 `socks5.txt` 作为代理列表启动 `start.py`。同时会在本地生成 SSH 私钥（`./pte-proxy-key.pem`）用于登录。

该工具仅供已获得目标书面授权的压测与渗透测试使用；对未授权目标发起流量攻击是违法行为。此场景计费较高（默认 1T 流量档，约 1k 元），请谨慎评估成本。

## 前置条件

- AWS 账号需已开通 `ap-east-1`（香港）区域，且已配置可用的 redc 凭据。
- 默认使用 ARM64 机型 `t4g.nano`；若修改机型，需同步替换与架构匹配的 AMI。
- 必须通过 `terraform.tfvars` 或 `-e` 指定攻击模式、目标等参数，否则部署后 `start.py` 无法正常启动。
- 需确认账户配额与费用可接受；该场景按流量计费，成本较高。

## 快速使用

拉取场景：

```bash
redc pull aws/MHDDoS
```

指定目标与模式后启动：

```bash
redc run aws/MHDDoS \
  -e ddos_target=http://target.example.com:8000 \
  -e ddos_mode=APACHE \
  -e ddos_threads=1500 \
  -e ddos_time=300
```

查看运行状态：

```bash
redc status [uuid]
```

停止场景：

```bash
redc stop [uuid]
```

登录实例（私钥由场景在本地生成）：

```bash
ssh -i ./pte-proxy-key.pem admin@<public_ip>
```

## 参数说明

| 参数名 | 是否必填 | 默认值 | 示例 | 行为影响 |
|--------|----------|--------|------|----------|
| `node` | 是 | `10`（来自 `terraform.tfvars`） | `3` | 控制创建的 EC2 节点数量，直接影响并发量与费用。 |
| `ddos_target` | 是 | `http://www.target.com:8000`（来自 `terraform.tfvars`） | `http://target.example.com:8000` | 攻击目标地址，需替换为已授权目标。 |
| `ddos_threads` | 是 | `1500`（来自 `terraform.tfvars`） | `500` | 每节点线程数，影响压测强度。 |
| `ddos_time` | 是 | `300`（来自 `terraform.tfvars`） | `3600` | 持续时间，单位秒。 |
| `ddos_mode` | 是 | `APACHE`（来自 `terraform.tfvars`） | `POST` | 攻击方法，取值见 `variables.tf`：`APACHE` / `COOKIE` / `BYPASS` / `DOWNLOADER` / `POST` / `XMLRPC`。 |
| `ami` | 否 | `ami-01c9cc5554738042c` | `自定义镜像 ID` | 控制 EC2 使用的 AMI；当前机型为 ARM64，更换时需与实例架构一致。 |

> 除 `ami` 外，该模板的 `variables.tf` 未给其他变量设置 `default`，因此这些变量必须由 `terraform.tfvars` 或 `-e` 提供取值；表中对应的「默认值」列取自仓库内 `terraform.tfvars`。

## 输出说明

- `public_ip`：所有节点的公网 IP 列表。
- `ecs_ip`：兼容旧模板的输出别名，取值与 `public_ip` 相同。
- `ssh_user`：默认 SSH 用户名，当前为 `admin`。
- `ssh_commands`：可直接复制使用的 SSH 连接命令列表，已包含私钥路径。

## 注意事项

**区域配置**

需在 AWS 账号中开通 `ap-east-1`（香港）区域：

![](../../img/redc-2.png)

![](../../img/redc-3.png)

**使用限制**

本工具仅供 **授权的渗透测试** 使用，未经目标授权的 DDoS 攻击是违法行为。

**故障排查**

启动失败常见原因：与 AWS API 网络超时、该区域售罄或机型下架、AMI 架构与 `instance_type` 不匹配（当前为 ARM64 / `t4g.nano`）。

- 安全组默认放行全部入站和出站流量，部署后请按使用场景收紧。
- 本地私钥 `./pte-proxy-key.pem` 由 `local_file` 生成于当前工作目录，权限为 `0600`；请勿提交或外泄。
- 用户数据中会向 `MHDDoS/files/proxies/socks5.txt` 与 `/files/proxies/socks5.txt` 写入空的 SOCKS5 代理列表，如需使用代理需自行填充。
