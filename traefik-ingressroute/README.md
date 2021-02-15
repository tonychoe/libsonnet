# Traefik Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/)'s [IngressRoute](https://doc.traefik.io/traefik/master/routing/providers/kubernetes-crd/). IngressRoute is the Kubnernetes Ingress Controller CRD for Traefik.

## Usage

To use this mixin, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/traefik-ingressroute
```

To use, in your Tanka environment's `main.jsonnet` file:


```jsonnet
local ingressroute = (import "traefik-ingressroute/v1/main.libsonnet");
```

## Example

```jsonnet
local ingressroute = import 'traefik-ingressroute/v1/main.libsonnet';
local routes = ingressroute.spec.routes;
local services = ingressroute.spec.routes.services;

{
  my_ingressroute:
    ingressroute.new('my_ingressroute') +
    ingressroute.spec.withEntryPointsMixins('websecure') +
    ingressroute.spec.withRoutesMixins(
      routes.new("Host(`my.world.com`) && PathPrefix(`/prometheus`)" ) +
      routes.withKind('Rule') +
      routes.withServicesMixins([
        services.new('promkube-prometheus') +
        services.withNamespace('promkube') +
        services.withPort(9090),
      ]) 
    ) 
}
```
