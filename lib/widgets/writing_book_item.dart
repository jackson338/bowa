import 'package:bowa/pages/chapter_list_page.dart';
import 'package:flutter/material.dart';

class WritingBookItem extends StatelessWidget {
  final String id;
  final String bookTitle;
  final Image coverArt;
  final BuildContext context;
  const WritingBookItem({
    Key? key,
    required this.id,
    required this.bookTitle,
    required this.coverArt,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onBookTap(id, bookTitle);
        },
        child: SizedBox(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 70,
                  width: 60,
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
      ),
    );
  }
  void onBookTap(String id, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (editContext) => ChapterListPage(title: title)));
  }
}
