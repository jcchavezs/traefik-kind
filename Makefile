CLUSTER_NAME=traefik
TRAEFIK_NAMESPACE=traefik
APP_NAMESPACE=default

# loading an image tagged as latest will not work
# https://iximiuz.com/en/posts/kubernetes-kind-load-docker-image/
TRAEFIK_PLUGIN_IMAGE=traefik-plugin:0.1.0

.PHONY: build
# build creates a kind cluster
build:
	@kind create cluster --config kind-config.yaml --name ${CLUSTER_NAME}
	@$(MAKE) build-plugin-image

# Load the plugin image into the kind cluster
build-plugin-image:
	@docker build --load -t $(TRAEFIK_PLUGIN_IMAGE) ./localplugin
	@kind load docker-image $(TRAEFIK_PLUGIN_IMAGE) --name ${CLUSTER_NAME}

# deploy deploys traefik and the app
deploy-all: deploy-traefik deploy-httpbin

deploy-traefik:
	@TRAEFIK_NAMESPACE=$(TRAEFIK_NAMESPACE) \
	APP_NAMESPACE=$(APP_NAMESPACE) \
	TRAEFIK_PLUGIN_IMAGE=$(TRAEFIK_PLUGIN_IMAGE) \
	./deploy-traefik.sh

deploy-httpbin:
	@APP_NAMESPACE=$(APP_NAMESPACE) \
	envsubst < httpbin.yaml | kubectl apply -f -

undeploy-httpbin:
	@APP_NAMESPACE=$(APP_NAMESPACE) \
	envsubst < httpbin.yaml | kubectl delete -f -

.PHONY: cleanup
# cleanup deletes the kind cluster
cleanup:
	@kind delete cluster --name $(CLUSTER_NAME)