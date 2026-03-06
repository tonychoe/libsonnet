local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of ingressRouteUDP
  new(name): common.newResource('IngressRouteUDP', name),

  spec: common.spec {
    withEntryPoints(entryPoints): { spec+: { entryPoints: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    // **Note:** This function appends passed data to existing values
    withEntryPointsMixin(entryPoints): { spec+: { entryPoints+: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    withRoutes(routes): { spec+: { routes: if std.isArray(v=routes) then routes else [routes] } },
    // **Note:** This function appends passed data to existing values
    withRoutesMixin(routes): { spec+: { routes+: if std.isArray(v=routes) then routes else [routes] } },
    routes: {
      new(): {},
      withServices(services): { services: if std.isArray(v=services) then services else [services] },
      // **Note:** This function appends passed data to existing values
      withServicesMixin(services): { services+: if std.isArray(v=services) then services else [services] },
      services: {
        new(name): {
          name: name,
        },
        withNamespace(namespace): { namespace: namespace },
        withPort(port): { port: port },
        withWeight(weight): { weight: weight },
        withNativeLB(nativeLB): { nativeLB: nativeLB },
        withNodePortLB(nodePortLB): { nodePortLB: nodePortLB },
      },
    },
  },
}
