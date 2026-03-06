local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of tlsStore
  new(name): common.newResource('TLSStore', name),

  spec: common.spec {
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
