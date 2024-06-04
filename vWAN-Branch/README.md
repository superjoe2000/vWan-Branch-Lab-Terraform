# vWAN-Branch

This folder contains the main.tf file that deploys both the vWAN and the On-prem-branch infrastructure.  This file calls the vWAN and On-prem-branch as modules and ensures the communication of the required run time parameters/outputs from the two modules that are required to provide the public IP addressing for the vWAN to find the On-prem-branch and vice versa.

```Terraform
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
```
