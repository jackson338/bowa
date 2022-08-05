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
    List<String> chapters = [];
    List<String> chapterNames = [];
    List<String> chapterText = [];
    if (prefs.getStringList('$id chapters') != null) {
      chapters = prefs.getStringList('$id chapters')!;
    }
    if (prefs.getStringList('$id chapterNames') != null) {
      chapterNames = prefs.getStringList('$id chapterNames')!;
    }
    if (prefs.getStringList('$id chapterText') != null) {
      chapterText = prefs.getStringList('$id chapterText')!;
    }
    if (prefs.getStringList('$id jsonChapters') != null) {
      for (String chapter in prefs.getStringList('$id jsonChapters')!) {
        var chapterJson = jsonDecode(chapter);
        jsonChapterText.add(chapterJson);
      }
    }
    emit(state.copyWith(
      chapters: chapters,
      chapterNames: chapterNames,
      chapterText: chapterText,
      jsonChapterText: jsonChapterText,
    ));
  }

  /// Saves the text typed in the current chapter.
  void saveText(String text, QuillController cont, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //creating json string to be used while app is running
    var json = jsonEncode(cont.document.toDelta().toJson());
    List<dynamic> jsons = [];
    //creating json strings to be saved
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
    prefs.setStringList('$id jsonChapters', chapterJsonTexts);
    prefs.setStringList('$id chapterText', unmodifiedText);

    emit(state.copyWith(chapterText: unmodifiedText, jsonChapterText: jsons));
  }

// select a chapter
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
      jsonStrings.addAll(state.chapterText);
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
    if (prefs.getStringList('$id chapters') != null) {
      chapterList = prefs.getStringList('$id chapters')!;
    }
    if (prefs.getStringList('$id chapterNames') != null) {
      chapterNames = prefs.getStringList('$id chapterNames')!;
    }
    if (prefs.getStringList('$id chapterText') != null) {
      chapterText = prefs.getStringList('$id chapterText')!;
    }

    chapterList.add(chapt);
    chapterNames.add(chaptName);
    chapterText.add(chaptText);
    jsonStrings.add(jsonString);

    // locally save new chapter data
    prefs.setStringList('$id chapters', chapterList);
    prefs.setStringList('$id chapterNames', chapterNames);
    prefs.setStringList('$id chapterText', chapterText);
    prefs.setStringList('$id jsonChapters', jsonStrings);

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
    prefs.setStringList('$id chapterNames', newChapterNames);
    prefs.setStringList('$id chapterText', newChapterText);
    prefs.setStringList('$id jsonChapters', chapterJsonTexts);

    emit(state.copyWith(chapterNames: newChapterNames, chapterText: newChapterText,jsonChapterText: newJsonList));
  }

  // update the chapter title
  void updateTitle(String chapName, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chapterNames = [];
    chapterNames.addAll(state.chapterNames);
    chapterNames[index] = chapName;
    prefs.setStringList('$id chapterNames', chapterNames);
    emit(state.copyWith(chapterNames: chapterNames));
  }
}
