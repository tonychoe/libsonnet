{
  _config+:: {

    namespace: error 'must define traefik_namespace',

    traefik: {
      release_name: 'my',
      replicas: 1,
      accesslog: false,
      accesslog_format: 'common',
      entrypoints_port: 9000,
      entrypoints_web_port: 8000,
      entrypoints_websecure_port: 8443,
      tracing_jaeger: 'false',
      tracing_service_name: 'traefik',
      tracing_jaeger_agent: 'jaegertracing-agent.default:6831',
      tracing_jaeger_sampling_type: 'remote',
      tracing_jaeger_sampling_server: 'http://jaegertracing-agent.default:5778/sampling',
      // Pass extra args to traefik. See https://doc.traefik.io/traefik/reference/static-configuration/cli/
      extraArgs: [
      ],
    },
  },

  _images+:: {
    traefik_image: 'traefik:2.4.2',
  },
}
