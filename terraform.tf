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
      access_key           = "iR59/N2VGQT5x2uBw+QiRAOyZO0xVfyFrU5G61sBj4QaABrDMNpiol3CMN9KnRvVPlu3iiYMrV1u+ASt67VUJw=="
  }
}

provider "azurerm" {
  features {}
}
