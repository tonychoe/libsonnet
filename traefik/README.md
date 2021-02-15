# Traefik Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/).

## Usage

To use this mixin, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/traefik/v1
```

To use, in your Tanka environment's `main.jsonnet` file:


```jsonnet
local ingressroute = (import "traefik/ingressroute.libsonnet");

{
  ingressroute:
    ingressroute.new('example') +
    ingressroute.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'example',
    }) +
    ingressroute.spec.withEntryPointsMixins('websecure') +
    ingressroute.spec.withRoutesMixins(
      route.new("PathPrefix(`/hotrod`) || PathPrefix(`/demo`)") +
      route.withKind('Rule') +
      route.withServicesMixins([
        service.new('hotrod') +
        service.withPort(8080),
      ])
    ) +
}

```
