variable "location" {
  type    = string
  default = "westeurope"
}

variable "rg_name" {
  type    = string
  default = "rg-tfstate"
}

# MUST be globally unique, 3-24 chars, lowercase letters and numbers only.
variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type    = string
  default = "tfstate"
}
