prefix = "mlplatform"
location = "eastus"
db_admin_username = "postgresadmin"
db_admin_password = "StrongPassword123!" # Do not store sensitive data in your tfvars file in production!
alert_email = "admin@example.com"

tags = {
  environment = "development"
  project     = "ml-platform"
  owner       = "team-ml"
}