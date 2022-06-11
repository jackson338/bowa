import 'package:bowa/bloc/outline/outline.dart';
import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersBodyExpanded extends StatelessWidget {
  final OutlineBloc outlineBloc;
  final OutlineExpandedBloc outlineExpandedBloc;
  const CharactersBodyExpanded({
    Key? key,
    required this.outlineBloc,
    required this.outlineExpandedBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey,
      child: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: ListView.builder(
                    itemCount: outlineExpandedBloc.state.characters.length,
                    itemBuilder: ((context, index) {
                      if (outlineExpandedBloc.state.characters.isNotEmpty) {
                        TextEditingController name =
                            outlineExpandedBloc.state.characters[index][0];
                        TextEditingController looks =
                            outlineExpandedBloc.state.characters[index][1];
                        TextEditingController personality =
                            outlineExpandedBloc.state.characters[index][2];
                        TextEditingController description =
                            outlineExpandedBloc.state.characters[index][3];
                        //character
                        return ExpansionTile(
                          title: Center(
                            child: TextField(
                              controller: name,
                            ),
                          ),
                          //character descriptions
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: looks,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: personality,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: description,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('add character data');
                      }
                    }),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    outlineExpandedBloc.addCharacter();
                    outlineBloc.addCharacter();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Add Character',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
