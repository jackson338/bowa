part of 'chapter_list.dart';

class ChapterListBloc extends Cubit<ChapterListState> {
  final BuildContext context;
  final String id;
  ChapterListBloc({
    required this.context,
    required this.id,
  }) : super(const ChapterListState()) {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List jsonChapterText = [];
    List<int> drafts = [];
    List<String> chapters = [];
    List<String> chapterNames = [];
    List<String> chapterText = [];
    int wordGoal = 50000;
    int selectedDraft = 1;
    if (prefs.getStringList('$id drafts') != null) {
      final draftStrings = prefs.getStringList('$id drafts')!;
      for (final draftString in draftStrings) {
        drafts.add(int.parse(draftString));
      }
    } else {
      final draftStrings =
          List.generate(state.drafts.length, (index) => '${state.drafts[index]}');
      for (final draftString in draftStrings) {
        drafts.add(int.parse(draftString));
      }
      prefs.setStringList('$id drafts', draftStrings);
    }
    if (prefs.getInt('$id selected draft') != null) {
      selectedDraft = prefs.getInt('$id selected draft')!;
    }
    if (prefs.getStringList('$id $selectedDraft chapters') != null) {
      chapters = prefs.getStringList('$id $selectedDraft chapters')!;
    } else if (prefs.getStringList('$id chapters') != null) {
      final backupChapters = prefs.getStringList('$id chapters')!;
      prefs.setStringList('$id $selectedDraft chapters', backupChapters);
      chapters = backupChapters;
      prefs.getStringList('$id chapters');
    }
    if (prefs.getStringList('$id $selectedDraft chapterNames') != null) {
      chapterNames = prefs.getStringList('$id $selectedDraft chapterNames')!;
    } else if (prefs.getStringList('$id chapterNames') != null) {
      final backupNames = prefs.getStringList('$id chapterNames')!;
      prefs.setStringList('$id $selectedDraft chapterNames', backupNames);
      chapterNames = backupNames;
      prefs.remove('$id chapterNames');
    }
    if (prefs.getStringList('$id $selectedDraft chapterText') != null) {
      chapterText = prefs.getStringList('$id $selectedDraft chapterText')!;
    } else if (prefs.getStringList('$id chapterText') != null) {
      final backupChapterText = prefs.getStringList('$id chapterText')!;
      prefs.setStringList('$id $selectedDraft chapterText', backupChapterText);
      chapterText = backupChapterText;
      prefs.getStringList('$id chapterText');
    }
    if (prefs.getStringList('$id $selectedDraft jsonChapters') != null) {
      for (String chapter in prefs.getStringList('$id $selectedDraft jsonChapters')!) {
        var chapterJson = jsonDecode(chapter);
        jsonChapterText.add(chapterJson);
        // Clipboard.setData(ClipboardData(text: jsonChapterText.toString()));
      }
    } else if (prefs.getStringList('$id jsonChapters') != null) {
      final backupJsonChapterText = prefs.getStringList('$id jsonChapters')!;
      for (String chapter in backupJsonChapterText) {
        var chapterJson = jsonDecode(chapter);
        jsonChapterText.add(chapterJson);
        // Clipboard.setData(ClipboardData(text: jsonChapterText.toString()));
      }
      prefs.setStringList('$id $selectedDraft jsonChapters', backupJsonChapterText);
      prefs.remove('$id jsonChapters');
    }
    if (prefs.getString('$id $selectedDraft word goal') != null) {
      String wordgoal = prefs.getString('$id $selectedDraft word goal')!;
      wordGoal = int.parse(wordgoal);
    } else if (prefs.getString('$id word goal') != null) {
      final backupWordCount = prefs.getString('$id word goal')!;
      prefs.setString('$id $selectedDraft word goal', backupWordCount);
      String wordgoal = backupWordCount;
      wordGoal = int.parse(wordgoal);
      prefs.remove('$id word goal');
    }
    emit(state.copyWith(
      chapters: chapters,
      chapterNames: chapterNames,
      chapterText: chapterText,
      jsonChapterText: jsonChapterText,
      wordGoal: wordGoal,
      drafts: drafts,
      selectedDraft: selectedDraft,
    ));
  }

  void selectDraft(int selected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('$id selected draft', selected);
    emit(state.copyWith(selectedDraft: selected));
    init();
  }

  void newDraft() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> drafts = [];
    drafts.addAll(state.drafts);
    drafts.add(state.drafts.length + 1);
    prefs.setInt('$id selected draft', drafts.last);
    final draftStrings = List.generate(drafts.length, (index) => '${drafts[index]}');
    prefs.setStringList('$id drafts', draftStrings);
    emit(state.copyWith(drafts: drafts, selectedDraft: drafts.last));
    init();
  }

  void deleteBook(
    String title,
    WritingBloc writingBloc,
  ) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: FittedBox(
              child: Row(
                children: [
                  Text(
                    'Are you sure you want to Delete ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                  Text(
                    '$title?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            actions: [
              FittedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              const BorderSide(width: 1, style: BorderStyle.solid)),
                        ),
                        onPressed: () {
                          deletePrefs(title);
                          writingBloc.deleteBook(id, title);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Text(
                              'Yes, delete $title',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.headline1!.color,
                                  fontSize: 20.0),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              const BorderSide(width: 1, style: BorderStyle.solid)),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Row(
                          children: [
                            Text(
                              "No, don't delete $title",
                              maxLines: 1,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.headline1!.color,
                                fontSize: 20.0,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void deletePrefs(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('$id chapters');
    prefs.remove('$id chapterNames');
    prefs.remove('$id chapterText');
    prefs.remove('$id jsonChapters');
    prefs.remove('$id note keys');
    prefs.remove('$id note vals');
    prefs.remove('$id outlines');
    prefs.remove('$id characters');
    prefs.remove('$id note');
    prefs.remove('$id $title note json');
    for (final index in state.drafts) {
      prefs.remove('$id $index chapters');
      prefs.remove('$id $index chapterNames');
      prefs.remove('$id $index chapterText');
      prefs.remove('$id $index jsonChapters');
    }
  }

  /// Saves the text typed in the current chapter.
  void saveText(String text, QuillController cont, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //creating json string to be used while app is running
    var json = jsonEncode(cont.document.toDelta().toJson());
    List<dynamic> jsons = [];
    // creating json strings to be saved
    List<String> chapterJsonTexts = [];
    if (state.jsonChapterText.isNotEmpty) {
      for (dynamic j in state.jsonChapterText) {
        chapterJsonTexts.add(jsonEncode(j));
      }
    }
    //creating json object for continued editing
    if (state.jsonChapterText.isNotEmpty) {
      jsons.addAll(state.jsonChapterText);
      jsons[index] = cont.document.toDelta().toJson();
    } else {
      jsons.add(cont.document.toDelta().toJson());
    }
    List<String> unmodifiedText = [];
    if (state.chapterText.isNotEmpty) {
      unmodifiedText.addAll(state.chapterText);
    }
    unmodifiedText[state.chapterSelected] = text;
    chapterJsonTexts[index] = json;
    prefs.setStringList('$id ${state.selectedDraft} jsonChapters', chapterJsonTexts);
    prefs.setStringList('$id ${state.selectedDraft} chapterText', unmodifiedText);

    emit(state.copyWith(chapterText: unmodifiedText, jsonChapterText: jsons));
  }

/// select a chapter
  void select(chapterSelect) {
    emit(state.copyWith(chapterSelected: chapterSelect));
  }

  // create a new chapter
  void addChapter(
      String chaptName, String chapt, String chaptText, QuillController cont) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //add to the state.chapters property
    List<String> chapterList = [];
    if (state.chapters.isNotEmpty) {
      chapterList.addAll(state.chapters);
    }
    //add json chapterText
    var json = cont.document.toDelta().toJson();
    List<dynamic> jsonChapterText = [];
    if (state.jsonChapterText.isNotEmpty) {
      jsonChapterText.addAll(state.jsonChapterText);
    }
    jsonChapterText.add(json);

    // saving json strings
    var jsonString = jsonEncode(cont.document.toDelta().toJson());
    List<String> jsonStrings = [];
    if (state.jsonChapterText.isNotEmpty) {
      for (final obj in state.jsonChapterText) {
        jsonStrings.add(jsonEncode(obj));
      }
    }

    // add to the state.chapterNames property
    List<String> chapterNames = [];
    if (state.chapterNames.isNotEmpty) {
      chapterNames.addAll(state.chapterNames);
    }

    // add to the state.chapterText property
    List<String> chapterText = [];
    if (state.chapterText.isNotEmpty) {
      chapterText.addAll(state.chapterText);
    }
    if (prefs.getStringList('$id ${state.selectedDraft} chapters') != null) {
      chapterList = prefs.getStringList('$id ${state.selectedDraft} chapters')!;
    }
    if (prefs.getStringList('$id ${state.selectedDraft} chapterNames') != null) {
      chapterNames = prefs.getStringList('$id ${state.selectedDraft} chapterNames')!;
    }
    if (prefs.getStringList('$id ${state.selectedDraft} chapterText') != null) {
      chapterText = prefs.getStringList('$id ${state.selectedDraft} chapterText')!;
    }

    chapterList.add(chapt);
    chapterNames.add(chaptName);
    chapterText.add(chaptText);
    jsonStrings.add(jsonString);

    // locally save new chapter data
    prefs.setStringList('$id ${state.selectedDraft} chapters', chapterList);
    prefs.setStringList('$id ${state.selectedDraft} chapterNames', chapterNames);
    prefs.setStringList('$id ${state.selectedDraft} chapterText', chapterText);
    prefs.setStringList('$id ${state.selectedDraft} jsonChapters', jsonStrings);

    emit(state.copyWith(
        chapters: chapterList,
        chapterNames: chapterNames,
        chapterText: chapterText,
        jsonChapterText: jsonChapterText));
  }

  // reorder chapters
  void reorder(int oldIndex, int newIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<String> newChapterNames = [];
    if (state.chapters.isNotEmpty) {
      newChapterNames.addAll(state.chapterNames);
    }
    final String chapterName = newChapterNames.removeAt(oldIndex);
    newChapterNames.insert(newIndex, chapterName);
    // chapter text
    final List<String> newChapterText = [];
    if (state.chapters.isNotEmpty) {
      newChapterText.addAll(state.chapterText);
    }
    final String chapterT = newChapterText.removeAt(oldIndex);
    newChapterText.insert(newIndex, chapterT);

    // saving json strings
    List<dynamic> newJsonList = [];
    newJsonList.addAll(state.jsonChapterText);
    final newJSON = newJsonList.removeAt(oldIndex);
    newJsonList.insert(newIndex, newJSON);

    List<String> chapterJsonTexts = [];
    for (dynamic j in newJsonList) {
      chapterJsonTexts.add(jsonEncode(j));
    }

    // locally save the reordered list
    prefs.setStringList('$id ${state.selectedDraft} chapterNames', newChapterNames);
    prefs.setStringList('$id ${state.selectedDraft} chapterText', newChapterText);
    prefs.setStringList('$id ${state.selectedDraft} jsonChapters', chapterJsonTexts);

    emit(state.copyWith(
        chapterNames: newChapterNames,
        chapterText: newChapterText,
        jsonChapterText: newJsonList));
  }

  // update the chapter title
  void updateTitle(String chapName, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chapterNames = [];
    chapterNames.addAll(state.chapterNames);
    chapterNames[index] = chapName;
    prefs.setStringList('$id ${state.selectedDraft} chapterNames', chapterNames);
    emit(state.copyWith(chapterNames: chapterNames));
  }
}
