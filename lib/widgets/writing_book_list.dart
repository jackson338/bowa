import 'package:bowa/widgets/writing_book_item.dart';
import 'package:flutter/material.dart';

class WritingBookList extends StatelessWidget {
  final List<String> idList;
  final List<String> titleList;
  final List<Image> coverArtList;
  final List<String> ids;
  const WritingBookList({
    Key? key,
    required this.idList,
    required this.titleList,
    required this.coverArtList,
    required this.ids,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orient) {
      return GridView.count(
        crossAxisCount: orient == Orientation.portrait ? 2 : 3,
        children: List.generate(
          titleList.length,
          (index) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.8,
              child: WritingBookItem(
                bookTitle: titleList[index],
                coverArt: coverArtList[index],
                context: context,
                id: ids[index],
              ),
            );
          },
        ),
      );
    });
  }
}
