# OpenTelemetry Collector Jsonnet Library

This repository contains the Jsonnet library for [OpenTelemetry Collector](https://github.com/open-telemetry/opentelemetry-collector).

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/), [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler) and OpenTelemertry Operator.

(2) Then you can install the library with:

```bash
# Run this command at your tanka home

$ jb install github.com/tonychoe/libsonnet/opentelemetry-collector@master
```

(3) To deploy OpenTelemetry Collector, use the following example in your Tanka environment's `main.jsonnet` file:

```jsonnet
local agent = (import 'github.com/tonychoe/libsonnet/opentelemetry-collector/agent.libsonnet');
local gateway = (import 'github.com/tonychoe/libsonnet/opentelemetry-collector/gateway.libsonnet');

agent + gateway {
  _images+:: {
    otelcol: 'us-phoenix-1.ocir.io/idvjmdrn1r3d/otel/opentelemetry-collector-contrib:0.44.0',
  },

  _config+:: {
    namespace: 'otelcol',

    agent_release_name: 'otelcol-agent',
    /* Add your own opentelemetry collector configuration
    agent_config:: {
    },
    */

    gateway_release_name: 'otelcol-gateway',
    gateway_replicas: 3,
    /* Add your own opentelemetry collector configuration
    gateway_config: {
    },
    */
  },
}
