local config = import 'config.libsonnet';
local k = import 'ksonnet-util/kausal.libsonnet';

k + config {

  local boilerplateMetadata = {
    'app.kubernetes.io/name': 'otelcol-gateway',
    'app.kubernetes.io/instance': $._config.gateway_release_name,
  },

  local serviceAccount = $.core.v1.serviceAccount,

  gateway_serviceaccount:
    serviceAccount.new($._config.gateway_release_name) +
    serviceAccount.metadata.withLabelsMixin(boilerplateMetadata),

  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  // install ClusterRole and ClusterRoleBinding so OtelCol can be used across namespaces.
  gateway_clusterrole:
    clusterRole.new($._config.gateway_release_name) +
    clusterRole.metadata.withLabelsMixin(boilerplateMetadata),

  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,

  gateway_clusterrolebinding:
    clusterRoleBinding.new($._config.gateway_release_name)
    + clusterRoleBinding.metadata.withLabelsMixin(boilerplateMetadata)
    + clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io')
    + clusterRoleBinding.roleRef.withKind('ClusterRole')
    + clusterRoleBinding.roleRef.withName($._config.gateway_release_name)
    + clusterRoleBinding.withSubjectsMixin({
      kind: 'ServiceAccount',
      name: $._config.gateway_release_name,
      namespace: $._config.namespace,
    }),

  local configMap = $.core.v1.configMap,

  gateway_config_map:
    configMap.new($._config.gateway_release_name) +
    configMap.withData({
      'gateway.yml': $.util.manifestYaml($._config.gateway_config),
    }),
  local container = $.core.v1.container,

  gateway_container::
    container.new('gateway', $._images.otelcol) +
    container.withPortsMixin($.core.v1.containerPort.newNamed(8888, 'metrics')) +
    container.withArgsMixin('--config=/conf/gateway.yml') +
    container.withEnv([
      $.core.v1.envVar.fromFieldPath('KUBE_NODE_NAME', 'spec.nodeName'),
      $.core.v1.envVar.fromFieldPath('POD_NAME', 'metadata.name'),
    ]) +
    container.mixin.readinessProbe.httpGet.withPath('/') +
    container.mixin.readinessProbe.httpGet.withPort(13133) +
    container.mixin.readinessProbe.withInitialDelaySeconds(10) +
    container.mixin.readinessProbe.withTimeoutSeconds(1) +
    container.mixin.readinessProbe.httpGet.withPath('/') +
    container.mixin.readinessProbe.httpGet.withPort(13133) +
    container.mixin.readinessProbe.withInitialDelaySeconds(10) +
    container.mixin.readinessProbe.withTimeoutSeconds(1) +
    // currently configured to run as non-root
    container.securityContext.capabilities.withDrop('ALL') +
    container.securityContext.withRunAsNonRoot(true) +
    container.securityContext.withRunAsGroup(65532) +
    container.securityContext.withRunAsUser(65532),

  local deployment = $.apps.v1.deployment,

  gateway_deployment:
    deployment.new($._config.gateway_release_name, $._config.gateway_replicas, $.gateway_container, boilerplateMetadata)
    + deployment.metadata.withLabelsMixin(boilerplateMetadata)
    + deployment.spec.template.metadata.withLabelsMixin(boilerplateMetadata)
    + deployment.spec.template.metadata.withAnnotationsMixin($._config.gateway_annotations)
    + deployment.spec.template.spec.withHostNetwork(false)
    + deployment.spec.template.spec.withServiceAccount($._config.gateway_release_name)
    + deployment.spec.template.spec.withTerminationGracePeriodSeconds(60)
    + deployment.spec.strategy.rollingUpdate.withMaxSurge(1)
    + deployment.spec.strategy.rollingUpdate.withMaxUnavailable(1)
    + $.util.configMapVolumeMount($.gateway_config_map, '/conf')
    + deployment.spec.template.spec.affinity.podAntiAffinity.withPreferredDuringSchedulingIgnoredDuringExecution({
      weight: 100,
      podAffinityTerm: {
        labelSelector: {
          matchExpressions: [{
            key: 'name',
            operator: 'In',
            values: [
              $._config.gateway_release_name,
            ],
          }],
        },
        topologyKey: 'kubernetes.io/hostname',
      },
    }),

  local gateway_service = $.core.v1.service,

  gateway_service:
    gateway_service.new($._config.gateway_release_name,
                        boilerplateMetadata,
                        [
                          { name: 'metrics', port: 8888, targetPort: 'metrics' },
                          { name: 'otlp-grpc', port: 4317, targetPort: 'otlp-grpc' },
                          { name: 'otlp-http', port: 4318, targetPort: 'otlp-http' },
                        ]) +
    gateway_service.mixin.metadata.withLabelsMixin(boilerplateMetadata) +
    gateway_service.mixin.spec.withType('ClusterIP'),
}
