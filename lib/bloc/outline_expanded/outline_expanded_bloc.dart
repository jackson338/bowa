part of 'outline_expanded.dart';

class OutlineExpandedBloc extends Cubit<OutlineExpandedState> {
  final OutlineState outlineState;
  OutlineExpandedBloc({required this.outlineState})
      : super(const OutlineExpandedState()) {
    init();
  }

  void init() {
    emit(state.copyWith(
        storyPoint: outlineState.storyPoint, subPoint: outlineState.subPoint));
  }

  void addPoint(TextEditingController controller) {
    List<TextEditingController> points = [];
    if (state.storyPoint.isNotEmpty) {
      points.addAll(state.storyPoint);
    }
    points.add(controller);
    emit(state.copyWith(
      storyPoint: points,
    ));
  }

  void addParentSubPoint(
      int index, List<TextEditingController> controller, TextEditingController cont) {
    List<List<TextEditingController>> subPoints = [];
    if (state.subPoint.isNotEmpty) {
      subPoints.addAll(state.subPoint);
    }
    subPoints.add(controller);
    cont.text = '$index baby';
    subPoints[index].add(cont);
    emit(state.copyWith(subPoint: subPoints));
  }

  void selectBody(String val) {
    emit(state.copyWith(bodySelected: val));
  }

  void addSubPoint(int index, TextEditingController controller) {
    controller.text = '$index hey';
    List<List<TextEditingController>> subPoints = [];
    if (state.subPoint.isNotEmpty) {
      subPoints.addAll(state.subPoint);
    }
    if (subPoints.isEmpty) {
      List<TextEditingController> newCont = [controller];
      subPoints.add(newCont);
    } else {
      if (subPoints[index].isNotEmpty) subPoints[index].add(controller);
    }
    emit(state.copyWith(
      subPoint: subPoints,
    ));
  }

  void addCharacter() {
    List<List<TextEditingController>> character = [];
    if (state.characters.isNotEmpty) {
      character.addAll(state.characters);
    }
    List<TextEditingController> details = [];
    TextEditingController name = TextEditingController();
    name.text = 'Name: ';
    TextEditingController looks = TextEditingController();
    looks.text = 'Looks: ';
    TextEditingController personality = TextEditingController();
    personality.text = 'Personality: ';
    TextEditingController description = TextEditingController();
    description.text = 'Description: ';
    details.add(name);
    details.add(looks);
    details.add(personality);
    details.add(description);
    character.add(details);
    emit(state.copyWith(characters: character));
  }

  void addDetail() {
    List<TextEditingController> detail = [];
    TextEditingController description = TextEditingController();
    description.text = 'details';
    if (state.details.isNotEmpty) detail.addAll(state.details);
    detail.add(description);
    emit(state.copyWith(details: detail));
  }
}
