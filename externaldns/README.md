# ExternalDNS Jsonnet Library

This repository contains the Jsonnet library for [ExternalDNS](https://github.com/kubernetes-sigs/external-dns).

## Usage

(1) To use this library, install [Tanka](https://tanka.dev/) and [Jsonnet Bundler](https://tanka.dev/install#jsonnet-bundler).

(2) Then you can install the library with:

```bash
$ jb install github.com/tonychoe/libsonnet/externaldns
```

(3) To deploy ExternalDNS, 

First, ceate a secret with your DNS provider detail in the same namespace. The secret must be named as `external-dns-config`.
``` bash
kubectl create secret generic external-dns-config --from-file=./YOURPROVIDER.yaml --namespace=YOURNAMESPACE
```

Second, in your Tanka environment's `main.jsonnet` file:

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
      release_name: 'YOURRELEASENAME',
      txt_owner_id: 'YOUROWNERID',
    },
  }
}
```

Third, 'tk apply' with your `main.jsonnet` file.

## Note

* This library doesn't create a namespace.
