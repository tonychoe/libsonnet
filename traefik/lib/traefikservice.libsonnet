local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of traefikService
  new(name): common.newResource('TraefikService', name),

  spec: common.spec,
}
