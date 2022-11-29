import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/bloc/theme_bloc/theme.dart';
import 'package:bowa/bloc/writing/writing.dart';
import 'package:bowa/pages/chapter_list_page.dart';
import 'package:flutter/material.dart';

class WritingBookItem extends StatelessWidget {
  final String bookTitle;
  final BuildContext context;
  final String id;
  final WritingBloc writingBloc;
  final ThemeBloc themeBloc;
  final LoginBloc loginBloc;
  final int index;
  const WritingBookItem({
    Key? key,
    required this.bookTitle,
    required this.context,
    required this.id,
    required this.writingBloc,
    required this.themeBloc,
    required this.loginBloc,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onBookTap(bookTitle);
        },
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).hoverColor,
                ),
                height: 100,
                width: 100,
                child: Center(
                  child: Text(
                    'boWa',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  bookTitle,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onBookTap(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (editContext) => ChapterListPage(
          title: title,
          id: id,
          writingBloc: writingBloc,
          themeBloc: themeBloc,
          loginBloc: loginBloc,
          index: index,
        ),
      ),
    );
  }
}
