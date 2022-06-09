import 'package:bowa/bloc/outline/outline.dart';
import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:bowa/pages/outline/outline_expanded_pages/characters_body_expanded.dart';
import 'package:bowa/pages/outline/outline_expanded_pages/details_body_expanded.dart';
import 'package:bowa/pages/outline/outline_expanded_pages/outline_body_expanded.dart';
import 'package:bowa/widgets/story_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutlineExpandedPage extends StatelessWidget {
  final OutlineBloc outlineBloc;
  const OutlineExpandedPage({Key? key, required this.outlineBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocProvider(
        create: (context) => OutlineExpandedBloc(outlineState: outlineBloc.state),
        child: BlocBuilder<OutlineExpandedBloc, OutlineExpandedState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton(
                        dropdownColor: Theme.of(context).primaryColor,
                        focusColor: Theme.of(context).primaryColor,
                        elevation: 0,
                        value: state.bodySelected,
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'one',
                            child: Text('Outline'),
                          ),
                          DropdownMenuItem(
                            value: 'two',
                            child: Text('Characters'),
                          ),
                          DropdownMenuItem(
                            value: 'three',
                            child: Text('Details'),
                          ),
                        ],
                        underline: const SizedBox(
                          height: 0,
                        ),
                        onChanged: (value) {
                          context.read<OutlineExpandedBloc>().selectBody('$value');
                        },
                      ),
                    ],
                  ),
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
                body: state.bodySelected == 'two'
                    ? CharactersBodyExpanded(
                        outlineBloc: outlineBloc,
                        outlineExpandedBloc: context.read<OutlineExpandedBloc>(),
                      )
                    : state.bodySelected == 'three'
                        ? DetailsBodyExpanded()
                        : OutlineBodyExpanded(
                            state: state,
                            outlineBloc: context.read<OutlineExpandedBloc>(),
                          ));
          },
        ),
      ),
    );
  }
}
