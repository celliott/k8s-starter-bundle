# Docker Variables
AWS_DEFAULT_REGION ?= us-east-1
ECR_BASE ?= 923133779345.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
IMAGE_TAG ?= $(shell git log -n 1 --pretty=format:'%h')

# EKS Variables
EKS_CLUSTER_NAME ?= poc-eks-cluster

# project vars
PROJECT ?= starter-bundle
ENVIRONMENT ?= staging
NAMESPACE ?= starter-bundle

# API Vars
SERVICE ?= starter-bundle
API_NAME ?= starter-bundle-api
API_PORT ?= 3000
API_USER ?= admin
API_PASS ?= mypassword

# APP Vars
APP_NAME ?= starter-bundle-frontend
APP_PORT ?= 5000
SECRET ?= nosecret

export
