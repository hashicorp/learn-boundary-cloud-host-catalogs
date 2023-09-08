# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.11.0"
    }
  }

  required_version = ">= 0.14.9"
}

output "client_id" {
  value = azuread_application.boundary_app.application_id
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

resource "azurerm_resource_group" "boundary_rg" {
  name     = "boundary-dynamic-hosts_group"
  location = "eastus"
}

# Create an application with Reader app role
data "azurerm_subscription" "primary" {}
data "azuread_client_config" "current" {}

resource "azuread_application" "boundary_app" {
  display_name = "boundary_app"
  owners       = [data.azuread_client_config.current.object_id]

  app_role {
    allowed_member_types = ["Application"]
    description          = "Reader role enabling app to read subscription details"
    display_name         = "Reader"
    enabled              = true
    id                   = "1b19509b-32b1-4e9f-b71d-4992aa991967"
    value                = "Read.All"
  }
}

# Create a service principle for the application
resource "azuread_service_principal" "boundary_service_principal" {
  application_id = azuread_application.boundary_app.application_id
  app_role_assignment_required = false
  owners         = [data.azuread_client_config.current.object_id]
}

# Assign the Contributor role to the application service principle
resource "azurerm_role_assignment" "contributor_role_assignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.boundary_service_principal.object_id
}
