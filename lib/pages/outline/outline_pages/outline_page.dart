import 'package:bowa/bloc/outline/outline.dart';
import 'package:bowa/pages/outline/outline_expanded_pages/outline_expanded_page.dart';
import 'package:bowa/pages/outline/outline_pages/characters_body.dart';
import 'package:bowa/pages/outline/outline_pages/details_body.dart';
import 'package:bowa/pages/outline/outline_pages/outline_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutlinePage extends StatelessWidget {
  final String id;
  const OutlinePage({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocProvider(
        create: (context) => OutlineBloc(id: id),
        child: BlocBuilder<OutlineBloc, OutlineState>(
          buildWhen: (previous, current) => previous != current,
          builder: (outlineContext, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Side Notes'),
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
                      ? DetailsBody(
                          outlineState: state,
                        )
                      : OutlineBody(
                          outlineBloc: outlineContext.read<OutlineBloc>(),
                        ),
            );
          },
        ),
      ),
    );
  }
}
