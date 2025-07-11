#!/bin/bash
K3S_URL=https://xxx.xx.x.xx:6443
K3S_TOKEN=xxxxxx
set -e

echo "🧹 卸载旧的 k3s-agent..."
/usr/local/bin/k3s-agent-uninstall.sh || true
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

if [ -z "$K3S_URL" ] || [ -z "$K3S_TOKEN" ]; then
  echo "请设置环境变量 K3S_URL 和 K3S_TOKEN"
  exit 1
fi

echo "🚀 安装 k3s Worker，加入集群..."
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -