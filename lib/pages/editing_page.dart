import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/bloc/editing/editing.dart';
import 'package:bowa/pages/side_notes/side_notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:tuple/tuple.dart';

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
              Document doc = Document.fromJson(
                state.jsonChapterText[state.chapterSelected],
              );
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
                  appBar: AppBar(
                    title: SizedBox(
                      width: MediaQuery.of(context).size.width / 9,
                      child: const FittedBox(
                        child: Text(
                          'Chapters',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  body: Container(
                    color: Theme.of(context).hoverColor,
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
                                        return Theme.of(context).primaryColor;
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
                                              decoration: InputDecoration(
                                                hintText: 'Chapter Name',
                                                hintStyle:
                                                    Theme.of(context).textTheme.bodyText1,
                                              ),
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
                      padding: const EdgeInsets.only(bottom: 90.0),
                      child: Builder(
                        builder: (context) {
                          return FloatingActionButton(
                            onPressed: () {
                              quillFocus.unfocus();
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
                                // showAlignmentButtons: state.tools,
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
            );
          },
        ),
      ),
    );
  }
}
