import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/bloc/side_notes/side_notes.dart';
import 'package:bowa/pages/side_notes/side_notes_editing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class SideNotesPage extends StatelessWidget {
  final String id;
  final String title;
  final LoginBloc lBloc;
  final int index;
  const SideNotesPage({
    required this.id,
    required this.title,
    required this.lBloc,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SideNotesBloc(
        id: id,
        title: title,
        lBloc: lBloc,
        index: index,
      ),
      child: BlocBuilder<SideNotesBloc, SideNotesState>(
        buildWhen: (previous, current) => previous.notes != current.notes,
        builder: (context, state) {
          final SideNotesBloc sideNotesBloc = context.read<SideNotesBloc>();
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).hoverColor,
              title: FittedBox(
                child: Text(
                  'Side Notes',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                color: Theme.of(context).iconTheme.color,
              ),
              actions: [
                // New chapter button
                IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(
                            'New Note',
                            style: TextStyle(color: Theme.of(context).hoverColor),
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
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
            body: OrientationBuilder(
              builder: (context, orient) {
                return Container(
                  color: Theme.of(context).hoverColor,
                  child: Column(
                    children: [
                      // list widget height
                      SizedBox(
                        height: orient == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 2
                            : MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
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
                                    color: Theme.of(context).backgroundColor,
                                  ),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            child: Text(
                                              state.notes.values.elementAt(index),
                                              maxLines: 10,
                                              style:
                                                  Theme.of(context).textTheme.bodyText1,
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
