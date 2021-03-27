local k = import 'ksonnet-util/kausal.libsonnet';

k {

  # Installs ServiceAccount
  local serviceAccount = $.core.v1.serviceAccount,

  external_dns_serviceaccount:
    serviceAccount.new($._config.external_dns.release_name + '-external-dns') +
    serviceAccount.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'external-dns',
      'app.kubernetes.io/instance': $._config.external_dns.release_name,
    }),

  # installs ClusterRole and ClusterRoleBinding so external-dns can be used across namespaces.
  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  external_dns_clusterrole:
    clusterRole.new($._config.external_dns.release_name + '-external-dns') +
    clusterRole.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'external-dns',
      'app.kubernetes.io/instance': $._config.external_dns.release_name,
    }) +
    clusterRole.withRulesMixin([
      policyRule.withApiGroups('') +
      policyRule.withResources(['services','endpoints','pods']) +
      policyRule.withVerbs(['get','list','watch']),
      policyRule.withApiGroups(['extensions','networking.k8s.io']) +
      policyRule.withResources(['ingresses']) +
      policyRule.withVerbs(['get','list','watch']),
      policyRule.withApiGroups(['']) +
      policyRule.withResources(['nodes']) +
      policyRule.withVerbs(['list']),
    ]),

  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,

  external_dns_clusterrolebinding:
    clusterRoleBinding.new($._config.external_dns.release_name + '-external-dns') +
    clusterRoleBinding.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'external-dns',
      'app.kubernetes.io/instance': $._config.external_dns.release_name,
    }) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName($._config.external_dns.release_name + '-external-dns') +
    clusterRoleBinding.withSubjectsMixin({
      kind: 'ServiceAccount',
      name: $._config.external_dns.release_name + '-external-dns',
      namespace: '%s' % $._config.namespace,
    }),

  # Make arguments to pass to the external-dns container
  local containerArgs = [
      '--source=service',
      '--source=ingress',
      '--provider=%s' % $._config.external_dns.provider,
      '--policy=%s' % $._config.external_dns.policy,
      '--registry=%s' % $._config.external_dns.registry,
      '--txt-owner-id=%s' % $._config.external_dns.txt_owner_id,
      '--interval=%s' % $._config.external_dns.interval,
      '--events',
      '--log-format=%s' % $._config.external_dns.log_format,
  ] +
  $._config.external_dns.extraArgs,

  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,
  local volumeMount = $.core.v1.volumeMount,

  external_dns_container::
    container.new($._config.external_dns.release_name + 'external-dns', $._images.external_dns_image) +
    container.withArgs(containerArgs) +
    container.withVolumeMountsMixin([
      volumeMount.new('config','/etc/kubernetes/'),
    ]),

  local deployment = $.apps.v1.deployment,

  external_dns_deployment:
    deployment.new($._config.external_dns.release_name + '-external-dns', 1, $.external_dns_container, {
      'app.kubernetes.io/name': 'external-dns',
      'app.kubernetes.io/instance': $._config.external_dns.release_name,
    }) +
    deployment.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'external-dns',
      'app.kubernetes.io/instance': $._config.external_dns.release_name,
    }) +
    deployment.spec.template.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'external-dns',
      'app.kubernetes.io/instance': $._config.external_dns.release_name,
    }) +
    deployment.spec.strategy.withType('Recreate') +
    deployment.spec.template.spec.withServiceAccount($._config.external_dns.release_name + '-external-dns') +
    deployment.spec.template.spec.withVolumesMixin($.core.v1.volume.fromSecret('config', 'external-dns-config')),
}
