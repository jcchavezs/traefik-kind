CLUSTER_NAME=traefik
LOG4SHELL_VULNERABLE_IMAGE="ghcr.io/christophetd/log4shell-vulnerable-app@sha256:6f88430688108e512f7405ac3c73d47f5c370780b94182854ea2cddc6bd59929"
APP_NAMESPACE=default

all: build load deploy

.PHONY: load
load:
	@kind load docker-image ${LOG4SHELL_VULNERABLE_IMAGE} --name ${CLUSTER_NAME}

deploy:
	APP_NAMESPACE=$(APP_NAMESPACE) LOG4SHELL_VULNERABLE_IMAGE=$(LOG4SHELL_VULNERABLE_IMAGE) envsubst < app.yaml | kubectl apply -f -

undeploy:
	APP_NAMESPACE=$(APP_NAMESPACE) LOG4SHELL_VULNERABLE_IMAGE=$(LOG4SHELL_VULNERABLE_IMAGE) envsubst < app.yaml | kubectl delete -f -