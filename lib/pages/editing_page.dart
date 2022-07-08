import 'package:bowa/bloc/chapter_list/chapter_list.dart';
import 'package:bowa/bloc/editing/editing.dart';
import 'package:bowa/pages/outline/outline_pages/outline_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_flip_builder/page_flip_builder.dart';


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
    final pageFlipper = PageFlipBuilderState();
    RegExp wordCount = RegExp(r"[\w-._]+");
    Iterable matches = [];
    bool buildCalled = false;
    TextEditingController contentController = TextEditingController();
    TextEditingController titleCont = TextEditingController();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocProvider(
        create: (_) => EditingBloc(context: context, chapState: chapterListState),
        child: BlocBuilder<EditingBloc, EditingState>(
          builder: (editContext, state) {
            //set the text of the contentController
            if (state.chapterText.isNotEmpty && !buildCalled) {
              contentController.text = state.chapterText[state.chapterSelected];
              contentController.selection = TextSelection.fromPosition(
                  TextPosition(offset: contentController.text.length));
              titleCont.text = state.chapterNames[state.chapterSelected];
              titleCont.selection =
                  TextSelection.fromPosition(TextPosition(offset: titleCont.text.length));
              matches = wordCount.allMatches(contentController.text);
              buildCalled = true;
            }
            return Scaffold(
              //Chapter Container
              drawer: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 3.5,
                color: Colors.grey,
                child: OrientationBuilder(
                  builder: (context, orient) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.4,
                      width: MediaQuery.of(context).size.width / 5,
                      child: ListView.builder(
                        itemCount: state.chapters.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              TextButton(
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
                                  editContext.read<EditingBloc>().select(index);
                                  chapterListBloc.select(index);
                                  Navigator.of(context).pop();
                                  pageFlipper.flip();
                                },
                                child: FittedBox(
                                  child: Text(
                                    '${index + 1}: ${state.chapterNames[index]}',
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                  ),
                                ),
                              ),
                              if (index == state.chapters.length - 1)
                                IconButton(
                                  splashColor: Colors.blue,
                                  onPressed: () {
                                    String chapterName;
                                    TextEditingController chaptNameController =
                                        TextEditingController();
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
                                            onSubmitted: (_) {
                                              Navigator.of(context).pop();
                                              chapterName = chaptNameController.text;
                                              editContext.read<EditingBloc>().addChapter(
                                                  chapterName,
                                                  'Chapter ${index + 2}',
                                                  chapterName,
                                                  index + 1);
                                              chapterListBloc.addChapter(
                                                chapterName,
                                                'Chapter ${index + 2}',
                                                chapterName,
                                              );
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
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              endDrawer: OrientationBuilder(
                builder: (context, orient) {
                  //contains outline
                  return Drawer(
                    width: orient == Orientation.portrait
                        ? MediaQuery.of(context).size.width / 1.8
                        : MediaQuery.of(context).size.width / 3,
                    child: OutlinePage(
                      id: id,
                    ),
                  );
                },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
              floatingActionButton: Builder(builder: (context) {
                return FloatingActionButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(Icons.list),
                );
              }),
              appBar: AppBar(
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
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        icon: const Icon(Icons.list),
                      );
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
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 1.35,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              //page flip
                              child: PageFlipBuilder(
                                interactiveFlipEnabled: false,
                                frontBuilder: (_) => TextField(
                                  autocorrect: true,
                                  autofocus: false,
                                  enableSuggestions: true,
                                  decoration: const InputDecoration(
                                    hintText: "Start writing!",
                                  ),
                                  scrollPadding: const EdgeInsets.all(20.0),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 99999,
                                  controller: contentController,
                                  keyboardAppearance: Brightness.dark,
                                  textCapitalization: TextCapitalization.sentences,
                                  onChanged: (_) {
                                    List<String> chapterText = [];
                                    if (state.chapterText.isNotEmpty) {
                                      chapterText.addAll(state.chapterText);
                                    }
                                    chapterText[state.chapterSelected] =
                                        contentController.text;
                                    matches = wordCount.allMatches(contentController.text);
                                    editContext.read<EditingBloc>().saveText(chapterText);
                                    chapterListBloc.saveText(chapterText);
                                  },
                                ),
                                backBuilder: (_) => TextField(
                                  autocorrect: true,
                                  autofocus: false,
                                  enableSuggestions: true,
                                  decoration: const InputDecoration(
                                    hintText: "Start writing!",
                                  ),
                                  scrollPadding: const EdgeInsets.all(20.0),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 99999,
                                  controller: contentController,
                                  keyboardAppearance: Brightness.dark,
                                  textCapitalization: TextCapitalization.sentences,
                                  onChanged: (_) {
                                    List<String> chapterText = [];
                                    if (state.chapterText.isNotEmpty) {
                                      chapterText.addAll(state.chapterText);
                                    }
                                    chapterText[state.chapterSelected] =
                                        contentController.text;
                                    matches = wordCount.allMatches(contentController.text);
                                    editContext.read<EditingBloc>().saveText(chapterText);
                                    chapterListBloc.saveText(chapterText);
                                  },
                                ),
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
                                  '${state.chapterNames[state.chapterSelected]}\n\n${state.chapterText[state.chapterSelected]}';
                              Clipboard.setData(ClipboardData(text: copyText));
                            },
                            icon: const Icon(Icons.copy),
                            iconSize: 15,
                          ),
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
