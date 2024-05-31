// Deploy a vWAN in one region and an branch in another

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
