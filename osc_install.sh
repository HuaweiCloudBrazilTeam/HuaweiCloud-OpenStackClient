# Configuring python and pipx
yum -y install python3 # distro dependant

pip3 install --upgrade pip
pip3 install pipx --user
~/.local/bin/pipx ensurepath

# OSC
pipx install python-openstackclient

# Neutron
pipx inject --include-apps python-openstackclient python-neutronclient # Networking
## neutron lbaas-loadbalancer-list

# DNS/Designate
pipx inject python-openstackclient python-designateclient

pipx inject --include-apps python-openstackclient python-glanceclient
pipx inject --include-apps python-openstackclient python-heatclient

# HuaweiCloud specific
pipx inject --include-apps python-openstackclient git+https://github.com/Huawei/OpenStackClient_Auto-Scaling  # not funcional (python3 incompatibility?)

# Autocomplete
openstack complete | sudo tee /etc/bash_completion.d/osc.bash_completion > /dev/null