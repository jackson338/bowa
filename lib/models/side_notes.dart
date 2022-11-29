class SideNotes {
  Map<String, String> notes;
  int outlines;
  int characters;
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
}
