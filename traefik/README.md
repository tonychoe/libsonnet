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

(5) To import all Traefik CRD helpers with one module:

```jsonnet
local traefikCrds = import "traefik/crds.libsonnet";

{
  tlsoption:
    traefikCrds.tlsoption.new("strict-tls") +
    traefikCrds.tlsoption.spec.withMinVersion("VersionTLS13") +
    traefikCrds.tlsoption.spec.withSniStrict(true),
  ingressroute:
    traefikCrds.ingressroute.new("my") +
    traefikCrds.ingressroute.spec.withTls("my-tls-secret") +
    traefikCrds.ingressroute.spec.withTlsOptions("strict-tls"),
}
```

(6) To apply secure defaults globally:

```jsonnet
local traefikCrds = import "traefik/crds.libsonnet";

traefikCrds.presets.secureDefaults.strict("wildcard-tracing-oraclecloud-com-cert")
```

(7) To add new ingressroute, see the example.

## CRD Helpers

This library includes helper modules for the current Traefik CRDs:

* `traefik/crds.libsonnet` (single import for all helpers)
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
* `traefik/presets/secure-defaults.libsonnet`

All helpers provide:

* `new(name)` for object creation
* `spec.withSpec(spec)` for full spec replacement
* `spec.withSpecMixin(spec)` for additive spec merge

## Compatibility

* The helpers target `traefik.io/v1alpha1` CRDs.
* This library was validated against Traefik Kubernetes CRD schema from the Traefik `v3.6` docs:
  * https://doc.traefik.io/traefik/v3.6/routing/providers/kubernetes-crd/
  * https://raw.githubusercontent.com/traefik/traefik/v3.6/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
* Deprecated fields are still exposed when useful for migration, for example:
  * `TLSOption.spec.preferServerCipherSuites`

## Example

* [Example 1](examples/traefik.jsonnet)
