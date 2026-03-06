{
  metadata: {
    // Map of string keys and values that can be used to organize and categorize (scope and select) objects.
    withLabels(labels): { metadata+: { labels: labels } },
    // **Note:** This function appends passed data to existing values
    withLabelsMixin(labels): { metadata+: { labels+: labels } },
    // Name must be unique within a namespace.
    withName(name): { metadata+: { name: name } },
  },

  // New returns an instance of tlsStore
  new(name): {
               apiVersion: 'traefik.io/v1alpha1',
               kind: 'TLSStore',
             } + self.metadata.withName(name=name) +
             self.metadata.withLabelsMixin({
               'app.kubernetes.io/name': 'traefik',
               'app.kubernetes.io/instance': name,
             }),
  spec: {
    withSpec(spec): { spec: spec },
    // **Note:** This function appends passed data to existing values
    withSpecMixin(spec): { spec+: spec },
    withDefaultCertificate(defaultCertificate): { spec+: { defaultCertificate: defaultCertificate } },
    withDefaultCertificateSecretName(secretName): { spec+: { defaultCertificate: { secretName: secretName } } },
    withDefaultGeneratedCert(defaultGeneratedCert): { spec+: { defaultGeneratedCert: defaultGeneratedCert } },
    withCertificates(certificates): { spec+: { certificates: if std.isArray(v=certificates) then certificates else [certificates] } },
    // **Note:** This function appends passed data to existing values
    withCertificatesMixin(certificates): { spec+: { certificates+: if std.isArray(v=certificates) then certificates else [certificates] } },
    certificates: {
      new(secretName): {
        secretName: secretName,
      },
    },
  },
}
