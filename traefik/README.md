# Traefik Jsonnet Library

This repository contains the Jsonnet library for [Traefik](https://traefik.io/).

## Usage

#### With [Tanka](https://tanka.dev)

```bash
$ jb install github.com/tonychoe/libsonnet/traefik/v1
```

Then put the following into `lib/k.libsonnet`:

```jsonnet
(import "github.com/github.com/tonychoe/libsonnet/traefik/v1/main.libsonnet")

```

#### Standalone

```bash
$ jb install github.com/tonychoe/libsonnet/traefik/v1
```

Then import it in your project:

```jsonnet
local k = import "github.com/tonychoe/libsonnet/traefik/v1/main.libsonnet"
```
