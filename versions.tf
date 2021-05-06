terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.57.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.1.0"
    }
  }
}