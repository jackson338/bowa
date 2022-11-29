import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/pages/editing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

/// Creates a widget that displays a container with text and functionality to add a new chapter
Widget addChapter(BuildContext context, ChapterListBloc clBloc, ChapterListState state) {
  return GestureDetector(
    key: UniqueKey(),
    onTap: () {
      String chapterName;
      TextEditingController chaptNameController = TextEditingController();
      Document doc = Document();
      QuillController quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
      showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(400, 50, 50, 50),
        color: Theme.of(context).hoverColor,
        items: [
          PopupMenuItem(
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Chapter Name'),
              controller: chaptNameController,
              keyboardAppearance: Brightness.dark,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) {
                Navigator.of(context).pop();
                chapterName = chaptNameController.text;
                clBloc.addChapter(
                  chapterName,
                  'Chapter ${state.chapters.length + 1}',
                  chapterName,
                  quillController,
                );
              },
            ),
          ),
        ],
        elevation: 8.0,
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black, width: 2),
          color: Theme.of(context).hoverColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.add_box_outlined,
                color: Colors.black,
                size: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Add Chapter',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

///Displays a widget showing some chapter text, title, and word count. Widget is reorderable.
Widget chapterWidget(
  BuildContext context,
  ChapterListBloc clBloc,
  int index,
  int bookIndex,
  String id,
  String title,
  Iterable matches,
  LoginBloc lBloc,
) {
  return Padding(
    key: UniqueKey(),
    padding: const EdgeInsets.all(15.0),
    child: GestureDetector(
      onTap: () {
        clBloc.select(index);
        final page = EditingPage(
          id: id,
          title: title,
          chapterListBloc: clBloc,
          chapterListState: clBloc.state,
          lBloc: lBloc,
          bookIndex: bookIndex,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).backgroundColor,
        ),
        //reorderable list widget width
        width: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  clBloc.state.chapterNames[index],
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Word Count: ${matches.length}',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Text(
                    clBloc.state.chapterText[index],
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 10,
                  ),
                ),
              ),
              const Spacer(),
              Align(
                child: ReorderableDragStartListener(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          clBloc.state.chapters[index],
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Icon(
                          Icons.drag_handle,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  splashColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    String copyText =
                        '${clBloc.state.chapterNames[clBloc.state.chapterSelected]}\n\n${clBloc.state.chapterText[clBloc.state.chapterSelected]}';
                    Clipboard.setData(ClipboardData(text: copyText));
                  },
                  icon: const Icon(Icons.copy),
                  iconSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
