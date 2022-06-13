import 'package:bowa/bloc/outline/outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsBody extends StatelessWidget {
  final OutlineState outlineState;
  const DetailsBody({
    required this.outlineState,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OutlineBloc(),
      child: BlocBuilder<OutlineBloc, OutlineState>(
        buildWhen: (previous, current) => outlineState.details != current.details,
        builder: (outlineContext, state) {
          if (outlineState.details.isNotEmpty) {
            outlineContext.read<OutlineBloc>().updateDetailState(outlineState.details);
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey,
            //ListView of detail expansion tiles
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
                            //detail
                            return ExpansionTile(
                              title: Center(child: Text(state.details[index].text)),
                              //detail description
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(state.details[index].text),
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
