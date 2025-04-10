resource "helm_release" "argocd" {
  chart            = var.chart_name
  namespace        = var.namespace
  create_namespace = true
  name             = var.chart_name
  cleanup_on_fail  = true
  repository       = var.repository_helm_url
  values           = [file("${path.module}//install.yaml")]
}
resource "null_resource" "output_secret_admin" {
  depends_on = [helm_release.argocd]
  provisioner "local-exec" {
    command = <<-EOT
        kubectl get secret argocd-initial-admin-secret --namespace ${var.namespace} -o jsonpath={.data.password} | base64 -d > secret_admin.txt
    EOT
  }
}
resource "null_resource" "delete_secret_admin" {
  depends_on = [null_resource.output_secret_admin]
  provisioner "local-exec" { 
    command = <<-EOT
        kubectl delete secret argocd-initial-admin-secret --namespace ${var.namespace}
    EOT
  }
}
