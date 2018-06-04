variable "rules" {
  description = "Security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = "map"

  default = {
    # HTTP
    http-80-tcp   = [80, 80, "tcp", "HTTP"]
    http-8080-tcp = [8080, 8080, "tcp", "HTTP"]

    # HTTPS
    https-443-tcp = [443, 443, "tcp", "HTTPS"]

    # IPSEC
    ipsec-500-udp  = [500, 500, "udp", "IPSEC ISAKMP"]
    ipsec-4500-udp = [4500, 4500, "udp", "IPSEC NAT-T"]

    # MySQL
    mysql-tcp = [3306, 3306, "tcp", "MySQL/Aurora"]

    # PostgreSQL
    postgresql-tcp = [5432, 5432, "tcp", "PostgreSQL"]

    # SSH
    ssh-tcp = [22, 22, "tcp", "SSH"]

    # Open all ports & protocols
    all-all = [-1, -1, "-1", "All protocols"]
    all-tcp = [0, 65535, "tcp", "All TCP ports"]
  }
}

variable "auto_groups" {
  description = "Map of groups of security group rules to use to generate modules (see update_groups.sh)"
  type        = "map"

  default = {
    http-80 = {
      ingress_rules     = ["http-80-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }

    https-443 = {
      ingress_rules     = ["https-443-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }

    ipsec-500 = {
      ingress_rules     = ["ipsec-500-udp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }

    ipsec-4500 = {
      ingress_rules     = ["ipsec-4500-udp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }

    mysql = {
      ingress_rules     = ["mysql-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }

    postgresql = {
      ingress_rules     = ["postgresql-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }

    ssh = {
      ingress_rules     = ["ssh-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }

    web = {
      ingress_rules     = ["http-80-tcp", "http-8080-tcp", "https-443-tcp"]
      ingress_with_self = ["all-all"]
      egress_rules      = ["all-all"]
    }
  }
}
