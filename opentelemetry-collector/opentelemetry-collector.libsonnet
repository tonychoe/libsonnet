{
  new(name, mode, replicas, config): {
    apiVersion: 'opentelemetry.io/v1alpha1',
    kind: 'OpenTelemetryCollector',
    metadata: {
      name: name,
    },
    spec: {
      mode: mode,
      replicas: replicas,
      config: config,
    },
  },
}
