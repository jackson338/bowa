part of 'notes_editing.dart';

class NotesEditingBloc extends Cubit<NotesEditingState> {
  final String title;
  final String id;
  NotesEditingBloc({
    required this.title,
    required this.id,
  }) : super(const NotesEditingState()) {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('$id $title note json') != null) {
      final json = jsonDecode(prefs.getString('$id $title note json')!);
      emit(state.copyWith(noteText: json));
    }
  }

  void saveText(QuillController cont) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(cont.document.toDelta().toJson());
    prefs.setString('$id $title note json', json);
  }

  void unfocus(QuillController cont) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(cont.document.toDelta().toJson());
    prefs.setString('$id $title note json', json);
    final stateJson = jsonDecode(json);
      emit(state.copyWith(noteText: stateJson));
  }


}
