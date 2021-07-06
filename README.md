# tf-ob-aws3

This manual is dedicated to create Amazon AWS resources using terraform.

on AWS
create VPC
create 2 subnets, one for public network, one for private network
create internet gw and connect to public network
create nat gateway, and connect to private network
create Auto scaling group for app, ec2 only private subnet
create a LB (check Application Load Balancer or Network Load Balancer)
publish a service over LB, ie nginx

## Requirements

- Hashicorp terraform recent version installed
[Terraform installation manual](https://learn.hashicorp.com/tutorials/terraform/install-cli)

- git installed
[Git installation manual](https://git-scm.com/download/mac)

- Amazon AWS account credentials saved in .aws/credentials file
[Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

## Preparation 
- Clone git repository. 

```bash
git clone https://github.com/antonakv/tf-ob-aws3.git
```

Expected command output looks like this:

```bash
Cloning into 'tf-ob-aws3'...
remote: Enumerating objects: 12, done.
remote: Counting objects: 100% (12/12), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 12 (delta 1), reused 3 (delta 0), pack-reused 0
Receiving objects: 100% (12/12), done.
Resolving deltas: 100% (1/1), done.
```

- Change folder to tf-ob-aws3

```bash
cd tf-ob-aws3
```

- Create file terraform.tfvars with following contents

```
key_name      = "PUT_YOUR_EXISTING_KEYNAME_HERE"
ami           = "ami-091d856a5f5701931" # Own private AMI with nginx installed, replace with your own
instance_type = "t2.medium"
region        = "eu-central-1"
cidr_vpc      = "10.5.0.0/16"
cidr_subnet1  = "10.5.1.0/24"
cidr_subnet2  = "10.5.2.0/24"
cidr_subnet3  = "10.5.3.0/24"
cidr_subnet4  = "10.5.4.0/24"

```

## Run terraform code

- In the same folder you were before run init


```bash
terraform init
```

Sample result

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.42.0...
- Installed hashicorp/aws v3.42.0 (self-signed, key ID 34365D9472D7468F)

Partner and community providers are signed by their developers.
If you d like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

- In the same folder you were before run terraform apply

```bash
terraform apply
```

Sample command output

```bash
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_acm_certificate.aws3 will be created
  + resource "aws_acm_certificate" "aws3" {
      + arn                       = (known after apply)
      + domain_name               = "tfe3.anton.hashicorp-success.com"
      + domain_validation_options = [
          + {
              + domain_name           = "tfe3.anton.hashicorp-success.com"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
        ]
      + id                        = (known after apply)
      + status                    = (known after apply)
      + subject_alternative_names = (known after apply)
      + tags_all                  = (known after apply)
      + validation_emails         = (known after apply)
      + validation_method         = "DNS"
    }

  # aws_acm_certificate_validation.aws3 will be created
  + resource "aws_acm_certificate_validation" "aws3" {
      + certificate_arn = (known after apply)
      + id              = (known after apply)
    }

  # aws_autoscaling_group.aws3 will be created
  + resource "aws_autoscaling_group" "aws3" {
      + arn                       = (known after apply)
      + availability_zones        = (known after apply)
      + default_cooldown          = (known after apply)
      + desired_capacity          = (known after apply)
      + force_delete              = true
      + force_delete_warm_pool    = false
      + health_check_grace_period = 300
      + health_check_type         = (known after apply)
      + id                        = (known after apply)
      + launch_configuration      = (known after apply)
      + max_size                  = 5
      + metrics_granularity       = "1Minute"
      + min_size                  = 2
      + name                      = "aakulov-aws3"
      + name_prefix               = (known after apply)
      + placement_group           = (known after apply)
      + protect_from_scale_in     = false
      + service_linked_role_arn   = (known after apply)
      + target_group_arns         = (known after apply)
      + vpc_zone_identifier       = (known after apply)
      + wait_for_capacity_timeout = "10m"

      + timeouts {
          + delete = "15m"
        }
    }

  # aws_eip.aws3 will be created
  + resource "aws_eip" "aws3" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags_all             = (known after apply)
      + vpc                  = true
    }

  # aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "aakulov-aws3"
        }
      + tags_all = {
          + "Name" = "aakulov-aws3"
        }
      + vpc_id   = (known after apply)
    }

  # aws_launch_configuration.aws3 will be created
  + resource "aws_launch_configuration" "aws3" {
      + arn                         = (known after apply)
      + associate_public_ip_address = false
      + ebs_optimized               = (known after apply)
      + enable_monitoring           = true
      + id                          = (known after apply)
      + image_id                    = "ami-091d856a5f5701931"
      + instance_type               = "t2.medium"
      + key_name                    = "aakulov"
      + name                        = (known after apply)
      + name_prefix                 = (known after apply)
      + security_groups             = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + no_device             = (known after apply)
          + snapshot_id           = (known after apply)
          + throughput            = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + throughput            = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_lb.aws3 will be created
  + resource "aws_lb" "aws3" {
      + arn                        = (known after apply)
      + arn_suffix                 = (known after apply)
      + dns_name                   = (known after apply)
      + drop_invalid_header_fields = false
      + enable_deletion_protection = false
      + enable_http2               = true
      + id                         = (known after apply)
      + idle_timeout               = 60
      + internal                   = false
      + ip_address_type            = (known after apply)
      + load_balancer_type         = "application"
      + name                       = "aakulov-aws3"
      + security_groups            = (known after apply)
      + subnets                    = (known after apply)
      + tags_all                   = (known after apply)
      + vpc_id                     = (known after apply)
      + zone_id                    = (known after apply)

      + subnet_mapping {
          + allocation_id        = (known after apply)
          + ipv6_address         = (known after apply)
          + outpost_id           = (known after apply)
          + private_ipv4_address = (known after apply)
          + subnet_id            = (known after apply)
        }
    }

  # aws_lb_listener.aws3 will be created
  + resource "aws_lb_listener" "aws3" {
      + arn               = (known after apply)
      + certificate_arn   = (known after apply)
      + id                = (known after apply)
      + load_balancer_arn = (known after apply)
      + port              = 443
      + protocol          = "HTTPS"
      + ssl_policy        = "ELBSecurityPolicy-2016-08"
      + tags_all          = (known after apply)

      + default_action {
          + order            = (known after apply)
          + target_group_arn = (known after apply)
          + type             = "forward"
        }
    }

  # aws_lb_target_group.aws3 will be created
  + resource "aws_lb_target_group" "aws3" {
      + arn                                = (known after apply)
      + arn_suffix                         = (known after apply)
      + deregistration_delay               = 300
      + id                                 = (known after apply)
      + lambda_multi_value_headers_enabled = false
      + load_balancing_algorithm_type      = (known after apply)
      + name                               = "aakulov-aws3"
      + port                               = 80
      + preserve_client_ip                 = (known after apply)
      + protocol                           = "HTTP"
      + protocol_version                   = (known after apply)
      + proxy_protocol_v2                  = false
      + slow_start                         = 0
      + tags_all                           = (known after apply)
      + target_type                        = "instance"
      + vpc_id                             = (known after apply)

      + health_check {
          + enabled             = (known after apply)
          + healthy_threshold   = (known after apply)
          + interval            = (known after apply)
          + matcher             = (known after apply)
          + path                = (known after apply)
          + port                = (known after apply)
          + protocol            = (known after apply)
          + timeout             = (known after apply)
          + unhealthy_threshold = (known after apply)
        }

      + stickiness {
          + cookie_duration = (known after apply)
          + cookie_name     = (known after apply)
          + enabled         = (known after apply)
          + type            = (known after apply)
        }
    }

  # aws_nat_gateway.nat will be created
  + resource "aws_nat_gateway" "nat" {
      + allocation_id        = (known after apply)
      + connectivity_type    = "public"
      + id                   = (known after apply)
      + network_interface_id = (known after apply)
      + private_ip           = (known after apply)
      + public_ip            = (known after apply)
      + subnet_id            = (known after apply)
      + tags                 = {
          + "Name" = "aakulov-aws3"
        }
      + tags_all             = {
          + "Name" = "aakulov-aws3"
        }
    }

  # aws_placement_group.aws3 will be created
  + resource "aws_placement_group" "aws3" {
      + arn                = (known after apply)
      + id                 = (known after apply)
      + name               = "aws3"
      + placement_group_id = (known after apply)
      + strategy           = "spread"
      + tags_all           = (known after apply)
    }

  # aws_route53_record.aws3 will be created
  + resource "aws_route53_record" "aws3" {
      + allow_overwrite = true
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "tfe3.anton.hashicorp-success.com"
      + records         = (known after apply)
      + ttl             = 300
      + type            = "CNAME"
      + zone_id         = "Z077919913NMEBCGB4WS0"
    }

  # aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"] will be created
  + resource "aws_route53_record" "cert_validation" {
      + allow_overwrite = true
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = (known after apply)
      + records         = (known after apply)
      + ttl             = 60
      + type            = (known after apply)
      + zone_id         = "Z077919913NMEBCGB4WS0"
    }

  # aws_route_table.aws3-private will be created
  + resource "aws_route_table" "aws3-private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = ""
              + instance_id                = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = (known after apply)
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "aakulov-aws3-private"
        }
      + tags_all         = {
          + "Name" = "aakulov-aws3-private"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table.aws3-public will be created
  + resource "aws_route_table" "aws3-public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + instance_id                = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "aakulov-aws3-public"
        }
      + tags_all         = {
          + "Name" = "aakulov-aws3-public"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.aws3-private will be created
  + resource "aws_route_table_association" "aws3-private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_route_table_association.aws3-public will be created
  + resource "aws_route_table_association" "aws3-public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.aws3-internal-sg will be created
  + resource "aws_security_group" "aws3-internal-sg" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = -1
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "icmp"
              + security_groups  = []
              + self             = false
              + to_port          = -1
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = []
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = (known after apply)
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = "aws3-internal-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "aws3-internal-sg"
        }
      + tags_all               = {
          + "Name" = "aws3-internal-sg"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.aws3-lb-sg will be created
  + resource "aws_security_group" "aws3-lb-sg" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = "aws3-lb-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "aws3-lb-sg"
        }
      + tags_all               = {
          + "Name" = "aws3-lb-sg"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.subnet_private will be created
  + resource "aws_subnet" "subnet_private" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.5.1.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags_all                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.subnet_private1 will be created
  + resource "aws_subnet" "subnet_private1" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1c"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.5.3.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags_all                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.subnet_public will be created
  + resource "aws_subnet" "subnet_public" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.5.2.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags_all                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.subnet_public1 will be created
  + resource "aws_subnet" "subnet_public1" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1c"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.5.4.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + tags_all                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.5.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = true
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "Name" = "aakulov-aws3"
        }
      + tags_all                         = {
          + "Name" = "aakulov-aws3"
        }
    }

Plan: 24 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aws_url = "tfe3.anton.hashicorp-success.com"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_placement_group.aws3: Creating...
aws_vpc.vpc: Creating...
aws_acm_certificate.aws3: Creating...
aws_eip.aws3: Creating...
aws_eip.aws3: Creation complete after 0s [id=eipalloc-bd139c83]
aws_placement_group.aws3: Creation complete after 0s [id=aws3]
aws_acm_certificate.aws3: Creation complete after 6s [id=arn:aws:acm:eu-central-1:267023797923:certificate/982cc622-b78d-48bb-be82-014530df9b5f]
aws_acm_certificate_validation.aws3: Creating...
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Creating...
aws_vpc.vpc: Still creating... [10s elapsed]
aws_vpc.vpc: Creation complete after 12s [id=vpc-09f80f4158fe85b30]
aws_internet_gateway.igw: Creating...
aws_subnet.subnet_private: Creating...
aws_subnet.subnet_public1: Creating...
aws_subnet.subnet_public: Creating...
aws_subnet.subnet_private1: Creating...
aws_lb_target_group.aws3: Creating...
aws_security_group.aws3-lb-sg: Creating...
aws_lb_target_group.aws3: Creation complete after 1s [id=arn:aws:elasticloadbalancing:eu-central-1:267023797923:targetgroup/aakulov-aws3/89f78245e41eb1e9]
aws_subnet.subnet_public1: Creation complete after 1s [id=subnet-0f1c363fd35f75ebe]
aws_subnet.subnet_public: Creation complete after 1s [id=subnet-0f205e86559d25399]
aws_subnet.subnet_private: Creation complete after 1s [id=subnet-01d3cac338832c2d5]
aws_subnet.subnet_private1: Creation complete after 1s [id=subnet-006028ae75b86d101]
aws_internet_gateway.igw: Creation complete after 1s [id=igw-06ac5f80a9a52a2f4]
aws_nat_gateway.nat: Creating...
aws_route_table.aws3-public: Creating...
aws_security_group.aws3-lb-sg: Creation complete after 2s [id=sg-09f3a306c7049e9f0]
aws_lb.aws3: Creating...
aws_security_group.aws3-internal-sg: Creating...
aws_route_table.aws3-public: Creation complete after 1s [id=rtb-0754279b4ae3bdced]
aws_route_table_association.aws3-public: Creating...
aws_route_table_association.aws3-public: Creation complete after 1s [id=rtbassoc-0ec4289d3e88bcfc9]
aws_security_group.aws3-internal-sg: Creation complete after 2s [id=sg-03a4975c686dc4604]
aws_launch_configuration.aws3: Creating...
aws_acm_certificate_validation.aws3: Still creating... [10s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [10s elapsed]
aws_launch_configuration.aws3: Creation complete after 0s [id=terraform-20210706142510749600000002]
aws_nat_gateway.nat: Still creating... [10s elapsed]
aws_lb.aws3: Still creating... [10s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [20s elapsed]
aws_acm_certificate_validation.aws3: Still creating... [20s elapsed]
aws_nat_gateway.nat: Still creating... [20s elapsed]
aws_lb.aws3: Still creating... [20s elapsed]
aws_acm_certificate_validation.aws3: Creation complete after 28s [id=2021-07-06 14:25:21 +0000 UTC]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [30s elapsed]
aws_nat_gateway.nat: Still creating... [30s elapsed]
aws_lb.aws3: Still creating... [30s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [40s elapsed]
aws_nat_gateway.nat: Still creating... [40s elapsed]
aws_lb.aws3: Still creating... [40s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [50s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Creation complete after 50s [id=Z077919913NMEBCGB4WS0__f706da4cad7adeb580f9da519a94d5b8.tfe3.anton.hashicorp-success.com._CNAME]
aws_nat_gateway.nat: Still creating... [50s elapsed]
aws_lb.aws3: Still creating... [50s elapsed]
aws_nat_gateway.nat: Still creating... [1m0s elapsed]
aws_lb.aws3: Still creating... [1m0s elapsed]
aws_nat_gateway.nat: Still creating... [1m10s elapsed]
aws_lb.aws3: Still creating... [1m10s elapsed]
aws_nat_gateway.nat: Still creating... [1m20s elapsed]
aws_lb.aws3: Still creating... [1m20s elapsed]
aws_nat_gateway.nat: Still creating... [1m30s elapsed]
aws_lb.aws3: Still creating... [1m30s elapsed]
aws_nat_gateway.nat: Still creating... [1m40s elapsed]
aws_lb.aws3: Still creating... [1m40s elapsed]
aws_nat_gateway.nat: Still creating... [1m50s elapsed]
aws_lb.aws3: Still creating... [1m50s elapsed]
aws_nat_gateway.nat: Creation complete after 1m56s [id=nat-09ddbae7c543f78f7]
aws_route_table.aws3-private: Creating...
aws_route_table.aws3-private: Creation complete after 1s [id=rtb-04055193d395bfc05]
aws_route_table_association.aws3-private: Creating...
aws_route_table_association.aws3-private: Creation complete after 1s [id=rtbassoc-079ec5184c085c51d]
aws_lb.aws3: Still creating... [2m0s elapsed]
aws_lb.aws3: Creation complete after 2m2s [id=arn:aws:elasticloadbalancing:eu-central-1:267023797923:loadbalancer/app/aakulov-aws3/a9489dce0ae3a5f2]
aws_route53_record.aws3: Creating...
aws_lb_listener.aws3: Creating...
aws_autoscaling_group.aws3: Creating...
aws_lb_listener.aws3: Creation complete after 1s [id=arn:aws:elasticloadbalancing:eu-central-1:267023797923:listener/app/aakulov-aws3/a9489dce0ae3a5f2/195487f529ce14a5]
aws_route53_record.aws3: Still creating... [10s elapsed]
aws_autoscaling_group.aws3: Still creating... [10s elapsed]
aws_autoscaling_group.aws3: Still creating... [20s elapsed]
aws_route53_record.aws3: Still creating... [20s elapsed]
aws_autoscaling_group.aws3: Still creating... [30s elapsed]
aws_route53_record.aws3: Still creating... [30s elapsed]
aws_route53_record.aws3: Creation complete after 36s [id=Z077919913NMEBCGB4WS0_tfe3.anton.hashicorp-success.com_CNAME]
aws_autoscaling_group.aws3: Still creating... [40s elapsed]
aws_autoscaling_group.aws3: Still creating... [50s elapsed]
aws_autoscaling_group.aws3: Still creating... [1m0s elapsed]
aws_autoscaling_group.aws3: Still creating... [1m10s elapsed]
aws_autoscaling_group.aws3: Still creating... [1m20s elapsed]
aws_autoscaling_group.aws3: Still creating... [1m30s elapsed]
aws_autoscaling_group.aws3: Still creating... [1m40s elapsed]
aws_autoscaling_group.aws3: Still creating... [1m50s elapsed]
aws_autoscaling_group.aws3: Still creating... [2m0s elapsed]
aws_autoscaling_group.aws3: Still creating... [2m10s elapsed]
aws_autoscaling_group.aws3: Still creating... [2m20s elapsed]
aws_autoscaling_group.aws3: Still creating... [2m30s elapsed]
aws_autoscaling_group.aws3: Still creating... [2m40s elapsed]
aws_autoscaling_group.aws3: Still creating... [2m50s elapsed]
aws_autoscaling_group.aws3: Still creating... [3m0s elapsed]
aws_autoscaling_group.aws3: Still creating... [3m10s elapsed]
aws_autoscaling_group.aws3: Creation complete after 3m14s [id=aakulov-aws3]

Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

aws_url = "tfe3.anton.hashicorp-success.com"
```

