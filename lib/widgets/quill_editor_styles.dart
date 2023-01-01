import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

DefaultStyles quillStyles({required BuildContext context}) {
  return DefaultStyles(
      paragraph: DefaultTextBlockStyle(Theme.of(context).textTheme.bodyText1!,
          const Tuple2(8, 0), const Tuple2(0, 0), null),
      h1: DefaultTextBlockStyle(
          TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 35),
          const Tuple2(16, 0),
          const Tuple2(0, 0),
          null),
      h2: DefaultTextBlockStyle(
          TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 28),
          const Tuple2(15, 0),
          const Tuple2(0, 0),
          null),
      h3: DefaultTextBlockStyle(
          TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 21),
          const Tuple2(14, 0),
          const Tuple2(0, 0),
          null),
      bold: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontWeight: FontWeight.bold),
      color: Theme.of(context).textTheme.bodyText1!.color);
}
