terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }

  backend "remote" {
    organization = "my-organization-name"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "snowflake" {
}

resource "snowflake_role" "app_role" {
  name = "STREAMLIT_APP_ROLE"
}

resource "snowflake_database" "app_db" {
  name = "STREAMLIT_APP_DB"
}

resource "snowflake_schema" "app_schema" {
  name     = "APP_SCHEMA"
  database = snowflake_database.app_db.name
}

resource "snowflake_warehouse" "app_wh" {
  name                 = "STREAMLIT_APP_WH"
  size                 = "XSMALL"
  auto_suspend         = 300
  auto_resume          = true
  initially_suspended  = false
}

resource "snowflake_role_grants" "app_role_grants" {
  role_name = snowflake_role.app_role.name

  database_privileges {
    database_name = snowflake_database.app_db.name
    privileges    = ["USAGE", "CREATE SCHEMA"]
  }

  warehouse_privileges {
    warehouse_name = snowflake_warehouse.app_wh.name
    privileges     = ["USAGE"]
  }
}

output "warehouse_name" {
  value = snowflake_warehouse.app_wh.name
}

output "database_name" {
  value = snowflake_database.app_db.name
}
