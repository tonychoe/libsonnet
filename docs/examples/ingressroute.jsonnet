local ingressroute = ( import 'traefik-ingressroute/v1/ingressroute.libsonnet' );

{
  local routes = ingressroute.spec.routes,
  local services = ingressroute.spec.routes.services,
  local release_name = 'my-ingressroute',

  my_ingressroute:
    ingressroute.new(release_name) +
    ingressroute.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': release_name,
    }) +
    ingressroute.spec.withEntryPointsMixin('websecure') +
    ingressroute.spec.withRoutesMixin(
      routes.new("Host(`my.cloud.com`) && PathPrefix(`/prometheus`)" ) +
      routes.withKind('Rule') +
      routes.withServicesMixin([
        services.new('promkube-prometheus') + 
        services.withNamespace('promkube') + 
        services.withPort(9090),
      ]) 
    ) +
    ingressroute.spec.withRoutesMixin(
      routes.new("Host(`my.cloud.com`) && PathPrefix(`/jaeger`)") +
      routes.withKind('Rule') +
      routes.withServicesMixin([
        services.new('jaegertracing-query') + 
        services.withNamespace('default') + 
        services.withPort(80),
      ])
    ) +
}
