
output "created_namespace" {
  value       = kubernetes_namespace.platform_ns.metadata[0].name
  description = "The name of the namespace created by Terraform"
}
