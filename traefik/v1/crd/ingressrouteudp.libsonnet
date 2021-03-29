{
  ingressrouteudps_crd: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
       "name": "ingressrouteudps.traefik.containo.us"
    },
    "spec": {
       "group": "traefik.containo.us",
       "version": "v1alpha1",
       "names": {
          "kind": "IngressRouteUDP",
          "plural": "ingressrouteudps",
          "singular": "ingressrouteudp"
       },
       "scope": "Namespaced"
    }
  }
}