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

/*
  endpoints: {
    # A list of endpoints allowed as part of this ServiceMonitor.
    withEndpoints( endpoints ): { spec+: { endpoints: if std.isArray(v=endpoints) then endpoints else [endpoints] } },
    # Selector to select Endpoints objects.
    withSelector( selector ): { spec+: { selector: selector } },
  },
*/

  # A label selector is a label query over a set of resources. The result of matchLabels and matchExpressions are ANDed. An empty label selector matches all objects. A null label selector matches no objects.
  labelSelector: {
    # matchExpressions is a list of label selector requirements. The requirements are ANDed.
    withMatchExpressions(matchExpressions): { selector+: { matchExpressions: if std.isArray(v=matchExpressions) then matchExpressions else [matchExpressions] } },
    # matchExpressions is a list of label selector requirements. The requirements are ANDed.
    # **Note:** This function appends passed data to existing values
    withMatchExpressionsMixin(matchExpressions): { selector+: { matchExpressions+: if std.isArray(v=matchExpressions) then matchExpressions else [matchExpressions] } },
    # matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.
    withMatchLabels(matchLabels): { selector+: { matchLabels: matchLabels } },
    # matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.
    # **Note:** This function appends passed data to existing values
    withMatchLabelsMixin(matchLabels): { selector+: { matchLabels+: matchLabels } },
  },

  # New returns an instance of serviceMonitor
  new( name, endpoints, selector ): {
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'ServiceMonitor',
  }  
  + self.spec.withEndpoints( endpoints )
  + self.spec.withSelector( selector )
  + self.metadata.withName( name )
  + self.metadata.withLabelsMixin({
    'app.kubernetes.io/name': name,
    'app.kubernetes.io/instance': servicemonitor,
  }),
  spec: {
    ###
    # ServiceMonitorSpec contains specification parameters for a ServiceMonitor.
    ###
    # The label to use to retrieve the job name from.
    withJobLabel( jobLabel ): { spec+: { jobLabel: jobLabel } },
    # TargetLabels transfers labels on the Kubernetes Service onto the target.
    withTargetLabels( targetLabels ): { spec+: { targetLabels: if std.isArray(v=targetLabels) then targetLabels else [targetLabels] } },
    # TargetLabels transfers labels on the Kubernetes Service onto the target.
    # **Note:** This function appends passed data to existing values
    withTargetLabelsMixin( targetLabels ): { spec+: { targetLabels+: if std.isArray(v=targetLabels) then targetLabels else [targetLabels] } },
    # PodTargetLabels transfers labels on the Kubernetes Pod onto the target.
    withPodTargetLabels( podTargetLabels ): { spec+: { podTargetLabels: if std.isArray(v=podTargetLabels) then podTargetLabels else [podTargetLabels] } },
    # PodTargetLabels transfers labels on the Kubernetes Pod onto the target.
    # **Note:** This function appends passed data to existing values
    withPodTargetLabelsMixin( podTargetLabels ): { spec+: { podTargetLabels+: if std.isArray(v=podTargetLabels) then podTargetLabels else [podTargetLabels] } },
    # A list of endpoints allowed as part of this ServiceMonitor.
    withEndpoints( endpoints ): { spec+: { endpoints: if std.isArray(v=endpoints) then endpoints else [endpoints] } },
    # Selector to select Endpoints objects.
    withSelector( selector ): { spec+: selector },
    # A list of endpoints allowed as part of this ServiceMonitor.
    # { endpoints: if std.isArray(v=endpoints) then endpoints else [endpoints] },
    # A list of endpoints allowed as part of this ServiceMonitor.
    # **Note:** This function appends passed data to existing values
    # withEndpointsMixin( endpoints ): { spec+: { endpoints+: if std.isArray(v=endpoints) then endpoints else [endpoints] } },
    # { selector: selector },
    # Selector to select which namespaces the Endpoints objects are discovered from.
    withNamespaceSelector( namespaceSelector ): { spec+: { namespaceSelector: namespaceSelector } },
    # SampleLimit defines per-scrape limit on number of scraped samples that will be accepted.
    withSampleLimit( sampleLimit ): { spec+: { sampleLimit: sampleLimit } },
    # TargetLimit defines a limit on the number of scraped targets that will be accepted.
    withTargetLimit( targetLimit ): { spec+: { targetLimit: targetLimit } },
  },
}
