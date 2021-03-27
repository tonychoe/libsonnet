# Traefik Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/).

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

(2) Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/traefik
```

(3) Install the Traefik CRDs:

* They are the cluster-wide resource, so you just need to install only once.

To install,, in your Tanka environment's `crd.jsonnet` file:

```jsonnet
local crd = (import "traefik/v1/traefik-crd.libsonnet");
```
and use 'tk apply' with the `crd.jsonnet` file.

(4) To deploy traefik, in your Tanka environment's `main.jsonnet` file:

```jsonnet
local traefik = (import "traefik/v1/traefik.libsonnet");

traefik {
  _config+:: {
    namespace: "default",
  },
}
```

(5) To add new ingressroute, see the example.

## Example

* [Example 1](examples/traefik.jsonnet)

