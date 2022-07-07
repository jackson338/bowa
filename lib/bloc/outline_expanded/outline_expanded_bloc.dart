part of 'outline_expanded.dart';

class OutlineExpandedBloc extends Cubit<OutlineExpandedState> {
  final OutlineState outlineState;
  OutlineExpandedBloc({required this.outlineState})
      : super(const OutlineExpandedState()) {
    init();
  }

  void init() {
    emit(state.copyWith(
        storyPoint: outlineState.storyPoint,
        subPoint: outlineState.subPoint,
        bodySelected: outlineState.bodySelected));
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
    character.add(_details());
    emit(state.copyWith(characters: character));
  }

  List<TextEditingController> _details() {
    List<TextEditingController> details = [];
    details.add(_name());
    details.add(_looks());
    details.add(_personality());
    details.add(_description());

    return details;
  }

  TextEditingController _name() {
    TextEditingController name = TextEditingController();
    name.text = 'Name: ';
    return name;
  }

  TextEditingController _looks() {
    TextEditingController looks = TextEditingController();
    looks.text = 'Looks: ';
    return looks;
  }

  TextEditingController _personality() {
    TextEditingController personality = TextEditingController();
    personality.text = 'Personality: ';
    return personality;
  }

  TextEditingController _description() {
    TextEditingController description = TextEditingController();
    description.text = 'Description: ';
    return description;
  }

  void updateCharacterState(List<List<TextEditingController>> characters) {
    emit(state.copyWith(characters: characters));
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
