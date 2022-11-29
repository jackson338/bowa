part of 'notes_editing.dart';

class NotesEditingBloc extends Cubit<NotesEditingState> {
  final String title;
  final String id;
  NotesEditingBloc({
    required this.title,
    required this.id,
  }) : super(const NotesEditingState());

  void tool() {
    emit(state.copyWith(tools: !state.tools));
  }
}
