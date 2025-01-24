# ===============================variables.tf===============================
variable "cloud" {
  type = map
  default = {
  "token" = "y0_AgAAAAAM1fCDAATuwQAAAAEQf4s6AAAyt8bSqcVPyJKFaPpBAs3nZ82mQw"
  "cloud_id" = "b1g7e77kb9vgi8k8mbvgS"
  "folder_id" = "b1g7rtd16au0omj9id7e"
  }
}

variable "images" {
  type = map
  default = {
    "debian_12" = "fd8t5b6prt4g7cseseqh"
    "Fedora_37" = "fd8kki6jts574bk9u9rn"
    "debian_9" = "fd8t5b6prt4g7cseseqh"
    "ubuntu_24" = "fd84kp940dsrccckilj6"
  }
}

