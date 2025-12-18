variable "rg_name" { type = string }
variable "location" { type = string }
variable "aks_name" { type = string }
variable "subnet_id" { type = string }
variable "node_count" {
  type    = number
  default = 2
}

variable "vm_size" {
  default = "Standard_B2s_v2"
}
