import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/pages/editing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChapterListPage extends StatelessWidget {
  final String title;
  final String id;
  const ChapterListPage({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp wordCount = RegExp(r"[\w-._]+");
    Iterable matches = [];
    return BlocProvider(
      create: (context) => ChapterListBloc(context: context, id: id),
      child: BlocBuilder<ChapterListBloc, ChapterListState>(
        builder: (editContext, state) {
          int totalCount = 0;
          for (String text in state.chapterText) {
            matches = wordCount.allMatches(text);
            totalCount += matches.length;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
              actions: [
                // Total word count
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Words: $totalCount',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                // New chapter button
                IconButton(
                    onPressed: () {
                      String chapterName;
                      TextEditingController chaptNameController = TextEditingController();
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(400, 50, 50, 50),
                        items: [
                          PopupMenuItem(
                            child: TextField(
                              autofocus: true,
                              decoration: const InputDecoration(hintText: 'Chapter Name'),
                              controller: chaptNameController,
                              onSubmitted: (_) {
                                Navigator.of(context).pop();
                                chapterName = chaptNameController.text;
                                editContext.read<ChapterListBloc>().addChapter(
                                      chapterName,
                                      'Chapter ${state.chapters.length + 1}',
                                      chapterName,
                                    );
                              },
                            ),
                          ),
                        ],
                        elevation: 8.0,
                      );
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            body: OrientationBuilder(
              builder: (context, orient) {
                return Container(
                  color: Theme.of(context).hoverColor,
                  child: ListView(
                    children: [
                      Column(
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
                                matches = wordCount.allMatches(state.chapterText[index]);
                                return Padding(
                                  key: UniqueKey(),
                                  padding: const EdgeInsets.all(15.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      editContext.read<ChapterListBloc>().select(index);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditingPage(
                                            id: id,
                                            title: title,
                                            chapterListBloc:
                                                editContext.read<ChapterListBloc>(),
                                            chapterListState: editContext.read<ChapterListBloc>().state,
                                            initialIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Theme.of(context).cardColor,
                                      ),
                                      //reorderable list widget width
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(bottom: 12.0),
                                              child: Text(
                                                state.chapterNames[index],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(bottom: 12.0),
                                                child: Text(
                                                  'Word Count: ${matches.length}',
                                                  style: TextStyle(
                                                      color:
                                                          Theme.of(context).primaryColor),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                child: Text(
                                                  state.chapterText[index],
                                                  maxLines: orient == Orientation.portrait
                                                      ? 10
                                                      : 3,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        state.chapters[index],
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                      Icon(
                                                        Icons.drag_handle,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                splashColor:
                                                    Theme.of(context).primaryColor,
                                                onPressed: () {
                                                  String copyText =
                                                      '${state.chapterNames[state.chapterSelected]}\n\n${state.chapterText[state.chapterSelected]}';
                                                  Clipboard.setData(
                                                      ClipboardData(text: copyText));
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
                              },
                              itemCount: state.chapters.length,
                              onReorder: (oldIndex, newIndex) {
                                editContext
                                    .read<ChapterListBloc>()
                                    .reorder(oldIndex, newIndex);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
