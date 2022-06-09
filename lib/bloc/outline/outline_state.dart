part of 'outline.dart';

class OutlineState {
  final List<TextEditingController> storyPoint;
  final List<List<TextEditingController>> subPoint;
  final List<List<TextEditingController>> characters;
  final List<List<TextEditingController>> details;
  final String bodySelected;

  const OutlineState({
    this.subPoint = const [],
    this.storyPoint = const [],
    this.characters = const [],
    this.details = const [],
    this.bodySelected = 'one',
  });

  OutlineState copyWith({
    final List<TextEditingController>? storyPoint,
    final List<List<TextEditingController>>? subPoint,
    final List<List<TextEditingController>>? characters,
    final List<List<TextEditingController>>? details,
    final String? bodySelected,
  }) {
    return OutlineState(
      storyPoint: storyPoint ?? this.storyPoint,
      subPoint: subPoint ?? this.subPoint,
      characters: characters ?? this.characters,
      details: details ?? this.details,
      bodySelected: bodySelected ?? this.bodySelected,
    );
  }
}
