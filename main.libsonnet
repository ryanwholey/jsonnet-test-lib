local k = import 'lib/k.libsonnet';

{
  deployment(name, image)::
    k.apps.v1.deployment.new(name=name, containers=[
      k.core.v1.container.new(name=name, image=image)
    ])
  ,
  service(name, ports):
    k.core.v1.service.new(name=name, ports=ports, selector='name: app')
  ,
  apiServer(environment)::
    "http://192.168.64.25:8443"
  ,
  manifest(config)::
    k.apps.v1.deployment.new(name=config.name, containers=[
      k.core.v1.container.new(name=config.name, image=config.image)
    ],) 
  ,
  spec(apiServer, environment, config)::
    {
      apiVersion: 'tanka.dev/v1alpha1',
      kind: 'Environment',
      metadata: {
        name: 'default'
      },
      spec: {
        apiServer: apiServer,
        namespace: config.namespace
      },
      data: {
        deployment: $.deployment(config.name, config.image),
        service: $.service(config.name, config.image),
      },
    }
}