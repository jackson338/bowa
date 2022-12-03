// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'title',
      'chapterTitles',
      'chapterTexts',
      'chapters',
      'jsonChapterTexts',
      'drafts',
      'selectedDraft',
      'wordGoals',
      'sideNotes'
    ],
  );
  return Book(
    id: json['id'] as String,
    title: json['title'] as String,
    chapterTitles: (json['chapterTitles'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList(),
    chapterTexts: (json['chapterTexts'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList(),
    chapters: (json['chapters'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList(),
    jsonChapterTexts: (json['jsonChapterTexts'] as List<dynamic>)
        .map((e) => e as List<dynamic>)
        .toList(),
    drafts: (json['drafts'] as List<dynamic>).map((e) => e as int).toList(),
    selectedDraft: json['selectedDraft'] as int,
    wordGoals:
        (json['wordGoals'] as List<dynamic>).map((e) => e as int?).toList(),
    sideNotes: SideNotes.fromJson(json['sideNotes'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'chapterTitles': instance.chapterTitles,
      'chapterTexts': instance.chapterTexts,
      'chapters': instance.chapters,
      'jsonChapterTexts': instance.jsonChapterTexts,
      'drafts': instance.drafts,
      'selectedDraft': instance.selectedDraft,
      'wordGoals': instance.wordGoals,
      'sideNotes': instance.sideNotes,
    };
