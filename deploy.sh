# Installing Dependencies
#sudo apt update
yes | sudo apt install python3-dev libffi-dev gcc libssl-dev
yes | sudo apt install python3-pip
sudo pip3 install -U pip
sudo pip install -U 'ansible>=4,<6'


# Install Kolla-ansible
sudo pip3 install git+https://opendev.org/openstack/kolla-ansible@master
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla
cp -r /usr/local/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
cp /usr/local/share/kolla-ansible/ansible/inventory/* .


# Install Ansible Galaxy requirements
kolla-ansible install-deps


# Configure Ansible
mkdir /etc/ansible
tee /etc/ansible/ansible.cfg << EOF
[defaults]
host_key_checking=False
pipelining=True
forks=100
EOF


# Kolla passwords
kolla-genpwd


# configuring Kolla globals.yml
sudo apt install net-tools
# In this we are storing the ip of eth0 for further use.
my_br_ip=$(ifconfig eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  | cut -d' ' -f2)


# kolla_base_distro: "ubuntu"
# network_interface: "eth0"
# neutron_external_interface: "eth1"
# kolla_internal_vip_address: "$my_br_ip"
# enable_cinder: "no"
# enable_haproxy: "no"

tee /etc/kolla/globals.yml << EOF
---
workaround_ansible_issue_8743: yes
kolla_base_distro: "ubuntu"
network_interface: "eth0"
neutron_external_interface: "eth1"
kolla_internal_vip_address: "$my_br_ip"
enable_cinder: "no"
enable_haproxy: "no"
EOF

# Deployment
kolla-ansible -i ./all-in-one bootstrap-servers
kolla-ansible -i ./all-in-one prechecks
kolla-ansible -i ./all-in-one deploy


# Using OpenStack
pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/master --ignore-installed
kolla-ansible post-deploy
. /etc/kolla/admin-openrc.sh
/usr/local/share/kolla-ansible/init-runonce

# Displaying login password
cat /etc/kolla/passwords.yml | grep keystone_admin_password


