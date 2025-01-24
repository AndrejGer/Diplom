# ===============================providers.tf===============================
terraform { 
  required_providers {
    yandex = {
        source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token                    = "${var.cloud["token"]}"
  cloud_id                 = "${var.cloud["cloud_id"]}"
  folder_id                = "${var.cloud["folder_id"]}"
}

