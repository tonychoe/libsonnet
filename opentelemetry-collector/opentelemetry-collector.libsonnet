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

  new(name, mode, replicas, config):
    {
      apiVersion: 'opentelemetry.io/v1alpha1',
      kind: 'OpenTelemetryCollector',
    } +
    self.spec.withMode(mode) +
    self.spec.withConfig(config) +
    self.spec.withReplicas(mode, replicas) +
    self.metadata.withName(name) +
    self.metadata.withLabelsMixin({
      'app.kubernetes.io/name': name,
      'app.kubernetes.io/instance': 'opentelemetry-collector-' + mode,
    }),
  spec: {
    withMode(mode): { spec+: { mode+: mode } },
    withConfig(config): { spec+: { config+: config } },
    withReplicas(mode, replicas): if mode == 'deployment' then { spec+: { replicas+: replicas } } else {},
  },
}
