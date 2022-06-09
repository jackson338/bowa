import 'package:bowa/bloc/outline/outline.dart';
import 'package:bowa/bloc/outline_expanded/outline_expanded.dart';
import 'package:bowa/pages/outline/outline_expanded_pages/outline_expanded_page.dart';
import 'package:bowa/pages/outline/outline_pages/characters_body.dart';
import 'package:bowa/pages/outline/outline_pages/details_body.dart';
import 'package:bowa/pages/outline/outline_pages/outline_body.dart';
import 'package:bowa/widgets/story_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutlinePage extends StatelessWidget {
  const OutlinePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocProvider(
        create: (context) => OutlineBloc(),
        child: BlocBuilder<OutlineBloc, OutlineState>(
          buildWhen: (previous, current) => previous != current,
          builder: (outlineContext, state) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: DropdownButton(
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
                          outlineContext.read<OutlineBloc>().selectBody('$value');
                        },
                      ),
                    ),
                  ],
                ),
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutlineExpandedPage(
                            outlineBloc: outlineContext.read<OutlineBloc>(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              body: state.bodySelected == 'two'
                  ? CharactersBody(
                    outlineState: state,
                    )
                  : state.bodySelected == 'three'
                      ? DetailsBody()
                      : OutlineBody(state: state),
            );
          },
        ),
      ),
    );
  }
}
