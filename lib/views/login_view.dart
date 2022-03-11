import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';

import '../utils/show_error_dailog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: "Enter Email"),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(hintText: "Enter Password"),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);
                    // print(userCredential);

                    final user = FirebaseAuth.instance.currentUser;
                    if (user?.emailVerified ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        notesRoute,
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamed(
                        verifyEmailRoute,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    // print(e.code);
                    switch (e.code) {
                      case 'user-not-found':
                        {
                          return await showErrorDailog(
                              context, 'User not Found!');
                        }
                      case 'wrong-password':
                        {
                          return await showErrorDailog(
                              context, 'Incorrect Password!');
                        }
                      default:
                        {
                          return await showErrorDailog(
                            context,
                            'Error: ${e.code}',
                          );
                        }
                    }
                  } catch (e) {
                    return await showErrorDailog(
                      context,
                      e.toString(),
                    );
                  }
                },
                child: const Text("Login")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text("Not Registered Yet? Register Now!"))
          ],
        ));
  }
}
