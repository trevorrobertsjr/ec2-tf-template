# using default VPC for most examples
variable "network_interface_id" {
  type    = string
  default = "vpc-0e737a55eef87bf6"
}

variable "ami" {
  type    = string
  default = "ami-01c647eace872fc02"
}

# t2.medium required for airbyte
variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key" {
  type    = string
  default = "my laptop"
}
