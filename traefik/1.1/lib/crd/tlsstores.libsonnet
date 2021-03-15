{
  tlsstores_crd: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
       "name": "tlsstores.traefik.containo.us"
    },
    "spec": {
       "group": "traefik.containo.us",
       "version": "v1alpha1",
       "names": {
         "kind": "TLSStore",
         "plural": "tlsstores",
         "singular": "tlsstore"
       },
       "scope": "Namespaced"
    }
  }
}
