local k = import 'lib/k.libsonnet';

{
  deployment(name)::
    k.apps.v1.deployment.new(name=name, containers=[
      k.core.v1.container.new(name=name, image=name)
    ])
  ,
}