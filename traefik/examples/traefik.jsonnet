local traefik = (import 'traefik/traefik.libsonnet');
local traefikCrds = import 'traefik/crds.libsonnet';

traefik {
  // Use this to override the image
  _images+:: {
    traefik_image: 'traefik:2.4.2',
  },

  // Use this to override the config
  _config+:: {

    namespace: 'traefik',

    traefik+:: {
      // this name is used in two places
      // 1) Resource name, suffixed by '-traefik'
      // 2) value for the metadata.labels."app.kubernetes.io/instance"
      release_name: 'mylab',
      replicas: 1,
      accesslog: true,
      accesslog_format: 'json',
      entrypoints_port: 9000,
      entrypoints_web_port: 8000,
      entrypoints_websecure_port: 8443,
      // Use this to pass extra args to traefik. See https://doc.traefik.io/traefik/reference/static-configuration/cli/
      extraArgs: [
        '--metrics.prometheus=true',
        '--log.level=INFO',
        '--providers.kubernetescrd.allowCrossNamespace=true',
      ],
    },
  },

  local ingressroute = traefikCrds.ingressroute,
  local tlsoption = traefikCrds.tlsoption,
  local routes = ingressroute.spec.routes,
  local services = ingressroute.spec.routes.services,
  local clientAuth = tlsoption.spec.clientAuth,

  tlsoption:
    tlsoption.new('my-default-tls') +
    tlsoption.spec.withMinVersion('VersionTLS12') +
    tlsoption.spec.withSniStrict(true) +
    tlsoption.spec.withCipherSuitesMixin([
      'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',
      'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',
    ]) +
    tlsoption.spec.withClientAuth(
      clientAuth.new('NoClientCert'),
    ),

  ingressroute:
    ingressroute.new('my') +
    ingressroute.spec.withEntryPointsMixin('websecure') +
    ingressroute.spec.withRoutesMixin(
      routes.new('PathPrefix(`/api/push`) || PathPrefix(`/api/get`)') +
      routes.withKind('Rule') +
      routes.withPriority(30) +
      routes.withServicesMixin([
        services.new('test') +
        services.withNamespace($._config.namespace) +
        services.withPort(8080),
      ]),
    ) +
    ingressroute.spec.withTls('my-tls-secret') +
    ingressroute.spec.withTlsOptions('my-default-tls'),
}
