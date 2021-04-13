{
  _config+:: {

    namespace: error 'must define namespace for externaldns',

    external_dns: {
      release_name: 'my',
      provider: 'oci',
      policy: 'sync',
      registry: 'txt',
      txt_owner_id: error 'must define txt_onwer_id for externaldns',
      interval:  '10m', 
      log_format: 'json',
      // Pass extra args to externaldns
      extraArgs: [
      ],
    },
  },

  _images+:: {
    external_dns_image: 'k8s.gcr.io/external-dns/external-dns:v0.7.6',
  },
}
