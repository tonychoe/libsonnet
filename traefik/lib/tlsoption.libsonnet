{
  metadata: {
    // Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
    withLabels(labels): { metadata+: { labels: labels } },
    // Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
    // **Note:** This function appends passed data to existing values
    withLabelsMixin(labels): { metadata+: { labels+: labels } },
    // Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
    withName(name): { metadata+: { name: name } },
  },

  // New returns an instance of tlsOption
  // More info: https://doc.traefik.io/traefik/reference/dynamic-configuration/kubernetes-crd/
  new(name): {
               apiVersion: 'traefik.io/v1alpha1',
               kind: 'TLSOption',
             } + self.metadata.withName(name=name) +
             self.metadata.withLabelsMixin({
               'app.kubernetes.io/name': 'traefik',
               'app.kubernetes.io/instance': name,
             }),
  spec: {
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
