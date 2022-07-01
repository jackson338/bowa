import 'package:bowa/bloc/writing/writing.dart';
import 'package:bowa/pages/books_page/reading_page.dart';
import 'package:bowa/widgets/writing_book_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/books/books.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BooksBloc(
            context: context,
          ),
        ),
        BlocProvider(
          create: (_) => WritingBloc(
            context: context,
          ),
        ),
      ],
      child: BlocBuilder<BooksBloc, BooksState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.title),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            color: state.reading ? Colors.grey : Colors.white,
                            elevation: 3,
                            child: TextButton(
                              onPressed: context.read<BooksBloc>().reading,
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Reading',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: state.reading ? Colors.white : Colors.grey,
                            elevation: 3,
                            child: TextButton(
                              onPressed: () {
                                if (!context.read<WritingBloc>().state.titlesUpdated) {
                                  context.read<WritingBloc>().updateTitles();
                                }
                                context.read<BooksBloc>().writing();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Writing',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: state.reading
                          ? const ReadingPage()
                          : BlocBuilder<WritingBloc, WritingState>(
                              buildWhen: (previous, current) => previous != current,
                              builder: (context, state) {
                                return WritingBookList(
                                  idList: context.read<WritingBloc>().state.idList,
                                  titleList: context.read<WritingBloc>().state.titleList,
                                  coverArtList:
                                      context.read<WritingBloc>().state.coverArtList ??
                                          [],
                                          ids: state.idList,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: state.reading
                ? null
                : SizedBox(
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
                    ),
                    //submit button
                    Card(
                      color: Theme.of(context).backgroundColor,
                      elevation: 3,
                      child: TextButton(
                        onPressed: () {
                          bloc.createDraft(
                              titleController, sheetContext, writingBloc.state);
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
