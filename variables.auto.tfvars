alb = {
  servers = [
    {
      name   = "VM1"
      subnet = "172.16.0.0/24"
      ami    = "ami-089c6f2e3866f0f14"
      type   = "t2.micro"
    },
    {
      name   = "VM2"
      subnet = "172.16.1.0/24"
      ami    = "ami-089c6f2e3866f0f14"
      type   = "t2.micro"
    }
  ]
  network = "172.16.0.0/16"
  subnets = [
    {
      cidr = "172.16.0.0/24"
      az   = "us-east-2a"
    },
    {
      cidr = "172.16.1.0/24"
      az   = "us-east-2b"
    }
  ]
}