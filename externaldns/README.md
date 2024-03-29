# ExternalDNS Jsonnet Library

This repository contains the Jsonnet library for [ExternalDNS](https://github.com/kubernetes-sigs/external-dns).

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

(2) Then you can install the library with:

```bash
# Run this command at your tanka home

$ jb install github.com/tonychoe/libsonnet/externaldns@master
```

(3) To deploy ExternalDNS, 

First, create a namespace
```bash
kubectl create namespace YOURNAMESPACE
```

Second, create a secret with your DNS provider detail in the same namespace. The secret must be named as `external-dns-config`.
``` bash
kubectl create secret generic external-dns-config --from-file=./YOURPROVIDER.yaml --namespace=YOURNAMESPACE
```

Third, in your Tanka environment's `main.jsonnet` file:

```jsonnet
local externaldns = (import 'externaldns/v1/externaldns.libsonnet');

externaldns {
  # Use this to override the image
  _images+:: {
  },

  # Use this to override the config
  _config+:: {

    namespace: 'YOURNAMESPACE',

    external_dns+:: {
      # release_name is used in two places
      # 1) Resource name, suffixed by '-external-dns'
      # 2) value for the metadata.labels."app.kubernetes.io/instance"
      release_name: 'YOURRELEASENAME',
      txt_owner_id: 'YOUROWNERID',
      // Pass extra args to ExternalDNS
      extraArgs: [
      ],
    },
  }
}
```

Third, 'tk apply' with your `main.jsonnet` file.

## Note

* This library doesn't create a namespace.
