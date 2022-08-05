part of 'editing.dart';

class EditingState {
  final List<Image>? coverArtList;
  final int chapterSelected;
  final List<String> chapters;
  final List<String> chapterNames;
  final bool typing;
  final List<dynamic> jsonChapterText;

  const EditingState({
    this.coverArtList = const [],
    this.chapterSelected = 0,
    this.chapters = const [],
    this.chapterNames = const [],
    this.typing = true,
    this.jsonChapterText = const [],
  });

  EditingState copyWith({
    final List<Image>? coverArtList,
    final int? chapterSelected,
    final List<String>? chapters,
    final List<String>? chapterNames,
    final bool? typing,
    final List<dynamic>? jsonChapterText,
  }) {
    return EditingState(
      coverArtList: coverArtList ?? this.coverArtList,
      chapterSelected: chapterSelected ?? this.chapterSelected,
      chapters: chapters ?? this.chapters,
      chapterNames: chapterNames ?? this.chapterNames,
      typing: typing ?? this.typing,
      jsonChapterText: jsonChapterText ?? this.jsonChapterText,
    );
  }
}
