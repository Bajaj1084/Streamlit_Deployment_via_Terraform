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

resource "snowflake_database" "demo_db" {
  name    = "DEMO_DB_V3"
  comment = "Database for Snowflake Terraform demo"
}

resource "snowflake_schema" "demo_schema" {
  database = snowflake_database.demo_db.name
  name     = "DEMO_SCHEMA_V3"
  comment  = "Schema for Snowflake Terraform demo"
}

resource "snowflake_streamlit" "streamlit" {
  database  = "DEMO_DB_V3"
  schema    = "DEMO_SCHEMA_V3"
  name      = "Demo_streamlit"
  main_file = "/app.py"
}
