local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of ingressRouteTCP
  new(name): common.newResource('IngressRouteTCP', name),

  spec: common.spec {
    withEntryPoints(entryPoints): { spec+: { entryPoints: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    // **Note:** This function appends passed data to existing values
    withEntryPointsMixin(entryPoints): { spec+: { entryPoints+: if std.isArray(v=entryPoints) then entryPoints else [entryPoints] } },
    withRoutes(routes): { spec+: { routes: if std.isArray(v=routes) then routes else [routes] } },
    // **Note:** This function appends passed data to existing values
    withRoutesMixin(routes): { spec+: { routes+: if std.isArray(v=routes) then routes else [routes] } },
    routes: {
      new(match): {
        match: match,
      },
      withSyntax(syntax): { syntax: syntax },
      withPriority(priority): { priority: priority },
      withMiddlewares(middlewares): { middlewares: if std.isArray(v=middlewares) then middlewares else [middlewares] },
      // **Note:** This function appends passed data to existing values
      withMiddlewaresMixin(middlewares): { middlewares+: if std.isArray(v=middlewares) then middlewares else [middlewares] },
      middlewares: {
        new(name): {
          name: name,
        },
        withNamespace(namespace): { namespace: namespace },
      },
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
        withTerminationDelay(terminationDelay): { terminationDelay: terminationDelay },
        withProxyProtocol(proxyProtocol): { proxyProtocol: proxyProtocol },
        withNativeLB(nativeLB): { nativeLB: nativeLB },
        withNodePortLB(nodePortLB): { nodePortLB: nodePortLB },
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
      withPassthrough(passthrough): { tls+: { passthrough: passthrough } },
    },
    withTls(tls): { spec+: { tls: tls } },
    // **Note:** This function appends passed data to existing values
    withTlsMixin(tls): { spec+: { tls+: tls } },
    withTlsOptions(name, namespace=null): {
      spec+: {
        tls+: {
          options: if namespace == null then { name: name } else { name: name, namespace: namespace },
        },
      },
    },
    withTlsStore(name, namespace=null): {
      spec+: {
        tls+: {
          store: if namespace == null then { name: name } else { name: name, namespace: namespace },
        },
      },
    },
    withTlsPassthrough(passthrough): { spec+: { tls+: { passthrough: passthrough } } },
  },
}
