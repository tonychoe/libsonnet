# OpenTelemetry Demo Jsonnet Library

This library uses the OpenTelemetry Demo Helm Chart.

## Maintenance

1. Clone the desired version of Helm chart in the /charts directory. e.g., /charts/opentelemetry-demo

2. Go to the directory of cloned chart and run `helm dependency build`



# Usage

`jb install github.com/tonychoe/libsonnet/opentelemetry-demo@master`

```
local oteldemo = import 'github.com/tonychoe/libsonnet/opentelemetry-demo/main.libsonnet';
local k = import 'k.libsonnet';
local tk = import 'tk';

oteldemo.new(overrides={
  values+: {
    // Disable unwanted services
    grafana+: {
      enabled: false,
    },
    jaeger+: {
      enabled: false,
    },
    'opentelemetry-collector'+: {
      enabled: false,
    },
    prometheus+: {
      enabled: false,
    },
  },
})
```
