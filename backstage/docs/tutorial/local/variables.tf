variable "chart_name" {
  type        = string
  default     = "argo-cd"
  description = "Nome do helm chart do argocd que será criada"
}
variable "repository_helm_url" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
  description = "URL do repositório do helm chart do argocd que será criada"
}
variable "namespace" {
  type        = string
  default     = "argocd"
  description = "Namespace do cluster onde os recursos do argocd que será criada"
}
variable "kubeconfig_path" {
  type        = string
  default     = "C:\\Users\\ivo.fulco\\.kube\\docker-desktop.config" #"~/.kube/config"
  description = "Nome do arquivo de kubeconfig"
}
variable "kubeconfig_context" {
  type        = string
  default     = "docker-desktop"
  description = "Nome do contexto do kubeconfig"
}

variable "chart_name_argo_rollouts" {
  type        = string
  default     = "argo-rollouts"
  description = "Nome do helm chart do argocd que será criada"
}

variable "namespace_argo_rollouts" {
  type        = string
  default     = "argo-rollouts"
  description = "Namespace do cluster onde os recursos do argocd que será criada"
}