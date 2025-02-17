import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/bloc/theme_bloc/theme.dart';
import 'package:bowa/bloc/writing/writing.dart';
import 'package:bowa/pages/settings.dart';
import 'package:bowa/widgets/outline_text_field.dart';
import 'package:bowa/widgets/writing_book_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksPage extends StatelessWidget {
  final ThemeBloc themeBloc;
  final LoginBloc loginBloc;
  const BooksPage({
    Key? key,
    required this.themeBloc,
    required this.loginBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WritingBloc(
        context: context,
        loginBloc: loginBloc,
      ),
      child: BlocBuilder<WritingBloc, WritingState>(
        builder: (context, state) {
          if (!context.read<WritingBloc>().state.titlesUpdated) {
            context.read<WritingBloc>().updateTitles();
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Writing Page',
                style: Theme.of(context).textTheme.headline1,
              ),
              actions: [
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage(
                                  themeBloc: themeBloc,
                                ))),
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).iconTheme.color,
                    ))
              ],
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: WritingBookList(
                  library: loginBloc.state.user!.library ?? [],
                  writingBloc: context.read<WritingBloc>(),
                  themeBloc: themeBloc,
                  loginBloc: loginBloc,
                ),
              ),
            ),
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width / 2.6,
              child: Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                child: TextButton(
                  onPressed: () {
                    newDraft(context, context.read<WritingBloc>(), loginBloc);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Text(
                          'New Draft',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.edit_note,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void newDraft(BuildContext context, WritingBloc bloc, LoginBloc loginBloc) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController wordGoal = TextEditingController(text: '50000');
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (sheetContext) {
        return BlocProvider(
          create: (context) => WritingBloc(
            context: context,
            loginBloc: loginBloc,
          ),
          child: BlocBuilder<WritingBloc, WritingState>(
            builder: (context, state) {
              WritingBloc writingBloc = context.read<WritingBloc>();
              return Container(
                color: Theme.of(context).hoverColor,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  children: [
                    //pop-up title text
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'New Draft',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    //title name text field
                    TextField(
                      autofocus: true,
                      decoration: outlineTextField(
                        context: context,
                        selected: Theme.of(context).primaryColor,
                        stagnant: Theme.of(context).backgroundColor,
                        hintText: 'New Draft',
                      ),
                      controller: titleController,
                      keyboardAppearance: Brightness.dark,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    //submit button
                    Card(
                      color: Theme.of(context).backgroundColor,
                      elevation: 3,
                      child: TextButton(
                        onPressed: () {
                          bloc.createDraft(titleController, sheetContext,
                              writingBloc.state, wordGoal.text);
                          // Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Create Draft',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Text(
                            'Word Goal: ',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              keyboardAppearance: Brightness.dark,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: outlineTextField(
                                context: context,
                                selected: Theme.of(context).primaryColor,
                                stagnant: Theme.of(context).backgroundColor,
                              ),
                              controller: wordGoal,
                              cursorColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
