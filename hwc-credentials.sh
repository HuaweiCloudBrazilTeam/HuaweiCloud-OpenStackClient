#!/bin/sh

# Documentação sobre parametrização da autenticação do OpenStackClient para HuaweiCloud se encontra em:
## https://support.huaweicloud.com/en-us/devg-sdk_cli/en-us_topic_0070637155.html

# Ajuste sua região padrão
export HWC_DEFAULT_REGION="la-south-2"
# A listagem de códigos das regiões está disponível em https://developer.huaweicloud.com/intl/en-us/endpoint
# Você pode alterar temporariamente a região executando no Shell: 
### export HWC_REGION=codigo-da-regiao
### source hwc-credentials.sh 

# Não alterar. Se a variável HWC_REGION estiver vazia, usa o valor de HWC_DEFAULT_REGION
export HWC_REGION="${HWC_REGION:-`echo $HWC_DEFAULT_REGION`}" # não alterar

# "Project name" é a segregação usada entre as regiões da HuaweiCloud.
# Por padrão cada região tem um projeto com nome idêntico ao código da mesma.
# Altere apenas se você tiver criado Projetos adicionais
export OS_PROJECT_NAME=$HWC_REGION

# Como o provider do Terraform precisa de region para funcionar, definimos numa variavel diferente das OS_
# Se não houvesse esse problema com o OpenStackClient, poderiamos simplesmente usar a variável OS_REGION_NAME junto com o provider Terraform
export TF_VAR_region=$HWC_REGION

export OS_AUTH_URL="https://iam.$HWC_REGION.myhuaweicloud.com/v3"

# substitua pelo nome da sua conta na Huawei Cloud
export OS_DOMAIN_NAME="hwc_1234"

# Mantenha $OS_DOMAIN_NAME caso você esteja autenticando o usuário padrão Enterprise Admin
# Altere para o nome de usuário IAM, caso você tenha algum
export OS_USERNAME=$OS_DOMAIN_NAME 
export OS_PASSWORD="sua senha aqui"

# OPCIONAL
# Chaves AK/SK são necessárias para operações no OBS (oObject Storage Service)
# Nos demais serviços a autenticação usando OS_USERNAME e OS_PASSWORD é suficiente
export OS_ACCESS_KEY=ABCDEFGH
export OS_SECRET_KEY=MuitosCaracteresMisturados

#### Não é necessário editar daqui para baixo #######
export CLIFF_FIT_WIDTH=1 # faz o OpenStackClient ajustar automaticamente a formatação de tabelas para largura do terminal

export NOVA_ENDPOINT_TYPE=publicURL 
export OS_ENDPOINT_TYPE=publicURL 
export CINDER_ENDPOINT_TYPE=publicURL 
export OS_VOLUME_API_VERSION=2 
export OS_IDENTITY_API_VERSION=3 
export OS_IMAGE_API_VERSION=2

## Variáveis para NÃO serem usadas:
#### OS_REGION_NAME: ao utilizar gera problema de compatibilidade entre OpenStackClient e HuaweiCloud
#### OS_TENANT_NAME: obsoleta, usar OS_PROJECT_NAME no lugar
