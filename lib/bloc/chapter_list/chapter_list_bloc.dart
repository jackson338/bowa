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
    emit(state.copyWith(
      chapters: chapters,
      chapterNames: chapterNames,
      chapterText: chapterText,
    ));
  }

  /// Saves the text typed in the current chapter.
  void saveText(List<String> text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('$id chapterText', text);
    emit(state.copyWith(chapterText: text));
  }

//select a chapter
  void select(chapterSelect) {
    emit(state.copyWith(chapterSelected: chapterSelect));
  }

  //create a new chapter
  void addChapter(String chaptName, String chapt, String chaptText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //add to the state.chapters property
    List<String> chapterList = [];
    if (state.chapters.isNotEmpty) {
      chapterList.addAll(state.chapters);
    }

    //add to the state.chapterNames property
    List<String> chapterNames = [];
    if (state.chapterNames.isNotEmpty) {
      chapterNames.addAll(state.chapterNames);
    }

    //add to the state.chapterText property
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

//locally save the new chapter
    prefs.setStringList('$id chapters', chapterList);
    prefs.setStringList('$id chapterNames', chapterNames);
    prefs.setStringList('$id chapterText', chapterText);

    emit(state.copyWith(
        chapters: chapterList, chapterNames: chapterNames, chapterText: chapterText));
  }

//reorder chapters
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
    //chapter text
    final List<String> newChapterText = [];
    if (state.chapters.isNotEmpty) {
      newChapterText.addAll(state.chapterText);
    }

    final String chapterT = newChapterText.removeAt(oldIndex);
    newChapterText.insert(newIndex, chapterT);

    //locally save the reordered list
    prefs.setStringList('$id chapterNames', newChapterNames);
    prefs.setStringList('$id chapterText', newChapterText);
    emit(state.copyWith(chapterNames: newChapterNames, chapterText: newChapterText));
  }

//update the chapter title
  void updateTitle(String chapName, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chapterNames = [];
    chapterNames.addAll(state.chapterNames);
    chapterNames[index] = chapName;
    prefs.setStringList('$id chapterNames', chapterNames);
    emit(state.copyWith(chapterNames: chapterNames));
  }
}
