import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Library',style: Theme.of(context).textTheme.headline1,),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
        child: Text(
          'library',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
