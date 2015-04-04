variable "version" {
  defailt = "21"
}
variable "region" {}
variable "distribution" {}
variable "virttype" {}

output "ami_id" {
    value = "${lookup(var.all_amis, format(\"%s-%s-%s-%s\", var.version, var.region, var.distribution, var.virttype))}"
}

