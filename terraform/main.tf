resource "yandex_vpc_network" "app_network" {
  name        = "app-vpc-network"
  description = "Isolated VPC network for application infrastructure"
}

resource "yandex_vpc_subnet" "app_subnet" {
  name           = "app-public-subnet"
  description    = "Public subnet for application VM"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.app_network.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group allowing SSH (22), HTTP (80), HTTPS (443) and blocking all other ingress"
  network_id  = yandex_vpc_network.app_network.id

  ingress {
    protocol       = "TCP"
    description    = "Allow SSH access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow incoming HTTP traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow incoming HTTPS traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.ubuntu_image_family
}

resource "yandex_compute_instance" "app_server" {
  name        = var.vm_name
  hostname    = var.vm_name
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vm_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.app_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.app_sg.id]
  }

  metadata = {
    ssh-keys  = "ubuntu:${var.public_ssh_key}"
    user-data = <<-EOF
      #cloud-config
      datasource:
        Ec2:
          strict_id: false
      ssh_pwauth: no
      users:
        - name: ubuntu
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${var.public_ssh_key}
      packages:
        - ca-certificates
        - curl
        - gnupg
        - lsb-release
      runcmd:
        - install -m 0755 -d /etc/apt/keyrings
        - curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        - chmod a+r /etc/apt/keyrings/docker.asc
        - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        - apt-get update -y
        - apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        - systemctl enable docker
        - systemctl start docker
        - usermod -aG docker ubuntu
        - mkdir -p /home/ubuntu/app
        - chown -R ubuntu:ubuntu /home/ubuntu/app
    EOF
  }

  scheduling_policy {
    preemptible = false
  }
}