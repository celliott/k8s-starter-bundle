# Starter Bundle

## Base docker apline images
* [NodeJS 8.8](https://github.com/nodejs/docker-node/blob/master/8.8/alpine/Dockerfile)
* [Python 2.7](https://github.com/docker-library/python/blob/master/2.7/alpine3.4/Dockerfile)

## Setup A New Example Project Repo

### Applications

##### Add App(s) dir to ./apps dir. All apps must include Dockerfile.

```
docker \
  api
    src
    Dockerfile
  frontend
    src
    Dockerfile
```

### Docker Compose

##### Create docker-compose.yml v2 that specifies build location for each app.

NOTE ENVs are seeded from docker.mk

```yml
version: '2'
services:
  api:
    build: docker/api
    image: ${ECR_BASE}/${API_NAME}:${BUILD_TAG}
  frontend:
    build: docker/frontend
    image: ${ECR_BASE}/${APP_NAME}:${BUILD_TAG}
```

### Make and default.mk

##### Add application ENVs to default.mk

```
...
# Service Vars
NAME=starter-bundle

# API Vars
API_NAME=starter-bundle-api
API_PORT=3000
API_USER=admin
API_PASS=mypassword

# APP Vars
APP_NAME=starter-bundle-frontend
APP_PORT=5000
```

##### Add docker commands to Makefile

```
init :
	-helm init --upgrade

config : init
	docker-compose config --quiet

build : config
	docker-compose build

up : init
	docker-compose up -d

down :
	docker-compose down

push : build
	docker-compose push
```

### Helm Chart

##### Add helm chart to repo `helm/<service_name>`

NOTE this step is not documented b/c charts will be different depending on the application requirements. A good starting point: [How To Create Your First Helm Chart](https://docs.bitnami.com/kubernetes/how-to/create-your-first-helm-chart/)

##### Add helm upgrade command in Makefile with ENV overrides

```
helm-deploy :
	-helm init
	-kubectl create namespace $(SERVICE)
	helm upgrade -i $(NAMESPACE) helm/$(SERVICE) \
		--namespace $(NAMESPACE) \
		--set repository_base=$(ECR_BASE) \
		--set build.tag=$(IMAGE_TAG)

delete :
	helm del --purge $(SERVICE)
```
