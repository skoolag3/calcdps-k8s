#!/bin/bash
set -e

echo "=== 1. Instalando kubectl ==="
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
    echo "kubectl instalado com sucesso!"
else
    echo "kubectl já está instalado."
fi

echo "=== 2. Instalando Minikube ==="
if ! command -v minikube &> /dev/null; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm -f minikube-linux-amd64
    echo "Minikube instalado com sucesso!"
else
    echo "Minikube já está instalado."
fi

echo "=== 3. Iniciando cluster Minikube ==="
minikube start --driver=docker --memory=2048

echo "=== 4. Construindo a imagem calcdps:v1 diretamente no Minikube ==="
# Isso garante que o cluster Kubernetes consiga puxar a imagem sem precisar de Docker Hub
eval $(minikube docker-env)
docker build -t calcdps:v1 .
docker tag calcdps:v1 calcdps:v2

echo "=== Ambiente pronto para a atividade! ==="
kubectl get nodes
kubectl cluster-info
