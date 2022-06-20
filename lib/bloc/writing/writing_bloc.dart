part of 'writing.dart';

class WritingBloc extends Cubit<WritingState> {
  final BuildContext context;
  WritingBloc({
    required this.context,
  }) : super(const WritingState());

  getFromGallery() async {
    List<Image> newCoverArtList = [];
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
        }
        newCoverArtList.add(Image.file(
          imageFile,
          fit: BoxFit.contain,
        ));
        emit(state.copyWith(coverArtList: newCoverArtList, imageSelected: true));
      }
    } catch (e) {
      emit(state.copyWith(imageSelected: false));
      return;
    }
  }

  void createDraft(TextEditingController titleController, BuildContext sheetContext,
      WritingState writingState) {
    List<String> titleList = [];
    titleList.addAll(state.titleList);
    titleList.add(titleController.text);

    List<String> idList = [];
    idList.addAll(state.idList);
    idList.add(DateTime.now().toString());

    List<Image> newCoverArtList = [];
    if (state.coverArtList != null) {
      newCoverArtList.addAll(state.coverArtList!);
    }
    if (writingState.imageSelected) {
      newCoverArtList.addAll(writingState.coverArtList!);
    } else {
      newCoverArtList.add(Image.asset('lib/images/IMG-1124.jpg'));
    }

    emit(
      state.copyWith(
        titleList: titleList,
        coverArtList: newCoverArtList,
        idList: idList,
        imageSelected: false,
      ),
    );
    Navigator.of(sheetContext).pop();
  }
}
