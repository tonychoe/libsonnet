local tlsoption = import '../tlsoption.libsonnet';
local tlsstore = import '../tlsstore.libsonnet';

{
  // Returns default TLS resources for strict global HTTPS behavior.
  new(defaultCertificateSecretName, minVersion='VersionTLS13', sniStrict=true): {
    default_tlsoption:
      tlsoption.new('default') +
      tlsoption.spec.withSniStrict(sniStrict) +
      tlsoption.spec.withMinVersion(minVersion),

    default_tlsstore:
      tlsstore.new('default') +
      tlsstore.spec.withDefaultCertificateSecretName(defaultCertificateSecretName),
  },

  // Convenience alias for strict TLS defaults (TLS 1.3 + strict SNI).
  strict(defaultCertificateSecretName):
    self.new(
      defaultCertificateSecretName=defaultCertificateSecretName,
      minVersion='VersionTLS13',
      sniStrict=true,
    ),
}
