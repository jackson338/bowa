part of 'chapter_list.dart';

class ChapterListState {
  final int chapterSelected;
  final List<String> chapters;
  final List<String> chapterNames;
  final List<String> chapterText;

  const ChapterListState({
    this.chapterSelected = 0,
    this.chapters = const [],
    this.chapterNames = const [],
    this.chapterText = const [],
  });

  ChapterListState copyWith({
    final int? chapterSelected,
    final List<String>? chapters,
    final List<String>? chapterNames,
    final List<String>? chapterText,
  }) {
    return ChapterListState(
      chapterSelected: chapterSelected ?? this.chapterSelected,
      chapters: chapters ?? this.chapters,
      chapterNames: chapterNames ?? this.chapterNames,
      chapterText: chapterText ?? this.chapterText,
    );
  }
}
