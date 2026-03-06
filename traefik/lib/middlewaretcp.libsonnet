local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of middlewareTCP
  new(name): common.newResource('MiddlewareTCP', name),

  spec: common.spec,
}
