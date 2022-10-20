part of 'chapter_list.dart';

class ChapterListState {
  final int chapterSelected;
  final int selectedDraft;
  final List<int> drafts;
  final List<String> chapters;
  final List<String> chapterNames;
  final List<String> chapterText;
  final List<dynamic> jsonChapterText;
  final int wordGoal;

  const ChapterListState({
    this.chapterSelected = 0,
    this.selectedDraft = 0,
    this.drafts = const [1],
    this.chapters = const [],
    this.chapterNames = const [],
    this.chapterText = const [],
    this.jsonChapterText = const [],
    this.wordGoal = 0,
  });

  ChapterListState copyWith({
    final int? chapterSelected,
    final int? selectedDraft,
    final List<int>? drafts,
    final List<String>? chapters,
    final List<String>? chapterNames,
    final List<String>? chapterText,
    final List<dynamic>? jsonChapterText,
    final int? wordGoal,
  }) {
    return ChapterListState(
      chapterSelected: chapterSelected ?? this.chapterSelected,
      selectedDraft: selectedDraft ?? this.selectedDraft,
      drafts: drafts ?? this.drafts,
      chapters: chapters ?? this.chapters,
      chapterNames: chapterNames ?? this.chapterNames,
      chapterText: chapterText ?? this.chapterText,
      jsonChapterText: jsonChapterText ?? this.jsonChapterText,
      wordGoal: wordGoal ?? this.wordGoal,
    );
  }
}
