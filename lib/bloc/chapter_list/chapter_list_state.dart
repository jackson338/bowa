part of 'chapter_list.dart';

class ChapterListState {
  final List<Image>? coverArtList;
  final int chapterSelected;
  final List<String> chapters;
  final List<String> chapterNames;
  final List<String> chapterText;

  const ChapterListState({
    this.coverArtList = const [],
    this.chapterSelected = 0,
    this.chapters = const [],
    this.chapterNames = const [],
    this.chapterText = const [],
  });

  ChapterListState copyWith({
    final List<Image>? coverArtList,
    final int? chapterSelected,
    final List<String>? chapters,
    final List<String>? chapterNames,
    final List<String>? chapterText,
  }) {
    return ChapterListState(
      coverArtList: coverArtList ?? this.coverArtList,
      chapterSelected: chapterSelected ?? this.chapterSelected,
      chapters: chapters ?? this.chapters,
      chapterNames: chapterNames ?? this.chapterNames,
      chapterText: chapterText ?? this.chapterText,
    );
  }
}
