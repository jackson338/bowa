import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library page baby!'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Text('library'),
    );
  }
}
