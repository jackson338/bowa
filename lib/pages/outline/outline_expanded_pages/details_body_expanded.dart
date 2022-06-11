import 'package:bowa/bloc/outline/outline.dart';
import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsBodyExpanded extends StatelessWidget {
  final OutlineBloc outlineBloc;
  const DetailsBodyExpanded({
    required this.outlineBloc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OutlineExpandedBloc(outlineState: outlineBloc.state),
      child: BlocBuilder<OutlineExpandedBloc, OutlineExpandedState>(
        buildWhen: (previous, current) => previous != current,
        builder: (outlineContext, state) {
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
                          itemCount: 5,
                          itemBuilder: ((context, index) {
                            //character
                            return const ExpansionTile(
                              title: Center(child: Text('details')),
                              //character descriptions
                              children: [
                                Align(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'The sky is blue and the sun is also blue. This doesn\'t really effect the lighting but the sun is blue'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('The ships name is the borealis'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      'The robots name is aurora. Your name is Evan.'),
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
