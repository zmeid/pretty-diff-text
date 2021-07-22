# PrettyDiffText
![Snapshot](https://i.imgur.com/cIUnaLpl.png)

**PrettyDiffText is wrapper of RichText which demonstrates differences between two texts visually.**

It uses Google's [diff-match-patch](https://github.com/google/diff-match-patch) library which implements [Myer's diff algorithm](https://neil.fraser.name/writing/diff/myers.pdf). It is generally considered to be the best general-purpose diff.

- :fire: **Pure Dart**: It is written purely in Dart.
- :star: **Cross-Platform**: Works on Android, iOS, macOS, Windows, Linux and the web.
- :boom: Highly Customizable: Almost everything can be customized:
  - Text style of AddedText, DeletedText, EqualText.
  - Diff cleanup types: SEMANTIC, EFFICIENCY, NONE
  - Diff algorithm tuning: DiffTimeout, EditCost
  - All customization which Flutter's RichText has.

## Installing:
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pretty_diff_text: ^1.0.0
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
  /// Default text style of RichText. Mainly will be used for the text which did not change.
  /// [addedTextStyle] and [deletedTextStyle] will inherit styles from it.
  final TextStyle defaultTextStyle;

  /// Text style of text which was added.
  final TextStyle addedTextStyle;

  /// Text style of text which was deleted.
  final TextStyle deletedTextStyle;

  /// See [DiffCleanupType] for types.
  final DiffCleanupType diffCleanupType;

  /// If the mapping phase of the diff computation takes longer than this,
  /// then the computation is truncated and the best solution to date is
  /// returned. While guaranteed to be correct, it may not be optimal.
  /// A timeout of '0' allows for unlimited computation.
  /// The default value is 1.0.
  final double diffTimeout;

  /// Cost of an empty edit operation in terms of edit characters.
  /// This value is used when [DiffCleanupType] is selected as [DiffCleanupType.EFFICIENCY]
  /// The larger the edit cost, the more aggressive the cleanup.
  /// The default value is 4.
  final int diffEditCost;

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
```

```dart
enum DiffCleanupType {
  /// Increase human readability by factoring out commonalities which are likely to be coincidental.
  SEMANTIC,

  /// Increase computational efficiency by factoring out short commonalities which are not worth the overhead.
  /// The larger the edit cost(see: [PrettyDiffText::diffEditCost]), the more aggressive the cleanup.
  EFFICIENCY,

  /// No cleanup. Raw output.
  NONE
}
```

## Demo App
Clone the demo app to play around: [DEMO](./example)

## Changelog

[CHANGELOG](./CHANGELOG.md)

## License

[MIT License](./LICENSE)

## References:
- [Google's diff-match-patch](https://github.com/google/diff-match-patch).
