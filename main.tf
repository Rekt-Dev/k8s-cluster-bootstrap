terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kube_config
}

provider "helm" {
  kubernetes = {
    config_path = var.kube_config
  }
}

resource "kubernetes_namespace" "platform_ns" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "dbapp_deployment" {
  name       = "dbapp-release"
  namespace  = kubernetes_namespace.platform_ns.metadata[0].name
  chart      = "./dbapp"
}
