# Atividade Prática: Kubernetes no GitHub Codespaces (CalcDPS)

Este repositório contém a aplicação **CalcDPS** (Python / Streamlit) adaptada para implantação em cluster Kubernetes (Minikube) no **GitHub Codespaces**.

---

## 📸 Checklist dos Prints para Envio no AVA

Você deve capturar prints do terminal mostrando os comandos e suas saídas:

1. **Print 1 (Cluster):** `kubectl get nodes` e `kubectl cluster-info` mostrando o nó `Ready`.
2. **Print 2 (Deployment e Pods):** `kubectl apply -f deployment.yaml` e `kubectl get pods` (com 2 réplicas rodando).
3. **Print 3 (Service):** `kubectl apply -f service.yaml` e `kubectl get svc`.
4. **Print 4 (Acesso à Aplicação):** `kubectl port-forward service/calcdps-service 8080:8501` e o navegador/aba Ports acessando a tela do CalcDPS.
5. **Print 5 (Escalonamento):** `kubectl scale deployment calcdps-app --replicas=4` e `kubectl get pods` mostrando 4 réplicas rodando.
6. **Print 6 (Rolling Update):** `kubectl apply -f deployment.yaml` e `kubectl rollout status deployment/calcdps-app`.
7. **Print 7 (Rollback):** `kubectl rollout undo deployment/calcdps-app` e `kubectl rollout status deployment/calcdps-app`.

---

## 🚀 Passo a Passo no GitHub Codespaces

### Passo 1: Abrir no Codespaces
1. No seu repositório no GitHub, clique no botão verde **`< > Code`**.
2. Vá na aba **Codespaces** e clique em **Create codespace on main**.
3. Aguarde o ambiente abrir no navegador.

---

### Passo 2 & 3: Instalação e Inicialização do Cluster

No terminal do Codespace, você pode executar o script automático:
```bash
chmod +x setup-k8s.sh
./setup-k8s.sh
```

*Ou executar manualmente cada comando:*
```bash
# 1. Instalar kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# 2. Instalar Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# 3. Iniciar o Cluster
minikube start --driver=docker --memory=2048

# 4. Gerar a imagem localmente dentro do Minikube
eval $(minikube docker-env)
docker build -t calcdps:v1 .
docker tag calcdps:v1 calcdps:v2
```

---

### Passo 4: Verificar o Cluster 📸 *(Tirar Print 1)*

```bash
kubectl get nodes
kubectl cluster-info
```

---

### Parte 1: Criar o Deployment 📸 *(Tirar Print 2)*

```bash
kubectl apply -f deployment.yaml
kubectl get pods
kubectl describe deployment calcdps-app
```

---

### Parte 2: Criar o Service 📸 *(Tirar Print 3)*

```bash
kubectl apply -f service.yaml
kubectl get svc
```

---

### Parte 3: Acessar a Aplicação 📸 *(Tirar Print 4)*

Encaminhe a porta do serviço (porta 8501 da aplicação para 8080 local):
```bash
kubectl port-forward service/calcdps-service 8080:8501
```
* O Codespaces mostrará uma notificação para abrir a porta no navegador (ou vá na aba **Ports** do VS Code e clique no globo ao lado da porta 8080).
* Tire um print do terminal rodando o port-forward e da aplicação aberta!
* Para parar o port-forward no terminal e continuar os próximos comandos, pressione `Ctrl + C`.

---

### Parte 4: Escalar a Aplicação 📸 *(Tirar Print 5)*

Escale para 4 réplicas:
```bash
kubectl scale deployment calcdps-app --replicas=4
kubectl get pods
```

---

### Parte 5: Rolling Update 📸 *(Tirar Print 6)*

No arquivo `deployment.yaml`, altere a linha da imagem:
```yaml
image: calcdps:v2
```
Em seguida, aplique a atualização e verifique o status:
```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment/calcdps-app
```

---

### Parte 6: Rollback 📸 *(Tirar Print 7)*

Reverta a atualização:
```bash
kubectl rollout undo deployment/calcdps-app
kubectl rollout status deployment/calcdps-app
```

---

### Parte 7: Limpeza

Finalize e limpe os recursos:
```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
minikube stop
```
