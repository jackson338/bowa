import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/bloc/editing/editing.dart';
import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

Widget drawerChapterList(
  BuildContext context,
  EditingBloc editingBloc,
  bool buildCalled,
  ChapterListBloc chapterListBloc,
  LoginBloc lBloc,
  int bookIndex,
  int chapterSelected,
) {
  return SizedBox(
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
          itemCount: lBloc.state.user!.library![bookIndex]
                  .chapters[lBloc.state.user!.library![bookIndex].selectedDraft].length +
              1,
          itemBuilder: (context, index) {
            if (index !=
                lBloc
                    .state
                    .user!
                    .library![bookIndex]
                    .chapters[lBloc.state.user!.library![bookIndex].selectedDraft]
                    .length) {
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (index == chapterSelected) {
                              return Theme.of(context).primaryColor;
                            }
                            return null;
                          }),
                        ),
                        onPressed: () {
                          buildCalled = false;
                          FocusManager.instance.primaryFocus?.unfocus();
                          chapterListBloc.select(index);
                          editingBloc.select(index, lBloc.state);
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              '${index + 1}: ${lBloc.state.user!.library![bookIndex].chapterTitles[lBloc.state.user!.library![bookIndex].selectedDraft][index]}',
                              maxLines: 1,
                              style: const TextStyle(color: Colors.black, fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // add chapter button
              return Center(
                child: IconButton(
                  splashColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    String chapterName;
                    TextEditingController chaptNameController = TextEditingController();
                    Document doc = Document();
                    QuillController quillCont = QuillController(
                      document: doc,
                      selection: const TextSelection.collapsed(offset: 0),
                    );
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(0, 110, 100, 100),
                      items: [
                        PopupMenuItem(
                          child: TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Chapter Name',
                              hintStyle: Theme.of(context).textTheme.bodyText1,
                            ),
                            controller: chaptNameController,
                            keyboardAppearance: Brightness.dark,
                            textCapitalization: TextCapitalization.sentences,
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
                              editingBloc.select(index, lBloc.state);
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
              );
            }
          },
        ),
      ),
    ),
  );
}
