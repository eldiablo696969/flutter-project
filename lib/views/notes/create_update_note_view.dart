import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ireview/services/auth/auth_service.dart';
import 'package:ireview/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:ireview/utilities/generics/get_arguments.dart';
import 'package:ireview/services/cloud/cloud_note.dart';
import 'package:ireview/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  _CreateUpdateNoteViewState createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  XFile? image;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 62, 62),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.black,
        title: const Text('New Note'),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          )
        ],
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        elevation: 10.0,
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 63, 62, 62))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 63, 62, 62))),
                  ),
                  style: const TextStyle(color: Colors.white, wordSpacing: 0),
                  autofocus: true,
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

// class ImagePickerScreen extends StatefulWidget {
//   const ImagePickerScreen({Key? key}) : super(key: key);

//   @override
//   State<ImagePickerScreen> createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   XFile? image;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('gallery'),
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final ImagePicker picker = ImagePicker();
//                   final img =
//                       await picker.pickImage(source: ImageSource.gallery);
//                   setState(() {
//                     image = img;
//                   });
//                 },
//                 label: const Text('Choose Image'),
//                 icon: const Icon(Icons.image),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final ImagePicker picker = ImagePicker();
//                   final img =
//                       await picker.pickImage(source: ImageSource.camera);
//                   setState(() {
//                     image = img;
//                   });
//                 },
//                 label: const Text('Take Photo'),
//                 icon: const Icon(Icons.camera_alt_outlined),
//               ),
//             ],
//           ),
//           if (image != null)
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(child: Image.file(File(image!.path))),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         image = null;
//                       });
//                     },
//                     label: const Text('Remove Image'),
//                     icon: const Icon(Icons.close),
//                   )
//                 ],
//               ),
//             )
//           else
//             const SizedBox(),
//         ],
//       ),
//     );
//   }
// }
