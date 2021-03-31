/*
(import 'servicemonitor.libsonnet')
+ (import 'endpoints.libsonnet')
*/
{
  endpoint:: (import 'endpoint.libsonnet'),
  namespaceselector:: (import 'namespaceselector.libsonnet'),
  relabelconfig:: (import 'relabelconfig.libsonnet'),
  servicemonitor:: (import 'servicemonitor.libsonnet'),
}
