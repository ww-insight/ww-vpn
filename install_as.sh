apt update
apt upgrade -y
apt install ca-certificates wget net-tools gnupg -y

wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | sudo apt-key add -
touch /etc/apt/sources.list.d/openvpn-as-repo.list
chmod 777 /etc/apt/sources.list.d/openvpn-as-repo.list
echo "deb http://as-repository.openvpn.net/as/debian focal main">/etc/apt/sources.list.d/openvpn-as-repo.list
apt update

sudo apt install openvpn-as -y
