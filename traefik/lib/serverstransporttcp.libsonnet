local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of serversTransportTCP
  new(name): common.newResource('ServersTransportTCP', name),

  spec: common.spec,
}
