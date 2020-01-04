variable "aws_ip_cidr_range" {
  default = "172.15.0.0/16"
}
variable "private_subnetCIDR" {
  default = "172.15.1.0/24"
}
variable "mapPublicIPPrivateSubnet" {
  default = "false"
}
variable "availability_zonePrivateSubnet" {
  default = "a"
}
variable "public_subnetCIDR" {
  default = "172.15.2.0/24"
}
variable "mapPublicIPPublicSubnet" {
  default = "true"
}
variable "availability_zonePublicSubnet" {
  default = "b"
}
variable "destcidrblock" {
  default = "0.0.0.0/0"
}
