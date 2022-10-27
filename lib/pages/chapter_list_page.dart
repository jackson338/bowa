import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/bloc/theme_bloc/theme.dart';
import 'package:bowa/bloc/writing/writing.dart';
import 'package:bowa/pages/settings.dart';
import 'package:bowa/widgets/reorderable_chapter_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class ChapterListPage extends StatelessWidget {
  final String title;
  final String id;
  final WritingBloc writingBloc;
  final ThemeBloc themeBloc;
  const ChapterListPage({
    Key? key,
    required this.title,
    required this.id,
    required this.writingBloc,
    required this.themeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp wordCount = RegExp(r"[\w-._]+");
    Iterable matches = [];
    return BlocProvider(
      create: (context) => ChapterListBloc(context: context, id: id),
      child: BlocBuilder<ChapterListBloc, ChapterListState>(
        buildWhen: (previous, current) =>
            previous.chapters != current.chapters ||
            previous.selectedDraft != current.selectedDraft ||
            previous.chapterText != current.chapterText,
        builder: (editContext, state) {
          int totalCount = 0;
          for (String text in state.chapterText) {
            matches = wordCount.allMatches(text);
            totalCount += matches.length;
          }
          double length = totalCount / state.wordGoal;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).hoverColor,
              title: FittedBox(
                child: Text(
                  '$title (Draft ${state.selectedDraft})',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              actions: [
                // Total word count
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Words: $totalCount',
                    style:
                        TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 15),
                  ),
                ),
                // New chapter button
                IconButton(
                  onPressed: () {
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
                              editContext.read<ChapterListBloc>().addChapter(
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
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).hoverColor,
            body: OrientationBuilder(
              builder: (context, orient) {
                return Container(
                  color: Theme.of(context).hoverColor,
                  height: MediaQuery.of(context).size.height,
                  child: FittedBox(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        //reorderable list widget height
                        SizedBox(
                          height: orient == Orientation.portrait
                              ? MediaQuery.of(context).size.height / 2
                              : MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          //reorderable list
                          child: ReorderableListView.builder(
                            buildDefaultDragHandles: false,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index != state.chapters.length) {
                                matches = wordCount.allMatches(state.chapterText[index]);
                                return chapterWidget(
                                    context,
                                    context.read<ChapterListBloc>(),
                                    index,
                                    id,
                                    title,
                                    matches);
                              } else {
                                return addChapter(
                                    context, context.read<ChapterListBloc>(), state);
                              }
                            },
                            itemCount: state.chapters.length + 1,
                            onReorder: (oldIndex, newIndex) {
                              if (newIndex > state.chapters.length) {
                                editContext
                                    .read<ChapterListBloc>()
                                    .reorder(oldIndex, newIndex - 1);
                              } else {
                                editContext
                                    .read<ChapterListBloc>()
                                    .reorder(oldIndex, newIndex);
                              }
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //Delete Book Button
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: TextButton(
                                    onPressed: () => editContext
                                        .read<ChapterListBloc>()
                                        .deleteBook(title, writingBloc),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Delete $title',
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 20.0),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Copy All Button
                                const Text('Copy All: '),
                                IconButton(
                                  splashColor: Theme.of(context).primaryColor,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    String copyText = '';
                                    for (int index = 0;
                                        index < state.chapterNames.length;
                                        index++) {
                                      copyText += '${state.chapterNames[index]}\n\n';
                                      copyText += '${state.chapterText[index]}\n\n';
                                    }
                                    Clipboard.setData(ClipboardData(text: copyText));
                                  },
                                  icon: const Icon(Icons.copy),
                                  iconSize: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Word Goal: $totalCount / ${state.wordGoal}'),
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 20,
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  heightFactor: 1.0,
                                  widthFactor: !length.isNaN ? length : 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 25,
                              child: ListView.separated(
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: state.chapterNames.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 25,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).disabledColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(Icons.circle,
                                        color: Theme.of(context).backgroundColor,
                                        size: 17),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 10,
                                    width: MediaQuery.of(context).size.width /
                                        state.chapterNames.length,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                List<Widget> drafts = [];
                for (final draft in state.drafts) {
                  drafts.add(
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextButton(
                        onPressed: () {
                          editContext.read<ChapterListBloc>().selectDraft(draft);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '$title (Draft $draft)',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor, fontSize: 25),
                        ),
                      ),
                    ),
                  );
                }
                drafts.add(
                  IconButton(
                    onPressed: () {
                      editContext.read<ChapterListBloc>().newDraft();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
                setting(context, themeBloc, editContext.read<ChapterListBloc>(), drafts);
              },
              child: const Icon(
                Icons.settings,
                size: 40,
              ),
            ),
          );
        },
      ),
    );
  }
}

void setting(BuildContext context, ThemeBloc themeBloc, ChapterListBloc chapterBloc,
    List<Widget> drafts) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Note',
            style: TextStyle(color: Theme.of(context).backgroundColor),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).hoverColor,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).hoverColor,
        body: ListView(
          children: [
            ExpansionTile(
              title: Text('Drafts', style: Theme.of(context).textTheme.headline1),
              expandedAlignment: Alignment.centerLeft,
              children: drafts,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8.0),
              child: Text('Theme', style: Theme.of(context).textTheme.headline1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //light theme
                SettingsPage.themeWidget(
                    context, Colors.black, Colors.white, 'Light Theme', themeBloc),
                //dark theme
                SettingsPage.themeWidget(
                    context, Colors.white, Colors.black, 'Dark Theme', themeBloc),
              ],
            ),
          ],
        ),
      );
    },
  );
}
