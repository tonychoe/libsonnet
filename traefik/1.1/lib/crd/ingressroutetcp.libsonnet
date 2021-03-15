{
  ingressroutetcps_crd: {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
       "name": "ingressroutetcps.traefik.containo.us"
    },
    "spec": {
       "group": "traefik.containo.us",
       "version": "v1alpha1",
       "names": {
          "kind": "IngressRouteTCP",
          "plural": "ingressroutetcps",
          "singular": "ingressroutetcp"
       },
       "scope": "Namespaced"
    }
  }
}
