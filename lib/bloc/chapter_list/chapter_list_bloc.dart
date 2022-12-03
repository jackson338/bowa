part of 'chapter_list.dart';

class ChapterListBloc extends Cubit<ChapterListState> {
  final BuildContext context;
  final String id;
  final LoginBloc loginBloc;
  final int index;
  ChapterListBloc({
    required this.context,
    required this.id,
    required this.loginBloc,
    required this.index,
  }) : super(const ChapterListState()) {
    init();
  }

  void init() async {
    int selectedDraft = loginBloc.state.user!.library![index].selectedDraft;
    Book book = loginBloc.state.user!.library![index];
    if (book.chapters.isNotEmpty) {
      emit(state.copyWith(
        chapters: book.chapters[selectedDraft],
        chapterNames: book.chapterTitles[selectedDraft],
        chapterText: book.chapterTexts[selectedDraft],
        jsonChapterText: book.jsonChapterTexts[selectedDraft],
        wordGoal: book.wordGoals[selectedDraft] ?? 50000,
        drafts: book.drafts,
        selectedDraft: selectedDraft,
      ));
    }
  }

  void selectDraft(int selected) async {
    loginBloc.state.user!.library![index].selectedDraft = selected;
    emit(state.copyWith(
      selectedDraft: selected,
    ));
    init();
  }

  void newDraft() async {
    loginBloc.state.user!.library![index].chapterTexts.add([]);
    loginBloc.state.user!.library![index].chapterTitles.add([]);
    loginBloc.state.user!.library![index].chapters.add([]);
    loginBloc.state.user!.library![index].jsonChapterTexts.add([]);
    loginBloc.state.user!.library![index].drafts.add(state.drafts.length);
    loginBloc.state.user!.library![index].selectedDraft =
        loginBloc.state.user!.library![index].drafts.last;
    loginBloc.state.user!.library![index].wordGoals.add(state.wordGoal);
    init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(loginBloc.state.user!.toJson());
    prefs.setString('${loginBloc.state.user!.authorName} user', jsonString);
  }

  void deleteBook(WritingBloc writingBloc) {
    final List<Book> newLib = [];
    for (int i = 0; i < loginBloc.state.user!.library!.length; i++) {
      if (i != index) {
        newLib.add(loginBloc.state.user!.library![i]);
      }
    }
    final User lib = loginBloc.state.user!.copyWith(library: newLib);
    loginBloc.updateLibrary(lib);
    writingBloc.init();
    Navigator.of(context).pop();
  }

  /// Saves the text typed in the current chapter.
  void saveText(String text, QuillController cont, int i) {
    Book book = loginBloc.state.user!.library![index];
    book.chapterTexts[state.selectedDraft][i] = text;
    book.jsonChapterTexts[state.selectedDraft][i] = cont.document.toDelta().toJson();
    List<Book> newLib = loginBloc.state.user!.library!;
    newLib[index] = book;
    final User newUser = loginBloc.state.user!.copyWith(library: newLib);
    loginBloc.updateLibrary(newUser);
    init();
  }

  /// select a chapter
  void select(chapterSelect) {
    emit(state.copyWith(chapterSelected: chapterSelect));
  }

  // create a new chapter
  void addChapter(
      String chaptName, String chapt, String chaptText, QuillController cont) async {
    var json = cont.document.toDelta().toJson();
    loginBloc.state.user!.library![index].chapterTitles[state.selectedDraft]
        .add(chaptName);
    loginBloc.state.user!.library![index].chapters[state.selectedDraft].add(chapt);
    loginBloc.state.user!.library![index].chapterTexts[state.selectedDraft]
        .add(chaptText);
    loginBloc.state.user!.library![index].jsonChapterTexts[state.selectedDraft].add(json);
    init();
    emit(state.copyWith(
        chapters: loginBloc.state.user!.library![index].chapters[state.selectedDraft]));
        SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(loginBloc.state.user!.toJson());
    prefs.setString('${loginBloc.state.user!.authorName} user', jsonString);
  }

  // reorder chapters
  void reorder(int oldIndex, int newIndex) async {
    // print('old index: $oldIndex new index: $newIndex');
    // if (oldIndex < newIndex) {
    //   newIndex -= 1;
    // }
    // final Book newBook = loginBloc.state.user!.library!.removeAt(oldIndex);
    // loginBloc.state.user!.library!.insert(newIndex, newBook);
    // // final newUser = loginBloc.state.user!.copyWith(library: newLib);
    // // loginBloc.updateLibrary(newUser);
    // init();
  }

  // update the chapter title
  void updateTitle(String chapName, int index) async {
    List<String> chapterNames = [];
    chapterNames.addAll(state.chapterNames);
    chapterNames[index] = chapName;
    emit(state.copyWith(chapterNames: chapterNames));
  }

  Widget delete(
    BuildContext context,
    String title,
    WritingBloc writingBloc,
  ) {
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
  }
}
