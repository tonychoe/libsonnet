# Prometheus Operator Jsonnet Library

This repository contains the Jsonnet library for these APIs 
* [PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#podmonitor) 
* [ServiceMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#servicemonitor)
* [PrometheusRule](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#prometheusrule)

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/), [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler) and Prometheus Operator CRD.

(2) Ensure your cluster already have the latest version of ServiceMonitor CRD installed.
Use 'apply' or 'replace' command.

```bash
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/crds/crd-servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/crds/crd-podmonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/crds/crd-prometheuses.yaml
```

(3) Then you can install the library with:

```bash
# Run this command at your tanka home

$ jb install github.com/tonychoe/libsonnet/prometheus-operator@master
or 
$ jb update github.com/tonychoe/libsonnet/prometheus-operator@master
```

(4) To deploy ServiceMonitor, use the following example in your Tanka environment's `main.jsonnet` file:

```jsonnet
local s = (import "github.com/tonychoe/libsonnet/prometheus-operator/main.libsonnet");
{

  local endpoint = s.endpoint,
  local servicemonitor = s.servicemonitor,
  local relabelconfig = s.relabelconfig,

  relabelconfig::
    relabelconfig.new()
    + relabelconfig.withSourceLabels( [ '__meta_kubernetes_namespace', '__meta_kubernetes_service_name' ] )
    + relabelconfig.withSeparator( '/' )
    + relabelconfig.withTargetLabel( 'job' )
    + relabelconfig.withRegex( '(.*)' )
    + relabelconfig.withReplacement( '$1' )
    + relabelconfig.withAction( 'replace' )
  ,

  consul_servicemoniter:
    local app = 'consul';
    servicemonitor.new( 
      app, 
      [
        endpoint.new( ) 
        + endpoint.withPort( 'statsd-exporter-http-metrics' )
        + endpoint.withRelabelings( $.relabelconfig ),
        endpoint.new( )
        + endpoint.withPort( 'consul-exporter-http-metrics' )
        + endpoint.withRelabelings( $.relabelconfig ),
      ],
      servicemonitor.labelSelector.withMatchLabels( { name: app } ) 
    ),

  memcached_servicemoniter:
    local app = 'memcached';
    servicemonitor.new( 
      app, 
      endpoint.new( ) 
      + endpoint.withPort( 'exporter-http-metrics' )
      + endpoint.withRelabelings( $.relabelconfig ), 
      servicemonitor.labelSelector.withMatchLabels( { name: app } ) 
    ),
}
```

(4) To deploy PodMonitor, use the following example in your Tanka environment's `main.jsonnet` file:
```jsonnet
local s = (import 'github.com/tonychoe/libsonnet/prometheus-operator/main.libsonnet');
{

  local podmetricsendpoint = s.podmetricsendpoint,
  local podmonitor = s.podmonitor,
  local relabelconfig = s.relabelconfig,

  relabelconfig::
    relabelconfig.new()
    + relabelconfig.withSourceLabels(['__meta_kubernetes_namespace', '__meta_kubernetes_service_name'])
    + relabelconfig.withSeparator('/')
    + relabelconfig.withTargetLabel('job')
    + relabelconfig.withRegex('(.*)')
    + relabelconfig.withReplacement('$1')
    + relabelconfig.withAction('replace')
  ,

  agent_podmonitor:
    local app = 'otelcol-agent';
    podmonitor.new(app, podmetricsendpoint.new() + podmetricsendpoint.withPort('metrics') + podmetricsendpoint.withRelabelings($.relabelconfig), podmonitor.labelSelector.withMatchLabels({ name: app })),

  gateway_podmonitor:
    local app = 'otelcol-gateway';
    podmonitor.new(app, podmetricsendpoint.new() + podmetricsendpoint.withPort('metrics') + podmetricsendpoint.withRelabelings($.relabelconfig), podmonitor.labelSelector.withMatchLabels({ name: app })),
}
```

## Example

* [Example](docs/servicemonitor.jsonnet)

## Credits To

This project is deeply infuenced by [jsonnet-libs/k8s-alpha](https://github.com/jsonnet-libs/k8s-alpha).

