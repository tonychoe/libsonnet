{
  _config+:: {

    namespace: error 'must define traefik_namespace',

    traefik: {
      release_name: 'my',
      replicas: 1,
      accesslog: false,
      accesslog_format: 'common',
      entrypoints_port: 9000,
      entrypoints_web_port: 8000,
      entrypoints_websecure_port: 8443,
      // Pass extra args to traefik. See https://doc.traefik.io/traefik/reference/static-configuration/cli/
      extraArgs: [
      ],
    },
  },

  _images+:: {
    traefik_image: 'traefik:2.5.3',
  },
}
