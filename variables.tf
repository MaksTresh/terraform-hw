variable "vpc_1_cidr" {
  description = "VPC CIDR"
  default     = "172.20.0.0/16"
}

variable "vpc_2_cidr" {
  description = "VPC CIDR"
  default     = "172.21.0.0/16"
}

variable "vpc_1_cidr_public" {
  description = "Public subnet CIDR"
  default     = "172.20.0.0/24"
}

variable "vpc_1_cidr_private" {
  description = "Private subnet CIDR"
  default     = "172.20.1.0/24"
}

variable "vpc_3_cidr_private" {
  description = "Private subnet CIDR"
  default     = "172.20.5.0/24"
}


variable "vpc_2_cidr_public" {
  description = "Public subnet CIDR"
  default     = "172.21.0.0/24"
}

variable "vpc_2_cidr_private" {
  description = "Private subnet CIDR"
  default     = "172.21.1.0/24"
}

variable "vpc_3_cidr_public" {
  description = "Public subnet CIDR"
  default     = "172.20.10.0/24"
}