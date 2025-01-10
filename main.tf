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


# Grant usage on the database


# Grant usage on the schema


# Grant usage on the warehouse




 

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
