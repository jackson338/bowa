import 'package:bowa/bloc/outline/outline.dart';
import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:flutter/material.dart';

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
    if (outlineBloc.state.characters.length >
        outlineExpandedBloc.state.characters.length) {
      outlineExpandedBloc.updateCharacterState(outlineBloc.state.characters);
    }
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
                              enableInteractiveSelection: true,
                              controller: name,
                              onSubmitted: (change) {
                                List<List<TextEditingController>> updateCharacters =
                                    outlineBloc.state.characters;
                                updateCharacters[index][0].text = change;
                                print('index: $index name: ${updateCharacters[index][0].text}');
                                outlineBloc.saveCharacterText(updateCharacters);
                              },
                            ),
                          ),
                          //character descriptions
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: looks,
                                onChanged: (change) {
                                  List<List<TextEditingController>> updateCharacters =
                                      outlineBloc.state.characters;
                                  updateCharacters[index][1].text = change;
                                  outlineBloc.saveCharacterText(updateCharacters);
                                  looks.selection = TextSelection.fromPosition(
                                      TextPosition(offset: looks.text.length));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: personality,
                                onChanged: (change) {
                                  List<List<TextEditingController>> updateCharacters =
                                      outlineBloc.state.characters;
                                  updateCharacters[index][2].text = change;
                                  outlineBloc.saveCharacterText(updateCharacters);
                                  personality.selection = TextSelection.fromPosition(
                                      TextPosition(offset: personality.text.length));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: description,
                                onChanged: (change) {
                                  List<List<TextEditingController>> updateCharacters =
                                      outlineBloc.state.characters;
                                  updateCharacters[index][3].text = change;
                                  outlineBloc.saveCharacterText(updateCharacters);
                                  description.selection = TextSelection.fromPosition(
                                      TextPosition(offset: description.text.length));
                                },
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
