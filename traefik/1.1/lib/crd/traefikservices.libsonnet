{
  traefikservices_crd: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
       "name": "traefikservices.traefik.containo.us"
    },
    "spec": {
       "group": "traefik.containo.us",
       "version": "v1alpha1",
       "names": {
          "kind": "TraefikService",
          "plural": "traefikservices",
          "singular": "traefikservice"
       },
       "scope": "Namespaced"
    }
  }
}
