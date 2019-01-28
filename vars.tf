#################
### Variables ###
#################


###############
### Globals ###
###############

locals {
  my_tags = {
    # Set this so we know who owns resources, plz!
    who = "${var.whoami}"
    created = "terraformed"
  }
}

variable "whoami" {
  description = "But really, who *AM* I?"
  default = ""
}

variable "region" {
  description = "The region for your instance."
  default = ""
}

variable "az" {
  description = "The availability zone for your instance."
  default = ""
}

variable "az_b" {
  description = "The availability zone for your instance."
  default = ""
}

variable "az_c" {
  description = "The availability zone for your instance."
  default = ""
}

variable "azs" {
  description = "Availability Zones to use for load balancing"
  type = "list"
  default = []
}

variable "my_addresses" {
  description = "Your public IP addresses to provide access into the VPC (i.e. google 'what is my ip' and add it here)"
  default = ["127.0.0.1/32"]
}

variable "vpc_cidr" {
  description = "Internal CIDR subnet for your VPC"
  default = ""
}

variable "pref" {
  description = "The preface for all of your object names"  
  default = ""
}

variable "keypair" {
  description = "The name of your keypair for access"
  default = ""
}

variable "count" {
  description = "How many things to make"
  default = "0"
}

#########################
### Instance Settings ###
#########################

variable "instance_cidr" {
  description = "Internal CIDR subnet for your instances"
  default = "/26"
}

variable "def_ami" {
  description = "The default AMI to use for instances if not otherwise defined."
  # Ubuntu 16.04
  default = "ami-db710fa3"
}

variable "jump_ami" {
  description = "Configured Ubuntu jump API"
  # Ubuntu 16.04
  default = "ami-0c7dbf6c10e9e16a6"
}

variable "ins_type" {
  description = "The default instance type"
  default = "t2.micro"
}

variable "cent7_ami" {
  description = "Default AMI for CentOS (7) Linux"
  default = "ami-3ecc8f46"
}

variable "cent6_ami" {
  description = "Default AMI for CentOS (6) Linux"
  default = "ami-6fcc8f17"
}

