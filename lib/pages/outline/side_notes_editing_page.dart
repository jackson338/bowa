import 'package:bowa/bloc/side_notes/side_notes.dart';
import 'package:bowa/bloc/side_notes_editing/notes_editing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

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
        buildWhen: (previous, current) => previous.noteText != current.noteText,
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
                title: Text(title),
                leading: IconButton(
                  onPressed: () {
                    sideNotesBloc.updateVal(
                        title, quillController.document.toPlainText());
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: QuillToolbar.basic(
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
