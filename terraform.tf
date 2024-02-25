terraform {
  required_version = ">1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
  }
  backend "azurerm" {
      resource_group_name  = "rg-bongiorno-weu-001"
      storage_account_name = "testtfsttae"
      container_name       = "getstate"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
