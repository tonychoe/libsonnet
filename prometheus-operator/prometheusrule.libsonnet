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

  // https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md
  // New returns an instance of PrometheusRule
  new(name):
    {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'PrometheusRule',
    }
    + self.metadata.withName(name)
    + self.metadata.withLabelsMixin({
      'app.kubernetes.io/name': name,
      'app.kubernetes.io/instance': name + '-recording-rule',
    }),
  spec: {
    withGroups(groups): { spec+: { groups: groups } },
    withGroupsWithoutKey(groups): { spec+: groups },
  },
}
