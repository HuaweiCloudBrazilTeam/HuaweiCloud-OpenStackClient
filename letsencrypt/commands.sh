export MYIP=$(curl -Ss http://canihazip.com/s) # from anywhere
# or
export MYIP=$(curl -Ss http://169.254.169.254/latest/meta-data/public-ipv4) $ from the cloud


### Using Openstack Designate plugin
# https://docs.openstack.org/python-designateclient/latest/user/index.html
pip install python-openstackclient
mkdir -p ~/.config/openstack
vim ~/.config/openstack/clouds.yaml
openstack region list

pip install python-designateclient

export DNS_ZONE=mydomain.tld
export DNS_RECORD=myrecord
export DNS_RECORD_VALUE=123.123.123.123
openstack zone list
openstack recordset list "$DNS_ZONE"
openstack recordset create "$DNS_ZONE" --type A "$DNS_RECORD" --record "$DNS_RECORD_VALUE"

recordset delete "$DNS_ZONE" "$DNS_RECORD"."$DNS_ZONE"

#### Certbot with Designate plugin
pip install certbot-dns-openstack
certbot --version

certbot --authenticator certbot-dns-openstack:dns-openstack \
  certonly \
  -d "$DNS_RECORD"."$DNS_ZONE" \
  --register-unsafely-without-email \
  --agree-tos \
  --config-dir $PWD/config --work-dir $PWD/work-dir --logs-dir $PWD/logs

