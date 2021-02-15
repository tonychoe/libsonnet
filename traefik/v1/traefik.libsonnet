local k = import 'ksonnet-util/kausal.libsonnet';

k {
  _config+:: {
    traefik_namespace: 'default',
    traefik_release_name: 'traefik',
    traefik_replicas: 3,
    traefik_entrypoints_port: 9000,
    traefik_entrypoints_web_port: 8000,
    traefik_entrypoints_websecure_port: 8000,
    traefik_accesslog: true,
    traefik_accesslog_format: 'json',
    traefik_tracing_jaeger: 'true',
    traefik_tracing_service_name: 'traefik-proxy',
    traefik_tracing_jaeger_agent: 'jaegertracing-agent.default:6831',
    traefik_tracing_jaeger_sampling_type: 'remote',
    traefik_tracing_jaeger_sampling_server: 'http://jaegertracing-agent.default:5778/sampling',
    // Pass extra args to traefik. See https://doc.traefik.io/traefik/reference/static-configuration/cli/
    traefik_extraArgs: [
      '--ping=true',
      '--api.debug=false',
      '--log.level=ERROR',
    ],
  },

  _images+:: {
    traefik: 'traefik:2.4.2',
  },

  local containerArgs = [
      '--entryPoints.traefik.address=:%d/tcp' % $._config.traefik_entrypoints_port,
      '--entryPoints.web.address=:%d/tcp' % $._config.traefik_entrypoints_web_port,
      '--entryPoints.websecure.address=:%d/tcp' % $._config.traefik_entrypoints_websecure_port,
      '--providers.kubernetescrd',
      '--providers.kubernetesingress',
      '--accesslog=%s' % $._config.traefik_accesslog,
      '--accesslog.format=%s' % $._config.traefik_accesslog_format,
      '--tracing.jaeger=%s' % $._config.traefik_tracing_jaeger,
      '--tracing.serviceName=%s' % $._config.traefik_tracing_service_name,
      '--tracing.jaeger.localAgentHostPort=%s' % $._config.traefik_tracing_jaeger_agent,
      '--tracing.jaeger.samplingType=%s' % $._config.traefik_tracing_jaeger_sampling_type,
      '--tracing.jaeger.samplingServerURL=%s' % $._config.traefik_tracing_jaeger_sampling_server,
  ] +
  $._config.traefik_extraArgs,

  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,
  local volumeMount = $.core.v1.volumeMount,

  traefik_container::
    container.new($._config.traefik_release_name, $._images.traefik) +
    container.withArgs(containerArgs) +
    container.withPorts([
      containerPort.newNamed($._config.traefik_entrypoints_port,$._config.traefik_release_name),
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

  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  traefik_clusterrole:
    clusterRole.new($._config.traefik_release_name) +
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
      policyRule.withResources(['ingressroutes','ingressroutetcps','ingressrouteudps','middlewares','tlsoptions','tlsstores','traefikservices']) +
      policyRule.withVerbs(['get','list','watch']),
    ]),

  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,

  traefik_clusterrolebinding:
      clusterRoleBinding.new($._config.traefik_release_name) +
      clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
      clusterRoleBinding.roleRef.withKind('ClusterRole') +
      clusterRoleBinding.roleRef.withName($._config.traefik_release_name) +
      clusterRoleBinding.withSubjectsMixin({
        kind: 'ServiceAccount',
        name: $._config.traefik_release_name,
        namespace: '%s' % $._config.traefik_namespace,
      }),

  local deployment = $.apps.v1.deployment,

  traefik_deployment:
    deployment.new($._config.traefik_release_name, $._config.traefik_replicas, [
      $.traefik_container,
    ]) +
    deployment.spec.template.spec.withVolumesMixin($.core.v1.volume.fromEmptyDir('data'))
    + deployment.spec.template.spec.withVolumesMixin($.core.v1.volume.fromEmptyDir('tmp'))
    + deployment.spec.template.spec.withServiceAccount($._config.traefik_release_name)
    + deployment.spec.template.spec.withTerminationGracePeriodSeconds(60)
    # Defines a pod’s "file system group" ID for volume access
    + deployment.spec.template.spec.securityContext.withFsGroup(65532)
    + deployment.spec.strategy.rollingUpdate.withMaxSurge(1)
    + deployment.spec.strategy.rollingUpdate.withMaxUnavailable(1),

  traefik_service:
    $.util.serviceFor($.traefik_deployment),

  traefik_ingressroute: {
      apiVersion: 'traefik.containo.us/v1alpha1',
      kind: 'IngressRoute',
      metadata: {
        name: $._config.traefik_release_name,
        labels: {
          'app.kubernetes.io/name': $._config.traefik_release_name,
        },
      },
      spec: {
        entryPoints: [
          'traefik'
        ],
        routes: [{
          match: "PathPrefix(`/dashboard`) || PathPrefix(`/api`)",
          kind: 'Rule',
          services: [{
            name: 'api@internal',
            kind: 'TraefikService',
          }],
        }],
      }
    }
}
