Creating VPN VM
------------------------------
1. Create file `secret.tfvar`:

       YA_TOKEN="<0Auth-Token>" 
       YA_CLOUD="<Yandex-Cloud-Name>"
       YA_FOLDER="<Yandex-Cloud-Folder-ID>"
       YA_SUBNET="<Yandex-Cloud-Subnet-ID>"
       YA_USER="<user-name>"
       YA_KEY_FOLDER="<some-folder>"

2. Create VM with Jenkins using `jenkins-vm.tf`:

        terraform init
        terraform apply -var-file secret.tfvar -auto-approve

