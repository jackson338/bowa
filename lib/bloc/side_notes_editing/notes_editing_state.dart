part of 'notes_editing.dart';

class NotesEditingState {
  final dynamic noteText;

  const NotesEditingState({
    this.noteText = '',
  });

  NotesEditingState copyWith({
    final dynamic noteText,
  }) {
    return NotesEditingState(
      noteText: noteText ?? this.noteText,
    );
  }
}
