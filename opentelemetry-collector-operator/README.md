# OpenTelemetry Collector Operator Jsonnet Library

This repository contains the Jsonnet library for [OpenTelemetry Collector Operator's Custom Resource](https://github.com/open-telemetry/opentelemetry-operator/blob/main/docs/api.md).

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/), [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler) and OpenTelemertry Operator.

(2) Then you can install the library with:

```bash
# Run this command at your tanka home

$ jb install github.com/tonychoe/libsonnet/opentelemetry-collector-operator@master
```

(3) To deploy OpenTelemetry Collector Custom Resource, use the following example in your Tanka environment's `main.jsonnet` file:

```jsonnet
local otelcollector = (import 'github.com/tonychoe/libsonnet/opentelemetry-collector-operator/opentelemetry-collector.libsonnet');
{
  otelcollector_gateway:
    otelcollector.new('daemonset', $.util.manifestYaml($.otelcollector_config)),

  otelcollector_config:: {
    receivers: {
      otlp: {
        protocols: {
          grpc: null,
          http: null,
        },
      },
      jaeger: {
        protocols: {
          grpc: null,
          thrift_http: null,
        },
      },
    },
    processors: {
      batch: null,
      memory_limiter: {
        ballast_size_mib: 683,
        limit_mib: 1500,
        spike_limit_mib: 512,
        check_interval: '5s',
      },
    },
    exporters: {
      jaeger: {
        endpoint: 'jaeger-collector.jaeger:14250',
        insecure: true,
      },
    },
    extensions: {
      health_check: {},
      zpages: {},
    },
    service: {
      extensions: [
        'health_check',
        'zpages',
      ],
      pipelines: {
        traces: {
          receivers: [
            'otlp',
            'jaeger',
          ],
          processors: [
            'memory_limiter',
            'batch',
          ],
          exporters: [
            'jaeger',
          ],
        },
      },
    },
  },
}
```

## Credits To

This project is deeply infuenced by [jsonnet-libs/k8s-alpha](https://github.com/jsonnet-libs/k8s-alpha).

