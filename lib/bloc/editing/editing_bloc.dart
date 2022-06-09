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
        chapterText: chapState.chapterText,
        chapters: chapState.chapters,
        chapterSelected: chapState.chapterSelected,
      ),
    );
  }

  void saveText(List<String> text) {
    emit(state.copyWith(chapterText: text));
  }

//select a chapter
  void select(chapterSelect) {
    emit(state.copyWith(chapterSelected: chapterSelect));
  }

  //create a new chapter
  void addChapter(String chaptName, String chapt, String chaptText, int chapterSelect) {
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
    //add to the state.chapterText property
    List<String> chapterText = [];
    if (state.chapterText.isNotEmpty) {
      chapterText.addAll(state.chapterText);
    }
    chapterText.add(chaptText);
    emit(state.copyWith(
        chapters: chapterList,
        chapterNames: chapterNames,
        chapterText: chapterText,
        chapterSelected: chapterSelect));
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
    final List<String> newChapterText = [];
    if (state.chapters.isNotEmpty) {
      newChapterText.addAll(state.chapterText);
    }
    final String chapterT = newChapterText.removeAt(oldIndex);
    newChapterText.insert(newIndex, chapterT);
    emit(state.copyWith(
        // chapters: newChapters,
        chapterNames: newChapterNames,
        chapterText: newChapterText));
  }

//update the chapter title
  void updateTitle(String chapName, int index) {
    List<String> chapterNames = [];
    chapterNames.addAll(state.chapterNames);
    chapterNames[index] = chapName;
    emit(state.copyWith(chapterNames: chapterNames));
  }
}
