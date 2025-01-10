terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
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

# Grant usage and privileges on account level
resource "snowflake_grant" "account_grants" {
  for_each = toset(["USAGE"])
  
  grants_on {
    account = true
  }

  privileges = [each.value]
  roles      = [snowflake_role.app_role.name]
}

# Grant usage on the database
resource "snowflake_grant" "database_grants" {
  for_each = toset(["USAGE", "CREATE SCHEMA", "CREATE TABLE", "SELECT", "INSERT"])

  grants_on {
    object_name = snowflake_database.app_db.name
    object_type = "DATABASE"
  }

  privileges = [each.value]
  roles      = [snowflake_role.app_role.name]
}

# Grant usage on the schema
resource "snowflake_grant" "schema_grants" {
  for_each = toset(["USAGE", "SELECT"])

  grants_on {
    object_name = "\"${snowflake_database.app_db.name}\".\"${snowflake_schema.app_schema.name}\""
    object_type = "SCHEMA"
  }

  privileges = [each.value]
  roles      = [snowflake_role.app_role.name]
}

# Grant usage on the warehouse
resource "snowflake_grant" "warehouse_grants" {
  for_each = toset(["USAGE", "OPERATE", "MONITOR"])

  grants_on {
    object_name = snowflake_warehouse.app_wh.name
    object_type = "WAREHOUSE"
  }

  privileges = [each.value]
  roles      = [snowflake_role.app_role.name]
}

# Future grants for tables in the database
resource "snowflake_grant" "future_table_grants_in_database" {
  grants_on {
    future_grants_in {
      database = snowflake_database.app_db.name
    }
    object_type = "TABLE"
  }

  privileges = ["SELECT", "INSERT"]
  roles      = [snowflake_role.app_role.name]
}

# Future grants for tables in the schema
resource "snowflake_grant" "future_table_grants_in_schema" {
  grants_on {
    future_grants_in {
      schema = "\"${snowflake_database.app_db.name}\".\"${snowflake_schema.app_schema.name}\""
    }
    object_type = "TABLE"
  }

  privileges = ["SELECT", "INSERT"]
  roles      = [snowflake_role.app_role.name]
}

# Outputs for confirmation
output "warehouse_name" {
  value = snowflake_warehouse.app_wh.name
}

output "database_name" {
  value = snowflake_database.app_db.name
}

output "schema_name" {
  value = snowflake_schema.app_schema.name
}
