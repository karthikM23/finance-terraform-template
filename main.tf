#Ec2 instance creation

module "hdfc-ec2" {
    source = "../../cb-tf-templates/modules/ec2/instance"
    env = "finance"
    region = var.region
    instance_model = "snorkel"
    instance_name = "snorkel-1a"
    ami_id = "ami-0c6615d1e95c98aca"
    instance_type = "t3.medium"
    subnet_id = "subnet-0e7371d2512d7d84c"
    availability_zone = "ap-south-1a"
    security_group = "sg-0f0118daad632822f"       
    iam_instance_profile = ""
    public_ip_required_instances = var.require-pub-ip
    #ssh_key_pair = "snorkel-keypair"
    #root_block = var.root_block
    root_block = var.root_block
    #ssh_key_pair = var.ssh_key_pair                     
}

#security group creation

module "hdfc-sg" {
    source = "../../cb-tf-templates/modules/ec2/security_group"
    region = var.region
    env = "finance"
    security_group_name = "snorkel-security-group"
    vpc_id = "vpc-00ffd405898b0759a"
    sg_description = var.description
}

#security group rules

module "hdfc-sg-rules" {
    source = "../../cb-tf-templates/modules/ec2/security_group_rule"
    depends_on = [ module.hdfc-sg ]
    region = var.region
    env = "finance"
    security_group_id = module.hdfc-sg.id
    security_group_name = "snorkel-security-group"
    sg_rules = var.hdfc-sg-rules
}

#eip for load balancer
#module "nat_eip" {
 # source = "../../cb-tf-templates/modules/ec2/elastic_ip"
 # vpc = true
 # region = var.region
 # env = "finance"
 # elastic_ip_name = "EIP-for-nlb"
  #tags = "cb-finance-ap-s1-nlb-eip"
#}


#Load balancer creation

module "hdfc-loadbalancer" {
    source = "../../cb-tf-templates/modules/elbv2/load_balancer"
    region = var.region
    env = "finance"
    lb_name = "snorkel-hdfc-lb"
    subnets = var.subnet-ids
    load_balancer_type = "network"
    internal = false
    enable_deletion_protection = true
    idle_timeout = "350"
    enable_http2 = false
    #enable_cross_zone_load_balancing = true
    #subnet_mapping {
    #subnet_id = "subnet-0e1532edf3bf640e5"
    #allocation_id = module.nat_eip.id
  #}
}

#lb target group

module "hdfc-targetgrp" {
    source = "../../cb-tf-templates/modules/elbv2/target_group"
    region = var.region
    env = "finance"
    tg_name = "hdfc-tg"
    vpc_id = "vpc-00ffd405898b0759a" 
    protocol = "TCP"
    port = "22" 
    health_check_config = var.health-check
    tags = var.tag
}

#lb tg attachment

module "tg-attachment" {
    source = "../../cb-tf-templates/modules/elbv2/target_group_attachment"
    target_group_arn = module.hdfc-targetgrp.id
    target_id = module.hdfc-ec2.id
    target_port = "22"
    
}

#load balancer listener

module "lb-listener" {
    source = "../../cb-tf-templates/modules/elbv2/listener"
    region = var.region
    env = "finance"
    load_balancer_arn = module.hdfc-targetgrp.id
    listener_details = var.lb-details
    #tg_details = ""
  
}

