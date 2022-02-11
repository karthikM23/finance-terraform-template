variable "region" {
    description = "region"
    type = string
    default = "ap-south-1"
}

variable "require-pub-ip" {
    type = list
    description = "Instance needs to have Public IP attached while provisioning"
    default = []
}

#variable "root_device_size" {
  #type = string
  #description = "Root Volume Configuration"
  #default = 8
#}

#variable "root_device_type" {
  #type = string
  #description = "root volume type"
  #default = "gp2"
#}

variable "root_block" {
  type = map
  description = "Root Volume Configuration"
  default = {
    snorkel = {
       volume_type = "gp2"
       volume_size = 8
       iops        = null
     }
  }
}

#variable "ssh_key_pair" {
  #type = map
  #description = "keypair file"
#}

#ec2 security group description

variable "description" {
  type = map
  description = "Security Group description (Defaults set to sg_name)"
  default = {
    finance = "snorkel Security Group"
  }
}

#ec2 security group rules

variable "hdfc-sg-rules" {
  type = any
  description = "Security Group Ingress and Egress Rules"
  default = {
    snorkel-security-group = {
        ingress = [
           {
               from_port = 22
               to_port   = 22
               protocol  = "tcp"
               description = "SSH Rules"
               cidr_blocks = ["0.0.0.0/0"]
           }
        ]
        ingress = [
            {
               from_port = 443
               to_port   = 443
               protocol  = "tcp"
               description = "Hdfc Rules"
               cidr_blocks = ["175.100.160.30/32", "175.100.162.139/32", "175.100.160.208/32", "175.100.160.205/32"]
            }
        ]
        egress = [
         {
               from_port = 0
               to_port   = 0
               protocol  = "-1"
               cidr_block = ["0.0.0.0/0"]
               description = "Open Rule"
         }
       ]
     }
  }
}

#load balancer

variable "subnet-ids" {
    type = list
    description = "A list of subnet IDs to attach to the LB"
    default = ["subnet-0e1532edf3bf640e5", "subnet-0a47a25629e8b40bb"]
}

#lb target group

variable "tag" {
    type = any
    description = "tags"
  
}

variable "health-check" {
    description = "Target Group health check config"
    type        = map
    default     = {
        #enabled                 = true
        protocol                = "TCP"
        # path                    = "/healthz"
        port                    = "traffic-port"
        healthy_threshold       = 3
        unhealthy_threshold     = 3
        # timeout                 = 5
        interval                = 30
        # matcher                 = "200"
    }
}


#lb listener

variable "lb-details" {
    description = "Listener Details"
    type        = any
    default = {
        port = "22"
        protocol = "TCP"
    }
}