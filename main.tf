variable "resource_group_name" {
  type  = string
}

variable "region" {
  type  = string
}

variable "apim_name" {
  type  = string
}

variable "backend_storage_account_name" {
  type = string
}

variable "backend_container_name" {
  type = string
}

variable "dev_portal_storage_account_name" {
  type = string
}

terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 2.49.0"
    }
  }
  backend "azurerm" {
      resource_group_name = var.resource_group_name
      storage_account_name = var.backend_storage_account_name #"tfstorageaccountapim"
      container_name = var.backend_container_name #"tfstate"
      key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

/* resource "azurerm_api_management" "example" {
  name                = var.apim_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "My Company"
  publisher_email     = "publisher-email@no.com"

  sku_name = "Developer_1"
} */

resource "azurerm_storage_account" "static_storage" {
  name                     = var.dev_portal_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = true
  allow_blob_public_access  = true

  static_website {
    index_document = "index.html"
  }

  blob_properties {
    cors_rule {
      allowed_headers = ["*"]
      allowed_methods = ["GET","HEAD","OPTIONS","PUT","POST"]
      allowed_origins = ["*"]
      exposed_headers = ["*"]
      max_age_in_seconds = 200
    }
  }
}

/* resource "azurerm_api_management_api" "example" {
  name                = "example-api"
  resource_group_name = azurerm_resource_group.example.name
  api_management_name = azurerm_api_management.example.name
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("${path.module}/conference-api.json")
  }
} */