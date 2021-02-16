local k = import 'ksonnet-util/kausal.libsonnet';
local ingressroute = import 'traefik-ingressroute/v1/ingressroute.libsonnet';

k {
  _config+:: {
    traefik_namespace: error 'must define traefik_namespace',
    traefik_release_name: 'my',
    traefik_replicas: 1,
    traefik_accesslog: false,
    traefik_accesslog_format: 'common',
    traefik_entrypoints_port: 9000,
    traefik_entrypoints_web_port: 8000,
    traefik_entrypoints_websecure_port: 8443,
    traefik_tracing_jaeger: 'false',
    traefik_tracing_service_name: 'traefik',
    traefik_tracing_jaeger_agent: 'jaegertracing-agent.default:6831',
    traefik_tracing_jaeger_sampling_type: 'remote',
    traefik_tracing_jaeger_sampling_server: 'http://jaegertracing-agent.default:5778/sampling',
    // Pass extra args to traefik. See https://doc.traefik.io/traefik/reference/static-configuration/cli/
    traefik_extraArgs: [
    ],
  },

  _images+:: {
    traefik: 'traefik:2.4.2',
  },

  # Make arguments to pass to the traefik container
  local boilerplateArgs = [
      '--accesslog=%s' % $._config.traefik_accesslog,
      '--accesslog.format=%s' % $._config.traefik_accesslog_format,
      '--entryPoints.traefik.address=:%d/tcp' % $._config.traefik_entrypoints_port,
      '--entryPoints.web.address=:%d/tcp' % $._config.traefik_entrypoints_web_port,
      '--entryPoints.websecure.address=:%d/tcp' % $._config.traefik_entrypoints_websecure_port,
      '--providers.kubernetescrd',
      '--providers.kubernetesingress',
      '--api.dashboard=true',
      '--ping=true', // Do not disable. It's used for liveliness and readiness check.
  ] +
  $._config.traefik_extraArgs,

  local tracingArgs = [
      '--tracing.jaeger=%s' % $._config.traefik_tracing_jaeger,
      '--tracing.serviceName=%s' % $._config.traefik_tracing_service_name,
      '--tracing.jaeger.localAgentHostPort=%s' % $._config.traefik_tracing_jaeger_agent,
      '--tracing.jaeger.samplingType=%s' % $._config.traefik_tracing_jaeger_sampling_type,
      '--tracing.jaeger.samplingServerURL=%s' % $._config.traefik_tracing_jaeger_sampling_server,
  ],

  local containerArgs = 
    if $._config.traefik_tracing_jaeger == true then 
      boilerplateArgs + tracingArgs
    else
      boilerplateArgs
    ,

  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,
  local volumeMount = $.core.v1.volumeMount,

  traefik_container::
    container.new($._config.traefik_release_name + 'traefik', $._images.traefik) +
    container.withArgs(containerArgs) +
    container.withPorts([
      containerPort.newNamed($._config.traefik_entrypoints_port,'traefik'),
      containerPort.newNamed($._config.traefik_entrypoints_web_port,'web'),
      containerPort.newNamed($._config.traefik_entrypoints_websecure_port,'websecure'),
    ]) +
    container.readinessProbe.httpGet.withPath('/ping') +
    container.readinessProbe.httpGet.withPort($._config.traefik_entrypoints_port) +
    container.readinessProbe.withFailureThreshold(1) +
    container.readinessProbe.withInitialDelaySeconds(10) +
    container.readinessProbe.withPeriodSeconds(10) +
    container.readinessProbe.withSuccessThreshold(1) +
    container.readinessProbe.withTimeoutSeconds(2) +
    container.livenessProbe.httpGet.withPath('/ping') +
    container.livenessProbe.httpGet.withPort($._config.traefik_entrypoints_port) +
    container.livenessProbe.withFailureThreshold(3) +
    container.livenessProbe.withInitialDelaySeconds(10) +
    container.livenessProbe.withPeriodSeconds(10) +
    container.livenessProbe.withSuccessThreshold(1) +
    container.livenessProbe.withTimeoutSeconds(2) +
    container.resources.withLimitsMixin({
      'cpu': '300m',
      'memory': '150Mi',
    }) +
    container.resources.withRequestsMixin({
      'cpu': '100m',
      'memory': '50Mi',
    }) +
    container.withVolumeMountsMixin([
      volumeMount.new('data','/data'),
      volumeMount.new('tmp','/tmp'),
    ]) +
    container.securityContext.capabilities.withDrop('ALL') +
    container.securityContext.withReadOnlyRootFilesystem(true) +
    # Run as non-root with UID 65532 and GID 65532
    container.securityContext.withRunAsGroup(65532) +
    container.securityContext.withRunAsNonRoot(true) +
    container.securityContext.withRunAsUser(65532), 
    // + $.util.resourcesRequests('100m', '500Mi'),

  local serviceAccount = $.core.v1.serviceAccount,

  traefik_serviceaccount:
    serviceAccount.new($._config.traefik_release_name + '-traefik') +
    serviceAccount.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik_release_name,
    }),

  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  # installs ClusterRole and ClusterRoleBinding so Traefik can be used across namespaces.
  traefik_clusterrole:
    clusterRole.new($._config.traefik_release_name + '-traefik') +
    clusterRole.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik_release_name,
    }) +
    clusterRole.withRulesMixin([
      policyRule.withApiGroups('') +
      policyRule.withResources(['services','endpoints','secrets']) +
      policyRule.withVerbs(['get','list','watch']),
      policyRule.withApiGroups(['extensions','networking.k8s.io']) +
      policyRule.withResources(['ingresses','ingressclasses']) +
      policyRule.withVerbs(['get','list','watch']),
      policyRule.withApiGroups(['extensions','networking.k8s.io']) +
      policyRule.withResources(['ingresses/status']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups(['traefik.containo.us']) +
      policyRule.withResources(['ingressroutes','ingressroutetcps','ingressrouteudps','middlewares','tlsoptions','tlsstores','traefikservices', 'serverstransports']) +
      policyRule.withVerbs(['get','list','watch']),
    ]),

  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,

  traefik_clusterrolebinding:
    clusterRoleBinding.new($._config.traefik_release_name + '-traefik') +
    clusterRoleBinding.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik_release_name,
    }) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName($._config.traefik_release_name + '-traefik') +
    clusterRoleBinding.withSubjectsMixin({
      kind: 'ServiceAccount',
      name: $._config.traefik_release_name + '-traefik',
      namespace: '%s' % $._config.traefik_namespace,
    }),

  local deployment = $.apps.v1.deployment,

  traefik_deployment:
    deployment.new($._config.traefik_release_name + '-traefik', $._config.traefik_replicas, $.traefik_container, {
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik_release_name,
    }) +
    deployment.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik_release_name,
    }) +
    deployment.spec.template.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik_release_name,
    }) +
    # If hostNetwork is true, runs traefik in the host network namespace
    deployment.spec.template.spec.withHostNetwork(false) +
    deployment.spec.template.spec.withVolumesMixin($.core.v1.volume.fromEmptyDir('data')) +
    deployment.spec.template.spec.withVolumesMixin($.core.v1.volume.fromEmptyDir('tmp')) +
    deployment.spec.template.spec.withServiceAccount($._config.traefik_release_name + '-traefik') +
    deployment.spec.template.spec.withTerminationGracePeriodSeconds(60) +
    # Defines a pod’s "file system group" ID for volume access
    deployment.spec.template.spec.securityContext.withFsGroup(65532) +
    deployment.spec.strategy.rollingUpdate.withMaxSurge(1) +
    deployment.spec.strategy.rollingUpdate.withMaxUnavailable(1),

  traefik_service:
    $.util.serviceFor($.traefik_deployment),

  local routes = ingressroute.spec.routes,
  local services = ingressroute.spec.routes.services,

  traefik_ingressroute:
    ingressroute.new($._config.traefik_release_name + '-dashboard') +
    ingressroute.metadata.withLabelsMixin({
      'app.kubernetes.io/name': 'traefik',
      'app.kubernetes.io/instance': $._config.traefik_release_name,
    }) +
    ingressroute.spec.withEntryPointsMixin('traefik') +
    ingressroute.spec.withRoutesMixin(
      routes.new("PathPrefix(`/dashboard`) || PathPrefix(`/api`)") +
      routes.withKind('Rule') +
      routes.withServicesMixin([
        services.new('api@internal') +
        services.withKind('TraefikService'),
      ]) 
    ),
}