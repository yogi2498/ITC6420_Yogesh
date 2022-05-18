

output "instances_ids" {
  value = [for ec2 in aws_instance.ec2_lb : ec2.id]
}

output "lb_id" {
  value = module.alb.lb_id
}

output "lb_dns" {
  value = module.alb.lb_dns_name
}
