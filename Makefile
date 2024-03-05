CLUSTER_NAME=traefik
TRAEFIK_NAMESPACE=traefik
APP_NAMESPACE=default

.PHONY: build
# build creates a kind cluster
build:
	@kind create cluster --config kind-config.yaml --name ${CLUSTER_NAME}

.PHONY: deploy
# deploy deploys traefik and the app
deploy:
	@TRAEFIK_NAMESPACE=$(TRAEFIK_NAMESPACE) \
	APP_NAMESPACE=$(APP_NAMESPACE) \
	./deploy.sh

.PHONY: cleanup
# cleanup deletes the kind cluster
cleanup:
	@kind delete cluster --name $(CLUSTER_NAME)