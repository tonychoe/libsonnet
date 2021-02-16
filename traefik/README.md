# Traefik Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/).

## Usage

To use this mixin, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/traefik
```

To use, in your Tanka environment's `main.jsonnet` file:


```jsonnet
local ingressroute = (import "traefik-ingressroute/v1/traefik.libsonnet");
```

## Example

* [Example 1](../docs/examples/traefik.jsonnet)

