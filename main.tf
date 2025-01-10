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

provider "snowflake" {}

# Create Snowflake role
resource "snowflake_role" "app_role" {
  name = "STREAMLIT_APP_ROLE"
}

# Create Snowflake database
resource "snowflake_database" "app_db" {
  name = "STREAMLIT_APP_DB"
}

# Create Snowflake schema
resource "snowflake_schema" "app_schema" {
  name     = "APP_SCHEMA"
  database = snowflake_database.app_db.name
}

# Create Snowflake warehouse
resource "snowflake_warehouse" "app_wh" {
  name                 = "STREAMLIT_APP_WH"
  warehouse_size       = "XSMALL"
  auto_suspend         = 300
  auto_resume          = true
  initially_suspended  = false
}

# Assign privileges to the role
resource "snowflake_role_grants" "app_role_grants" {
  role_name = snowflake_role.app_role.name

  # Database privileges
  database_privileges {
    database_name = snowflake_database.app_db.name
    privileges    = ["USAGE", "CREATE SCHEMA", "CREATE TABLE", "SELECT", "INSERT"]
  }

  # Warehouse privileges
  warehouse_privileges {
    warehouse_name = snowflake_warehouse.app_wh.name
    privileges     = ["USAGE", "OPERATE", "MONITOR"]
  }

  # Schema privileges
  schema_privileges {
    database_name = snowflake_database.app_db.name
    schema_name   = snowflake_schema.app_schema.name
    privileges    = ["USAGE", "SELECT"]
  }
}

# Future grants for database objects
resource "snowflake_grant" "future_grants_in_database" {
  on_future {
    database_name = snowflake_database.app_db.name
    object_type   = "TABLE"
  }

  privileges = ["SELECT", "INSERT"]
  roles      = [snowflake_role.app_role.name]
}

# Future grants for schema objects
resource "snowflake_grant" "future_grants_in_schema" {
  on_future {
    schema_name = "\"${snowflake_database.app_db.name}\".\"${snowflake_schema.app_schema.name}\""
    object_type = "TABLE"
  }

  privileges = ["SELECT", "INSERT"]
  roles      = [snowflake_role.app_role.name]
}

# Output values
output "warehouse_name" {
  value = snowflake_warehouse.app_wh.name
}

output "database_name" {
  value = snowflake_database.app_db.name
}
