# ServiceMonitor Jsonnet Library

This repository contains the Jsonnet library for [ServiceMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#servicemonitor).

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

(2) Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/servicemonitor
```

(3) To deploy ServiceMonitor, use the following example in your Tanka environment's `main.jsonnet` file:

```jsonnet
local servicemonitor = (import "servicemonitor/servicemonitor.libsonnet");
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

## Example

* [Example](docs/servicemonitor.jsonnet)

## Credits To

This project is deeply infuenced by [jsonnet-libs/k8s-alpha](https://github.com/jsonnet-libs/k8s-alpha).

