ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text)


init:
	terraform init

plan:
	@terraform plan -var="account_id=$(ACCOUNT)"
	
apply:
	terraform apply -auto-approve -var="account_id=$(ACCOUNT)"

destroy:
	terraform destroy -auto-approve