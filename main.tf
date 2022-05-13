variable "instance_names" {
  type = set(string)
  default = ["k8s1", "k8s2", "k8s3"] 
}

data "civo_size" "small" {
    filter {
        key = "name"
        values = ["g3.medium"]
        match_by = "re"
    }

    filter {
        key = "type"
        values = ["instance"]
    }

}

# Query instance disk image
data "civo_disk_image" "ubuntu" {
   filter {
        key = "name"
        values = ["ubuntu-focal"]
   }
}

# Create a new instance
resource "civo_instance" "k8s" {
    for_each   = var.instance_names
    sshkey_id  = "fb9a863a-65a4-4d62-997d-9844d94831fe"
    hostname   = each.value
    tags       = ["kubernetes", "kubeadm"]
    notes      = "kubeadm instances"
    size       = element(data.civo_size.small.sizes, 0).name
    disk_image = element(data.civo_disk_image.ubuntu.diskimages, 0).id
}
