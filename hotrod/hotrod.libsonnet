local k = import 'k.libsonnet';

k {
  _config+:: {

    namespace: error 'must define hotrod_namespace',

    hotrod: {
      release_name: 'my',
      http_port: 8080,
      metrics_port: 8083,
      replicas: 1,
      extraArgs: [
      ],
      extraEnvs: [
      ],
    },
  },

  _images+:: {
    hotrod_image: 'jaegertracing/example-hotrod:latest',
  },

  local boilerplateMetadata = {
    'app.kubernetes.io/name': 'hotrod',
    'app.kubernetes.io/instance': $._config.hotrod.release_name,
  },

  local serviceAccount = $.core.v1.serviceAccount,

  hotrod_serviceaccount:
    serviceAccount.new($._config.hotrod.release_name) +
    serviceAccount.metadata.withLabelsMixin(boilerplateMetadata),

  local containerArgs = [
                          'all',
                        ] +
                        $._config.hotrod.extraArgs,

  local containerEnvs = [
                        ] +
                        $._config.hotrod.extraEnvs,

  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,

  hotrod_container::
    container.new($._config.hotrod.release_name, $._images.hotrod_image) +
    container.withArgs(containerArgs) +
    container.withEnv(containerEnvs) +
    container.withPortsMixin(containerPort.newNamed($._config.hotrod.http_port, 'http')) +
    container.withPortsMixin(containerPort.newNamed($._config.hotrod.metrics_port, 'metrics')) +
    container.readinessProbe.httpGet.withPath('/hotrod') +
    container.readinessProbe.httpGet.withPort($._config.hotrod.http_port) +
    container.livenessProbe.httpGet.withPath('/hotrod') +
    container.livenessProbe.httpGet.withPort($._config.hotrod.http_port) +
    container.securityContext.capabilities.withDrop('ALL') +
    container.securityContext.withReadOnlyRootFilesystem(true) +
    container.securityContext.withRunAsGroup(65532) +
    container.securityContext.withRunAsNonRoot(true) +
    container.securityContext.withRunAsUser(65532),

  local deployment = $.apps.v1.deployment,

  hotrod_deployment:
    deployment.new($._config.hotrod.release_name, $._config.hotrod.replicas, $.hotrod_container, boilerplateMetadata)
    + deployment.metadata.withLabelsMixin(boilerplateMetadata)
    + deployment.spec.selector.withMatchLabels(boilerplateMetadata)
    + deployment.spec.template.metadata.withLabelsMixin(boilerplateMetadata)
    + deployment.spec.template.spec.withServiceAccount($._config.hotrod.release_name),

  local service = $.core.v1.service,
  local servicePort = $.core.v1.servicePort,

  hotrod_service:
    service.new($._config.hotrod.release_name, boilerplateMetadata, [
      servicePort.newNamed('http', $._config.hotrod.http_port, 'http'),
      servicePort.newNamed('metrics', $._config.hotrod.metrics_port, 'metrics'),
    ]) +
    service.metadata.withLabelsMixin(boilerplateMetadata) +
    service.spec.withType('ClusterIP'),
}
