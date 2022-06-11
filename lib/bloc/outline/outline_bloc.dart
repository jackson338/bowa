part of 'outline.dart';

class OutlineBloc extends Cubit<OutlineState> {
  OutlineBloc() : super(const OutlineState());

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

  void selectBody(String val) {
    emit(state.copyWith(bodySelected: val));
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

  void updateCharacterState(List<List<TextEditingController>> characters) {
    emit(state.copyWith(characters: characters));
  }

  void updateDetailState(List<TextEditingController> details) {
    emit(state.copyWith(details: details));
  }
}
