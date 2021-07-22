enum DiffCleanupType {
  /// Increase human readability by factoring out commonalities which are likely to be coincidental.
  SEMANTIC,

  /// Increase computational efficiency by factoring out short commonalities which are not worth the overhead.
  /// The larger the edit cost(see: [PrettyDiffText::diffEditCost]), the more aggressive the cleanup.
  EFFICIENCY,

  /// No cleanup. Raw output.
  NONE
}
