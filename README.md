# Zero-to-VPC

This should build a working VPC with an Ubuntu 16.04 jump box, 1 CentOS 6 server, and 1 CentOS 7 server. You can change these with the "count" variable in vars.tf, and the AMIs used for each with the "*_ami" variables in the same location.

You will need to decide how to provide access credentials until we have Vault implemented. You can pull them from your AWS CLI credentials file, export them to environment variables, or store them in a static credentials.tf file (an example of this is provided, but there are better ways).

Securing your credentials and IAM users is an exercise left for the reader.

You can find details about the options for credential configuration here:
https://www.terraform.io/docs/providers/aws/

## Get started
You **MUST** modify the following things to start building your own environments.
In vars.tf:
- Change the "whoami" value value to yourself
- Change the "vpc_cidr" to a value that's all yours
- Change the "pref" value to something you'd like to use to uniquely identify all objects created by this terraform plan
- Change the "keypair" to a keypair that you own and wish to use for access to these instances

You **MAY** wish to modify some of the following, as well
+ In vars.tf:
 + Add any tags that you wish to be added to every object in the "my_tags" mapping.
 + The "region" and "az" if you wish to work in a region/AZ other than Oregon/us-west-2(a)
 + The default AMI values to match the distributions of your choice. These subscruptions appear to be region-specific, so you may need to subscribe to these in your preferred region, or choose an AMI that already has an active subscription.
subscription.

+ In main.tf:
 + If you need more/fewer instances, you can remove/add aws_instance blocks to match the number and types you wish to build. 
 + The instances as configured will delete the EBS volumes (virtual disk) when you run "terraform destroy" to keep the volume storage from filling up with defunct instances. If you wish to preserve your EBS volumes, be sure to remove the "root_block_device" block from the relevant aws_instance blocks.

## To-Do
This was my very first terraform. It was largely an exercise to build/manage a multi-purpose test environment. I know a lot could be better, but this served its purpose at the time. My would-like-to-fix-this-if-I-get-hit-by-a-car-and-spend-six-months-in-a-body-cast-with-nothing-better-to-do list is:
* Dynamically enumerate/assign availability zones
* Better handle instance counts/assignments with subnets in different AZs
* Actually use a tfvars file instead of leaving stuff empty in vars.tf (this was definitely a gap in my TF knowledge when I began)
* Maybe divide the files out more logically from main.tf. Maybe.
