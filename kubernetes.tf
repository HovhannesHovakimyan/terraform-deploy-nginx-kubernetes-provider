########################
#     Resource map     #
########################
# - kubernetes deployment
# - kubernetes service

########################
#     Provider         #
########################
provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

# Retrieve AKS cluster information
data "terraform_remote_state" "aks" {
  backend = "local"

  config = {
    path = "../terraform-provision-aks-cluster/terraform.tfstate"
  }
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
  resource_group_name = data.terraform_remote_state.aks.outputs.resource_group_name
}

# Azure Kubernetes Deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = var.kub_deploy_params.name
    labels = {
      App = var.kub_deploy_params.label
    }
  }

  spec {
    replicas = var.kub_deploy_params.replica_count
    selector {
      match_labels = {
        App = var.kub_deploy_params.match_label
      }
    }
    template {
      metadata {
        labels = {
          App = var.kub_deploy_params.template_label
        }
      }
      spec {
        container {
          image = var.kub_deploy_params.template_container_image
          name  = var.kub_deploy_params.template_container_name

          port {
            container_port = var.kub_deploy_params.template_container_port
          }

          resources {
            limits = {
              cpu    = var.kub_deploy_params.template_container_res_cpu_limit
              memory = var.kub_deploy_params.template_container_res_memory_limit
            }
            requests = {
              cpu    = var.kub_deploy_params.template_container_res_cpu_request
              memory = var.kub_deploy_params.template_container_res_memory_request
            }
          }
        }
      }
    }
  }
}

# Azure Kubernetes Service
resource "kubernetes_service" "nginx" {
  metadata {
    name = var.kub_service_params.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = var.kub_service_params.port
      target_port = var.kub_service_params.target_port
    }

    type = var.kub_service_params.type
  }
}

