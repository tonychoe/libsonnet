local ingressroute = import 'ingressroute/ingressroute.jsonnet';
local route = ingressroute.spec.route;
local service = ingressroute.spec.route.service;

{
  traefik_ingressroute:
    ingressroute.new('example') +
    ingressroute.metadata.withLabelsMixin({  
      'app.kubernetes.io/name': 'example',
    }) +
    ingressroute.spec.withEntryPointsMixins('websecure') +
    ingressroute.spec.withRoutesMixins(
      route.new("PathPrefix(`/hotrod`) || PathPrefix(`/demo`)") +
      route.withKind('Rule') +
      route.withServicesMixins([
        service.new('hotrod') + 
        service.withPort(8080),
      ])
    ) +
    ingressroute.spec.withRoutesMixins({
      match: "PathPrefix(`/hotrod`) || PathPrefix(`/demo`)",
      kind: 'Rule',
      services: [{
        name: 'hotrod',
        port: 8080,
      }],
    }) 
}
