import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/bloc/editing/editing.dart';
import 'package:bowa/pages/outline/side_notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class EditingPage extends StatelessWidget {
  final String title;
  final ChapterListBloc chapterListBloc;
  final ChapterListState chapterListState;
  final String id;
  final int initialIndex;

  const EditingPage({
    Key? key,
    required this.title,
    required this.chapterListBloc,
    required this.chapterListState,
    required this.id,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp wordCount = RegExp(r"[\w-._]+");
    Iterable matches = [];
    bool buildCalled = false;
    TextEditingController titleCont = TextEditingController();
    QuillController quillController = QuillController.basic();
    FocusNode quillFocus = FocusNode();
    return GestureDetector(
      onTap: () {
        // FocusManager.instance.primaryFocus?.unfocus();
        quillFocus.unfocus();
      },
      child: BlocProvider(
        create: (_) => EditingBloc(context: context, chapState: chapterListState),
        child: BlocBuilder<EditingBloc, EditingState>(
          builder: (editContext, state) {
            final editingBloc = editContext.read<EditingBloc>();
            quillFocus.hasFocus
                ? editingBloc.openDrawer(false)
                : editingBloc.openDrawer(true);
            if (state.jsonChapterText.isNotEmpty && !buildCalled) {
              //Setting title controller text to chapter name
              titleCont.text = state.chapterNames[state.chapterSelected];
              titleCont.selection =
                  TextSelection.fromPosition(TextPosition(offset: titleCont.text.length));
              //setting document for json formatting
              Document doc =
                  Document.fromJson(state.jsonChapterText[state.chapterSelected]);
              //creating quill controller and assigning the document to the json created 'doc' value
              quillController = QuillController(
                document: doc,
                selection: const TextSelection.collapsed(offset: 0),
                onSelectionChanged: (_) {
                  //creating chapter text variable for wordcount
                  List<dynamic> chapterText = [];
                  if (state.jsonChapterText.isNotEmpty) {
                    chapterText.addAll(state.jsonChapterText);
                  }
                  //assigning chapter text plain text from quill controller
                  chapterText[state.chapterSelected] = quillController.document
                      .getPlainText(0, quillController.document.length);
                  //updating word count
                  matches = wordCount.allMatches(quillController.document.toPlainText());
                  //editing bloc saveText
                  editingBloc.saveText(quillController);
                  //saving data through sharedpreferences and updating the chapterlist.
                  chapterListBloc.saveText(quillController.document.toPlainText(),
                      quillController, state.chapterSelected);
                },
              );
              //setting word count based on chapter text
              matches = wordCount.allMatches(quillController.document.toPlainText());
              buildCalled = true;
            }
            return Scaffold(
              //Chapter Container
              drawer: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 3.5,
                child: Scaffold(
                  appBar: AppBar(title: const Text('Chapters')),
                  body: Container(
                    color: Colors.grey,
                    child: ListView.builder(
                      itemCount: state.chapters.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith((states) {
                                      if (index == state.chapterSelected) {
                                        return Colors.orangeAccent;
                                      }
                                      return null;
                                    }),
                                  ),
                                  onPressed: () {
                                    buildCalled = false;
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    editingBloc.select(index);
                                    chapterListBloc.select(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      child: Text(
                                        '${index + 1}: ${state.chapterNames[index]}',
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (index == state.chapters.length - 1)
                                // add chapter button
                                Center(
                                  child: IconButton(
                                    splashColor: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      String chapterName;
                                      TextEditingController chaptNameController =
                                          TextEditingController();
                                      Document doc = Document();
                                      QuillController quillCont = QuillController(
                                        document: doc,
                                        selection:
                                            const TextSelection.collapsed(offset: 0),
                                      );
                                      showMenu(
                                        context: context,
                                        position:
                                            const RelativeRect.fromLTRB(0, 110, 100, 100),
                                        items: [
                                          PopupMenuItem(
                                            child: TextField(
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                  hintText: 'Chapter Name'),
                                              controller: chaptNameController,
                                              keyboardAppearance: Brightness.dark,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              onSubmitted: (_) {
                                                Navigator.of(context).pop();
                                                chapterName = chaptNameController.text;
                                                editingBloc.addChapter(
                                                  chapterName,
                                                  'Chapter ${index + 2}',
                                                  chapterName,
                                                  index + 1,
                                                  quillCont,
                                                );
                                                chapterListBloc.addChapter(
                                                  chapterName,
                                                  'Chapter ${index + 2}',
                                                  chapterName,
                                                  quillCont,
                                                );
                                                buildCalled = false;
                                                editingBloc.select(index + 1);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                        elevation: 8.0,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add_box_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              endDrawer: OrientationBuilder(
                builder: (context, orient) {
                  //contains side notes
                  return Drawer(
                    width: MediaQuery.of(context).size.width,
                    child: SideNotesPage(
                      id: id,
                      title: title,
                    ),
                  );
                },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: state.drawerOpen
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: Builder(
                        builder: (context) {
                          return FloatingActionButton(
                            onPressed: () {
                              quillFocus.unfocus();
                              Scaffold.of(context).openDrawer();
                            },
                            child: const Icon(Icons.list_alt_outlined),
                          );
                        },
                      ),
                    )
                  : null,
              // floatingActionButton:
              appBar: AppBar(
                // back button
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                actions: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Words: ${matches.length}',
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            quillFocus.unfocus();
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(Icons.edit_note_sharp));
                    },
                  ),
                ],
                title: FittedBox(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              body: Row(
                children: [
                  // Writing Container
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
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
                            child: Container(
                              decoration:
                                  BoxDecoration(border: Border.all(color: Colors.grey)),
                              height: MediaQuery.of(context).size.height / 1.35,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Builder(builder: (scaffoldContext) {
                            return QuillToolbar.basic(
                              customButtons: [
                                QuillCustomButton(
                                  icon: Icons.list_alt_outlined,
                                  onTap: () {
                                    quillFocus.unfocus();
                                    Scaffold.of(scaffoldContext).openDrawer();
                                  },
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
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
