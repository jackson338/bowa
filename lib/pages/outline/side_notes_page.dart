import 'package:bowa/bloc/side_notes/side_notes.dart';
import 'package:bowa/pages/outline/side_notes_editing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class SideNotesPage extends StatelessWidget {
  final String id;
  const SideNotesPage({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SideNotesBloc(id: id),
      child: BlocBuilder<SideNotesBloc, SideNotesState>(
        buildWhen: (previous, current) => previous.notes != current.notes,
        builder: (context, state) {
          final SideNotesBloc sideNotesBloc = context.read<SideNotesBloc>();
          int totalCount = 0;
          return Scaffold(
            appBar: AppBar(
              title: const FittedBox(
                child: Text(
                  'Side Notes',
                  style: TextStyle(fontSize: 15),
                ),
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
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('New Note')),
                        backgroundColor: Theme.of(context).hintColor,
                        body: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                sideNotesBloc.newNote('Outline');
                                Navigator.of(context).pop();
                              },
                              child: const Text('Outline'),
                            ),
                            TextButton(
                              onPressed: () {
                                sideNotesBloc.newNote('Character');
                                Navigator.of(context).pop();
                              },
                              child: const Text('Character'),
                            ),
                            TextButton(
                              onPressed: () {
                                sideNotesBloc.newNote('Note');
                                Navigator.of(context).pop();
                              },
                              child: const Text('Note'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: OrientationBuilder(
              builder: (context, orient) {
                return Container(
                  color: Theme.of(context).hoverColor,
                  child: Column(
                    children: [
                      //reorderable list widget height
                      SizedBox(
                        height: orient == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 2
                            : MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        //reorderable list
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              key: UniqueKey(),
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<SideNotesBloc>().select(index);

                                  final page = NotesEditingPage(
                                    title: state.notes.keys.elementAt(index),
                                    sideNotesBloc: sideNotesBloc,
                                    id: id,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => page),
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
                                          padding: const EdgeInsets.only(bottom: 12.0),
                                          child: Text(
                                            state.notes.keys.elementAt(index),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            child: Text(
                                              state.notes.values.elementAt(index),
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
                                              child: Icon(
                                                Icons.drag_handle,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: state.notes.length,
                        ),
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
