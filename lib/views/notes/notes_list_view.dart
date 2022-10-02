import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ireview/services/cloud/cloud_note.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 63, 62, 62),
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                onDeleteNote(note);
              }
            },
            background: Container(
              alignment: AlignmentDirectional.centerStart,
              margin: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.red),
              // ignore: sort_child_properties_last
              child: Column(
                children: const [
                  Flexible(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 3),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              padding: const EdgeInsets.symmetric(vertical: 5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Color.fromARGB(255, 151, 147, 147),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 9.0, vertical: 9.0),
                      onTap: () {
                        onTap(note);
                      },
                      title: Text(
                        note.text,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
