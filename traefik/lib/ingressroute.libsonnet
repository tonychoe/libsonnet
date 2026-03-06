{
  metadata: {
    // Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
    withLabels(labels): { metadata+: { labels: labels } },
    // Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
    // **Note:** This function appends passed data to existing values
    withLabelsMixin(labels): { metadata+: { labels+: labels } },
    // Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
    withName(name): { metadata+: { name: name } },
  },

  // New returns an instance of ingressRoute
  // More info: https://doc.traefik.io/traefik/reference/dynamic-configuration/kubernetes-crd/
  new(name): {
               apiVersion: 'traefik.io/v1alpha1',
               kind: 'IngressRoute',
             } + self.metadata.withName(name=name) +
             self.metadata.withLabelsMixin({
               'app.kubernetes.io/name': 'traefik',
               'app.kubernetes.io/instance': name,
             }),
  spec: {
    // Port that is used as the traffic entry point.
    withEntryPoints(entryPoints): { spec+: { entryPoints: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    // Port that is used as the traffic entry point.
    // **Note:** This function appends passed data to existing values
    withEntryPointsMixin(entryPoints): { spec+: { entryPoints+: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    // ParentRefs defines references to parent IngressRoute resources for multi-layer routing.
    withParentRefs(parentRefs): { spec+: { parentRefs: if std.isArray(v=parentRefs) then parentRefs else [parentRefs] } },
    // ParentRefs defines references to parent IngressRoute resources for multi-layer routing.
    // **Note:** This function appends passed data to existing values
    withParentRefsMixin(parentRefs): { spec+: { parentRefs+: if std.isArray(v=parentRefs) then parentRefs else [parentRefs] } },
    parentRefs: {
      // Returns a new parent ref
      new(name): {
        name: name,
      },
      withNamespace(namespace): { namespace: namespace },
    },
    // Maps the incoming requests to the services that can handle them.
    withRoutes(routes): { spec+: { routes: if std.isArray(v=routes) then routes else [routes] } },
    // Maps the incoming requests to the services that can handle them.
    // **Note:** This function appends passed data to existing values
    withRoutesMixin(routes): { spec+: { routes+: if std.isArray(v=routes) then routes else [routes] } },
    routes: {
      // Returns a new route
      new(match): {
        match: match,
      },
      withKind(kind): { kind: kind },
      withSyntax(syntax): { syntax: syntax },
      withPriority(priority): { priority: priority },
      withMiddlewares(middlewares): { middlewares: if std.isArray(v=middlewares) then middlewares else [middlewares] },
      withMiddlewaresMixin(middlewares): { middlewares+: if std.isArray(v=middlewares) then middlewares else [middlewares] },
      middlewares: {
        // Returns a new middleware reference
        new(name): {
          name: name,
        },
        withNamespace(namespace): { namespace: namespace },
      },
      withObservability(observability): { observability: observability },
      withObservabilityMixin(observability): { observability+: observability },
      observability: {
        withAccessLogs(accessLogs): { accessLogs: accessLogs },
        withMetrics(metrics): { metrics: metrics },
        withTracing(tracing): { tracing: tracing },
        withTraceVerbosity(traceVerbosity): { traceVerbosity: traceVerbosity },
      },
      withServicesMixin(services): { services+: if std.isArray(v=services) then services else [services] },
      services: {
        // Returns a new service
        new(name): {
          name: name,
        },
        withKind(kind): { kind: kind },
        withNamespace(namespace): { namespace: namespace },
        withPort(port): { port: port },
        withStrategy(strategy): { strategy: strategy },
        withScheme(scheme): { scheme: scheme },
        withServersTransport(serversTransport): { serversTransport: serversTransport },
        withNativeLB(nativeLB): { nativeLB: nativeLB },
        withNodePortLB(nodePortLB): { nodePortLB: nodePortLB },
        withPassHostHeader(passHostHeader): { passHostHeader: passHostHeader },
        withResponseForwarding(responseForwarding): { responseForwarding: responseForwarding },
        withSticky(sticky): { sticky: sticky },
        withHealthCheck(healthCheck): { healthCheck: healthCheck },
      },
    },
    tls: {
      withSecretName(secretName): { tls+: { secretName: secretName } },
      withOptions(options): { tls+: { options: options } },
      options: {
        new(name): {
          name: name,
        },
        withNamespace(namespace): { namespace: namespace },
      },
      withStore(store): { tls+: { store: store } },
      store: {
        new(name): {
          name: name,
        },
        withNamespace(namespace): { namespace: namespace },
      },
      withDomains(domains): { tls+: { domains: if std.isArray(v=domains) then domains else [domains] } },
      // **Note:** This function appends passed data to existing values
      withDomainsMixin(domains): { tls+: { domains+: if std.isArray(v=domains) then domains else [domains] } },
      domains: {
        new(main): {
          main: main,
        },
        withSans(sans): { sans: if std.isArray(v=sans) then sans else [sans] },
        withSansMixin(sans): { sans+: if std.isArray(v=sans) then sans else [sans] },
      },
      withCertResolver(certResolver): { tls+: { certResolver: certResolver } },
    },
    withTls(secretName): { spec+: { tls+: { secretName: secretName } } },
    // **Note:** This function appends passed data to existing values
    withTlsMixin(tls): { spec+: { tls+: tls } },
    withTlsCertResolver(certResolver): { spec+: { tls+: { certResolver: certResolver } } },
    withTlsStore(name, namespace=null): {
      spec+: {
        tls+: {
          store: if namespace == null then { name: name } else { name: name, namespace: namespace },
        },
      },
    },
    withTlsDomains(domains): { spec+: { tls+: { domains: if std.isArray(v=domains) then domains else [domains] } } },
    // **Note:** This function appends passed data to existing values
    withTlsDomainsMixin(domains): { spec+: { tls+: { domains+: if std.isArray(v=domains) then domains else [domains] } } },
    withTlsOptions(name, namespace=null): {
      spec+: {
        tls+: {
          options: if namespace == null then { name: name } else { name: name, namespace: namespace },
        },
      },
    },
  },
}
