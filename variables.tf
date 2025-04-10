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