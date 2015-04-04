tf_aws_fedora_ami
=================

Terraform module to get the current set of publicly available Fedora AMIs.

This module grabs all of the AMIs listed at:

   https://getfedora.org/en/cloud/download/

and then looks up the one you want given the input variables

## Input variables

  * version - 21 (the current version, and the default)
  * region - E.g. eu-central-1
  * distribution - base/atomic
  * virttype - hvm/pv

Outputs:

  * ami_id

## Example use

    module "ami" {
      source = "github.com/terraform-community-modules/tf_aws_fedora_ami"
      region = "eu-central-1"
      distribution = "atomic"
      virttype = "hvm"
    }

    resource "aws_instance" "atomic" {
      ami = "${module.ami.ami_id}"
      instance_type = "m3.8xlarge"
      ...
    }

## Stability note

I've added a version variable so that I *could* continue maintaining this when
subsequent versions are released - however that's predicated in the AMIs still
existing in future. I have no idea how I'll actually resolve this in future...

I recommend that you include this module by specific SHA for stability!

