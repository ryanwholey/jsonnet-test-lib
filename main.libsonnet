local k = import 'lib/k.libsonnet';

{
  deployment(name, image, port, replicas)::
    local container = k.core.v1.container;
    local deployment = k.apps.v1.deployment;
    deployment.new(name=name, containers=[
      (
        container.new(name=name, image=image) +
        container.withPorts(
          k.core.v1.containerPort.new(port)
        )
      )
    ]) +
    deployment.spec.withReplicas(replicas)
  ,
  service(name, port):
    local service = k.core.v1.service;
    local servicePort = k.core.v1.servicePort;

    service.new(
      name=name,
      ports=[ servicePort.newNamed("http", port, port) ],
      selector={ name: name, },
    )
  ,
  render(apiServer, environment, config)::
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
        deployment: $.deployment(config.name, config.image, config.port, config.replicas),
        service: $.service(config.name, config.port),
      },
    }
}