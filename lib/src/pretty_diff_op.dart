/// Represents the type of operation in a diff.
///
/// This enum is used to indicate whether a piece of text was:
/// - [INSERT]: Added in the new text (not present in the old text)
/// - [DELETE]: Removed from the old text (not present in the new text)
/// - [EQUAL]: Unchanged between the old and new text
enum PrettyDiffOp {
  INSERT,
  DELETE,
  EQUAL,
}
