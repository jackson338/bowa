part of 'side_notes.dart';

class SideNotesBloc extends Cubit<SideNotesState> {
  final String? id;
  final String title;
  final LoginBloc lBloc;
  final int index;
  SideNotesBloc({
    this.id,
    required this.title,
    required this.lBloc,
    required this.index,
  }) : super(const SideNotesState()) {
    init(id);
  }

  void init(id) {
    emit(state.copyWith(
        notes: lBloc.state.user!.library![index].sideNotes.notes,
        outlines: lBloc.state.user!.library![index].sideNotes.outlines,
        characters: lBloc.state.user!.library![index].sideNotes.outlines,
        note: lBloc.state.user!.library![index].sideNotes.note));
  }

  void updateVal(String key, String val) {
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
    print(lBloc.state.user!.library![index].sideNotes.notes);
    lBloc.state.user!.library![index].sideNotes =
        lBloc.state.user!.library![index].sideNotes.copyWith(notes: updatedNote);
    print(lBloc.state.user!.library![index].sideNotes.notes);
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
