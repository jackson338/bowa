// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'side_notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SideNotes _$SideNotesFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['notes', 'outlines', 'characters', 'note'],
  );
  return SideNotes(
    notes: Map<String, String>.from(json['notes'] as Map),
    outlines: json['outlines'] as int,
    characters: json['characters'] as int,
    note: json['note'] as int,
  );
}

Map<String, dynamic> _$SideNotesToJson(SideNotes instance) => <String, dynamic>{
      'notes': instance.notes,
      'outlines': instance.outlines,
      'characters': instance.characters,
      'note': instance.note,
    };
