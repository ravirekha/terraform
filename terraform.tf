provider "ucloud" {
  public_key = "sOBEB+k3WB3eBXiWW0u99jmgkcDxr06yplefuXcE72VMvZFMUxO4ytBuoaM="
  private_key = "tqYT2FZp2jNDrpFq1L6glpDUJN3nlksNlV0jUE7ZHmI8nkz2dEaLfxUhtf1AvK3S"
  project_id = "org-34em0u"
  region     = "cn-bj2"
}


# Query default security group
data "ucloud_security_groups" "default" {
    type = "recommend_web"
}
# Query image
data "ucloud_images" "default" {
  availability_zone = "cn-bj2-02"
  name_regex        = "^CentOS 6.5 64"
#  name_regex        = "^Ubuntu 18.04 64"
  image_type        = "base"
}

resource "ucloud_security_group" "example" {
    name = "tf-example-security-group"
    tag  = "tf-example-new"

    # http access from LAN
    rules {
        port_range = "80"
        protocol   = "tcp"
        cidr_block = "10.42.0.0/16"
        policy     = "accept"
    }

    # https access from LAN
    rules {
        port_range = "443"
        protocol   = "tcp"
        cidr_block = "10.42.0.0/16"
        policy     = "accept"
    }
}


# Create web instance
resource "ucloud_instance" "web" {
    availability_zone = "cn-bj2-02"
    image_id          = data.ucloud_images.default.images[0].id
    instance_type     = "n-basic-2"
    root_password     = "wA1234567"
    name              = "tf-example-instance"
    tag               = "tf-example-new"

    # the default Web Security Group that UCloud recommend to users
    security_group = data.ucloud_security_groups.default.security_groups[0].id
}
resource "ucloud_eip" "example" {
    bandwidth            = 4
    charge_mode          = "bandwidth"
    name                 = "tf-example-eip"
    tag                  = "tf-example"
    internet_type        = "bgp"
}
