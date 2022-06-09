import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:bowa/widgets/story_point.dart';
import 'package:flutter/material.dart';

class OutlineBodyExpanded extends StatelessWidget {
  final OutlineExpandedBloc outlineBloc;
  final OutlineExpandedState state;
  const OutlineBodyExpanded({
    Key? key,
    required this.outlineBloc,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text('Edit or add to your main story points'),
                              if (state.storyPoint.isEmpty)
                                TextButton(
                                  onPressed: () {
                                    TextEditingController control =
                                        TextEditingController();
                                    List<TextEditingController> subControl = [];
                                    TextEditingController cont = TextEditingController();
                                    outlineBloc.addPoint(control);
                                    outlineBloc.addParentSubPoint(0, subControl, cont);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Add New Story Point',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 1.3,
                                child: ListView.builder(
                                  itemCount: state.storyPoint.length,
                                  itemBuilder: ((context, index) {
                                    return Column(
                                      children: [
                                        StoryPointWidget(
                                          editing: true,
                                          stateIndex: index,
                                          state: state,
                                        ),
                                        if (index == state.storyPoint.length - 1)
                                          TextButton(
                                            onPressed: () {
                                              TextEditingController control =
                                                  TextEditingController();
                                              List<TextEditingController> subControl = [];
                                              TextEditingController cont =
                                                  TextEditingController();
                                              outlineBloc.addParentSubPoint(
                                                  index + 1, subControl, cont);
                                                  outlineBloc.addPoint(control);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Add New Story Point',
                                                style: TextStyle(
                                                    color:
                                                        Theme.of(context).primaryColor),
                                              ),
                                            ),
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
                  ],
                ),
              );
  }
}
