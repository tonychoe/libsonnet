local common = import '_common.libsonnet';

{
  metadata: common.metadata,

  // New returns an instance of tlsOption
  // More info: https://doc.traefik.io/traefik/reference/dynamic-configuration/kubernetes-crd/
  new(name): common.newResource('TLSOption', name),

  spec: common.spec {
    withMinVersion(minVersion): { spec+: { minVersion: minVersion } },
    withMaxVersion(maxVersion): { spec+: { maxVersion: maxVersion } },
    withCipherSuites(cipherSuites): { spec+: { cipherSuites: if std.isArray(v=cipherSuites) then cipherSuites else [cipherSuites] } },
    // **Note:** This function appends passed data to existing values
    withCipherSuitesMixin(cipherSuites): { spec+: { cipherSuites+: if std.isArray(v=cipherSuites) then cipherSuites else [cipherSuites] } },
    withCurvePreferences(curvePreferences): { spec+: { curvePreferences: if std.isArray(v=curvePreferences) then curvePreferences else [curvePreferences] } },
    // **Note:** This function appends passed data to existing values
    withCurvePreferencesMixin(curvePreferences): { spec+: { curvePreferences+: if std.isArray(v=curvePreferences) then curvePreferences else [curvePreferences] } },
    withAlpnProtocols(alpnProtocols): { spec+: { alpnProtocols: if std.isArray(v=alpnProtocols) then alpnProtocols else [alpnProtocols] } },
    // **Note:** This function appends passed data to existing values
    withAlpnProtocolsMixin(alpnProtocols): { spec+: { alpnProtocols+: if std.isArray(v=alpnProtocols) then alpnProtocols else [alpnProtocols] } },
    withSniStrict(sniStrict): { spec+: { sniStrict: sniStrict } },
    withDisableSessionTickets(disableSessionTickets): { spec+: { disableSessionTickets: disableSessionTickets } },
    withPreferServerCipherSuites(preferServerCipherSuites): { spec+: { preferServerCipherSuites: preferServerCipherSuites } },
    withClientAuth(clientAuth): { spec+: { clientAuth: clientAuth } },
    // **Note:** This function appends passed data to existing values
    withClientAuthMixin(clientAuth): { spec+: { clientAuth+: clientAuth } },
    clientAuth: {
      new(clientAuthType): {
        clientAuthType: clientAuthType,
      },
      withClientAuthType(clientAuthType): { clientAuthType: clientAuthType },
      withSecretNames(secretNames): { secretNames: if std.isArray(v=secretNames) then secretNames else [secretNames] },
      // **Note:** This function appends passed data to existing values
      withSecretNamesMixin(secretNames): { secretNames+: if std.isArray(v=secretNames) then secretNames else [secretNames] },
    },
  },
}
