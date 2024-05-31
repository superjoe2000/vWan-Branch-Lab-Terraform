// BGP settings from Hub
locals {
  brAsn                          = 65533
}

variable "hubGatewayAddress_primary" {
  type = string
}
variable "hubGatewayAddress_secondary" {
  type = string
}
variable "hubBgpPeeringAddress_primary" {
  type = string
}
variable "hubBgpPeeringAddress_secondary" {
  type = string
} 
variable "hubAsn" {
  type = number
}

resource "azurerm_resource_group" "res-1" {
  location = "centralus"
  name     = "rg-jlab-branch01"
}
resource "azurerm_windows_virtual_machine" "res-2" {
  admin_password                                         = "SecretP@ssw0rd"
  admin_username                                         = "joe"
  bypass_platform_safety_checks_on_user_schedule_enabled = true
  license_type                                           = "Windows_Server"
  location                                               = "centralus"
  name                                                   = "vmjlabbr01srv"
  network_interface_ids                                  = ["/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/networkInterfaces/vmjlabbr01srv139"]
  patch_assessment_mode                                  = "AutomaticByPlatform"
  patch_mode                                             = "AutomaticByPlatform"
  resource_group_name                                    = "rg-jlab-branch01"
  size                                                   = "Standard_B2s"
  additional_capabilities {
  }
  boot_diagnostics {
  }
  identity {
    type = "SystemAssigned"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-24,
  ]
}
resource "azurerm_virtual_machine_extension" "res-3" {
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  name                       = "AzurePolicyforWindows"
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationforWindows"
  type_handler_version       = "1.1"
  virtual_machine_id         = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Compute/virtualMachines/vmjlabbr01srv"
  depends_on = [
    azurerm_windows_virtual_machine.res-2,
  ]
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "res-7" {
  daily_recurrence_time = "1900"
  location              = "centralus"
  timezone              = "Central Standard Time"
  virtual_machine_id    = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Compute/virtualMachines/vmjlabbr01srv"
  notification_settings {
    email   = "admin@MngEnv024722.onmicrosoft.com"
    enabled = false
  }
  depends_on = [
    azurerm_windows_virtual_machine.res-2,
  ]
}
resource "azurerm_virtual_network_gateway_connection" "res-20" {
  dpd_timeout_seconds        = 45
  local_network_gateway_id   = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/localNetworkGateways/lngw-vwan-jlab-primary"
  location                   = "centralus"
  name                       = "s2s-vwan-hub-scus-primary"
  resource_group_name        = "rg-jlab-branch01"
  shared_key                 = "SharedKey2024"
  type                       = "IPsec"
  virtual_network_gateway_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/virtualNetworkGateways/vngw-jlab-branch01"
  enable_bgp                 = true
  depends_on = [
    azurerm_local_network_gateway.res-22,
    azurerm_virtual_network_gateway.res-32,
  ]
}
resource "azurerm_virtual_network_gateway_connection" "res-21" {
  dpd_timeout_seconds        = 45
  local_network_gateway_id   = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/localNetworkGateways/lngw-vwan-jlab-secondary"
  location                   = "centralus"
  name                       = "s2s-vwan-hub-scus-secondary"
  resource_group_name        = "rg-jlab-branch01"
  shared_key                 = "SharedKey2024"
  type                       = "IPsec"
  virtual_network_gateway_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/virtualNetworkGateways/vngw-jlab-branch01"
  enable_bgp                 = true
  depends_on = [
    azurerm_local_network_gateway.res-23,
    azurerm_virtual_network_gateway.res-32,
  ]
}
resource "azurerm_local_network_gateway" "res-22" {
  address_space       = ["10.22.0.0/16"]
  gateway_address     = var.hubGatewayAddress_primary
  location            = "centralus"
  name                = "lngw-vwan-jlab-primary"
  resource_group_name = "rg-jlab-branch01"
  bgp_settings {
    asn                 = var.hubAsn
    bgp_peering_address = var.hubBgpPeeringAddress_primary
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_local_network_gateway" "res-23" {
  address_space       = ["10.22.0.0/16"]
  gateway_address     = var.hubGatewayAddress_secondary
  location            = "centralus"
  name                = "lngw-vwan-jlab-secondary"
  resource_group_name = "rg-jlab-branch01"
  bgp_settings {
    asn                 = var.hubAsn
    bgp_peering_address = var. hubBgpPeeringAddress_secondary
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_network_interface" "res-24" {
  location            = "centralus"
  name                = "vmjlabbr01srv139"
  resource_group_name = "rg-jlab-branch01"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/publicIPAddresses/vmjlabbr01srv-ip"
    subnet_id                     = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/virtualNetworks/vnet-jlab-branch01/subnets/Compute"
  }
  depends_on = [
    azurerm_public_ip.res-29,
    azurerm_virtual_network.res-33
    # One of azurerm_subnet.res-34,azurerm_subnet_network_security_group_association.res-35 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_security_group" "res-25" {
  location            = "centralus"
  name                = "vnet-jlab-branch01-Compute-nsg-centralus"
  resource_group_name = "rg-jlab-branch01"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_public_ip" "res-29" {
  allocation_method   = "Static"
  location            = "centralus"
  name                = "vmjlabbr01srv-ip"
  resource_group_name = "rg-jlab-branch01"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_public_ip" "res-30" {
  allocation_method   = "Static"
  location            = "centralus"
  name                = "vngw-jlab-branch01-pip1"
  resource_group_name = "rg-jlab-branch01"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}



resource "azurerm_public_ip" "res-31" {
  allocation_method   = "Static"
  location            = "centralus"
  name                = "vngw-jlab-branch01-pip2"
  resource_group_name = "rg-jlab-branch01"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}

resource "azurerm_virtual_network_gateway" "res-32" {
  location                   = "centralus"
  name                       = "vngw-jlab-branch01"
  private_ip_address_enabled = true
  resource_group_name        = "rg-jlab-branch01"
  sku                        = "VpnGw1"
  type                       = "Vpn"
  active_active              = true
  ip_configuration {
    name                 = "default"
    public_ip_address_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/publicIPAddresses/vngw-jlab-branch01-pip1"
    subnet_id            = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/virtualNetworks/vnet-jlab-branch01/subnets/GatewaySubnet"
  }
  ip_configuration {
    name                 = "activeActive"
    public_ip_address_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/publicIPAddresses/vngw-jlab-branch01-pip2"
    subnet_id            = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/virtualNetworks/vnet-jlab-branch01/subnets/GatewaySubnet"
  }
  enable_bgp = true
  bgp_settings {
    asn         = local.brAsn
    peer_weight = 0
  }
  depends_on = [
    azurerm_public_ip.res-31,
    azurerm_subnet.res-36,
  ]
}

resource "azurerm_virtual_network" "res-33" {
  address_space       = ["192.168.0.0/16"]
  location            = "centralus"
  name                = "vnet-jlab-branch01"
  resource_group_name = "rg-jlab-branch01"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-34" {
  address_prefixes     = ["192.168.1.0/24"]
  name                 = "Compute"
  resource_group_name  = "rg-jlab-branch01"
  virtual_network_name = "vnet-jlab-branch01"
  depends_on = [
    azurerm_virtual_network.res-33,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-35" {
  network_security_group_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/networkSecurityGroups/vnet-jlab-branch01-Compute-nsg-centralus"
  subnet_id                 = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-branch01/providers/Microsoft.Network/virtualNetworks/vnet-jlab-branch01/subnets/Compute"
  depends_on = [
    azurerm_network_security_group.res-25,
    azurerm_subnet.res-34,
  ]
}
resource "azurerm_subnet" "res-36" {
  address_prefixes     = ["192.168.0.0/27"]
  name                 = "GatewaySubnet"
  resource_group_name  = "rg-jlab-branch01"
  virtual_network_name = "vnet-jlab-branch01"
  depends_on = [
    azurerm_virtual_network.res-33,
  ]
}


output "branch01_primary_vpn_address" {
  value = azurerm_public_ip.res-30.ip_address
}
output "branch01_secondary_vpn_address" {
  value = azurerm_public_ip.res-31.ip_address
}
output "branch01_primary_bgp_address" {
  value = azurerm_virtual_network_gateway.res-32.bgp_settings[0].peering_addresses[0].default_addresses[0]
}
output "branch01_secondary_bgp_address" {
  value = azurerm_virtual_network_gateway.res-32.bgp_settings[0].peering_addresses[1].default_addresses[0]
}
output "brAsn" {
  value = local.brAsn
}


