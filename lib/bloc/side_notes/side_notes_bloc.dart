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
    init();
  }

  void init() {
    Map<String, String> mapNotes = {};
    for (int i = 0;
        i < lBloc.state.user!.library![index].sideNotes.notes.values.length;
        i++) {
      if (lBloc.state.user!.library![index].sideNotes.notes.values
          .elementAt(i)
          .isNotEmpty) {
        Document doc;
        doc = Document.fromJson(jsonDecode(
            lBloc.state.user!.library![index].sideNotes.notes.values.elementAt(i)));
        mapNotes.addEntries([
          MapEntry(lBloc.state.user!.library![index].sideNotes.notes.keys.elementAt(i),
              doc.toPlainText())
        ]);
      }
    }
    emit(state.copyWith(
        notes: mapNotes,
        outlines: lBloc.state.user!.library![index].sideNotes.outlines,
        characters: lBloc.state.user!.library![index].sideNotes.outlines,
        note: lBloc.state.user!.library![index].sideNotes.note));
  }

  void updateVal(String key, QuillController doc) {
    //updated note
    Map<String, String> updatedNote =
        lBloc.state.user!.library![index].sideNotes.notes.map(
      (newKey, value) {
        final MapEntry<String, String> newVal;
        if (newKey == key) {
          newVal = MapEntry(newKey, jsonEncode(doc.document.toDelta().toJson()));
        } else {
          newVal = MapEntry(newKey, value);
        }
        return newVal;
      },
    );
    lBloc.state.user!.library![index].sideNotes =
        lBloc.state.user!.library![index].sideNotes.copyWith(notes: updatedNote);
    //updated notes map
    Map<String, String> mapNotes = {};
    for (int i = 0;
        i < lBloc.state.user!.library![index].sideNotes.notes.values.length;
        i++) {
      if (lBloc.state.user!.library![index].sideNotes.notes.values
          .elementAt(i)
          .isNotEmpty) {
        Document doc;
        doc = Document.fromJson(jsonDecode(
            lBloc.state.user!.library![index].sideNotes.notes.values.elementAt(i)));
        mapNotes.addEntries([
          MapEntry(lBloc.state.user!.library![index].sideNotes.notes.keys.elementAt(i),
              doc.toPlainText())
        ]);
      }
    }
    emit(state.copyWith(notes: mapNotes));
  }

  void newNote(String key) {
    Map<String, String> notes = {};
    notes.addAll(lBloc.state.user!.library![index].sideNotes.notes);
    int outlines = lBloc.state.user!.library![index].sideNotes.outlines;
    int characters = lBloc.state.user!.library![index].sideNotes.characters;
    int note = lBloc.state.user!.library![index].sideNotes.note;
    if (key == 'Outline') {
      outlines += 1;
      Document doc = Document();
      doc.insert(0, 'Outline');
      notes.addAll({'$key $outlines': jsonEncode(doc.toDelta().toJson())});
    }
    if (key == 'Character') {
      characters += 1;
      Document doc = Document();
      doc.insert(0, 'Character');
      notes.addAll({'$key $characters': jsonEncode(doc.toDelta().toJson())});
    }
    if (key == 'Note') {
      note += 1;
      Document doc = Document();
      doc.insert(0, 'Note');
      notes.addAll({'$key $note': jsonEncode(doc.toDelta().toJson())});
    }
    lBloc.state.user!.library![index].sideNotes =
        lBloc.state.user!.library![index].sideNotes.copyWith(
      notes: notes,
      note: note,
      outlines: outlines,
      characters: characters,
    );
    init();
  }
}
