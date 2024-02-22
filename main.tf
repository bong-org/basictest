

resource "azurerm_windows_virtual_machine" "example" {
  name                  = "bong-vm2-tf"
  resource_group_name   = "rg-bongiorno-weu-001"
  location              = "westeurope"
  size                  = "Standard_D2s_v3"
  admin_username        = "adminuser"
  admin_password        = "Password1234!"
  network_interface_ids = ["/subscriptions/0d6ce570-7813-445e-bb22-e35faf195918/resourceGroups/rg-bongiorno-weu-001/providers/Microsoft.Network/networkInterfaces/bongiorno-vm02416_z1",]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-Core"
    version   = "latest"
  }
}
