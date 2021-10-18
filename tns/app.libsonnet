{
  tns:: {
    new(name, arg, image):: {
      local deployment = $.apps.v1.deployment,
      // local container = deployment.mixin.spec.template.spec.containersType,
      local container = $.core.v1.container,
      local containerPort = $.core.v1.containerPort,
      local service = $.core.v1.service,
      local _container = container.new(name, image)
                         + container.withPorts(containerPort.newNamed(80, 'http-metrics'))
                         + container.withImagePullPolicy('IfNotPresent')
                         + container.withArgs(std.prune(['-log.level=debug', if arg != '' then arg else null]))
                         + container.withEnv([
                           { name: 'JAEGER_AGENT_HOST', value: $._config.tns.jaeger.host },
                           { name: 'JAEGER_TAGS', value: $._config.tns.jaeger.tags },
                           { name: 'JAEGER_SAMPLER_TYPE', value: $._config.tns.jaeger.sampler_type },
                           { name: 'JAEGER_SAMPLER_PARAM', value: $._config.tns.jaeger.sampler_param },
                         ])
      // { "name": "JAEGER_AGENT_HOST", "valueFrom": {"fieldRef":{"fieldPath":"status.hostIP"}}},
      ,

      _deployment: deployment.new(name, 1, [_container], {}),

      service: $.util.serviceFor(self._deployment),
    },
  },
}
