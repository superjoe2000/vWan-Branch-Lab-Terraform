// on-prem branch module outputs
//output "branch01_primary_vpn_address" {
//  value = azurerm_public_ip.res-30.ip_address
//}
//output "branch01_secondary_vpn_address" {
//  value = azurerm_public_ip.res-31.ip_address
//}
//output "branch01_primary_bgp_address" {
//  value = azurerm_virtual_network_gateway.res-32.bgp_settings[0].peering_addresses[0].default_addresses[0]
//}
//output "branch01_secondary_bgp_address" {
//  value = azurerm_virtual_network_gateway.res-32.bgp_settings[0].peering_addresses[1].default_addresses[0]
//}
//output "brAsn" {
//  value = local.brAsn
//}

// vWAN module outputs
//output "hubGateway" {
//  value = azurerm_vpn_gateway.res-44.bgp_settings
//}
//output "hubGatewayAddress_primary" {
//  value = azurerm_vpn_gateway.res-44.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips
//}
//output "hubGatewayAddress_secondary" {
//  value = azurerm_vpn_gateway.res-44.bgp_settings[0].instance_1_bgp_peering_address[0].tunnel_ips
//}
//output "hubBgpPeeringAddress_primary" {
//  value = azurerm_vpn_gateway.res-44.bgp_settings[0].instance_0_bgp_peering_address[0].default_ips
//}
//output "hubBgpPeeringAddress_secondary" {
//  value = azurerm_vpn_gateway.res-44.bgp_settings[0].instance_1_bgp_peering_address[0].default_ips
//}
//output "hubAsn" {
//  value = azurerm_vpn_gateway.res-44.bgp_settings[0].asn
//}

module "branch01" {
  source = "../On-prem-branch"
  hubGatewayAddress_primary  = module.vwan.hubGatewayAddress_primary
  hubGatewayAddress_secondary = module.vwan.hubGatewayAddress_secondary
  hubBgpPeeringAddress_primary = module.vwan.hubBgpPeeringAddress_primary
  hubBgpPeeringAddress_secondary = module.vwan.hubBgpPeeringAddress_secondary
  hubAsn = module.vwan.hubAsn
}

output "branch01_primary_vpn_address" {
  value = module.branch01.branch01_primary_vpn_address
}
output "branch01_secondary_vpn_address" {
  value = module.branch01.branch01_secondary_vpn_address
}
output "branch01_primary_bgp_address" {
  value = module.branch01.branch01_primary_bgp_address
}
output "branch01_secondary_bgp_address" {
  value = module.branch01.branch01_secondary_bgp_address
}
output "brAsn" {
  value = module.branch01.brAsn
}


module "vwan" {
  source = "../vWAN"
  branch01_primary_vpn_address = module.branch01.branch01_primary_vpn_address
  branch01_secondary_vpn_address = module.branch01.branch01_secondary_vpn_address
  branch01_primary_bgp_address = module.branch01.branch01_primary_bgp_address
  branch01_secondary_bgp_address = module.branch01.branch01_secondary_bgp_address
  brAsn = module.branch01.brAsn
}

output "hubGatewayAddress_primary" {
  value = module.vwan.hubGatewayAddress_primary
}
output "hubGatewayAddress_secondary" {
  value = module.vwan.hubGatewayAddress_secondary
}
output "hubBgpPeeringAddress_primary" {
  value = module.vwan.hubBgpPeeringAddress_primary
}
output "hubBgpPeeringAddress_secondary" {
  value = module.vwan.hubBgpPeeringAddress_secondary
}
output "hubAsn" {
  value = module.vwan.hubAsn
}
