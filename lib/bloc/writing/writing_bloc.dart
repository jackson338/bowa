part of 'writing.dart';

class WritingBloc extends Cubit<WritingState> {
  final BuildContext context;
  WritingBloc({
    required this.context,
  }) : super(const WritingState());

  void newProject() {
    final TextEditingController titleController = TextEditingController();
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (sheetContext) {
        return Container(
          color: Colors.grey,
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            children: [
              //pop-up title text
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('new book'),
              ),
              //title name text field
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Book Title'),
                controller: titleController,
              ),
              //submit button
              Card(
                color: Theme.of(context).backgroundColor,
                elevation: 3,
                child: TextButton(
                  onPressed: () {
                    List<Image> newCoverArtList = [];
                    if (state.coverArtList != null) {
                      newCoverArtList.addAll(state.coverArtList!);
                    }
                    newCoverArtList.add(Image.asset('lib/images/IMG-1124.jpg'));
                    List<String> titleList = [];
                    titleList.addAll(state.titleList);
                    titleList.add(titleController.text);
                    List<String> idList = [];
                    idList.addAll(state.idList);
                    idList.add(DateTime.now().toString());
                    emit(
                      state.copyWith(
                        titleList: titleList,
                        coverArtList: newCoverArtList,
                        idList: idList,
                      ),
                    );
                    Navigator.of(sheetContext).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Create Draft',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
