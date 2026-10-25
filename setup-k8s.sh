#!/bin/bash
set -e

# Detecta a arquitetura automaticamente (amd64 ou arm64)
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    K8S_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    K8S_ARCH="arm64"
else
    K8S_ARCH="amd64"
fi

echo "=== Detectada arquitetura: $K8S_ARCH ($ARCH) ==="

echo "=== 1. Instalando kubectl ==="
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${K8S_ARCH}/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
    echo "kubectl instalado com sucesso!"
else
    echo "kubectl já está instalado."
fi

echo "=== 2. Instalando Minikube ==="
if ! command -v minikube &> /dev/null; then
    curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${K8S_ARCH}"
    sudo install "minikube-linux-${K8S_ARCH}" /usr/local/bin/minikube
    rm -f "minikube-linux-${K8S_ARCH}"
    echo "Minikube instalado com sucesso!"
else
    echo "Minikube já está instalado."
fi

echo "=== 3. Iniciando cluster Minikube ==="
minikube start --driver=docker --memory=2048

echo "=== 4. Construindo a imagem calcdps:v1 e carregando no Minikube ==="
# Garante que usamos o Docker nativo do Codespaces para buildar
eval $(minikube docker-env -u 2>/dev/null || true)
docker build -t calcdps:v1 .
docker tag calcdps:v1 calcdps:v2

# Carrega a imagem para dentro do cluster Minikube
minikube image load calcdps:v1
minikube image load calcdps:v2

echo ""
echo "=== AMBIENTE PRONTO COM SUCESSO! ==="
kubectl get nodes
kubectl cluster-info
