part of 'editing.dart';

class EditingBloc extends Cubit<EditingState> {
  final BuildContext context;
  final ChapterListState chapState;
  final int bookIndex;
  final LoginState lState;
  EditingBloc({
    required this.context,
    required this.chapState,
    required this.bookIndex,
    required this.lState,
  }) : super(const EditingState()) {
    init();
  }

  void init() {
    bool tools = false;
    if (kIsWeb || Theme.of(context).platform == TargetPlatform.macOS) {
      tools = true;
    }
      emit(
      state.copyWith(
        tools: tools,
        chapterNames: lState.user!.library![bookIndex]
            .chapterTitles[lState.user!.library![bookIndex].selectedDraft],
        chapters: lState.user!.library![bookIndex]
            .chapters[lState.user!.library![bookIndex].selectedDraft],
        chapterSelected: chapState.chapterSelected,
        jsonChapterText: lState.user!.library![bookIndex]
            .jsonChapterTexts[lState.user!.library![bookIndex].selectedDraft],
      ),
    );
  }

  void openDrawer(final bool status) {
    emit(state.copyWith(drawerOpen: status));
  }

  void tool() {
    emit(state.copyWith(tools: !state.tools));
  }

  void editing(bool editing) {
    emit(state.copyWith(editing: editing));
  }

  void select(int chapterSelect, LoginState ls) {
    emit(state.copyWith(chapterSelected: chapterSelect));
    emit(
      state.copyWith(
        chapterNames: ls.user!.library![bookIndex]
            .chapterTitles[ls.user!.library![bookIndex].selectedDraft],
        chapters: ls.user!.library![bookIndex]
            .chapters[ls.user!.library![bookIndex].selectedDraft],
        chapterSelected: chapterSelect,
        jsonChapterText: ls.user!.library![bookIndex]
            .jsonChapterTexts[ls.user!.library![bookIndex].selectedDraft],
      ),
    );
  }

  void addChapter(String chaptName, String chapt, String chaptText, int chapterSelect,
      QuillController cont) {
    List<String> chapterList = [];
    if (state.chapters.isNotEmpty) {
      chapterList.addAll(state.chapters);
    }
    chapterList.add(chapt);
    List<String> chapterNames = [];
    if (state.chapterNames.isNotEmpty) {
      chapterNames.addAll(state.chapterNames);
    }
    chapterNames.add(chaptName);

    var json = cont.document.toDelta().toJson();
    List<dynamic> jsonChapterText = [];
    if (state.jsonChapterText.isNotEmpty) {
      jsonChapterText.addAll(state.jsonChapterText);
    }
    jsonChapterText.add(json);

    emit(state.copyWith(
      chapters: chapterList,
      chapterNames: chapterNames,
      chapterSelected: chapterSelect,
      jsonChapterText: jsonChapterText,
    ));
  }

  void updateTitle(String chapName, int index) {
    List<String> chapterNames = [];
    chapterNames.addAll(state.chapterNames);
    chapterNames[index] = chapName;
    emit(state.copyWith(chapterNames: chapterNames));
  }
}
