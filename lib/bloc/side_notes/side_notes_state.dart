part of 'side_notes.dart';

class SideNotesState {
  final Map<String, String> notes;
  final int selected;
  final int outlines;
  final int characters;
  final int note;

  const SideNotesState({
    this.notes = const {},
    this.selected = 0,
    this.outlines = 0,
    this.characters = 0,
    this.note = 0,
  });

  SideNotesState copyWith({
    final Map<String, String>? notes,
    final int? selected,
    final int? outlines,
    final int? characters,
    final int? note,
  }) {
    return SideNotesState(
      notes: notes ?? this.notes,
      selected: selected ?? this.selected,
      outlines: outlines ?? this.outlines,
      characters: characters ?? this.characters,
      note: note ?? this.note,
    );
  }
}
