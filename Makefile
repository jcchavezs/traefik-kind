CLUSTER_NAME=traefik-openfga
TRAEFIK_NAMESPACE=traefik
APP_NAMESPACE=default

.PHONY: build
build:
	@kind create cluster --config kind-config.yaml --name ${CLUSTER_NAME}
	@$(MAKE) deploy

.PHONY: deploy
deploy:
	@TRAEFIK_NAMESPACE=$(TRAEFIK_NAMESPACE) \
	APP_NAMESPACE=$(APP_NAMESPACE) \
	./deploy.sh

.PHONY: cleanup
cleanup:
	@kind delete cluster --name $(CLUSTER_NAME)