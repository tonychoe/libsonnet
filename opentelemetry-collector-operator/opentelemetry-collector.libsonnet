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

  new(name, config):
    {
      apiVersion: 'opentelemetry.io/v1alpha1',
      kind: 'OpenTelemetryCollector',
    } +
    self.spec.withConfig(config) +
    self.metadata.withName(name) +
    self.metadata.withLabelsMixin({
      'app.kubernetes.io/name': name,
      'app.kubernetes.io/instance': 'opentelemetry-collector',
    }),
  spec: {
    // +required Config is the raw JSON to be used as the collector's configuration. Refer to the OpenTelemetry Collector documentation for details.
    withConfig(config): { spec+: { config+: config } },
    // +optional Mode represents how the collector should be deployed (deployment, daemonset, statefulset or sidecar)
    withMode(mode): { spec+: { mode+: mode } },
    // +optional Args is the set of arguments to pass to the OpenTelemetry Collector binary.
    withArgs(args): { spec+: { args+: args } },
    // +optional Replicas is the number of pod instances for the underlying OpenTelemetry Collector
    withReplicas(replicas): { spec+: { replicas+: replicas } },
    // +optional Image indicates the container image to use for the OpenTelemetry Collector.
    withImage(image): { spec+: { image+: image } },
    // +optional ServiceAccount indicates the name of an existing service account to use with this instance.
    withServiceAccount(serviceaccount): { spec+: { serviceAccount+: serviceaccount } },
    // +optional VolumeClaimTemplates will provide stable storage using PersistentVolumes. Only available when the mode=statefulset.
    withVolumeClaimTemplates(volumeclaimtemplates): { spec+: { volumeClaimTemplates: if std.isArray(v=volumeclaimtemplates) then volumeclaimtemplates else [volumeclaimtemplates] } },
    // +optional VolumeClaimTemplates will provide stable storage using PersistentVolumes. Only available when the mode=statefulset.
    // **Note:** This function appends passed data to existing values
    withVolumeClaimTemplatesMixin(volumeclaimtemplates): { spec+: { volumeClaimTemplates+: if std.isArray(v=volumeclaimtemplates) then volumeclaimtemplates else [volumeclaimtemplates] } },
    // +optional VolumeMounts represents the mount points to use in the underlying collector deployment(s)
    withVolumeMounts(volumemounts): { spec+: { volumeMounts: if std.isArray(v=volumemounts) then volumemounts else [volumemounts] } },
    // +optional VolumeMounts represents the mount points to use in the underlying collector deployment(s)
    // **Note:** This function appends passed data to existing values
    withVolumeMountsMixin(volumemounts): { spec+: { volumeMounts+: if std.isArray(v=volumemounts) then volumemounts else [volumemounts] } },
    // +optional Volumes represents which volumes to use in the underlying collector deployment(s).
    withVolumes(volumes): { spec+: { volumes: if std.isArray(v=volumes) then volumes else [volumes] } },
    // +optional Volumes represents which volumes to use in the underlying collector deployment(s).
    // **Note:** This function appends passed data to existing values
    withVolumesMixin(volumes): { spec+: { volumes+: if std.isArray(v=volumes) then volumes else [volumes] } },
    // +optional Ports allows a set of ports to be exposed by the underlying v1.Service. By default, the operator
    // will attempt to infer the required ports by parsing the .Spec.Config property but this property can be
    // used to open aditional ports that can't be inferred by the operator, like for custom receivers.
    withPorts(ports): { spec+: { ports: if std.isArray(v=ports) then ports else [ports] } },
    // +optional Ports allows a set of ports to be exposed by the underlying v1.Service. By default, the operator
    // will attempt to infer the required ports by parsing the .Spec.Config property but this property can be
    // used to open aditional ports that can't be inferred by the operator, like for custom receivers.
    // **Note:** This function appends passed data to existing values
    withPortsMixin(ports): { spec+: { ports+: if std.isArray(v=ports) then ports else [ports] } },
    // +optional ENV vars to set on the OpenTelemetry Collector's Pods. These can then in certain cases be
    // consumed in the config file for the Collector.
    withEnv(env): { spec+: { env: if std.isArray(v=env) then env else [env] } },
    // +optional ENV vars to set on the OpenTelemetry Collector's Pods. These can then in certain cases be
    // consumed in the config file for the Collector.
    // **Note:** This function appends passed data to existing values
    withEnvMixin(env): { spec+: { env+: if std.isArray(v=env) then env else [env] } },
    // +optional Resources to set on the OpenTelemetry Collector pods.
    withResources(resources): { spec+: { resources+: resources } },
    // +optional SecurityContext will be set as the container security context.
    withSecurityContext(securitycontext): { spec+: { securityContext+: securitycontext } },
    // +optional Toleration to schedule OpenTelemetry Collector pods.
    // This is only relevant to daemonsets, statefulsets and deployments
    withTolerations(tolerations): { spec+: { tolerations: if std.isArray(v=tolerations) then tolerations else [tolerations] } },
    // +optional Toleration to schedule OpenTelemetry Collector pods.
    // This is only relevant to daemonsets, statefulsets and deployments
    // **Note:** This function appends passed data to existing values
    withTolerationsMixin(tolerations): { spec+: { tolerations+: if std.isArray(v=tolerations) then tolerations else [tolerations] } },
  },
}
