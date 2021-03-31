{
  metadata: {
    # Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
    withLabels(labels): { metadata+: { labels: labels } },
    # Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
    # **Note:** This function appends passed data to existing values
    withLabelsMixin(labels): { metadata+: { labels+: labels } },
    # Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
    withName(name): { metadata+: { name: name } },
  },

  # New returns an instance of ingressRoute
  # More info: https://doc.traefik.io/traefik/reference/dynamic-configuration/kubernetes-crd/
  new(name): {
    apiVersion: 'traefik.containo.us/v1alpha1',
    kind: 'IngressRoute',
  } + self.metadata.withName(name=name) +
  self.metadata.withLabelsMixin({
    'app.kubernetes.io/name': 'traefik',
    'app.kubernetes.io/instance': name,
  }),
  spec: {
    # Port that is used as the traffic entry point.  
    withEntryPoints(entryPoints): { spec+: { entryPoints: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    # Port that is used as the traffic entry point.  
    # **Note:** This function appends passed data to existing values
    withEntryPointsMixin(entryPoints): { spec+: { entryPoints+: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    # Maps the incoming requests to the services that can handle them. 
    withRoutes(routes): { spec+: { routes: if std.isArray(v=routes) then routes else [routes] } },
    # Maps the incoming requests to the services that can handle them. 
    # **Note:** This function appends passed data to existing values
    withRoutesMixin(routes): { spec+: { routes+: if std.isArray(v=routes) then routes else [routes] } },
    routes: {
      # Returns a new route
      new(match): {
        match: match,
      },
      withKind(kind): { kind: kind },
      withPriority(priority): { priority: priority },
      withServicesMixin(services): { services+: if std.isArray(v=services) then services else [services] },
      services: {
        # Returns a new service
        new(name): {
          name: name,
        },
        withKind(kind): { kind: kind },
        withNamespace(namespace): { namespace: namespace },
        withPort(port): { port: port },
        withStrategy(strategy): { strategy: strategy },
        withServersTransport(serversTransport): { serversTransport: serversTransport },
      }
    }
  }
}
