part of 'writing.dart';

class WritingBloc extends Cubit<WritingState> {
  final BuildContext context;
  final LoginBloc loginBloc;
  WritingBloc({required this.context, required this.loginBloc})
      : super(const WritingState(library: [])) {
    init();
  }

  void init() {
    emit(state.copyWith(library: loginBloc.state.user!.library));
  }

  void updateTitles() {
    emit(state.copyWith(titlesUpdated: true));
  }

  void createDraft(TextEditingController titleController, BuildContext sheetContext,
      WritingState writingState, String wordGoal) async {
    String id = UniqueKey().toString();
    final newBook = Book(
      id: id,
      title: titleController.text,
      chapterTitles: [[]],
      chapterTexts: [[]],
      chapters: [[]],
      jsonChapterTexts: [[]],
      drafts: [0],
      selectedDraft: 0,
      wordGoals: [
        int.parse(wordGoal),
      ],
      sideNotes: SideNotes.init(),
    );
    final newLib = loginBloc.state.user!.library ?? [];
    newLib.add(newBook);
    User newUser;
    newUser = loginBloc.state.user!.copyWith(library: newLib);
    loginBloc.updateLibrary(newUser);
    init();
    Navigator.of(sheetContext).pop();
  }
}
