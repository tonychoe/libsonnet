{
  // Endpoint defines a scrapeable endpoint serving Prometheus metrics.
  // More info: https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#endpoint

  // New returns an instance of endpoint
  new(): {
  },
  // Name of the service port this endpoint refers to. Mutually exclusive with targetPort.
  withPort(port): { port: port },
  // Name or number of the target port of the Pod behind the Service, the port must be specified with container port property. Mutually exclusive with port.
  withTargetPort(targetPort): { targetPort: targetPort },
  // HTTP path to scrape for metrics.
  withPath(path): { path: path },
  // HTTP scheme to use for scraping.
  withScheme(scheme): { scheme: scheme },
  // Optional HTTP URL parameters
  withParams(params): { params: if std.isArray(v=params) then params else [params] },
  // Optional HTTP URL parameters
  // **Note:** This function appends passed data to existing values
  withParamsMixin(params): { params+: if std.isArray(v=params) then params else [params] },
  // Interval at which metrics should be scraped
  withInterval(interval): { interval: interval },
  // Timeout after which the scrape is ended
  withScrapeTimeout(scrapeTimeout): { scrapeTimeout: scrapeTimeout },
  // TLS configuration to use when scraping the endpoint
  withTlsConfig(tlsConfig): { tlsConfig: tlsConfig },
  // File to read bearer token for scraping targets.
  withBearerTokenFile(bearerTokenFile): { bearerTokenFile: bearerTokenFile },
  // Secret to mount to read bearer token for scraping targets. The secret needs to be in the same namespace as the service monitor and accessible by the Prometheus Operator.
  withBearerTokenSecret(bearerTokenSecret): { bearerTokenSecret: bearerTokenSecret },
  // HonorLabels chooses the metric's labels on collisions with target labels.
  withHonorLabels(honorLabels): { honorLabels: honorLabels },
  // HonorTimestamps controls whether Prometheus respects the timestamps present in scraped data.
  withHonorTimestamps(honorTimestamps): { honorTimestamps: honorTimestamps },
  // BasicAuth allow an endpoint to authenticate over basic authentication
  // More info: https://prometheus.io/docs/operating/configuration/#endpoints
  withBasicAuth(basicAuth): { basicAuth: basicAuth },
  // OAuth2 for the URL. Only valid in Prometheus versions 2.27.0 and newer.
  withOauth2(oauth2): { oauth2: oauth2 },
  //  Authorization section for this endpoint
  withAuthorization(authorization): { authorization: authorization },
  // MetricRelabelConfigs to apply to samples before ingestion.
  withMetricRelabelings(metricRelabelings): { metricRelabelings: if std.isArray(v=metricRelabelings) then metricRelabelings else [metricRelabelings] },
  // MetricRelabelConfigs to apply to samples before ingestion.
  // **Note:** This function appends passed data to existing values
  withMetricRelabelingsMixin(metricRelabelings): { metricRelabelings+: if std.isArray(v=metricRelabelings) then metricRelabelings else [metricRelabelings] },
  // RelabelConfigs to apply to samples before scraping.
  // More info: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
  withRelabelings(relabelings): { relabelings: if std.isArray(v=relabelings) then relabelings else [relabelings] },
  // RelabelConfigs to apply to samples before scraping.
  // More info: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
  // **Note:** This function appends passed data to existing values
  withRelabelingsMixin(relabelings): { relabelings+: if std.isArray(v=relabelings) then relabelings else [relabelings] },
  // ProxyURL eg http://proxyserver:2195 Directs scrapes to proxy through this endpoint.
  withProxyUrl(proxyUrl): { proxyUrl: proxyUrl },
  // FollowRedirects configures whether scrape requests follow HTTP 3xx redirects.
  withFollowRedirects(followRedirects): { followRedirects: followRedirects },
}
