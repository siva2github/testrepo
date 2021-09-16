variable "sub_id"{
  type = string
}

variable "client_id"{
  type = string
}

variable "client_secret"{
  type = string
}

variable "tenant_id"{
  type = string
}

variable "count_value"{
  type = number
  default = 1
}

variable "system" {
    type = string
    description = "Name of the system or environment"
}

variable "servername" {
    type = string
    description = "Server name of the virtual machine"
}

variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    default = "centralus"

}
variable "environment"{
  type = string
  default = "test"
}
variable "admin_username" {
    type = string
    description = "Administrator username for server"
}

variable "admin_password" {
    type = string
    description = "Administrator password for server"
}

variable "vnet_address_space" {
    type = list
    description = "Address space for Virtual Network"
    default = ["10.0.0.0/16"]
}

variable "vmnodename" {
    type = list
    description = "Name of the Virtual Machines"
    default = ["Jenkins-Master", "Jenkins-Slave"]
}