part of 'editing.dart';

class EditingState {
  final List<Image>? coverArtList;
  final int chapterSelected;
  final List<String> chapters;
  final List<String> chapterNames;
  final List<String> chapterText;

  const EditingState({
    this.coverArtList = const [],
    this.chapterSelected = 0,
    this.chapters = const [],
    this.chapterNames = const [],
    this.chapterText = const [],
  });

  EditingState copyWith({
    final List<Image>? coverArtList,
    final int? chapterSelected,
    final List<String>? chapters,
    final List<String>? chapterNames,
    final List<String>? chapterText,
  }) {
    return EditingState(
      coverArtList: coverArtList ?? this.coverArtList,
      chapterSelected: chapterSelected ?? this.chapterSelected,
      chapters: chapters ?? this.chapters,
      chapterNames: chapterNames ?? this.chapterNames,
      chapterText: chapterText ?? this.chapterText,
    );
  }
}
