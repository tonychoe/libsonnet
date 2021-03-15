{
  serverstransports: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "name": "serverstransports.traefik.containo.us"
    },
    "spec": {
      "group": "traefik.containo.us",
      "version": "v1alpha1",
      "names": {
         "kind": "ServersTransport",
         "plural": "serverstransports",
         "singular": "serverstransport"
      },
      "scope": "Namespaced"
    }
  }
}
