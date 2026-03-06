{
  metadata: {
    // Map of string keys and values that can be used to organize and categorize (scope and select) objects.
    withLabels(labels): { metadata+: { labels: labels } },
    // **Note:** This function appends passed data to existing values
    withLabelsMixin(labels): { metadata+: { labels+: labels } },
    // Name must be unique within a namespace.
    withName(name): { metadata+: { name: name } },
  },

  defaultLabels(name): {
    'app.kubernetes.io/name': 'traefik',
    'app.kubernetes.io/instance': name,
  },

  newResource(kind, name): {
                             apiVersion: 'traefik.io/v1alpha1',
                             kind: kind,
                           } + self.metadata.withName(name=name) +
                           self.metadata.withLabelsMixin(self.defaultLabels(name)),

  spec: {
    withSpec(spec): { spec: spec },
    // **Note:** This function appends passed data to existing values
    withSpecMixin(spec): { spec+: spec },
  },
}
