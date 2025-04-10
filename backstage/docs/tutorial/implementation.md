- [Implementando o ArgoCD no ambiente](#implementando-o-argocd-no-ambiente)
- [Requisitos](#requisitos)
- [Passos](#passos)
  - [1.  Deploy via Helm com Terraform](#1--deploy-via-helm-com-terraform)
  - [2. Objetivo](#2-objetivo)

# Implementando o ArgoCD no ambiente

Este rápido passo a passo visa mostrar como fazer o deploy e utilização do ArgoCD em um ambiente são necessários alguns requisitos:

---

# Requisitos

- [x] Cluster Kubernetes
- [x] Kubectl
- [x] Helm
- [x] Terraform

---

# Passos

O script terraform faz basicamente os passos abaixo, deixando pronto o uso para deploy nos ambientes:

```
kubectl create namespace argocd;

kubectl apply -n argocd -f install.yaml;

kubectl get pods -n argocd;

kubectl port-forward svc/argocd-server -n argocd 8080:443;

kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath={.data.password} | base64 -d;

kubectl apply -f applications\argocd-demo-app.yaml;
```

## 1.  Deploy via Helm com Terraform

Na pasta raiz temos o modulo do Terraform que implementa o ESO via Helm no repositório `aws_tf_module_argocd_install`, e temos um repositório que faz a chamada do Modulo ESO para implementar, basta chamá-lo no repositorio `aws_tf_argocd_install`

Para execução do Terraform, basta executar o comando normalmente navegando por cada ambiente:

```
cd $(ambiente);

terraform init;

terraform apply -auto-approve;
```

---

## 2. Objetivo

O objetivo deste tutorial é somente exemplificar o provisionamento do ArgoCD para apresentar seu funcionamento de Applications para exemplo.

---