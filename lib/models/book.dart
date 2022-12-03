import 'package:bowa/models/side_notes.dart';
import 'package:json_annotation/json_annotation.dart';
part 'book.g.dart';


@JsonSerializable()
class Book {
  @JsonKey(required: true)
   String id;
   @JsonKey(required: true)
   String title;
   @JsonKey(required: true)
   List<List<String>> chapterTitles;
   @JsonKey(required: true)
   List<List<String>> chapterTexts;
   @JsonKey(required: true)
   List<List<String>> chapters;
   @JsonKey(required: true)
   List<List<dynamic>> jsonChapterTexts;
   @JsonKey(required: true)
   List<int> drafts;
   @JsonKey(required: true)
   int selectedDraft;
   @JsonKey(required: true)
   List<int?> wordGoals;
   @JsonKey(required: true)
   SideNotes sideNotes;
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
    required this.sideNotes,
  });
   factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this); 
}
