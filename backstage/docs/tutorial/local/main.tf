resource "helm_release" "argocd" {
  chart            = var.chart_name
  namespace        = var.namespace
  create_namespace = true
  name             = var.chart_name
  cleanup_on_fail  = true
  repository       = var.repository_helm_url
  values           = [file("argo-cd-install.yaml")] #https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 
}
resource "null_resource" "get_secret_admin" {
  depends_on = [helm_release.argocd]
  provisioner "local-exec" {
    environment = {
      KUBECONFIG = "${var.kubeconfig_path}"
    }
    command = <<-EOT
        kubectl get secret argocd-initial-admin-secret --namespace ${var.namespace} -o jsonpath={.data.password} | base64 -d > secret_admin.txt
    EOT
  }
}
resource "null_resource" "delete_secret_admin" {
  depends_on = [null_resource.get_secret_admin]
  provisioner "local-exec" {
    environment = {
      KUBECONFIG = "${var.kubeconfig_path}"
    }
    command = <<-EOT
        kubectl delete secret argocd-initial-admin-secret --namespace ${var.namespace}
    EOT
  }
}
resource "null_resource" "argocd_applications_deployment" {
  depends_on = [null_resource.delete_secret_admin]
  provisioner "local-exec" {
    environment = {
      KUBECONFIG = "${var.kubeconfig_path}"
    }
    command = <<-EOT
        kubectl apply -f ./namespaces-apps/.
    EOT        
  }
}
resource "helm_release" "argo_rollouts" {
  chart            = var.chart_name_argo_rollouts
  namespace        = var.namespace_argo_rollouts
  create_namespace = true
  name             = var.chart_name_argo_rollouts
  cleanup_on_fail  = true
  repository       = var.repository_helm_url
  values           = [file("argo-rollouts-install.yaml")] #https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
  set {
    name= "dashboard.enabled"
    value="true"
  }
}