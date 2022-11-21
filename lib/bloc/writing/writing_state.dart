part of 'writing.dart';

class WritingState {
  final List<Book> library;
  final bool titlesUpdated;

  const WritingState({
    required this.library,
    this.titlesUpdated = false,
  });

  WritingState copyWith({
    final List<Book>? library,
    final bool? titlesUpdated,
  }) {
    return WritingState(
      library: library ?? this.library,
      titlesUpdated: titlesUpdated ?? this.titlesUpdated,
    );
  }
}
