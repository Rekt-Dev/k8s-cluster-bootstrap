variable "kube_config" {
  type        = string
  default     = "~/.kube/config"
  description = "Path to the kubeconfig file"
}

variable "namespace_name" {
  type        = string
  default     = "production-ready-env"
  description = "The name of the k8s namespace to create"
}
