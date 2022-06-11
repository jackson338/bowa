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
        buildWhen: (previous, current) => previous.details != current.details,
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
                          itemCount: state.details.length,
                          itemBuilder: ((context, index) {
                            //character
                            return ExpansionTile(
                              title: const Center(child: Text('details')),
                              //character descriptions
                              children: [
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(controller: state.details[index]),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          outlineContext.read<OutlineExpandedBloc>().addDetail();
                          outlineBloc.updateDetailState(state.details);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Add Details',
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
        },
      ),
    );
  }
}
