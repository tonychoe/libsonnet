local crds = import '../crds.libsonnet';

{
  ingressroute:
    crds.ingressroute.new('web') +
    crds.ingressroute.spec.withEntryPoints('websecure') +
    crds.ingressroute.spec.withRoutes(
      crds.ingressroute.spec.routes.new('Host(`example.com`)') +
      crds.ingressroute.spec.routes.withKind('Rule') +
      crds.ingressroute.spec.routes.withServicesMixin(
        crds.ingressroute.spec.routes.services.new('web-svc') +
        crds.ingressroute.spec.routes.services.withPort(8080)
      )
    ) +
    crds.ingressroute.spec.withTls('wildcard-cert') +
    crds.ingressroute.spec.withTlsOptions('strict-tls'),

  ingressroutetcp:
    crds.ingressroutetcp.new('tcp') +
    crds.ingressroutetcp.spec.withEntryPoints('tcp') +
    crds.ingressroutetcp.spec.withRoutes(
      crds.ingressroutetcp.spec.routes.new('HostSNI(`example.com`)') +
      crds.ingressroutetcp.spec.routes.withServices(
        crds.ingressroutetcp.spec.routes.services.new('tcp-svc') +
        crds.ingressroutetcp.spec.routes.services.withPort(9000)
      )
    ),

  ingressrouteudp:
    crds.ingressrouteudp.new('udp') +
    crds.ingressrouteudp.spec.withEntryPoints('dns') +
    crds.ingressrouteudp.spec.withRoutes(
      crds.ingressrouteudp.spec.routes.new() +
      crds.ingressrouteudp.spec.routes.withServices(
        crds.ingressrouteudp.spec.routes.services.new('udp-svc') +
        crds.ingressrouteudp.spec.routes.services.withPort(53)
      )
    ),

  middleware:
    crds.middleware.new('headers') +
    crds.middleware.spec.withSpecMixin({
      headers: { stsSeconds: 31536000 },
    }),

  middlewaretcp:
    crds.middlewaretcp.new('allowlist') +
    crds.middlewaretcp.spec.withSpecMixin({
      ipAllowList: { sourceRange: ['10.0.0.0/8'] },
    }),

  serverstransport:
    crds.serverstransport.new('backend-transport') +
    crds.serverstransport.spec.withSpecMixin({
      insecureSkipVerify: true,
    }),

  serverstransporttcp:
    crds.serverstransporttcp.new('backend-transport-tcp') +
    crds.serverstransporttcp.spec.withSpecMixin({
      dialTimeout: '30s',
    }),

  tlsoption:
    crds.tlsoption.new('strict-tls') +
    crds.tlsoption.spec.withSniStrict(true) +
    crds.tlsoption.spec.withMinVersion('VersionTLS13') +
    crds.tlsoption.spec.withDisableSessionTickets(true),

  tlsstore:
    crds.tlsstore.new('default') +
    crds.tlsstore.spec.withDefaultCertificateSecretName('wildcard-cert'),

  traefikservice:
    crds.traefikservice.new('weighted') +
    crds.traefikservice.spec.withSpecMixin({
      weighted: {
        services: [
          { name: 'svc-a', port: 80, weight: 1 },
          { name: 'svc-b', port: 80, weight: 2 },
        ],
      },
    }),

  secure_defaults:
    crds.presets.secureDefaults.strict('wildcard-cert'),
}
