import 'pretty_diff_op.dart';

/// Represents a segment of text with its associated diff operation.
///
/// This class is used to store the result of a diff operation between two texts.
/// Each instance contains:
/// - [text]: The actual text segment
/// - [operation]: The type of operation (INSERT, DELETE, or EQUAL) that applies to this text
class PrettyDiff {
  /// Creates a new PrettyDiff instance.
  ///
  /// [text] is the text segment from the diff.
  /// [operation] indicates whether this text was added, deleted, or remained unchanged.
  PrettyDiff({required this.text, required this.operation});

  /// The text segment from the diff.
  final String text;

  /// The operation type that applies to this text segment.
  final PrettyDiffOp operation;
}
