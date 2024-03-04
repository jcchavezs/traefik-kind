# localplugin

Version 0.1.0 of coraza-http-wasm is incompatible with traefik as it requires host 0.6.0 hence we build this container to be able to consume the plugin as local-plugin and copy the wasm artifact during init containers phase.
