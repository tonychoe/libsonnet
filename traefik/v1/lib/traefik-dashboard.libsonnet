local ingressroute = (import 'ingressroute.libsonnet');

{
  local routes = ingressroute.spec.routes,
  local services = ingressroute.spec.routes.services,

  traefik_ingressroute:
    ingressroute.new($._config.traefik.release_name + '-dashboard') +
    ingressroute.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik.release_name,
    }) +
    ingressroute.spec.withEntryPointsMixin('traefik') +
    ingressroute.spec.withRoutesMixin(
      routes.new("PathPrefix(`/dashboard`) || PathPrefix(`/api`)") +
      routes.withKind('Rule') +
      routes.withServicesMixin([
        services.new('api@internal') +
        services.withKind('TraefikService'),
      ]) 
    ),
}
