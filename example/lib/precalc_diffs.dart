import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'Demo of PrettyDiffText with Precalculated Diffs';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _oldTextEditingController;
  late final TextEditingController _newTextEditingController;
  late final TextEditingController _diffTimeoutEditingController;
  late final TextEditingController _editCostEditingController;
  DiffCleanupType? _diffCleanupType = DiffCleanupType.SEMANTIC;

  @override
  void initState() {
    _oldTextEditingController = TextEditingController();
    _newTextEditingController = TextEditingController();
    _diffTimeoutEditingController = TextEditingController();
    _editCostEditingController = TextEditingController();
    _oldTextEditingController.text =
        "Let's go to Hatay and eat something delicious. Because everything there is super delicious";
    _newTextEditingController.text =
        "Let's go to Antakya eat something very delicious and unique. Because everything(especially kebabs and kunefe) super delicious!!!";
    _diffTimeoutEditingController.text = "1.0";
    _editCostEditingController.text = "4";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _oldTextEditingController,
                      maxLines: 5,
                      onChanged: (string) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "Old Text",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _newTextEditingController,
                      maxLines: 5,
                      onChanged: (string) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "New Text",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: EdgeInsets.only(top: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "--- PrettyDiffText OUTPUT ---",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: PrettyDiffText.withDiffs(
                          textAlign: TextAlign.center,
                          diffs: _getDiffs(
                            oldText: _oldTextEditingController.text,
                            newText: _newTextEditingController.text,
                            diffCleanupType:
                                _diffCleanupType ?? DiffCleanupType.SEMANTIC,
                            diffTimeout: diffTimeoutToDouble(),
                            diffEditCost: editCostToDouble(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(children: [
                Text(
                  "Diff timeout: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _diffTimeoutEditingController,
                    onChanged: (string) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Text(
                  " seconds",
                ),
              ]),
            ),
            Text(
              "If the mapping phase of the diff computation takes longer than this, then the computation is truncated and the best solution to date is returned. While guaranteed to be correct, it may not be optimal. A timeout of '0' allows for unlimited computation.",
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 3),
              child: Text(
                "Post-diff cleanup:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            RadioListTile(
                title: Text("Semantic Cleanup"),
                subtitle: Text(
                    "Increase human readability by factoring out commonalities which are likely to be coincidental"),
                value: DiffCleanupType.SEMANTIC,
                groupValue: _diffCleanupType,
                onChanged: (DiffCleanupType? value) {
                  setState(() {
                    _diffCleanupType = value;
                  });
                }),
            RadioListTile(
                title: Row(
                  children: [
                    Text("Efficiency Cleanup. Edit cost: "),
                    SizedBox(
                        width: 40,
                        height: 30,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _editCostEditingController,
                          onChanged: (string) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ))
                  ],
                ),
                subtitle: Text(
                    "Increase computational efficiency by factoring out short commonalities which are not worth the overhead. The larger the edit cost, the more aggressive the cleanup"),
                value: DiffCleanupType.EFFICIENCY,
                groupValue: _diffCleanupType,
                onChanged: (DiffCleanupType? value) {
                  setState(() {
                    _diffCleanupType = value;
                  });
                }),
            RadioListTile(
                title: Text("No Cleanup"),
                subtitle: Text("Raw output"),
                value: DiffCleanupType.NONE,
                groupValue: _diffCleanupType,
                onChanged: (DiffCleanupType? value) {
                  setState(() {
                    _diffCleanupType = value;
                  });
                }),
          ],
        ),
      ),
    );
  }

  double diffTimeoutToDouble() {
    try {
      final response = double.parse(_diffTimeoutEditingController.text);
      ScaffoldMessenger.of(context).clearSnackBars();
      return response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Enter a valid double value for edit cost")));
      });
      return 1.0; // default value for timeout
    }
  }

  int editCostToDouble() {
    try {
      final response = int.parse(_editCostEditingController.text);
      ScaffoldMessenger.of(context).clearSnackBars();
      return response;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Enter a valid integer value for edit cost")));
      });
      return 4; // default value for edit cost
    }
  }

  List<PrettyDiff> _getDiffs(
      {required String oldText,
      required String newText,
      required DiffCleanupType diffCleanupType,
      required double diffTimeout,
      required int diffEditCost}) {
    final dmp = DiffMatchPatch()
      ..diffTimeout = diffTimeout
      ..diffEditCost = diffEditCost;

    final diffs = dmp.diff(oldText, newText);
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

    return diffs
        .map((diff) => PrettyDiff(
              text: diff.text,
              operation: _prettyDiffOpFromDiffOp(diff.operation),
            ))
        .toList();
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
}
