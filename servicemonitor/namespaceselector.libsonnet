{
  # NamespaceSelector is a selector for selecting either all namespaces or a list of namespaces.

  # New returns an instance of NamespaceSelector
  new( ): {
  },
  # Boolean describing whether all namespaces are selected in contrast to a list restricting them.	
  withAny( any ): { any: any },
  # List of namespace names.
  withMatchNames( matchNames ): { matchNames: if std.isArray(v=matchNames) then matchNames else [matchNames] },
}

