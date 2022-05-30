{
  # RelabelConfig allows dynamic rewriting of the label set, being applied to samples before ingestion. It defines <metric_relabel_configs>-section of Prometheus configuration.
  # More info: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#metric_relabel_configs

  # New returns an instance of endpoint
  new( ): {
  },
  # The source labels select values from existing labels. Their content is concatenated using the configured separator and matched against the configured regular expression for the replace, keep, and drop actions.
  withSourceLabels( sourceLabels ): { sourceLabels: if std.isArray(v=sourceLabels) then sourceLabels else [sourceLabels] },
  # The source labels select values from existing labels. Their content is concatenated using the configured separator and matched against the configured regular expression for the replace, keep, and drop actions.
  # **Note:** This function appends passed data to existing values
  withSourceLabelsMixin( sourceLabels ): { sourceLabels+: if std.isArray(v=sourceLabels) then sourceLabels else [sourceLabels] },
  # Separator placed between concatenated source label values. default is ';'.
  withSeparator( separator ): { separator: separator },
  # Label to which the resulting value is written in a replace action. It is mandatory for replace actions. Regex capture groups are available.
  withTargetLabel( targetLabel ): { targetLabel: targetLabel },
  # Regular expression against which the extracted value is matched. Default is '(.*)'
  withRegex( Regex ): { regex: Regex },
  # Modulus to take of the hash of the source label values.
  withModulus( modulus ): { modulus: modulus },
  # Replacement value against which a regex replace is performed if the regular expression matches. Regex capture groups are available. Default is '$1'
  withReplacement( replacement ): { replacement: replacement },
  # Action to perform based on regex matching. Default is 'replace'
  withAction( action ): { action: action },
}

