import 'package:bowa/bloc/outline/outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersBody extends StatelessWidget {
  final OutlineState outlineState;
  const CharactersBody({
    Key? key,
    required this.outlineState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OutlineBloc(),
      child: BlocBuilder<OutlineBloc, OutlineState>(
        buildWhen: (previous, current) => previous.characters != outlineState.characters,
        builder: (outlineContext, state) {
          if (outlineState.characters.isNotEmpty) {
            outlineContext
                .read<OutlineBloc>()
                .updateCharacterState(outlineState.characters);
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
                          itemCount: outlineState.characters.length,
                          itemBuilder: ((context, index) {
                            //character
                            return ExpansionTile(
                              title: Center(child: Text(outlineState.characters[index][0].text)),
                              //character descriptions
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(outlineState.characters[index][1].text),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(outlineState.characters[index][2].text),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(outlineState.characters[index][3].text),
                                ),
                              ],
                            );
                          }),
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
    );
  }
}
