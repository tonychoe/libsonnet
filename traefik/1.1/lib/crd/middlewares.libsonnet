{
  middlewares_crd: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "name": "middlewares.traefik.containo.us"
    },
    "spec": {
      "group": "traefik.containo.us",
      "version": "v1alpha1",
      "names": {
         "kind": "Middleware",
         "plural": "middlewares",
         "singular": "middleware"
      },
      "scope": "Namespaced"
    }
  }
}
