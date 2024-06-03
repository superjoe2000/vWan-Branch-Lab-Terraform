locals {
}

variable "branch01_primary_vpn_address" {
  type = string
}
variable "branch01_primary_bgp_address" {
  type = string
}
variable "branch01_secondary_vpn_address" {
  type = string
}
variable "branch01_secondary_bgp_address" {
  type = string
}
variable "brAsn" {
  type = number
}

resource "azurerm_resource_group" "res-2" {
  location = "southcentralus"
  name     = "rg-jlab-vwan"
}
resource "azurerm_windows_virtual_machine" "res-3" {
  admin_password                                         = "SecretP@ssw0rd"
  admin_username                                         = "azureadmin"
  bypass_platform_safety_checks_on_user_schedule_enabled = true
  license_type                                           = "Windows_Server"
  location                                               = "southcentralus"
  name                                                   = "vmjlablz1srv01"
  network_interface_ids                                  = ["/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/networkInterfaces/vmjlablz1srv01738"]
  patch_assessment_mode                                  = "AutomaticByPlatform"
  patch_mode                                             = "AutomaticByPlatform"
  resource_group_name                                    = "rg-jlab-vwan"
  secure_boot_enabled                                    = true
  size                                                   = "Standard_B2s"
  vtpm_enabled                                           = true
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
    azurerm_network_interface.res-18,
  ]
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "res-8" {
  daily_recurrence_time = "1900"
  location              = "southcentralus"
  timezone              = "Central Standard Time"
  virtual_machine_id    = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Compute/virtualMachines/vmjlablz1srv01"
  notification_settings {
    enabled = false
  }
  depends_on = [
    azurerm_windows_virtual_machine.res-3,
  ]
}
resource "azurerm_network_interface" "res-18" {
  location            = "southcentralus"
  name                = "vmjlablz1srv01738"
  resource_group_name = "rg-jlab-vwan"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/publicIPAddresses/vmjlablz1srv01-pip"
    subnet_id                     = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualNetworks/vnet-vwan-jlab-scus/subnets/Compute"
  }
  depends_on = [
    azurerm_public_ip.res-30,
    azurerm_subnet.res-38
    # One of azurerm_subnet.res-38,azurerm_subnet_network_security_group_association.res-39 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_security_group" "res-22" {
  location            = "southcentralus"
  name                = "vnet-vwan-jlab-scus-Compute-nsg-southcentralus"
  resource_group_name = "rg-jlab-vwan"
  depends_on = [
    azurerm_resource_group.res-2,
  ]
}
resource "azurerm_network_security_rule" "res-25" {
  access                      = "Deny"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "DenyAnyRDPInbound"
  network_security_group_name = "vnet-vwan-jlab-scus-Compute-nsg-southcentralus"
  priority                    = 3000
  protocol                    = "Tcp"
  resource_group_name         = "rg-jlab-vwan"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-22,
  ]
}
resource "azurerm_network_security_group" "res-27" {
  location            = "southcentralus"
  name                = "vnet-vwan-jlab-scus-default-nsg-southcentralus"
  resource_group_name = "rg-jlab-vwan"
  depends_on = [
    azurerm_resource_group.res-2,
  ]
}
resource "azurerm_public_ip" "res-30" {
  allocation_method   = "Static"
  location            = "southcentralus"
  name                = "vmjlablz1srv01-pip"
  resource_group_name = "rg-jlab-vwan"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-2,
  ]
}
resource "azurerm_virtual_hub" "res-31" {
  address_prefix         = "10.50.0.0/16"
  hub_routing_preference = "VpnGateway"
  location               = "southcentralus"
  name                   = "hub-jlab-scus"
  resource_group_name    = "rg-jlab-vwan"
  sku                    = "Standard"
  virtual_wan_id         = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualWans/vwan-jlab"
  depends_on = [
    azurerm_virtual_wan.res-43,
  ]
}
resource "azurerm_virtual_hub_connection" "res-36" {
  internet_security_enabled = true
  name                      = "conn-hub-jlab-scus"
  remote_virtual_network_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualNetworks/vnet-vwan-jlab-scus"
  virtual_hub_id            = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualHubs/hub-jlab-scus"
  depends_on = [
    azurerm_virtual_hub.res-31,
    azurerm_virtual_network.res-37,
  ]
}
resource "azurerm_virtual_network" "res-37" {
  address_space       = ["10.22.0.0/16"]
  location            = "southcentralus"
  name                = "vnet-vwan-jlab-scus"
  resource_group_name = "rg-jlab-vwan"
  depends_on = [
    azurerm_resource_group.res-2,
  ]
}
resource "azurerm_subnet" "res-38" {
  address_prefixes     = ["10.22.1.0/24"]
  name                 = "Compute"
  resource_group_name  = "rg-jlab-vwan"
  virtual_network_name = "vnet-vwan-jlab-scus"
  depends_on = [
    azurerm_virtual_network.res-37,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-39" {
  network_security_group_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/networkSecurityGroups/vnet-vwan-jlab-scus-Compute-nsg-southcentralus"
  subnet_id                 = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualNetworks/vnet-vwan-jlab-scus/subnets/Compute"
  depends_on = [
    azurerm_network_security_group.res-22,
    azurerm_subnet.res-38,
  ]
}
resource "azurerm_subnet" "res-40" {
  address_prefixes     = ["10.22.0.0/24"]
  name                 = "default"
  resource_group_name  = "rg-jlab-vwan"
  virtual_network_name = "vnet-vwan-jlab-scus"
  depends_on = [
    azurerm_virtual_network.res-37,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-41" {
  network_security_group_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/networkSecurityGroups/vnet-vwan-jlab-scus-default-nsg-southcentralus"
  subnet_id                 = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualNetworks/vnet-vwan-jlab-scus/subnets/default"
  depends_on = [
    azurerm_network_security_group.res-27,
    azurerm_subnet.res-40,
  ]
}
resource "azurerm_virtual_wan" "res-43" {
  allow_branch_to_branch_traffic = false
  location                       = "southcentralus"
  name                           = "vwan-jlab"
  resource_group_name            = "rg-jlab-vwan"
  depends_on = [
    azurerm_resource_group.res-2,
  ]
}
resource "azurerm_vpn_gateway" "res-44" {
  location            = "southcentralus"
  name                = "bf8ceef55b8940289a462ab4e37cef3d-southcentralus-gw"
  resource_group_name = "rg-jlab-vwan"
  virtual_hub_id      = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualHubs/hub-jlab-scus"
  timeouts {
    // extend deployment timeout to 1.5 hours maximum
    create = "1h30m"
    update = "2h"
    delete = "20m"
  }
  depends_on = [
    azurerm_virtual_hub.res-31,
  ]
}
resource "azurerm_vpn_gateway_connection" "res-45" {
  name               = "Connection-vpnsite-jlab-branch01-primary"
  remote_vpn_site_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/vpnSites/vpnsite-jlab-branch01-primary"
  vpn_gateway_id     = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/vpnGateways/bf8ceef55b8940289a462ab4e37cef3d-southcentralus-gw"
  vpn_link {
    bgp_enabled      = true
    name             = "link-branch01-primary"
    shared_key       = "SharedKey2024"
    vpn_site_link_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/vpnSites/vpnsite-jlab-branch01-primary/vpnSiteLinks/link-jlab-vwan-primary"
  }
  depends_on = [
    azurerm_vpn_gateway.res-44,
    azurerm_vpn_site.res-47,
  ]
}
resource "azurerm_vpn_gateway_connection" "res-46" {
  name               = "Connection-vpnsite-jlab-branch01-secondary"
  remote_vpn_site_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/vpnSites/vpnsite-jlab-branch01-secondary"
  vpn_gateway_id     = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/vpnGateways/bf8ceef55b8940289a462ab4e37cef3d-southcentralus-gw"
  vpn_link {
    bgp_enabled      = true
    name             = "link-branch01-secondary"
    shared_key       = "SharedKey2024"
    vpn_site_link_id = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/vpnSites/vpnsite-jlab-branch01-secondary/vpnSiteLinks/link-branch01-secondary"
  }
  depends_on = [
    azurerm_vpn_gateway.res-44,
    azurerm_vpn_site.res-48,
  ]
}
resource "azurerm_vpn_site" "res-47" {
  address_cidrs       = ["192.168.0.0/16"]
  device_vendor       = "Microsoft"
  location            = "southcentralus"
  name                = "vpnsite-jlab-branch01-primary"
  resource_group_name = "rg-jlab-vwan"
  virtual_wan_id      = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualWans/vwan-jlab"
  link {
    ip_address    = var.branch01_primary_vpn_address
    name          = "link-jlab-vwan-primary"
    provider_name = "microsoft"
    speed_in_mbps = 50
    bgp {
      asn             = var.brAsn
      peering_address = var.branch01_primary_bgp_address
    }
  }
  depends_on = [
    azurerm_virtual_wan.res-43,
  ]
}
resource "azurerm_vpn_site" "res-48" {
  address_cidrs       = ["192.168.0.0/16"]
  device_vendor       = "Microsoft"
  location            = "southcentralus"
  name                = "vpnsite-jlab-branch01-secondary"
  resource_group_name = "rg-jlab-vwan"
  virtual_wan_id      = "/subscriptions/21e1ef34-0963-45a7-adf0-9ec348b85362/resourceGroups/rg-jlab-vwan/providers/Microsoft.Network/virtualWans/vwan-jlab"
  link {
    ip_address    = var.branch01_secondary_vpn_address
    name          = "link-branch01-secondary"
    provider_name = "microsoft"
    speed_in_mbps = 50
    bgp {
      asn             = var.brAsn
      peering_address = var.branch01_secondary_bgp_address
    }
  }
  depends_on = [
    azurerm_virtual_wan.res-43,
  ]
}

output "hubGatewayAddress_primary" {
  value = [for address in azurerm_vpn_gateway.res-44.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips : address][1]
}
output "hubGatewayAddress_secondary" {
  value = [for address in azurerm_vpn_gateway.res-44.bgp_settings[0].instance_1_bgp_peering_address[0].tunnel_ips : address][1]
}
output "hubBgpPeeringAddress_primary" {
  value = [for address in azurerm_vpn_gateway.res-44.bgp_settings[0].instance_0_bgp_peering_address[0].default_ips : address][0]
}
output "hubBgpPeeringAddress_secondary" {
  value = [for address in azurerm_vpn_gateway.res-44.bgp_settings[0].instance_1_bgp_peering_address[0].default_ips : address][0]
}
output "hubAsn" {
  value = azurerm_vpn_gateway.res-44.bgp_settings[0].asn
}
