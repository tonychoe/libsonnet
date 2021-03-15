{
  ingressroutes_crd: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
       "name": "ingressroutes.traefik.containo.us"
    },
    "spec": {
       "group": "traefik.containo.us",
       "version": "v1alpha1",
       "names": {
          "kind": "IngressRoute",
          "plural": "ingressroutes",
          "singular": "ingressroute"
       },
       "scope": "Namespaced"
    }
  }
}
