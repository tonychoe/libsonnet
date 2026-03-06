{
  metadata: {
    withLabels(labels): { metadata+: { labels: labels } },
    // **Note:** This function appends passed data to existing values
    withLabelsMixin(labels): { metadata+: { labels+: labels } },
    withName(name): { metadata+: { name: name } },
  },

  // New returns an instance of traefikService
  new(name): {
               apiVersion: 'traefik.io/v1alpha1',
               kind: 'TraefikService',
             } + self.metadata.withName(name=name) +
             self.metadata.withLabelsMixin({
               'app.kubernetes.io/name': 'traefik',
               'app.kubernetes.io/instance': name,
             }),
  spec: {
    withSpec(spec): { spec: spec },
    // **Note:** This function appends passed data to existing values
    withSpecMixin(spec): { spec+: spec },
  },
}
