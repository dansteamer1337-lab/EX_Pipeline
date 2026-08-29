terraform {
  required_version = ">= 1.0.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.yc_service_account_key_file != "" ? (fileexists("${path.module}/${var.yc_service_account_key_file}") ? "${path.module}/${var.yc_service_account_key_file}" : var.yc_service_account_key_file) : null
  token                    = var.yc_token != "" ? var.yc_token : null
  cloud_id                 = var.yc_cloud_id != "" ? var.yc_cloud_id : null
  folder_id                = var.yc_folder_id
  zone                     = var.yc_zone
}
