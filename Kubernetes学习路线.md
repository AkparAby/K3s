### 什么是 K3s？
#### K3s 是一个完全兼容的 Kubernetes 发行版，具有以下增强功能：

- 打包为单个二进制文件。
- 使用基于 sqlite3 作为默认存储机制的轻量级存储后端。同时支持使用 etcd3、MySQL 和 Postgres。
- 封装在简单的启动程序中，可以处理很多复杂的 TLS 和选项。
- 默认情况下是安全的，对轻量级环境有合理的默认值。
- 添加了简单但强大的 batteries-included 功能，例如：
  - 本地存储提供程序
  - 服务负载均衡器
  - Helm 控制器
  - Traefik 入口控制器
- 所有 Kubernetes control plane 组件的操作都封装在单个二进制文件和进程中。因此，K3s 支持自动化和管理复杂的集群操作（例如证书分发等）。
- 最大程度减轻了外部依赖性，K3s 仅需要现代内核和 cgroup 挂载。K3s 打包了所需的依赖，包括：
  - containerd
  - Flannel (CNI)
  - CoreDNS
  - Traefik (Ingress)
  - Klipper-lb (Service LB)
  - 嵌入式网络策略控制器
  - 嵌入式 local-path-provisioner
  - 主机实用程序（iptables、socat 等）


### 踩坑日记
 #### 端口开放 
 - 高可用部署时不要忘记开放 `2379-2380` 端口！不然server节点加不进去

---

### K3s节点的入站规则

  | Protocol | Port      | Source   | Destination | Description                                              |
  | :------- | :-------- | :------- | :---------- | :--------------------------------------------------------|
  | TCP      | 2379-2380 | Servers  | Servers     | Required only for HA with embedded etcd                  |
  | TCP      | 6443      | Agents   | Servers     | K3s supervisor and Kubernetes API Server                 |
  | UDP      | 8472      | All nodes| All nodes   | Required only for Flannel VXLAN                          |
  | TCP      | 10250     | All nodes| All nodes   | Kubelet metrics                                          |
  | UDP      | 51820     | All nodes| All nodes   | Required only for Flannel Wireguard with IPv4            |
  | UDP      | 51821     | All nodes| All nodes   | Required only for Flannel Wireguard with IPv6            |
  | TCP      | 5001      | All nodes| All nodes   | Required only for embedded distributed registry (Spiegel)|
  | TCP      | 6443      | All nodes| All nodes   | Required only for embedded distributed registry (Spiegel)|

