# USAGE
define USAGE
Usage: make [help | up | down | init | provision | deprovision | destroy]
endef
export USAGE

TF_DIR := ./terraform
UNAME := $(shell uname -s)
.PHONY:
help:
	@echo "$$USAGE"
up:
ifeq ($(UNAME),Darwin)
	docker-compose -f docker-compose-mac.yml up -d $(c)
else
	docker-compose -f docker-compose.yml up -d $(c)
endif
down:
ifeq ($(UNAME),Darwin)
	docker-compose -f docker-compose-mac.yml down $(c)
else
	docker-compose -f docker-compose.yml down $(c)
endif
init:
	cd ${TF_DIR} && terraform init
provision:
ifeq ($(UNAME),Darwin)
	cd ${TF_DIR} && terraform apply -var 'vault_oidc_discovery_url_host=keycloak' --auto-approve
else
	cd ${TF_DIR} && terraform apply --auto-approve
endif
deprovision:
	cd ${TF_DIR} && terraform destroy --auto-approve
destroy:
	cd ${TF_DIR} && terraform destroy --auto-approve && rm -rf *.terraform *.hcl *.tfstate *.backup
