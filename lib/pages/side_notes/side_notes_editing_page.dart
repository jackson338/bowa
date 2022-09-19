import 'package:bowa/bloc/side_notes/side_notes.dart';
import 'package:bowa/bloc/side_notes_editing/notes_editing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:tuple/tuple.dart';

class NotesEditingPage extends StatelessWidget {
  final String title;
  final String id;
  final SideNotesBloc sideNotesBloc;
  const NotesEditingPage(
      {Key? key, required this.title, required this.sideNotesBloc, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuillController quillController = QuillController.basic();
    FocusNode quillFocus = FocusNode();
    return BlocProvider(
      create: (context) => NotesEditingBloc(title: title, id: id),
      child: BlocBuilder<NotesEditingBloc, NotesEditingState>(
        builder: (context, state) {
          NotesEditingBloc notesBloc = context.read<NotesEditingBloc>();
          //setting document for json formatting
          Document doc;
          state.noteText.isNotEmpty
              ? doc = Document.fromJson(state.noteText)
              : doc = Document();
          //creating quill controller and assigning the document to the json created 'doc' value
          quillController = QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
            onSelectionChanged: (_) {
              notesBloc.saveText(quillController);
            },
          );

          return GestureDetector(
            onTap: () {
              notesBloc.unfocus(quillController);
              sideNotesBloc.updateVal(title, quillController.document.toPlainText());
              quillFocus.unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.headline1,
                ),
                leading: IconButton(
                  onPressed: () {
                    sideNotesBloc.updateVal(
                        title, quillController.document.toPlainText());
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: QuillEditor(
                          controller: quillController,
                          focusNode: quillFocus,
                          scrollController: ScrollController(),
                          scrollable: true,
                          padding: const EdgeInsets.only(left: 30),
                          autoFocus: false,
                          readOnly: false,
                          expands: true,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardAppearance: Brightness.dark,
                          customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                  Theme.of(context).textTheme.bodyText1!,
                                  const Tuple2(16, 0),
                                  const Tuple2(0, 0),
                                  null),
                              h1: DefaultTextBlockStyle(
                                  TextStyle(
                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                      fontSize: 35),
                                  const Tuple2(16, 0),
                                  const Tuple2(0, 0),
                                  null),
                              h2: DefaultTextBlockStyle(
                                  TextStyle(
                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                      fontSize: 28),
                                  const Tuple2(16, 0),
                                  const Tuple2(0, 0),
                                  null),
                              h3: DefaultTextBlockStyle(
                                  TextStyle(
                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                      fontSize: 21),
                                  const Tuple2(16, 0),
                                  const Tuple2(0, 0),
                                  null),
                              bold: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontWeight: FontWeight.bold),
                              color: Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: QuillToolbar.basic(
                        customButtons: [
                          QuillCustomButton(
                            icon: state.tools
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            onTap: () {
                              notesBloc.unfocus(quillController);
                              sideNotesBloc.updateVal(
                                  title, quillController.document.toPlainText());
                              quillFocus.unfocus();
                              notesBloc.tool();
                            },
                          ),
                        ],
                        controller: quillController,
                        showCameraButton: false,
                        showLink: false,
                        showCenterAlignment: false,
                        showCodeBlock: false,
                        showDirection: false,
                        showFormulaButton: false,
                        showImageButton: false,
                        showDividers: false,
                        showVideoButton: false,
                        showFontSize: false,
                        showFontFamily: false,
                        // showAlignmentButtons: state.tools,
                        showColorButton: false,
                        showQuote: false,
                        showBackgroundColorButton: false,
                        showListCheck: state.tools,
                        showInlineCode: state.tools,
                        showListBullets: state.tools,
                        showListNumbers: state.tools,
                        showSearchButton: state.tools,
                        showIndent: state.tools,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
