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
  name    = "DEMO_DB_V4"
  comment = "Database for Snowflake Terraform demo"
}

resource "snowflake_schema" "demo_schema" {
  database = snowflake_database.demo_db.name
  name     = "DEMO_SCHEMA_V4"
  comment  = "Schema for Snowflake Terraform demo"
}

resource "snowflake_warehouse" "app_wh" {
  name                 = "AF_TEST"
  warehouse_size       = "XSMALL"
  auto_suspend         = 300
  auto_resume          = true
  initially_suspended  = false
}





# Data Copy Commands (Run these manually or via an external process as Terraform does not handle data loading directly)
# COPY INTO TASTY_BYTES_CHATBOT.APP.DOCUMENTS FROM @TASTY_BYTES_CHATBOT.APP.S3LOAD/DOCUMENTS/
# COPY INTO TASTY_BYTES_CHATBOT.APP.ARRAY_TABLE FROM @TASTY_BYTES_CHATBOT.APP.S3LOAD/VECTOR_STORE/
# INSERT INTO TASTY_BYTES_CHATBOT.APP.VECTOR_STORE (SELECT ...) -- As per your SQL logic




