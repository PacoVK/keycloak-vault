# Integrate Keycloak with HashiCorp Vault

This is an example Terraform implementation of a Keycloak Vault integration.<br/> 
The project refers to a [medium post on this topic](https://pascal-euhus.medium.com/integrate-keycloak-with-hashicorp-vault-5264a873dd2f).

**This version is compatible with Quarkus, for Keyloak on Wildfly see [here](https://github.com/PacoVK/keycloak-vault/releases/tag/legacy-wildfly)**

## Prerequisite

### Keycloak frontend name resolution

You need to set the following entry in ``/etc/hosts`` or `C:\Windows\System32\drivers\etc\hosts`. 
```text
127.0.0.1 keycloak
```

This change should be done on the operating system that the end-user's browser is running on (when using WSL the change needs to be done on windows system). 

The keycloak name resolution for the backend (vault->keycloak) is done through the docker service name.

### Make

Install make. Ex for debian-like systems:

```
sudo apt install make
```

Alternatively check the `Makefile` and manually run the commands. 

For example to run the stack in the foreground and display all logs in the standard output, instead of `make up` you can use:

```
docker-compose up
```



## Usage

Use makefile: <br/>
```make [help | up | down | init | provision | deprovision | destroy | shell]```

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
| shell | open a shell with terraform binary  |
