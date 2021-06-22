MAKEFLAGS += --warn-undefined-variables --jobs=$(shell nproc)
SHELL := /bin/bash
ifeq ($(word 1,$(subst ., ,$(MAKE_VERSION))),4)
.SHELLFLAGS := -eu -o pipefail -c
endif
.DEFAULT_GOAL := help
.ONESHELL:



.PHONY: help
help: ## Show this help.
	@grep '.*:.*##' Makefile | grep -v grep  | sort | sed 's/:.* ##/:/g' | column -t -s:

TF_SRC := $(shell find ./ -maxdepth 1 -name "*.tf")
.DEFAULT_GOAL = terraform.tfstate

.PHONY: init
init: ## Run 'terraform init' (force)
	terraform init

.terraform:  ## Runs 'terraform init' and creates .terraform folder
	terraform init

terraform.tfplan: $(TF_SRC) .terraform  ## Runs 'terraform plan' and creates a plan file
	terraform plan -out tf.plan

terraform.tfstate: terraform.tfplan  ## Runs 'terraform apply' and applies the previously created plan file.
	terraform apply terraform.tfplan
	rm -f terraform.tfplan

.PHONY: force
force:
	touch *.tf
	make terraform.tfstate

README.md: *.tf  ## Update README.md with 'terraform-docs'
	sed -i'' -e '/^## Providers$$/,$$d' README.md
	terraform-docs md . >> README.md

.PHONY: clean
clean: .terraform  ## Runs 'terraform destroy' and deletes all resources
	terraform destroy -auto-approve
	rm -f terraform.tfstate terraform.tfplan
