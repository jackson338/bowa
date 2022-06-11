part of 'outline_expanded.dart';

class OutlineExpandedState {
  final List<TextEditingController> storyPoint;
  final List<List<TextEditingController>> subPoint;
  final List<List<TextEditingController>> characters;
  final List<TextEditingController> details;
  final String bodySelected;

  const OutlineExpandedState({
    this.subPoint = const [],
    this.storyPoint = const [],
    this.characters = const [],
    this.details = const [],
    this.bodySelected = 'one',
  });

  OutlineExpandedState copyWith({
    final List<TextEditingController>? storyPoint,
    final List<List<TextEditingController>>? subPoint,
    final List<List<TextEditingController>>? characters,
    final List<TextEditingController>? details,
    final String? bodySelected,
  }) {
    return OutlineExpandedState(
      storyPoint: storyPoint ?? this.storyPoint,
      subPoint: subPoint ?? this.subPoint,
      characters: characters ?? this.characters,
      details: details ?? this.details,
      bodySelected: bodySelected ?? this.bodySelected,
    );
  }
}
