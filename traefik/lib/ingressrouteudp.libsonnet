{
  metadata: {
    withLabels(labels): { metadata+: { labels: labels } },
    // **Note:** This function appends passed data to existing values
    withLabelsMixin(labels): { metadata+: { labels+: labels } },
    withName(name): { metadata+: { name: name } },
  },

  // New returns an instance of ingressRouteUDP
  new(name): {
               apiVersion: 'traefik.io/v1alpha1',
               kind: 'IngressRouteUDP',
             } + self.metadata.withName(name=name) +
             self.metadata.withLabelsMixin({
               'app.kubernetes.io/name': 'traefik',
               'app.kubernetes.io/instance': name,
             }),
  spec: {
    withSpec(spec): { spec: spec },
    // **Note:** This function appends passed data to existing values
    withSpecMixin(spec): { spec+: spec },
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
