
locals {
  vms_ids = [
    for vm in var.alb.servers : {
      target_id = aws_instance.ec2_lb[vm.name].id
      port      = 80
    }
  ]
}

resource "aws_security_group" "allow_http" {
  name   = "allow_http"
  vpc_id = aws_vpc.vpc_lb.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_network_interface" "nic_lb" {
  for_each        = { for nic in var.alb.servers : nic.name => nic }
  subnet_id       = aws_subnet.subnet_lb[each.value.subnet].id
  security_groups = [aws_security_group.allow_http.id]
}

resource "aws_instance" "ec2_lb" {
  for_each      = { for vm in var.alb.servers : vm.name => vm }
  ami           = each.value.ami
  instance_type = each.value.type

  network_interface {
    network_interface_id = aws_network_interface.nic_lb[each.value.name].id
    device_index         = 0
  }


  user_data = <<-EOF
    #!/bin/bash
    sudo amazon-linux-extras enable nginx1
    sudo yum -y install nginx
    sudo yum -y install python-pip
    sudo echo "Yogesh ALB" >  /usr/share/nginx/html/index.html
    sudo systemctl start nginx.service
  EOF
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id          = aws_vpc.vpc_lb.id
  subnets         = [for subnet in var.alb.subnets : aws_subnet.subnet_lb[subnet.cidr].id]
  security_groups = [aws_security_group.allow_http.id]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets          = local.vms_ids
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}
