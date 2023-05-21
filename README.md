#This repo will allow you to configure the following objects automatically 
using TF:

1. Pool (pointing to member behind CE)
2. LB (local on CE)
3. Generate valid certificate using Let's Encrypt CERTBOT 
4. Publish the DNS pointing to the LB automatically (in my example, AWS 
LB).

![Logo of My Project](./architecture-design.jpg)

the components :

Variables.tf = please change to adjust your env.
HTTP_POOL.tf = create Pool with the reference of your service
GENERATE_CERTIFICATE.tf = generates certificate using CERTBOT (runs BASH 
script names “script.sh” + “dns_register.sh”)
HTTPS_APP.tf = create LB with the certificate generated before, pointing 
to the Pool created before.
DNS_Create_Record.tf = create cname pointing from your desired FQDN to the 
cname created by the system. [we should replace with you public IP]. (runs 
BASH script named “create_cname.sh”)

Using vestctl :
https://gitlab.com/volterra.io/vesctl/blob/main/README.md


- [Prerequisites](#Prerequisites)

TF
CERTBOT :
https://certbot.eff.org/
VESCTL:
https://gitlab.com/volterra.io/vesctl/blob/main/README.md
jq installed


- [Installation](#installation)
