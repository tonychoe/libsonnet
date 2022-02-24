{
  _images+:: {
    otelcol: 'us-phoenix-1.ocir.io/idvjmdrn1r3d/otel/opentelemetry-collector-contrib:0.44.0',
  },

  _config+:: {
    namespace: error 'must define a namespace name',
    agent_release_name: error 'must define an agent release name',
    // Default config
    agent_config: {
      receivers: {
        otlp: {
          protocols: {
            grpc: { endpoint: '0.0.0.0:4317' },
            http: { endpoint: '0.0.0.0:4318' },
          },
        },
        jaeger: {
          protocols: {
            // grpc: { endpoint: '0.0.0.0:14250' },
            // thrift_http: { endpoint: '0.0.0.0:14268' },
            thrift_compact: { endpoint: '0.0.0.0:6831' },
          },
          remote_sampling: {
            host_endpoint: '0.0.0.0:5778',
          },
        },
      },
      processors: {
        memory_limiter: {
          limit_mib: 2000,
          spike_limit_mib: 400,
          check_interval: '5s',
        },
        batch: null,
      },
      exporters: {
        otlp: {
          endpoint: 'otelcol-gateway:4317',
          tls: {
            insecure: true,
          },
        },
        logging: {
          loglevel: 'debug',
        },
      },
      extensions: {
        health_check: {},
        zpages: {},
      },
      service: {
        extensions: [
          'health_check',
          'zpages',
        ],
        pipelines: {
          traces: {
            receivers: [
              'otlp',
              'jaeger',
            ],
            //
            // Best practices for theorderof processors
            // https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor
            //
            // 1. memory_limiter
            // 2. any sampling processors
            // 3. Any processor relying on sending source from context (e.g. attributes)
            // 4. batch
            // 5. any other processors
            //
            processors: [
              'memory_limiter',
              'batch',
            ],
            exporters: [
              'otlp',
              // 'logging',
            ],
          },
        },
      },
    },

    gateway_release_name: error 'must define a gateway release name',
    gateway_replicas: 1,
    gateway_config: {
      receivers: {
        otlp: {
          protocols: {
            grpc: null,  // localhost:4317
            http: null,  // localhost:4318
          },
        },
      },
      processors: {
        batch: {
          timeout: '1s',
          send_batch_size: 10000,
          send_batch_max_size: 11000,
        },
        memory_limiter: {
          // Maximum amount of memory, in MiB, targeted to be allocated by the process heap.
          // Note that typically the total memory usage of process will be about 50MiB higher
          // than this value.
          limit_mib: 4000,
          // The maximum, in MiB, spike expected between the measurements of memory usage.
          spike_limit_mib: 500,
          // check_interval is the time between measurements of memory usage for the
          // purposes of avoiding going over the limits. Defaults to zero, so no
          // checks will be performed. Values below 1 second are not recommended since
          // it can result in unnecessary CPU consumption.
          check_interval: '5s',
        },
        probabilistic_sampler: {
          hash_seed: 11,
          sampling_percentage: 100,
        },
      },
      exporters: {
        otlp: {
          endpoint: 'distributor.tempo:4317',
          tls: {
            insecure: true,
          },
          headers: {
            'x-scope-orgid': 'archlab',
          },
        },
        logging: {
          loglevel: 'debug',
        },
      },
      extensions: {
        health_check: {},
        zpages: {},
      },
      service: {
        extensions: [
          'health_check',
          'zpages',
        ],
        pipelines: {
          traces: {
            receivers: [
              'otlp',
            ],
            //
            // Best practices for theorderof processors
            // https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor
            //
            // 1. memory_limiter
            // 2. any sampling processors
            // 3. Any processor relying on sending source from context (e.g. attributes)
            // 4. batch
            // 5. any other processors
            //
            processors: [
              'memory_limiter',
              'probabilistic_sampler',
              'batch',
              // spanmetrics will pass on span data untouched to next processor
              // while also accumulating metrics to be sent to the configured 'otlp/spanmetrics' exporter.
              'spanmetrics',
            ],
            exporters: [
              'otlp',
              // 'logging',
            ],
          },
        },
      },
    },
  },
}
