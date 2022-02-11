output "hdfc_security_group" {
  value = module.hdfc-sg
}

#output "nlb-eip" {
 #   value = module.nat_eip
#}

output "hdfc-ec2" {
    value = module.hdfc-ec2
}

output "target-grp" {
    value = module.hdfc-targetgrp
}

