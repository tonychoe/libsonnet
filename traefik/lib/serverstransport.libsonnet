local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of serversTransport
  new(name): common.newResource('ServersTransport', name),

  spec: common.spec,
}
