#!/bin/bash 
# 第一个主节点执行脚本时传 init 参数：./install_master.sh init
# 其他主节点设置环境变量 K3S_URL=https://第一个主节点IP:6443，K3S_TOKEN=从第一个主节点获取的token，
# 执行 ./install_master.sh
K3S_URL=https://xxx.xx.x.xx:6443
K3S_TOKEN=xxxxxx
set -e

echo "🧹 卸载旧的 k3s..."
/usr/local/bin/k3s-uninstall.sh || true
rm -rf /etc/rancher /var/lib/rancher /var/lib/kubelet /run/k3s

echo "🛠️ 配置国内镜像加速..."
mkdir -p /etc/rancher/k3s

cat > /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  "docker.io":
    endpoint:
      - "https://docker.1panel.live"
      - "https://docker.1ms.run"
      - "https://dytt.online"
      - "https://docker-0.unsee.tech"
      - "https://lispy.org"
      - "https://666860.xyz"
      - "https://hub.rat.dev"
      - "https://docker.m.daocloud.io"
      - "https://demo.52013120.xyz"
      - "https://proxy.vvvv.ee"
EOF

if [ "$1" == "init" ]; then
  echo "🚀 安装 k3s Master，初始化集群..."
  curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_EXEC="server --cluster-init" sh -
  echo "✅ K3s Master 初始化完成。"
  echo "🔑 请记下您的 K3s 集群 Token (用于其他 Master 和 Worker 加入)："
  # 等待K3s服务启动并生成token文件，防止文件不存在
  sleep 10
  sudo cat /var/lib/rancher/k3s/server/node-token
  echo "--------------------------------------------------"
else
  if [ -z "$K3S_URL" ] || [ -z "$K3S_TOKEN" ]; then
    echo "请设置环境变量 K3S_URL 和 K3S_TOKEN"
    exit 1
  fi
  echo "🚀 安装 k3s Master，加入集群..."
  curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_EXEC="server" K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -
fi
