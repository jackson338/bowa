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
        List<String> looksStrings = prefs.getStringList('$id looks')!;
        List<String> personalities = prefs.getStringList('$id personalities')!;
        List<String> descriptions = prefs.getStringList('$id descriptions')!;
        List<TextEditingController> character = [];

        for (int ind = 0; ind < charNames.length; ind++) {
          TextEditingController name = TextEditingController();
          TextEditingController looks = TextEditingController();
          TextEditingController personality = TextEditingController();
          TextEditingController description = TextEditingController();
          name.text = charNames[ind];
          looks.text = looksStrings[ind];
          personality.text = personalities[ind];
          description.text = descriptions[ind];
          character.add(name);
          character.add(looks);
          character.add(personality);
          character.add(description);

          chars.add(character);
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
    List<String> looksStrings = [];
    List<String> personalities = [];
    List<String> descriptions = [];
    if (prefs.getStringList('$id characters names') != null) {
      charNames = prefs.getStringList('$id characters names')!;
    }
    if (prefs.getStringList('$id looks') != null) {
      looksStrings = prefs.getStringList('$id looks')!;
    }
    if (prefs.getStringList('$id personalities') != null) {
      personalities = prefs.getStringList('$id personalities')!;
    }
    if (prefs.getStringList('$id descriptions') != null) {
      descriptions = prefs.getStringList('$id descriptions')!;
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
    looksStrings.add(looks.text);
    prefs.setStringList('$id looks', looksStrings);
    // character personality
    details.add(personality);
    personalities.add(personality.text);
    prefs.setStringList('$id personalities', personalities);
    // character description
    details.add(description);
    descriptions.add(description.text);
    prefs.setStringList('$id descriptions', descriptions);

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

// when onChange is called from the characters_body_expanded page it updates and locally saves the text of each individual character attribute.
  void saveCharacterText(List<List<TextEditingController>> characters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> charNames = [];
    List<String> looksStrings = [];
    List<String> personalities = [];
    List<String> descriptions = [];
    for (List<TextEditingController> char in characters) {
      charNames.add(char[0].text);
      looksStrings.add(char[1].text);
      personalities.add(char[2].text);
      descriptions.add(char[3].text);
    }
    // character names
    prefs.setStringList('$id characters names', charNames);
    // character looks
    prefs.setStringList('$id looks', looksStrings);
    // character personality
    prefs.setStringList('$id personalities', personalities);
    // character description
    prefs.setStringList('$id descriptions', descriptions);

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
