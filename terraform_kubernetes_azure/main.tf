# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Generate random resource group name

resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "westus2"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = "eastus"
  name                = "k8stest"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "k8stest"
  tags                = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_a2_v2"
    node_count = "3"
  }
  /*linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }*/
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id     = "d3679c69-6995-47ad-9e41-51519ce739dc"
    client_secret = "vVt8Q~dET3LW9lGlmHXGtPpQ2Ji55Ymiq_B4JcBf"
  }
}
/*variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}*/