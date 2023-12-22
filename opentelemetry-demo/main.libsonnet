local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local k = import 'k.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  new(name='opentelemetry-demo', overrides={})::
    helm.template(name, './charts/opentelemetry-demo', overrides),
}
