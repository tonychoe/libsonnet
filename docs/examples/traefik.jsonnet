local traefik = (import "traefik/v1/traefik.libsonnet");

traefik {
  # Use this to override the image
	_images+:: {
	},

  # Use this to override the config
 	_config+:: {
    traefik_namespace: 'traefik',
    # this name is used in two places
    # 1) Resource name, suffixed by '-traefik'
    # 2) value for the metadata.labels."app.kubernetes.io/instance"
    traefik_release_name: 'mylab',
    traefik_replicas: 1,
    traefik_accesslog: true,
    traefik_accesslog_format: 'json',
    traefik_entrypoints_port: 9000,
    traefik_entrypoints_web_port: 8000,
    traefik_entrypoints_websecure_port: 8443,
    traefik_tracing_jaeger: true,
    traefik_tracing_service_name: 'traefik-proxy',
    traefik_tracing_jaeger_agent: 'jaegertracing-agent.default:6831',
    traefik_tracing_jaeger_sampling_type: 'remote',
    traefik_tracing_jaeger_sampling_server: 'http://jaegertracing-agent.default:5778/sampling',
    # Use this to pass extra args to traefik. See https://doc.traefik.io/traefik/reference/static-configuration/cli/
    traefik_extraArgs: [
      '--metrics.prometheus=true',
      '--log.level=INFO',
      '--providers.kubernetescrd.allowCrossNamespace=true',
    ],
  },
}
