import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryPointWidget extends StatelessWidget {
  final bool editing;
  final int stateIndex;
  final OutlineExpandedState state;
  const StoryPointWidget({
    Key? key,
    required this.editing,
    required this.stateIndex,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutlineExpandedBloc, OutlineExpandedState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, newState) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '${stateIndex + 1}.',
                      style: const TextStyle(fontSize: 30.0),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: editing
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width / 4,
                    child: editing
                        ? TextField(
                            controller: state.storyPoint[stateIndex],
                          )
                        : Text(state.storyPoint[stateIndex].text),
                  ),
                ],
              ),
              if (state.subPoint.isNotEmpty && newState.subPoint[stateIndex].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: SizedBox(
                      child: ListView.builder(
                        controller: ScrollController(keepScrollOffset: true),
                        itemCount: newState.subPoint[stateIndex].length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  '${index + 1}.',
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: editing
                                    ? MediaQuery.of(context).size.width / 2
                                    : MediaQuery.of(context).size.width / 4,
                                child: editing
                                    ? TextField(
                                        controller: state.subPoint[stateIndex][index],
                                      )
                                    : Text(state.subPoint[stateIndex][index].text),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (editing)
                TextButton(
                  onPressed: () {
                    TextEditingController control = TextEditingController();
                    context.read<OutlineExpandedBloc>().addSubPoint(stateIndex, control);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Add Sub Point',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
