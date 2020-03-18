provider "azurerm" {
  version = "2.1.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "terraform_remote_state" "base_env" {
  backend = "remote"

  config = {
    organization = "synaptic_racing"
    workspaces = {
      name = "${var.base-workspace}"
    }
  }
}

resource "random_string" "random" {
  length = 6
  special = false
  upper = false
}

module "sql-database" {
  source              = "app.terraform.io/synaptic_racing/database/azurerm"
  version             = "2.0.3"
  resource_group_name = data.terraform_remote_state.base_env.outputs.rg-name
  db_name             = var.db_name
  sql_admin_username  = var.db_username
  sql_password        = var.db_password
}
