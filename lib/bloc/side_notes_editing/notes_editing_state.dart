part of 'notes_editing.dart';

class NotesEditingState {
  final bool tools;

  const NotesEditingState({
    this.tools = true,
  });

  NotesEditingState copyWith({
    final bool? tools,
  }) {
    return NotesEditingState(
      tools: tools ?? this.tools,
    );
  }
}
