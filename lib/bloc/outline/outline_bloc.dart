part of 'outline.dart';

class OutlineBloc extends Cubit<OutlineState> {
  final String? id;
  OutlineBloc({
    this.id,
  }) : super(const OutlineState()) {
    init(id);
  }

  void init(String? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<TextEditingController> points = [];
    List<List<TextEditingController>> chars = [];
    if (id != null) {
      // retrieving story points from local data
      if (prefs.getStringList('$id story points') != null) {
        List<String> storyPoints = prefs.getStringList('$id story points')!;
        for (String text in storyPoints) {
          TextEditingController cont = TextEditingController();
          cont.text = text;
          points.add(cont);
        }
      }
      // retrieving character names from local data
      if (prefs.getStringList('$id characters names') != null) {
        List<String> charNames = prefs.getStringList('$id characters names')!;
        List<TextEditingController> characterName = [];

        for (int ind = 0; ind < charNames.length; ind++) {
          TextEditingController text = TextEditingController();
          TextEditingController looks = TextEditingController();
          TextEditingController personality = TextEditingController();
          TextEditingController description = TextEditingController();
          text.text = charNames[ind];
          characterName.add(text);
          characterName.add(looks);
          characterName.add(personality);
          characterName.add(description);

          chars.add(characterName);
        }
      }
      emit(state.copyWith(storyPoint: points, characters: chars));
    }
  }

  void addPoint(TextEditingController controller) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<TextEditingController> points = [];
    List<String> pointsText = [];
    if (prefs.getStringList('$id story points') != null) {
      pointsText = prefs.getStringList('$id story points')!;
    }
    if (state.storyPoint.isNotEmpty) {
      points.addAll(state.storyPoint);
    }
    points.add(controller);
    pointsText.add(controller.text);
    prefs.setStringList('$id story points', pointsText);
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

  void addCharacter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<List<TextEditingController>> character = [];
    List<String> charNames = [];
    if (prefs.getStringList('$id characters names') != null) {
      charNames = prefs.getStringList('$id characters names')!;
    }
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
    // character name
    details.add(name);
    charNames.add(name.text);
    prefs.setStringList('$id characters names', charNames);
    // character looks
    details.add(looks);
    // character personality
    details.add(personality);
    // character description
    details.add(description);

    // character details (parent list)
    character.add(details);
    emit(state.copyWith(characters: character));
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

  void updateDetailState(List<TextEditingController> details) {
    emit(state.copyWith(details: details));
  }

  void saveCharacterText(List<List<TextEditingController>> characters) {
    emit(state.copyWith(characters: characters));
  }

  void saveStoryPointText(List<TextEditingController> storyPoints) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> points = [];
    for (TextEditingController text in storyPoints) {
      points.add(text.text);
    }
    prefs.setStringList('$id story points', points);
    emit(state.copyWith(storyPoint: storyPoints));
  }

  void saveSubPointText(List<List<TextEditingController>> subPoints) {
    emit(state.copyWith(subPoint: subPoints));
  }
}
