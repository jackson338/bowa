import 'package:bowa/bloc/login_bloc/login.dart';
import 'package:bowa/bloc/theme_bloc/theme.dart';
import 'package:bowa/bloc/writing/writing.dart';
import 'package:bowa/models/book.dart';
import 'package:bowa/widgets/writing_book_item.dart';
import 'package:flutter/material.dart';

class WritingBookList extends StatelessWidget {
  final List<Book> library;
  final WritingBloc writingBloc;
  final ThemeBloc themeBloc;
  final LoginBloc loginBloc;
  const WritingBookList({
    Key? key,
    required this.library,
    required this.writingBloc,
    required this.themeBloc,
    required this.loginBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orient) {
      return GridView.count(
        crossAxisCount: orient == Orientation.portrait ? 2 : 3,
        children: List.generate(
          library.length,
          (index) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.8,
              child: WritingBookItem(
                bookTitle: library[index].title,
                context: context,
                id: library[index].id,
                writingBloc: writingBloc,
                themeBloc: themeBloc,
                loginBloc: loginBloc,
                index: index,
              ),
            );
          },
        ),
      );
    });
  }
}
