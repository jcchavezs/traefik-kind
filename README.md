# Traefik over Kind

This repository has the required configuration files to run Traefik over kind.

The manifests for traefik are mainly inspired in [this guide](https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/) however some tweaks have been added to be able to expose the ingress to the host network when using kind in mac/windows (based on [this guide](https://kind.sigs.k8s.io/docs/user/ingress/)).

## Getting started

First we will create a kind cluster by running `make build`.

Once the cluster is ready we will deploy the applications by running `make deploy` and after that we will be able to access the dashboard through <http://localhost:8080> and do some curls to the sample app:

```console
# Successful request:
curl -i http://localhost
```

Once you are done you can cleanup the environment running `make cleanup`.

### WAF

Coraza middleware has been enabled on httpbin ingress. The configuration for it is being declared in the [config middleware](./traefik/configmap.yaml). A call to `/headers` will be matched as per the rules but no rules:

```console
# Successful request:
curl -i http://localhost/headers
```

We can update the config map with the rules to enable blocking:

```console
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: config
  namespace: traefik
data:
  config.yaml: |
    http:
      middlewares:
        waf:
          plugin:
            coraza:
              directives:
                - SecRuleEngine On
                - SecDebugLog /dev/stdout
                - SecDebugLogLevel 9
                - SecRule REQUEST_URI "@streq /headers" "id:101,phase:1,log,deny,status:403"
```

```console
# Denied request:
curl -i http://localhost/headers
```

## Requirements

- kind
- kubectl
