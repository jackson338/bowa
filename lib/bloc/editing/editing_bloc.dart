part of 'editing.dart';

class EditingBloc extends Cubit<EditingState> {
  final BuildContext context;
  final ChapterListState chapState;
  EditingBloc({
    required this.context,
    required this.chapState,
  }) : super(const EditingState()) {
    init();
  }

  void init() {
    emit(
      state.copyWith(
        chapterNames: chapState.chapterNames,
        chapters: chapState.chapters,
        chapterSelected: chapState.chapterSelected,
        jsonChapterText: chapState.jsonChapterText,
      ),
    );
  }

  void openDrawer(final bool status) {
    emit(state.copyWith(drawerOpen: status));
  }

  void saveText(QuillController cont) {
    List<dynamic> jsonTexts = [];
    if (state.jsonChapterText.isNotEmpty) {
      jsonTexts.addAll(state.jsonChapterText);
    }
    jsonTexts[state.chapterSelected] = cont.document.toDelta().toJson();
    emit(state.copyWith(jsonChapterText: jsonTexts));
  }

//select a chapter
  void select(chapterSelect) {
    emit(state.copyWith(chapterSelected: chapterSelect));
  }

  //create a new chapter
  void addChapter(String chaptName, String chapt, String chaptText, int chapterSelect,
      QuillController cont) {
    //add to the state.chapters property
    List<String> chapterList = [];
    if (state.chapters.isNotEmpty) {
      chapterList.addAll(state.chapters);
    }
    chapterList.add(chapt);
    //add to the state.chapterNames property
    List<String> chapterNames = [];
    if (state.chapterNames.isNotEmpty) {
      chapterNames.addAll(state.chapterNames);
    }
    chapterNames.add(chaptName);

    //add json chapterText
    var json = cont.document.toDelta().toJson();
    List<dynamic> jsonChapterText = [];
    if (state.jsonChapterText.isNotEmpty) {
      jsonChapterText.addAll(state.jsonChapterText);
    }
    jsonChapterText.add(json);

    saveText(cont);

    emit(state.copyWith(
      chapters: chapterList,
      chapterNames: chapterNames,
      chapterSelected: chapterSelect,
      jsonChapterText: jsonChapterText,
    ));
  }

//reorder chapters
  void reorder(int oldIndex, int newIndex) {
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
    final List<dynamic> newChapterText = [];
    if (state.jsonChapterText.isNotEmpty) {
      newChapterText.addAll(state.jsonChapterText);
    }
    final chapterT = newChapterText.removeAt(oldIndex);
    newChapterText.insert(newIndex, chapterT);
    emit(state.copyWith(
        // chapters: newChapters,
        chapterNames: newChapterNames,
        jsonChapterText: newChapterText));
  }

//update the chapter title
  void updateTitle(String chapName, int index) {
    List<String> chapterNames = [];
    chapterNames.addAll(state.chapterNames);
    chapterNames[index] = chapName;
    emit(state.copyWith(chapterNames: chapterNames));
  }
}
