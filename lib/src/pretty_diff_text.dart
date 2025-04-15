import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:pretty_diff_text/src/diff_cleanup_type.dart';

import 'pretty_diff.dart';
import 'pretty_diff_op.dart';

class PrettyDiffText extends StatelessWidget {
  /// Default text style of RichText. Mainly will be used for the text which did not change.
  /// [addedTextStyle] and [deletedTextStyle] will inherit styles from it.
  final TextStyle defaultTextStyle;

  /// Text style of text which was added.
  final TextStyle addedTextStyle;

  /// Text style of text which was deleted.
  final TextStyle deletedTextStyle;

  /// !!! DERIVED PROPERTIES FROM FLUTTER'S [RichText] IN ORDER TO ALLOW CUSTOMIZABILITY !!!
  /// See [RichText] for documentation.
  ///
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  late final List<TextSpan> textSpans;

  /// Creates a PrettyDiffText widget that computes the differences between two texts.
  ///
  /// The [oldText] is the original text to compare against.
  /// The [newText] is the modified text to compare with.
  ///
  /// The [diffCleanupType] determines how the diff results are cleaned up:
  /// - [DiffCleanupType.SEMANTIC]: Reduces the number of edits by eliminating semantically trivial equalities (default)
  /// - [DiffCleanupType.EFFICIENCY]: Reduces the number of edits by eliminating operationally trivial equalities
  /// - [DiffCleanupType.NONE]: No cleanup, raw diff output
  ///
  /// The [defaultTextStyle] is applied to unchanged text.
  /// The [addedTextStyle] is applied to text that was added (present in [newText] but not in [oldText]).
  /// The [deletedTextStyle] is applied to text that was deleted (present in [oldText] but not in [newText]).
  ///
  /// The [diffTimeout] limits computation time in seconds. If the mapping phase takes longer than this,
  /// computation is truncated and returns the best solution found. A value of 0 allows unlimited computation.
  ///
  /// The [diffEditCost] affects cleanup when using [DiffCleanupType.EFFICIENCY]. Higher values result in
  /// more aggressive cleanup.
  ///
  /// The following properties are passed directly to the underlying [RichText] widget:
  /// - [textAlign]: How the text should be aligned horizontally.
  /// - [textDirection]: The directionality of the text.
  /// - [softWrap]: Whether the text should break at soft line breaks.
  /// - [overflow]: How visual overflow should be handled.
  /// - [textScaleFactor]: The number of font pixels for each logical pixel.
  /// - [maxLines]: An optional maximum number of lines for the text to span.
  /// - [locale]: Used to select region-specific glyphs and formatting.
  /// - [strutStyle]: Defines the strut, which sets minimum vertical layout metrics.
  /// - [textWidthBasis]: Defines how to measure the width of the rendered text.
  /// - [textHeightBehavior]: Defines how the paragraph will apply TextStyle.height to the ascent of the first line and descent of the last line.
  PrettyDiffText({
    Key? key,
    required String oldText,
    required String newText,
    DiffCleanupType diffCleanupType = DiffCleanupType.SEMANTIC,
    this.defaultTextStyle = const TextStyle(color: Colors.black),
    this.addedTextStyle = const TextStyle(
      backgroundColor: Color.fromARGB(255, 139, 197, 139),
    ),
    this.deletedTextStyle = const TextStyle(
      backgroundColor: Color.fromARGB(255, 255, 129, 129),
      decoration: TextDecoration.lineThrough,
    ),
    double diffTimeout = 1.0,
    int diffEditCost = 4,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key) {
    final dmp = DiffMatchPatch()
      ..diffTimeout = diffTimeout
      ..diffEditCost = diffEditCost;

    final diffs = dmp.diff(oldText, newText);
    _cleanupDiffs(dmp, diffs, diffCleanupType);

    textSpans = _textSpansFromDiffs([
      for (final diff in diffs)
        PrettyDiff(
          text: diff.text,
          operation: _prettyDiffOpFromDiffOp(diff.operation),
        )
    ]);
  }

  /// Creates a PrettyDiffText widget with pre-computed diffs.
  ///
  /// The [diffs] parameter should contain the pre-computed differences between two texts.
  /// This constructor is useful when you've already computed the diffs elsewhere or
  /// need to apply custom diff processing before displaying.
  ///
  /// The [defaultTextStyle] is applied to unchanged text.
  /// The [addedTextStyle] is applied to text that was added.
  /// The [deletedTextStyle] is applied to text that was deleted.
  ///
  /// The [diffTimeout] and [diffEditCost] parameters are included for API consistency
  /// but are not used in this constructor since diffs are pre-computed.
  ///
  /// The remaining parameters control the text rendering behavior and are passed
  /// directly to the underlying [RichText] widget.
  PrettyDiffText.withDiffs({
    Key? key,
    required List<PrettyDiff> diffs,
    this.defaultTextStyle = const TextStyle(color: Colors.black),
    this.addedTextStyle = const TextStyle(
      backgroundColor: Color.fromARGB(255, 139, 197, 139),
    ),
    this.deletedTextStyle = const TextStyle(
      backgroundColor: Color.fromARGB(255, 255, 129, 129),
      decoration: TextDecoration.lineThrough,
    ),
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key) {
    textSpans = _textSpansFromDiffs(diffs);
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '',
        style: this.defaultTextStyle,
        children: textSpans,
      ),
      textAlign: this.textAlign,
      textDirection: this.textDirection,
      softWrap: this.softWrap,
      overflow: this.overflow,
      maxLines: this.maxLines,
      textScaler: TextScaler.linear(this.textScaleFactor),
      locale: this.locale,
      strutStyle: this.strutStyle,
      textWidthBasis: this.textWidthBasis,
      textHeightBehavior: this.textHeightBehavior,
    );
  }

  TextStyle _getTextStyleByDiffOperation(PrettyDiff diff) =>
      switch (diff.operation) {
        PrettyDiffOp.INSERT => addedTextStyle,
        PrettyDiffOp.DELETE => deletedTextStyle,
        PrettyDiffOp.EQUAL => defaultTextStyle,
      };

  void _cleanupDiffs(
    DiffMatchPatch dmp,
    List<Diff> diffs,
    DiffCleanupType diffCleanupType,
  ) {
    switch (diffCleanupType) {
      case DiffCleanupType.SEMANTIC:
        dmp.diffCleanupSemantic(diffs);
        break;
      case DiffCleanupType.EFFICIENCY:
        dmp.diffCleanupEfficiency(diffs);
        break;
      case DiffCleanupType.NONE:
        // No clean up, do nothing.
        break;
    }
  }

  PrettyDiffOp _prettyDiffOpFromDiffOp(int diffOp) {
    switch (diffOp) {
      case DIFF_INSERT:
        return PrettyDiffOp.INSERT;
      case DIFF_DELETE:
        return PrettyDiffOp.DELETE;
      case DIFF_EQUAL:
        return PrettyDiffOp.EQUAL;
      default:
        throw "Unknown DiffCleanupType. DiffCleanupType should be one of: "
            "[SEMANTIC], [EFFICIENCY] or [NONE].";
    }
  }

  List<TextSpan> _textSpansFromDiffs(List<PrettyDiff> diffs) => [
        for (final diff in diffs)
          TextSpan(text: diff.text, style: _getTextStyleByDiffOperation(diff))
      ];
}
