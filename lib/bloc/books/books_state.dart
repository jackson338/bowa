part of 'books.dart';

class BooksState {
  final String title;
  final bool reading;

  const BooksState({
    this.title = 'Books State',
    this.reading = true,
  });

  BooksState copyWith({
    final String? title,
    final bool? reading,
  }) {
    return BooksState(title: title ?? this.title, reading: reading ?? this.reading);
  }
}
