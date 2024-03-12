#!/bin/bash

set +e

# We delete the deployment first as kind has issues replacing the deployment
envsubst < traefik/deployments.yaml | kubectl delete -f -

echo "Deploying traefik components:"
traefik_files=("namespaces" "clusterroles" "configmap" "deployments" "services" "tracing")
for f in ${traefik_files[@]}; do
  envsubst < traefik/${f}.yaml | kubectl apply -f -
done
