import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/bloc/editing/editing.dart';
import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/pages/side_notes/side_notes_page.dart';
import 'package:bowa/widgets/editing_chapterlist_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:tuple/tuple.dart';

class EditingPage extends StatelessWidget {
  final String title;
  final ChapterListBloc chapterListBloc;
  final ChapterListState chapterListState;
  final String id;
  final LoginBloc lBloc;
  final int bookIndex;

  const EditingPage({
    Key? key,
    required this.title,
    required this.chapterListBloc,
    required this.chapterListState,
    required this.id,
    required this.lBloc,
    required this.bookIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return BlocProvider(
      create: (_) => EditingBloc(
          context: context,
          bookIndex: bookIndex,
          lState: lBloc.state,
          chapState: chapterListState),
      child: BlocBuilder<EditingBloc, EditingState>(
        buildWhen: (previous, current) =>
            previous.editing != current.editing ||
            previous.tools != current.tools ||
            previous.drawerOpen != current.drawerOpen ||
            previous.chapterSelected != current.chapterSelected,
        builder: (editContext, state) {
             RegExp wordCount = RegExp(r"[\w-._]+");
    Iterable matches = [];
    bool buildCalled = false;
    TextEditingController titleCont = TextEditingController();
    QuillController quillController = QuillController.basic();
    FocusNode quillFocus = FocusNode();
          final editingBloc = editContext.read<EditingBloc>();
          state.editing ? editingBloc.openDrawer(false) : editingBloc.openDrawer(true);
          if (state.jsonChapterText.isNotEmpty && !buildCalled) {
            titleCont.text = lBloc.state.user!.library![bookIndex]
                    .chapterTitles[lBloc.state.user!.library![bookIndex].selectedDraft]
                [state.chapterSelected];
            titleCont.selection =
                TextSelection.fromPosition(TextPosition(offset: titleCont.text.length));
            Document doc = Document.fromJson(
              state.jsonChapterText[state.chapterSelected],
            );
            quillController = QuillController(
              document: doc,
              selection: const TextSelection.collapsed(offset: 0),
              onSelectionChanged: (_) {
                editingBloc.editing(true);
                List<dynamic> chapterText = [];
                if (state.jsonChapterText.isNotEmpty) {
                  chapterText.addAll(state.jsonChapterText);
                }
                chapterText[state.chapterSelected] = quillController.document
                    .getPlainText(0, quillController.document.length);
                matches = wordCount.allMatches(quillController.document.toPlainText());
                chapterListBloc.saveText(quillController.document.toPlainText(),
                    quillController, state.chapterSelected);
              },
            );
            matches = wordCount.allMatches(quillController.document.toPlainText());
            buildCalled = true;
          }
          return GestureDetector(
            onTap: () {
              quillFocus.unfocus();
              editingBloc.editing(false);
            },
            child: Scaffold(
              //Chapter Container
              drawer: drawerChapterList(context, editingBloc, buildCalled,
                  chapterListBloc, lBloc, bookIndex, state.chapterSelected),
              endDrawer: OrientationBuilder(
                builder: (context, orient) {
                  //contains side notes
                  return Drawer(
                    width: MediaQuery.of(context).size.width,
                    child: SideNotesPage(
                      id: id,
                      title: title,
                      lBloc: lBloc,
                      bookIndex: bookIndex,
                    ),
                  );
                },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: state.drawerOpen
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 90.0),
                      child: Builder(
                        builder: (context) {
                          return FloatingActionButton(
                            onPressed: () {
                              quillFocus.unfocus();
                              editingBloc.editing(false);
                              Scaffold.of(context).openDrawer();
                            },
                            child: const Icon(
                              Icons.list_alt_outlined,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    )
                  : null,
              // floatingActionButton:
              appBar: AppBar(
                // back button
                elevation: 0,
                backgroundColor: Theme.of(context).backgroundColor,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Words: ${matches.length}',
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            quillFocus.unfocus();
                            editingBloc.editing(false);
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: Icon(
                            Icons.edit_note_sharp,
                            color: Theme.of(context).iconTheme.color,
                          ));
                    },
                  ),
                ],
                title: FittedBox(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ),
              body: Row(
                children: [
                  // Writing Container
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      children: [
                        // Chapter Name
                        SizedBox(
                          height: 30,
                          child: TextField(
                            autofocus: false,
                            decoration: const InputDecoration(hintText: 'Chapter Name'),
                            controller: titleCont,
                            keyboardAppearance: Brightness.dark,
                            textCapitalization: TextCapitalization.sentences,
                            style: Theme.of(context).textTheme.bodyText1,
                            onChanged: (_) {
                              String chapterName = titleCont.text;
                              editContext
                                  .read<EditingBloc>()
                                  .updateTitle(chapterName, state.chapterSelected);
                              chapterListBloc.updateTitle(
                                  chapterName, state.chapterSelected);
                            },
                          ),
                        ),

                        // Chapter Text
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                //chapter text editor
                                child: QuillEditor(
                                  controller: quillController,
                                  focusNode: quillFocus,
                                  scrollController: ScrollController(),
                                  scrollable: true,
                                  padding: const EdgeInsets.only(left: 30),
                                  autoFocus: false,
                                  readOnly: false,
                                  expands: true,
                                  textCapitalization: TextCapitalization.sentences,
                                  keyboardAppearance: Brightness.dark,
                                  customStyles: DefaultStyles(
                                      paragraph: DefaultTextBlockStyle(
                                          Theme.of(context).textTheme.bodyText1!,
                                          const Tuple2(16, 0),
                                          const Tuple2(0, 0),
                                          null),
                                      h1: DefaultTextBlockStyle(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                              fontSize: 35),
                                          const Tuple2(16, 0),
                                          const Tuple2(0, 0),
                                          null),
                                      h2: DefaultTextBlockStyle(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                              fontSize: 28),
                                          const Tuple2(16, 0),
                                          const Tuple2(0, 0),
                                          null),
                                      h3: DefaultTextBlockStyle(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                              fontSize: 21),
                                          const Tuple2(16, 0),
                                          const Tuple2(0, 0),
                                          null),
                                      bold: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color,
                                          fontWeight: FontWeight.bold),
                                      color:
                                          Theme.of(context).textTheme.bodyText1!.color),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Builder(builder: (scaffoldContext) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: QuillToolbar.basic(
                                customButtons: [
                                  QuillCustomButton(
                                    icon: Icons.list_alt_outlined,
                                    onTap: () {
                                      quillFocus.unfocus();
                                      editingBloc.editing(false);
                                      Scaffold.of(scaffoldContext).openDrawer();
                                    },
                                  ),
                                  QuillCustomButton(
                                    icon: state.tools
                                        ? Icons.arrow_downward_rounded
                                        : Icons.arrow_upward_rounded,
                                    onTap: () => editingBloc.tool(),
                                  ),
                                ],
                                controller: quillController,
                                showCameraButton: false,
                                showLink: false,
                                showCenterAlignment: false,
                                showCodeBlock: false,
                                showDirection: false,
                                showFormulaButton: false,
                                showImageButton: false,
                                showDividers: false,
                                showVideoButton: false,
                                showFontSize: false,
                                showFontFamily: false,
                                showColorButton: false,
                                showQuote: false,
                                showBackgroundColorButton: false,
                                showListCheck: state.tools,
                                showInlineCode: state.tools,
                                showListBullets: state.tools,
                                showListNumbers: state.tools,
                                showSearchButton: state.tools,
                                showIndent: state.tools,
                                showHeaderStyle: state.tools,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
