part of 'side_notes.dart';

class SideNotesBloc extends Cubit<SideNotesState> {
  final String? id;
  SideNotesBloc({
    this.id,
  }) : super(const SideNotesState()) {
    init(id);
  }

  void init(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> notes = {};
    if (prefs.getStringList('$id note keys') != null &&
        prefs.getStringList('$id note vals') != null) {
      List<String> keys = prefs.getStringList('$id note keys')!;
      List<String> vals = prefs.getStringList('$id note vals')!;
      for (int index = 0; index < keys.length; index++) {
        notes.addAll({keys[index]: vals[index]});
      }
      int outlines = 0;
      int characters = 0;
      int note = 0;
      if (prefs.getInt('$id outlines') != null) {
        outlines = prefs.getInt('$id outlines')!;
      }
      if (prefs.getInt('$id characters') != null) {
        characters = prefs.getInt('$id characters')!;
      }
      if (prefs.getInt('$id note') != null) {
        note = prefs.getInt('$id note')!;
      }
      emit(state.copyWith(
          notes: notes, outlines: outlines, characters: characters, note: note));
    }
  }

  void updateVal(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> updatedNote = state.notes.map(
      (newKey, value) {
        final MapEntry<String, String> newVal;
        if (newKey == key) {
          newVal = MapEntry(newKey, val);
        } else {
          newVal = MapEntry(newKey, value);
        }
        return newVal;
      },
    );
    final List<String> vals = List.generate(updatedNote.length, (index) {
      return updatedNote.values.elementAt(index);
    });
    prefs.setStringList('$id note vals', vals);
    emit(state.copyWith(notes: updatedNote));
  }

  void newNote(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> notes = {};
    if (state.notes.isNotEmpty) {
      for (int index = 0; index < state.notes.length; index++) {
        notes.addAll(
            {state.notes.keys.elementAt(index): state.notes.values.elementAt(index)});
      }
    }
    List<String> keys = [];
    List<String> vals = [];
    if (prefs.getStringList('$id note keys') != null) {
      keys = prefs.getStringList('$id note keys')!;
      vals = prefs.getStringList('$id note vals')!;
    }
    int outlines = state.outlines;
    int characters = state.characters;
    int note = state.note;
    if (key == 'Outline') {
      outlines += 1;
      keys.add('$key $outlines');
      notes.addAll({'$key $outlines': ''});
    }
    if (key == 'Character') {
      characters += 1;
      keys.add('$key $characters');
      notes.addAll({'$key $characters': ''});
    }
    if (key == 'Note') {
      note += 1;
      keys.add('$key $note');
      notes.addAll({'$key $note': ''});
    }

    // saving notes map
    vals.add('');
    prefs.setStringList('$id note keys', keys);
    prefs.setStringList('$id note vals', vals);
    // saving integer tracking
    prefs.setInt('$id outlines', outlines);
    prefs.setInt('$id characters', characters);
    prefs.setInt('$id note', note);

    emit(state.copyWith(
        notes: notes, note: note, outlines: outlines, characters: characters));
  }

  void select(int selected) {
    emit(state.copyWith(selected: selected));
  }
}
