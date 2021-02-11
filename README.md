# Integrate Keycloak with HashiCorp Vault

This is an example Terraform implementation of a Keycloak Vault integration.<br/> 
The project refers to a [medium post on this topic](https://pascal-euhus.medium.com/integrate-keycloak-with-hashicorp-vault-5264a873dd2f). 

:warning: <br/>  
Note for Mac user :apple: to work with the Terraform code you need to add to your ```/etc/hosts```; <br/>
```
127.0.0.1 keycloak
``` 
:warning: <br/>  

## Usage
Use makefile: <br/>
```make [help | up | down | init | provision | deprovision | destroy]```

1. Start the local environment (Docker) ````make up````
2. Initialize Terraform  ````make init````
3. Apply the Terraform configuration ````make provision````
4. Shutdown the local environment (Docker) ````make down````

### Makefile 
| Command        | Description           |
| ------------- |:-------------:|
| up      | start docker container |
| down      | stop docker container      |
| init | terraform init    |
| provision | terraform apply     |
| deprovision | terraform destroy     |
| destroy |  terraform destroy and remove all terraform related files/states   |
