# https://docs.openstack.org/python-openstackclient/latest/cli/authentication.html
# https://docs.openstack.org/python-openstackclient/latest/cli/command-list.html
# https://docs.openstack.org/python-openstackclient/latest/contributor/plugins.html
# https://docs.openstack.org/python-openstackclient/latest/cli/man/openstack.html 

# https://support.huaweicloud.com/en-us/devg-sdk_cli/sdk_cli-devg.pdf

# Instance metadata from inside
# https://docs.openstack.org/nova/latest/user/metadata.html
# https://support.huaweicloud.com/en-us/usermanual-ecs/en-us_topic_0042400609.html
## openstack
curl http://169.254.169.254/openstack/latest/meta_data.json
curl -sS http://169.254.169.254/openstack/latest/meta_data.json|jq .availability_zone
curl -sS http://169.254.169.254/openstack/latest/meta_data.json|jq .name
## EC2 compatible
echo $(curl -sS http://169.254.169.254/latest/meta-data/local-hostname)
curl http://169.254.169.254/2009-04-04/meta-data/placement/availability-zone
curl http://169.254.169.254/latest/meta-data/instance-type


# Não é necessário personalizar estas variáveis
export CLIFF_FIT_WIDTH=1
export NOVA_ENDPOINT_TYPE=publicURL 
export OS_ENDPOINT_TYPE=publicURL 
export CINDER_ENDPOINT_TYPE=publicURL 
export OS_VOLUME_API_VERSION=2 
export OS_IDENTITY_API_VERSION=3 
export OS_IMAGE_API_VERSION=2

# variáveis personalizadas
# export OS_REGION_NAME="ap-southeast-1" # OpenStackClient reclama de falta de endpoint ao declarar essa variável
# OS_PROJECT_NAME e OS_TENANT_NAME são "sinônimos", com OS_PROJECT_NAME sendo o nome adotado no Keystone API v3
# Declarando OS_PROJECT_NAME, não é necessário (nem recomendável, pra evitar confusão) declarar OS_TENANT_NAME
export OS_PROJECT_NAME=ap-southeast-1

# Como o provider do Terraform precisa de region para funcionar, definimos numa variavel diferente das OS_
# Se não houvesse esse problema com o OpenStackClient, poderiamos simplesmente usar a variável OS_REGION_NAME junto com o provider Terraform
export TF_region=$OS_PROJECT_NAME 

export OS_AUTH_URL="https://iam.$OS_TENANT_NAME.myhuaweicloud.com/v3"
export OS_DOMAIN_NAME="<your HWC account name"
export OS_USERNAME=$OS_DOMAIN_NAME
 export OS_PASSWORD=""

export OS_ACCESS_KEY=
export OS_SECRET_KEY=


# Local client configuration
openstack configuration show

openstack versions show
openstack endpoint list
openstack region list
openstack availability zone list
openstack project list
openstack catalog list

### Operações com IAM - TODO: melhorar para ficar compatível com escopo project ####
unset OS_TENANT_NAME OS_PROJECT_NAME

# formato 1
OS_USER_DOMAIN_NAME=$OS_DOMAIN_NAME openstack user list
# formato 2
openstack user list --os-user-domain-name $OS_DOMAIN_NAME
#formato 3
OS_PROJECT_NAME= openstack user list --os-user-domain-name $OS_DOMAIN_NAME





# Criação de servidor
# https://docs.openstack.org/python-openstackclient/latest/cli/command-objects/server.html#server-create
## image can be defined by ID or by Name
openstack help server create
openstack subnet list

export ECS_NAME="test-$(TZ=America/Sao_Paulo date +%F-%Hh%M)"
#export ECS_FLAVOR="m1.large"
export ECS_FLAVOR="s3.medium.2"
export ECS_AZ="$OS_PROJECT_NAME""a"
# export ECS_IMAGE_NAME="Ubuntu 18.04 server 64bit"
export ECS_IMAGE_NAME="SUSE Linux Enterprise Server 15 SP1 1-2vCPU"
export ECS_SUBNET_NAME="subnet-default-sp" #### ALTERAR PARA NOME DE SUBNET DA SUA VPC!!! ###
export ECS_SUBNET_ID=$(openstack subnet list --name "$ECS_SUBNET_NAME" -c Network -f value)

openstack server create \
  --image "$ECS_IMAGE_NAME" \
  --flavor "$ECS_FLAVOR" \
  --availability-zone "$ECS_AZ" \
  --network "$ECS_SUBNET_ID" \
  $ECS_NAME



## Networking
### VPCs
### "Name" column == VPC name at the Console
### "ID" column = VPC ID at the console
openstack router list
export VPC_ID=$(openstack router list -f value -c ID|head -n 1) # selecting the first listed VPC
openstack router show $VPC_ID -f json | jq



#### "Name" column == VPC ID at the Console
openstack network list # List all subnets, one per line
openstack network show $VPC_ID -f json | jq



### Subnets
openstack subnet list -c Name -c Network -c Subnet

# Elastic IP  (same as Floating IP)
openstack floating ip list

## Provisioning new EIP from API
### Works, but couldn't find a way to assign bandwidth (uses 5Mbps, per traffic, as default)
openstack floating ip create admin_external_net

### Listing all unbounded EIPs
openstack floating ip list --status DOWN

### Selecting the ID of the first unbounded EIP
export EIP_ID=$(openstack floating ip list --status DOWN -f value -c ID|head -n 1)


# SSH Public Key
## https://docs.openstack.org/python-openstackclient/latest/cli/command-objects/keypair.html
ssh-keygen
openstack keypair list
openstack keypair create --public-key ~/.ssh/id_rsa.pub key-name

##################################
# VPNaaS
# ainda não sabemos como criar um VPN Service pela API, que não fique com as informações de bandwidth vazias (impossibilitando o uso)
export VPN_GW_NAME=$(openstack vpn service list -c Name -f value|head -n 1)
export VPN_GW_IP=$(openstack vpn service show $VPN_GW_NAME -c external_v4_ip -f value)

export VPN_CONN_NAME=$(openstack vpn ipsec site connection list -c Name -f value|head -n 1)
openstack vpn ipsec site connection show $VPN_CONN_NAME  --fit-width

#Renomeando uma conexão
openstack vpn ipsec site connection set --name vpn-new-name vpn-old-name

# No console uma policy é editável apenas nas configurações da conexão usada pela mesma
vpn ipsec policy list

###################
# Heat (orchestration)
openstack stack list

