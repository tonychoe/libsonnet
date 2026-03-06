# Traefik Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/).

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

(2) Then you can install the library with:

```bash
# Run this command at your tanka home

$ jb install github.com/tonychoe/libsonnet/traefik@master
```

(3) Install the Traefik CRDs:

* They are the cluster-wide resource, so you just need to install only once.
* CRD reference for humans: https://doc.crds.dev/github.com/traefik/traefik

```jsonnet
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_ingressroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_ingressroutetcps.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_ingressrouteudps.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_middlewares.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_middlewaretcps.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_serverstransports.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_serverstransporttcps.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_tlsoptions.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_tlsstores.yaml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik-helm-chart/master/traefik-crds/crds-files/traefik/traefik.io_traefikservices.yaml
```

(4) To deploy traefik, in your Tanka environment's `main.jsonnet` file:

```jsonnet
local traefik = (import "traefik/traefik.libsonnet");

traefik {
  _config+:: {
    namespace: "default",
  },
}
```

(5) To add a TLSOption and attach it to an IngressRoute:

```jsonnet
local ingressroute = import "traefik/ingressroute.libsonnet";
local tlsoption = import "traefik/tlsoption.libsonnet";

{
  tlsoption:
    tlsoption.new("strict-tls") +
    tlsoption.spec.withMinVersion("VersionTLS12") +
    tlsoption.spec.withSniStrict(true),
  ingressroute:
    ingressroute.new("my") +
    ingressroute.spec.withTls("my-tls-secret") +
    ingressroute.spec.withTlsOptions("strict-tls"),
}
```

(6) To add new ingressroute, see the example.

## CRD Helpers

This library includes helper modules for the current Traefik CRDs:

* `traefik/ingressroute.libsonnet`
* `traefik/ingressroutetcp.libsonnet`
* `traefik/ingressrouteudp.libsonnet`
* `traefik/middleware.libsonnet`
* `traefik/middlewaretcp.libsonnet`
* `traefik/serverstransport.libsonnet`
* `traefik/serverstransporttcp.libsonnet`
* `traefik/tlsoption.libsonnet`
* `traefik/tlsstore.libsonnet`
* `traefik/traefikservice.libsonnet`

All helpers provide:

* `new(name)` for object creation
* `spec.withSpec(spec)` for full spec replacement
* `spec.withSpecMixin(spec)` for additive spec merge

## Example

* [Example 1](examples/traefik.jsonnet)
