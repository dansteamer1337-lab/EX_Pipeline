variable "yc_token" {
  type        = string
  description = "Yandex Cloud OAuth token or IAM token"
  default     = ""
  sensitive   = true
}

variable "yc_service_account_key_file" {
  type        = string
  description = "Path to authorized key file for Yandex Cloud service account (JSON)"
  default     = ""
}

variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  default     = ""
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID where resources will be created"
}

variable "yc_zone" {
  type        = string
  description = "Availability zone for resources"
  default     = "ru-central1-a"
}

variable "public_ssh_key" {
  type        = string
  description = "Public SSH key string for accessing the virtual machine (e.g. ssh-ed25519 AAAAC3...)"
}

variable "vm_name" {
  type        = string
  description = "Name of the compute instance"
  default     = "app-server"
}

variable "vm_cores" {
  type        = number
  description = "Number of CPU cores for the VM"
  default     = 2
}

variable "vm_memory" {
  type        = number
  description = "Memory size in GB for the VM"
  default     = 2
}

variable "vm_core_fraction" {
  type        = number
  description = "Guaranteed CPU performance level in % (e.g. 20, 50, 100)"
  default     = 20
}

variable "vm_disk_size" {
  type        = number
  description = "Disk size in GB for the VM root disk"
  default     = 20
}

variable "ubuntu_image_family" {
  type        = string
  description = "Image family for Ubuntu OS"
  default     = "ubuntu-2204-lts"
}
