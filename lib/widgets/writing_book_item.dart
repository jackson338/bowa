import 'package:bowa/pages/chapter_list_page.dart';
import 'package:flutter/material.dart';

class WritingBookItem extends StatelessWidget {
  final String bookTitle;
  final Image coverArt;
  final BuildContext context;
  final String id;
  const WritingBookItem({
    Key? key,
    required this.bookTitle,
    required this.coverArt,
    required this.context,
    required this.id,
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
              child: SizedBox(
                height: 100,
                width: 100,
                child: coverArt,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(bookTitle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onBookTap(String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (editContext) => ChapterListPage(title: title, id: id,)));
  }
}
