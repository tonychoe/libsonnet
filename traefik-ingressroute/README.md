# Traefik IngressRoute Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/)'s [IngressRoute](https://doc.traefik.io/traefik/master/routing/providers/kubernetes-crd/). IngressRoute is the Kubnernetes Ingress Controller CRD for Traefik.

## Usage

To use this mixin, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/traefik-ingressroute/v1
```

To use, in your Tanka environment's `main.jsonnet` file:


```jsonnet
local ingressroute = (import "traefik-ingressroute/v1/ingressroute.libsonnet");
```

## Example

* [Example 1](../docs/examples/ingressroute.jsonnet)

