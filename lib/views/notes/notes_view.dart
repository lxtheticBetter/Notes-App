import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devTools show log;

import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout }

class _NotesViewState extends State<NotesView> {
  final Stream<QuerySnapshot> notes =
      FirebaseFirestore.instance.collection('notes').snapshots();

  CollectionReference notesCollectionReferance =
      FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              // devTools.log(value.toString());
              switch (value) {
                case MenuAction.logout:
                  {
                    final shouldLogOut = await showLogOutDailog(context);
                    devTools.log(shouldLogOut.toString());
                    if (shouldLogOut) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                  }

                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: notes,
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.hasError) {
                return const Text('Some Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading....');
              }

              final data = snapshot.requireData;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return Text('${data.docs[index]['note']}');
                },
              );
            },
          ),
          TextButton(
            onPressed: () async {
              Map<String, dynamic> demoData = {'note': 'Code for 4hrs'};
              final id = await notesCollectionReferance.add(demoData);
              print('id$id');
            },
            child: const Text('Add Data'),
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDailog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
