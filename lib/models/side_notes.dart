
import 'package:json_annotation/json_annotation.dart';
part 'side_notes.g.dart';


@JsonSerializable()
class SideNotes {
  @JsonKey(required: true)
  Map<String, String> notes;
  @JsonKey(required: true)
  int outlines;
  @JsonKey(required: true)
  int characters;
  @JsonKey(required: true)
  int note;
  SideNotes({
    required this.notes,
    required this.outlines,
    required this.characters,
    required this.note,
  });

  SideNotes.init({
    this.notes = const {},
    this.outlines = 0,
    this.characters = 0,
    this.note = 0,
  });

  SideNotes copyWith({
    Map<String, String>? notes,
    int? outlines,
    int? characters,
    int? note,
  }) {
    return SideNotes(
      notes: notes ?? this.notes,
      outlines: outlines ?? this.outlines,
      characters: characters ?? this.characters,
      note: note ?? this.note,
    );
  }
   factory SideNotes.fromJson(Map<String, dynamic> json) => _$SideNotesFromJson(json);
  Map<String, dynamic> toJson() => _$SideNotesToJson(this); 
}
