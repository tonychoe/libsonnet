local config = import 'config.libsonnet';
local k = import 'ksonnet-util/kausal.libsonnet';

k + config {

  local boilerplateMetadata = {
    'app.kubernetes.io/name': 'otelcol-agent',
    'app.kubernetes.io/instance': $._config.agent_release_name,
  },

  local serviceAccount = $.core.v1.serviceAccount,

  agent_serviceaccount:
    serviceAccount.new($._config.agent_release_name) +
    serviceAccount.metadata.withLabelsMixin(boilerplateMetadata),

  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  // install ClusterRole and ClusterRoleBinding so OtelCol can be used across namespaces.
  agent_clusterrole:
    clusterRole.new($._config.agent_release_name) +
    clusterRole.metadata.withLabelsMixin(boilerplateMetadata) +
    clusterRole.withRulesMixin([
      policyRule.withApiGroups('') +
      policyRule.withResources(['pods']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
    ]),

  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,

  agent_clusterrolebinding:
    clusterRoleBinding.new($._config.agent_release_name)
    + clusterRoleBinding.metadata.withLabelsMixin(boilerplateMetadata)
    + clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io')
    + clusterRoleBinding.roleRef.withKind('ClusterRole')
    + clusterRoleBinding.roleRef.withName($._config.agent_release_name)
    + clusterRoleBinding.withSubjectsMixin({
      kind: 'ServiceAccount',
      name: $._config.agent_release_name,
      namespace: $._config.namespace,
    }),

  local configMap = $.core.v1.configMap,

  agent_config_map:
    configMap.new($._config.agent_release_name) +
    configMap.withData({
      'agent.yml': $.util.manifestYaml($._config.agent_config),
    }),

  local container = $.core.v1.container,

  agent_container::
    container.new('agent', $._images.otelcol) +
    container.withPortsMixin($.core.v1.containerPort.newNamed(4317, 'otlp-grpc') + $.core.v1.containerPort.withHostPort(4317)) +
    container.withPortsMixin($.core.v1.containerPort.newNamed(4318, 'otlp-http') + $.core.v1.containerPort.withHostPort(4318)) +
    container.withPortsMixin($.core.v1.containerPort.newNamedUDP(6831, 'jaeger-compact') + $.core.v1.containerPort.withHostPort(6831)) +
    container.withPortsMixin($.core.v1.containerPort.newNamed(5778, 'jaeger-sampling') + $.core.v1.containerPort.withHostPort(5778)) +
    container.withPortsMixin($.core.v1.containerPort.newNamed(8888, 'metrics')) +
    container.withArgsMixin('--config=/conf/agent.yml') +
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

  /* in future, if otelcol should collect logs, then need to run as root
    container.mixin.securityContext.withRunAsUser(0) +
    container.securityContext.withReadOnlyRootFilesystem(true) +
  */

  local daemonSet = $.apps.v1.daemonSet,

  agent_daemonset:
    daemonSet.new($._config.agent_release_name, [$.agent_container]) +
    daemonSet.metadata.withLabelsMixin(boilerplateMetadata) +
    daemonSet.spec.template.metadata.withLabelsMixin(boilerplateMetadata) +
    daemonSet.spec.template.metadata.withAnnotationsMixin($._config.agent_annotations) +
    daemonSet.mixin.spec.template.spec.withServiceAccount($._config.agent_release_name) +
    $.util.configMapVolumeMount($.agent_config_map, '/conf'),

  /* in future, if otelcol should collect logs,
    $.util.hostVolumeMount('varlog', '/var/log', '/var/log') +
    $.util.hostVolumeMount('varlibdockercontainers', $._config.agent.container_root_path + '/containers', $._config.agent_config.container_root_path + '/containers', readOnly=true)
  */

  local agent_service = $.core.v1.service,

  agent_service:
    agent_service.new($._config.agent_release_name,
                      boilerplateMetadata,
                      [
                        { name: 'otlp-grpc', port: 4317, targetPort: 'otlp-grpc' },
                        { name: 'otlp-http', port: 4318, targetPort: 'otlp-http' },
                        { name: 'jaeger-compact', port: 6831, targetPort: 'jaeger-compact' },
                        { name: 'jaeger-sampling', port: 5778, targetPort: 'jaeger-sampling' },
                      ]) +
    agent_service.mixin.metadata.withLabelsMixin(boilerplateMetadata) +
    agent_service.mixin.spec.withType('ClusterIP'),
}
