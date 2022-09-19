part of 'notes_editing.dart';

class NotesEditingState {
  final dynamic noteText;
  final bool tools;

  const NotesEditingState({
    this.noteText = '',
    this.tools = false,
  });

  NotesEditingState copyWith({
    final dynamic noteText,
    final bool? tools,
  }) {
    return NotesEditingState(
      noteText: noteText ?? this.noteText,
      tools: tools ?? this.tools,
    );
  }
}
