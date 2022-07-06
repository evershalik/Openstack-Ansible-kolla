# Welcome to Openstack- Kolla-Ansible deployment

## For official documentation of Openstack-kolla-ansible 
[Click Here for official deployment](https://docs.openstack.org/kolla-ansible/latest/user/quickstart.html)

## To see Openstack kolla-ansible deployment 
[Click here for deployment video](https://www.youtube.com/watch?v=b-XgSPuedro&list=LL&index=1)

## For official kolla-ansible repository 
[Click here for official repo](https://opendev.org/openstack/kolla-ansible)

## Host Network Bridge Information:

OpenStack-Ansible uses bridges to connect physical and logical network interfaces on the host to virtual network interfaces within containers. Target hosts need to be configured with the following network bridges:

![](https://lh3.googleusercontent.com/GEEKQiewwupz56eTi9u6mcfwiglmTqCQJM0yITAntcBRuXQ-SQVgH5cndtsYo60kKiLjlcik6DzVJEJNRS_HeGrMxa26JsWui9B1ydhPWHivCc5sGQ2WAOUcSvL0seq9CdiQLiFQ9nGOops0p2k)

  

-   LXC internal: lxcbr0  
      
    The lxcbr0 bridge is required for LXC, but OpenStack-Ansible configures it automatically. It provides external (typically Internet) connectivity to containers with dnsmasq (DHCP/DNS) + NAT.  
      
    This bridge does not directly attach to any physical or logical interfaces on the host because iptables handles connectivity. It attaches to eth0 in each container.  
      
    The container network that the bridge attaches to is configurable in the openstack_user_config.yml file in the provider_networks dictionary.  
      
    
-   Container management: br-mgmt  
      
    The br-mgmt bridge provides management of and communication between the infrastructure and OpenStack services.  
      
    The bridge attaches to a physical or logical interface, typically a bond0 VLAN subinterface. It also attaches to eth1 in each container.  
      
    The container network interface that the bridge attaches to is configurable in the openstack_user_config.yml file.  
      
    
-   Storage:br-storage  
      
    The br-storage bridge provides segregated access to Block Storage devices between OpenStack services and Block Storage devices.  
      
    The bridge attaches to a physical or logical interface, typically a bond0 VLAN subinterface. It also attaches to eth2 in each associated container.  
      
    The container network interface that the bridge attaches to is configurable in the openstack_user_config.yml file.  
      
    
-   OpenStack Networking tunnel: br-vxlan  
      
    The br-vxlan interface is required if the environment is configured to allow projects to create virtual networks using VXLAN. It provides the interface for encapsulated virtual (VXLAN) tunnel network traffic.  
      
    Note that br-vxlan is not required to be a bridge at all, a physical interface or a bond VLAN subinterface can be used directly and will be more efficient. The name br-vxlan is maintained here for consistency in the documentation and example configurations.  
      
    The container network interface it attaches to is configurable in the openstack_user_config.yml file.  
      
    
-   OpenStack Networking provider: br-vlan  
      
    The br-vlan bridge provides infrastructure for VLAN tagged or flat (no VLAN tag) networks.  
      
    The bridge attaches to a physical or logical interface, typically bond1. It is not assigned an IP address because it handles only layer 2 connectivity.  
      
    The container network interface that the bridge attaches to is configurable in the openstack_user_config.yml file.


## Storage Configuration:
LVM: Local volume manager

Logical volume management (LVM) is a form of storage virtualization that offers system administrators a more flexible approach to managing disk storage space than traditional partitioning.
