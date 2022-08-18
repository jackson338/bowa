part of 'writing.dart';

class WritingBloc extends Cubit<WritingState> {
  final BuildContext context;
  WritingBloc({
    required this.context,
  }) : super(const WritingState());

  void updateTitles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = [];
    List<String> titleIds = [];
    List<String> imagePaths = [];
    List<Image> newCoverArtList = [];

    titles.addAll(state.titleList);
    imagePaths.addAll(state.imagePaths);
    if (state.coverArtList != null) {
      newCoverArtList.addAll(state.coverArtList!);
    }
    if (prefs.getStringList('title ids list') != null) {
      titleIds = prefs.getStringList('title ids list')!;
      for (String id in titleIds) {
        if (prefs.getString('$id title') != null) {
          titles.add(prefs.getString('$id title')!);
        } else {
          titles.add('');
        }
        if (prefs.getString('$id path') != null) {
          newCoverArtList.add(Image.asset('lib/images/bowa_black.png'));
          // File imageFile = File(prefs.getString('$id path')!);
          // newCoverArtList.add(Image.file(
          //   imageFile,
          //   fit: BoxFit.contain,
          // ));
        } else {
          newCoverArtList.add(Image.asset('lib/images/bowa_black.png'));
        }
      }
      emit(state.copyWith(
          idList: titleIds,
          titleList: titles,
          coverArtList: newCoverArtList,
          titlesUpdated: true));
    }
  }

  void deleteBook(String id, String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> idList = [];
    idList.addAll(state.idList);
    idList.remove(id);
    List<String> titleList = [];
    titleList.addAll(state.titleList);
    titleList.remove(title);
    prefs.setStringList('title ids list', idList);
    prefs.remove('$id title');
    prefs.remove('$id path');
    emit(
      state.copyWith(
        titleList: titleList,
        idList: idList,
        imageSelected: false,
      ),
    );
  }

  getFromGallery() async {
    List<Image> newCoverArtList = [];
    List<String> path = [];
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2800,
        maxHeight: 2800,
      );
      if (pickedFile != null) {
        List<XFile> files = [];
        files.add(pickedFile);
        File imageFile = File(pickedFile.path);
        if (state.imageSelected) {
          newCoverArtList.removeLast();
          path.removeLast();
        }
        newCoverArtList.add(Image.file(
          imageFile,
          fit: BoxFit.contain,
        ));
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        // final File newImage = await imageFile.copy('$tempPath/${imageFile.path}');
        path.add('$tempPath/${imageFile.path}');
        emit(state.copyWith(
            coverArtList: newCoverArtList, imagePaths: path, imageSelected: true));
      }
    } catch (e) {
      emit(state.copyWith(imageSelected: false));
      return;
    }
  }

  void createDraft(TextEditingController titleController, BuildContext sheetContext,
      WritingState writingState) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<String> titleList = [];
    List<String> idList = [];
    List<String> imagePaths = [];
    List<Image> newCoverArtList = [];
    String id = DateTime.now().toString();

    titleList.addAll(state.titleList);
    titleList.add(titleController.text);
    idList.addAll(state.idList);

    if (state.coverArtList != null) {
      newCoverArtList.addAll(state.coverArtList!);
      imagePaths.addAll(state.imagePaths);
    }
    if (writingState.imageSelected) {
      newCoverArtList.addAll(writingState.coverArtList!);
      imagePaths.addAll(writingState.imagePaths);
    } else {
      newCoverArtList.add(Image.asset('lib/images/bowa_black.png'));
      imagePaths.add('lib/images/bowa_black.png');
    }

    idList.add(id);
    pref.setStringList('title ids list', idList);
    pref.setString('$id title', titleController.text);
    pref.setString('$id path', imagePaths.last);
    emit(
      state.copyWith(
        titleList: titleList,
        coverArtList: newCoverArtList,
        imagePaths: imagePaths,
        idList: idList,
        imageSelected: false,
      ),
    );
    Navigator.of(sheetContext).pop();
  }
}
