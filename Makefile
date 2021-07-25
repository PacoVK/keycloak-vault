# USAGE
define USAGE
Usage: make [help | up | down | init | provision | deprovision | destroy | shell]
endef
export USAGE

TF_DIR := ./terraform
UNAME := $(shell uname -s)
.PHONY:
help:
	@echo "$$USAGE"

up:
	docker-compose -f docker-compose.yml up -d $(c)

down:
	docker-compose -f docker-compose.yml down $(c)

init:
	docker exec terraform-shell terraform init

provision:
	docker exec terraform-shell terraform apply --auto-approve

deprovision:
	docker exec terraform-shell terraform destroy --auto-approve

destroy:
	docker exec terraform-shell terraform destroy --auto-approve
	cd ${TF_DIR} && rm -rf *.terraform *.hcl *.tfstate *.backup

shell:
	docker exec -it terraform-shell ash
