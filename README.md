# PrettyDiffText
![Snapshot](https://i.imgur.com/cIUnaLpl.png)

**PrettyDiffText is wrapper of RichText which demonstrates differences between two texts visually.**

By default, it uses Google's [diff-match-patch](https://github.com/google/diff-match-patch) library which implements [Myer's diff algorithm](https://neil.fraser.name/writing/diff/myers.pdf). It is generally considered to be the best general-purpose diff.

- :fire: **Pure Dart**: It is written purely in Dart.
- :star: **Cross-Platform**: Works on Android, iOS, macOS, Windows, Linux and the web.
- :boom: **Highly Customizable**: Almost everything can be customized:
  - Text style of AddedText, DeletedText, EqualText.
  - Diff cleanup types: SEMANTIC, EFFICIENCY, NONE.
  - Diff algorithm tuning: DiffTimeout, EditCost.
  - Bring your own diffs: calculate the diffs using your own algorithm.
  - All customization which Flutter's RichText has.

## Installing:
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pretty_diff_text: ^2.1.0
```

## Import

```dart
import 'package:pretty_diff_text/pretty_diff_text.dart';
```

## How to use
It is easy as using Text widget!
```dart
PrettyDiffText(
  oldText: "Your old text",
  newText: "Your new text",
  )
```
![Snapshot](https://i.imgur.com/fGNXMYSl.png)

## Customization
Those properties are available for customization:
```dart
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
```

## Bring Your Own Diffs
If you'd like to calculate your own diffs, you can do so and pass them via the `withDiffs` contructor:

```dart
PrettyDiffText.withDiffs(
  diffs: _getDiffs(
    oldText: _oldTextEditingController.text,
    newText: _newTextEditingController.text,
    diffCleanupType: _diffCleanupType,
    diffTimeout: _diffTimeout,
    diffEditCost: _diffEditCost,
  ),
)
```

## Demo Apps
Clone the demo app to play around: [DEMO](./example)

## Changelog

[CHANGELOG](./CHANGELOG.md)

## License

[MIT License](./LICENSE)

## References:
- [Google's diff-match-patch](https://github.com/google/diff-match-patch).
