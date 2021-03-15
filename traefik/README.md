# Traefik Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/).

## Usage

To use this library, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/traefik/1.1
```

Install the Traefik Custom Resoruce Definition (cluster-wide resource) if not installed.
To install,, in your Tanka environment's `crd.jsonnet` file:

```jsonnet
local crd = (import "traefik/1.1/traefik-crd.libsonnet");
```
and use 'tk apply'.

To deploy traefik, in your Tanka environment's `main.jsonnet` file:

```jsonnet
local traefik = (import "1.1/traefik.libsonnet");

traefik {
  _config+:: {
    namespace: "default",
  },
}
```

To deploy the ingressroute, see the example.

## Example

* [Example 1](examples/traefik.jsonnet)

