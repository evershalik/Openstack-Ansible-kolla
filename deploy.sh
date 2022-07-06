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


# Kolla globals.yml
tee /etc/kolla/globals.yml << EOF
kolla_base_distro: "ubuntu"
network_interface: "eth0"
neutron_external_interface: "eth1"
kolla_internal_vip_address: "192.168.5.190"
enable_cinder: "no"
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

