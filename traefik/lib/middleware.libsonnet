local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of middleware
  new(name): common.newResource('Middleware', name),

  spec: common.spec,
}
