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

# Create File Format
resource "snowflake_file_format" "csv_ff" {
  name                         = "APP_CSV_FF"
  database                     = "DEMO_DB_V4"
  schema                       = "DEMO_SCHEMA_V4"
  format_type                  = "CSV"
  binary_format                = "UTF8"  # Binary format UTF-8
  compression                  = "AUTO"  # Automatic compression
  date_format                  = "AUTO"  # Auto date format
  encoding                     = "UTF8"  # Encoding set to UTF-8
  escape                       = "NONE"  # No escape character
  escape_unenclosed_field      = "NONE"  # No escape for unenclosed fields
  field_delimiter              = ";"  # Field delimiter set to semicolon
  field_optionally_enclosed_by = "\""  # Fields enclosed in double quotes
  record_delimiter             = "\r\n"  # Record delimiter set to carriage return + newline
  time_format                  = "AUTO"  # Auto time format
  timestamp_format             = "AUTO"  # Auto timestamp format
  empty_field_as_null          = true  # Empty fields treated as null
  null_if                      = ["", "NA", "NULL"]  # Null values to handle
  skip_header                  = 1  # Skip the header row (optional)
  validate_utf8                = true
}





# Data Copy Commands (Run these manually or via an external process as Terraform does not handle data loading directly)
# COPY INTO TASTY_BYTES_CHATBOT.APP.DOCUMENTS FROM @TASTY_BYTES_CHATBOT.APP.S3LOAD/DOCUMENTS/
# COPY INTO TASTY_BYTES_CHATBOT.APP.ARRAY_TABLE FROM @TASTY_BYTES_CHATBOT.APP.S3LOAD/VECTOR_STORE/
# INSERT INTO TASTY_BYTES_CHATBOT.APP.VECTOR_STORE (SELECT ...) -- As per your SQL logic




