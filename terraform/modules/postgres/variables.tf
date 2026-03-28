variable "project_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "db_user" {}
variable "db_password" {}
variable "subnet_id" {}
variable "dns_zone_id" {}
variable "server_name" {}
variable "sku_name" {}
variable "db_version" { default = "17" }
variable "storage_mb" { default = "32768" }
