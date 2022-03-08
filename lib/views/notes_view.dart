import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devTools show log;

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout }

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              // devTools.log(value.toString());
              switch (value) {
                case MenuAction.logout:
                  {
                    final shouldLogOut = await showLogOutDailog(context);
                    devTools.log(shouldLogOut.toString());
                    if (shouldLogOut) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login/', (route) => false);
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
      body: const Text("Hello"),
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
