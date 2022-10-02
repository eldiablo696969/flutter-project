import 'package:flutter/material.dart';
import 'package:ireview/constants/routes.dart';
import 'package:ireview/enums/menu_action.dart';
import 'package:ireview/services/auth/auth_service.dart';
import 'package:ireview/services/auth/bloc/auth_bloc.dart';
import 'package:ireview/services/auth/bloc/auth_event.dart';
import 'package:ireview/services/cloud/cloud_note.dart';
import 'package:ireview/services/cloud/firebase_cloud_storage.dart';
import 'package:ireview/utilities/dialogs/logout_dialog.dart';
import 'package:ireview/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.black,
        title: const Text('Notes'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        elevation: 10.0,
        actions: [
          PopupMenuButton<MenuAction>(
            elevation: 10.0,
            color: Color.fromARGB(255, 21, 21, 21),
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                  textStyle: TextStyle(color: Colors.white),
                ),
              ];
            },
          )
        ],
      ),
      body: Scaffold(
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
