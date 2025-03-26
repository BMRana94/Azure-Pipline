variable "prefix" {
  description = "The prefix which should be used for all resources in this deployment"
  type        = string
  default     = "mlplatform"
}

variable "location" {
  description = "The Azure Region in which all resources should be created"
  type        = string
  default     = "eastus"
}

variable "db_admin_username" {
  description = "The administrator username for PostgreSQL"
  type        = string
  default     = "postgresadmin"
  sensitive   = true
}

variable "db_admin_password" {
  description = "The administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email address for receiving alerts"
  type        = string
  default     = "admin@example.com"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {
    environment = "development"
    project     = "ml-platform"
  }
}