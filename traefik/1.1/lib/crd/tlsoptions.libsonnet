{
  tlsoptions_crd: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
       "name": "tlsoptions.traefik.containo.us"
    },
    "spec": {
       "group": "traefik.containo.us",
       "version": "v1alpha1",
       "names": {
          "kind": "TLSOption",
          "plural": "tlsoptions",
          "singular": "tlsoption"
       },
       "scope": "Namespaced"
    }
  }
}
