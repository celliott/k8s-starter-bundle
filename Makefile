include defaults.mk

check-env :

	@if [ -z $(ENVIRONMENT) ]; then \
		echo "ENVIRONMENT must be set; export ENVIRONMENT=<env>"; exit 10; \
	fi

ecr-init :
	$$(aws ecr get-login --no-include-email --region=${AWS_DEFAULT_REGION})

docker-build :
	docker-compose build --pull

docker-up : ecr-init
	docker-compose up -d

docker-down :
	docker-compose down

docker-push : ecr-init docker-build
	docker-compose push

k8s-auth :
	aws eks update-kubeconfig \
		--region $(AWS_DEFAULT_REGION) \
		--name $(EKS_CLUSTER_NAME)

helm-deploy :
	helm upgrade -i $(NAMESPACE) helm/$(SERVICE) \
		--namespace $(NAMESPACE) \
		--set repository_base=$(ECR_BASE) \
		--set build.tag=$(IMAGE_TAG) \
		--set new_relic_license_key=$(NEW_RELIC_LICENSE_KEY)

helm-delete :
	helm del --purge $(SERVICE)

enable-newrelic-metadata-injection :
	kubectl label namespace $(NAMESPACE) newrelic-metadata-injection=enabled

ssh-worker :
	ssh -J bastion-mojo.modaoperandi.com ec2-user@$$(kubectl get node --no-headers -o custom-columns=NAME:.metadata.name | awk 'FNR == 1 {print}')
