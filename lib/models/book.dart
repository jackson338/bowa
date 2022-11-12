import 'package:bowa/models/side_notes.dart';

class Book {
   String id;
   String title;
   List<List<String>?> chapterTitles;
   List<List<String>?> chapterTexts;
   List<List<String>?> chapters;
   List<dynamic> jsonChapterTexts;
   List<int> drafts;
   int selectedDraft;
   List<int?> wordGoals;
   SideNotes? sideNotes;
  Book({
    required this.id,
    required this.title,
    required this.chapterTitles,
    required this.chapterTexts,
    required this.chapters,
    required this.jsonChapterTexts,
    required this.drafts,
    required this.selectedDraft,
    required this.wordGoals,
    this.sideNotes,
  });
}
