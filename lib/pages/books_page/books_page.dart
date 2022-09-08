import 'package:bowa/bloc/writing/writing.dart';
import 'package:bowa/pages/books_page/reading_page.dart';
import 'package:bowa/widgets/writing_book_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/books/books.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WritingBloc(
        context: context,
      ),
      child: BlocBuilder<WritingBloc, WritingState>(
        buildWhen: (previous, current) => previous.idList != current.idList,
        builder: (context, state) {
          if (!context.read<WritingBloc>().state.titlesUpdated) {
            context.read<WritingBloc>().updateTitles();
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(state.title),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: WritingBookList(
                  idList: context.read<WritingBloc>().state.idList,
                  titleList: context.read<WritingBloc>().state.titleList,
                  coverArtList: context.read<WritingBloc>().state.coverArtList ?? [],
                  ids: state.idList,
                  writingBloc: context.read<WritingBloc>(),
                ),
              ),
            ),
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width / 2.6,
              child: Card(
                elevation: 2,
                child: TextButton(
                  onPressed: () {
                    newDraft(context, context.read<WritingBloc>());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        const Text(
                          'New Draft',
                          style: TextStyle(color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.edit_note,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void newDraft(BuildContext context, WritingBloc bloc) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController wordGoal = TextEditingController(text: '50000');
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (sheetContext) {
        return BlocProvider(
          create: (context) => WritingBloc(context: context),
          child: BlocBuilder<WritingBloc, WritingState>(
            buildWhen: (previous, current) =>
                previous.coverArtList != current.coverArtList,
            builder: (context, state) {
              WritingBloc writingBloc = context.read<WritingBloc>();
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
                      keyboardAppearance: Brightness.dark,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    //submit button
                    Card(
                      color: Theme.of(context).backgroundColor,
                      elevation: 3,
                      child: TextButton(
                        onPressed: () {
                          bloc.createDraft(titleController, sheetContext,
                              writingBloc.state, wordGoal.text);
                          // Navigator.of(context).pop();
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
                    Row(
                      children: [
                        TextButton(
                          onPressed: writingBloc.getFromGallery,
                          child: Row(
                            children: const [
                              Text('Add Image'),
                              Icon(Icons.add),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          width: 60,
                          child: state.coverArtList == null
                              ? Image.asset('lib/images/Untitled_Artwork.png')
                              : state.coverArtList!.isNotEmpty
                                  ? state.coverArtList!.last
                                  : Image.asset('lib/images/Untitled_Artwork.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Text(
                            'Word Goal: ',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 6,
                            child: TextField(
                              controller: wordGoal,
                              cursorColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
