
provider "azurerm" {
  features {}

  subscription_id = var.sub_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}


#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "${var.system}-DevOpsProject1-rg"
    location = var.location
    tags      = {
      Environment = var.system
    }
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    
    name                = "vnet-dev-${var.system}"
    address_space       = var.vnet_address_space
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  
  name                 = "snet-dev-${var.system}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.1.0/24"]

}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  count = var.count_value

  name                = "pip-${var.servername}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


# Create network security group and rule
resource "azurerm_network_security_group" "nsg" {
  count = var.count_value

  name                = "nsg-${var.system}-${count.index} "
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  #network_security_group_id = azurerm_network_security_group.nsg[count.index].id

  security_rule {
    name                       = "Allow_All"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
  resource "azurerm_network_interface" "nic" {
  count = var.count_value

  name                      = "nic-${var.servername}-${count.index}"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "niccfg-${var.servername}-${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[count.index].id
  }
  depends_on = [
     azurerm_subnet.subnet , azurerm_virtual_network.vnet
   ]
}

# Create virtual machine
  resource "azurerm_linux_virtual_machine" "vm" {
  count = var.count_value

  name = "${var.vmnodename[count.index]}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size               = "Standard_DS1"
  admin_username     = var.admin_username
  admin_password     = var.admin_password
  disable_password_authentication = false
  depends_on = [
    azurerm_network_interface.nic
   ]

   os_disk {
    name              = "stvm-${var.servername}-${count.index}-os"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    
  }
  source_image_reference {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "latest"
}

  tags = {
    environment = "${var.servername}-${count.index}"

  }

 provisioner "file" {
   connection {
       type     = "ssh"
       host = "${azurerm_public_ip.publicip[count.index].ip_address}"
       user     = "${var.admin_username}"
       password = "${var.admin_password}"
   }

   source = "master.sh"
   destination = "/home/azureuser/master.sh"

}

 provisioner "remote-exec" {

    connection {
        type     = "ssh"
        host = "${azurerm_public_ip.publicip[count.index].ip_address}"
        user     = "${var.admin_username}"
        password = "${var.admin_password}"
    }

     inline = [
        "sh -x /home/azureuser/master.sh",
     ]
 }

}
