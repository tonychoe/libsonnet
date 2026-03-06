{
  ingressroute: import 'ingressroute.libsonnet',
  ingressroutetcp: import 'ingressroutetcp.libsonnet',
  ingressrouteudp: import 'ingressrouteudp.libsonnet',
  middleware: import 'middleware.libsonnet',
  middlewaretcp: import 'middlewaretcp.libsonnet',
  serverstransport: import 'serverstransport.libsonnet',
  serverstransporttcp: import 'serverstransporttcp.libsonnet',
  tlsoption: import 'tlsoption.libsonnet',
  tlsstore: import 'tlsstore.libsonnet',
  traefikservice: import 'traefikservice.libsonnet',

  presets: {
    secureDefaults: import 'presets/secure-defaults.libsonnet',
  },
}
