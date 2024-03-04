#!/bin/bash

set +e

echo "Deploying traefik components:"
traefik_files=("namespaces" "clusterroles" "configmap" "deployments" "services" "tracing")
for f in ${traefik_files[@]}; do
  envsubst < traefik/${f}.yaml | kubectl apply -f -
done

echo "Deploying sample app:"
envsubst < httpbin.yaml | kubectl apply -f -