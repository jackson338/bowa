import 'package:bowa/bloc/outline/outline.dart';
import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:bowa/widgets/story_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutlineBody extends StatelessWidget {
  final OutlineBloc outlineBloc;
  const OutlineBody({
    Key? key,
    required this.outlineBloc,
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
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Main Story Points'),
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
                        itemCount: outlineBloc.state.storyPoint.length,
                        itemBuilder: ((context, index) {
                          return Column(
                            children: [
                              BlocProvider(
                                create: (context) =>
                                    OutlineExpandedBloc(outlineState: outlineBloc.state),
                                child: BlocBuilder<OutlineExpandedBloc,
                                    OutlineExpandedState>(
                                  buildWhen: (previous, current) =>
                                      outlineBloc.state.storyPoint != current.storyPoint,
                                  builder: (context, expandedState) {
                                    return StoryPointWidget(
                                      editing: false,
                                      stateIndex: index,
                                      outlineExpandedBloc:
                                          context.read<OutlineExpandedBloc>(),
                                      outlineBloc: outlineBloc,
                                    );
                                  },
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
