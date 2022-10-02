terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "YA_TOKEN" {type = string}
variable "YA_CLOUD" {type = string}
variable "YA_FOLDER" {type = string}
variable "YA_SUBNET" {type = string}
variable "YA_USER" {type = string}
variable "YA_KEY_FOLDER" {type = string}

locals {
  YA_PUBKEY_FILE = "${var.YA_KEY_FOLDER}/id_rsa.pub"
  YA_PRIVATEKEY_FILE = "${var.YA_KEY_FOLDER}/id_rsa"
}

provider "yandex" {
  token     = var.YA_TOKEN
  cloud_id  = "cloud-ww-bel"
  folder_id = "b1g1ea8du0rjbjnjl075"
  zone      = "ru-central1-b"
}
////////////////////////////////////////////   VM-1   ///////////////////////////////////////
resource "yandex_compute_instance" "vm-1" {

  name = "ww-vpn"

  allow_stopping_for_update = true

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: wwbel\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("/Users/wwbel/.ssh/id_rsa.pub")}"
  }
  boot_disk {
    initialize_params {
      image_id = "fd8qps171vp141hl7g9l" // Ubuntu 20.04
    }
  }
  network_interface {
    subnet_id = "e2lcrt85pcpnboln5af9"
    nat = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  scheduling_policy {
    preemptible = true
  }

    connection {
    type     = "ssh"
    user     = var.YA_USER
    private_key = "${file(local.YA_PRIVATEKEY_FILE)}"
    host     = self.network_interface.0.nat_ip_address
  }
    provisioner "remote-exec" {
    inline = [
       "sudo apt update"
      ,"sudo apt upgrade -y"
      ,"sudo apt install ca-certificates wget net-tools gnupg -y"

      ,"sudo wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | sudo apt-key add -"
      ,"sudo touch /etc/apt/sources.list.d/openvpn-as-repo.list"
      ,"sudo chmod 777 /etc/apt/sources.list.d/openvpn-as-repo.list"
      ,"sudo echo \"deb http://as-repository.openvpn.net/as/debian focal main\">/etc/apt/sources.list.d/openvpn-as-repo.list"
      ,"sudo apt update"

      ,"sudo apt install openvpn-as -y"

    ]
  }
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

