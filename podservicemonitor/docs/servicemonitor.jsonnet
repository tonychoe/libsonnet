local s = (import 'servicemonitor/main.libsonnet');
{

  local endpoint = s.endpoint,
  local servicemonitor = s.servicemonitor,
  local relabelconfig = s.relabelconfig,

  relabelconfig::
    relabelconfig.new() 
    + relabelconfig.withSourceLabels( [ '__meta_kubernetes_namespace', '__meta_kubernetes_service_name' ] )
    + relabelconfig.withSeparator( '/' )
    + relabelconfig.withTargetLabel( 'job' )
    + relabelconfig.withRegex( '(.*)' )
    + relabelconfig.withModulus( 'modulus' )
    + relabelconfig.withReplacement( '$1' )
    + relabelconfig.withAction( 'replace' )
  ,

  endpoint::
    endpoint.new( )
    + endpoint.withPort( 'port2' )
    + endpoint.withTargetPort( 'targetPort' )
    + endpoint.withPath( 'path' )
    + endpoint.withScheme( 'scheme' )
    + endpoint.withParams( 'params' )
    + endpoint.withParamsMixin( [ 'params2', 'params3' ] )
    + endpoint.withInterval( 'interval' )
    + endpoint.withScrapeTimeout( 'scrapeTimeout' )
    + endpoint.withTlsConfig( 'tlsConfig' )
    + endpoint.withBearerTokenFile( 'bearerTokenFile' )
    + endpoint.withBearerTokenSecret( 'bearerTokenSecret' )
    + endpoint.withHonorLabels( 'honorLabels' )
    + endpoint.withHonorTimestamps( 'honorTimestamps' )
    + endpoint.withBasicAuth( 'basicAuth' )
    + endpoint.withMetricRelabelings( $.relabelconfig )
    + endpoint.withMetricRelabelingsMixin( $.relabelconfig )
    + endpoint.withRelabelings( $.relabelconfig )
    + endpoint.withRelabelingsMixin( $.relabelconfig )
    + endpoint.withProxyUrl( 'proxyUrl' )
  ,

  servicemonitor: 
    servicemonitor.new( 'test', $.endpoint, 
      servicemonitor.labelSelector.withMatchLabels( { app: 'prom' } )
    ) 
    + servicemonitor.spec.withJobLabel( 'job' )
    + servicemonitor.spec.withTargetLabels( [ 'target1', 'target2' ]  )
    + servicemonitor.spec.withTargetLabelsMixin( [ 'target3', 'target4' ]  )
    + servicemonitor.spec.withPodTargetLabels( [ 'target5', 'target6' ]  )
    + servicemonitor.spec.withPodTargetLabelsMixin( [ 'target7', 'target8' ]  )
    + servicemonitor.spec.withSampleLimit( 50 )
    + servicemonitor.spec.withTargetLimit( 100 )
    ,
}
