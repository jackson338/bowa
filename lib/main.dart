import 'package:bowa/pages/account_page.dart';
import 'package:bowa/pages/books_page/books_page.dart';
import 'package:bowa/pages/library_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    const HomePage(),
    const LibraryPage(),
    const BooksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange,
        primaryColorLight: Colors.orangeAccent,
        primaryColorDark: Colors.deepOrange,
        backgroundColor: Colors.white,
        disabledColor: Colors.grey[800],
        hoverColor: Colors.grey,
        cardColor: Colors.white,
        // brightness: Brightness.dark,
      ),
      home: Controller(
        pages: _pages,
      ),
    );
  }
}

class Controller extends StatelessWidget {
  final List<Widget> pages;

  const Controller({Key? key, required this.pages}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        body: TabBarView(
          children: pages,
        ),
        bottomNavigationBar: OrientationBuilder(builder: (portrait, orientation) {
          Orientation orient = orientation;
          return Container(
            height: MediaQuery.of(context).size.height / 10,
            margin: const EdgeInsets.only(bottom: 20),
            child: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? const Text(
                          'Account',
                        )
                      : null,
                ),
                Tab(
                  icon: Icon(
                    Icons.library_books,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? const Text(
                          'Library',
                        )
                      : null,
                ),
                Tab(
                  icon: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: orient == Orientation.portrait
                      ? const Text(
                          'Books',
                        )
                      : null,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
