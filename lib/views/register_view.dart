import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  String error = "";

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
          title: const Text("Register"),
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
            Text(error),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);
                    // print(userCredential);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    print('authentication error');
                    print(e.code);
                    switch (e.code) {
                      case 'email-already-in-use':
                        {
                          return setState(
                              () => error = "Email is already in use!");
                        }
                      case 'weak-password':
                        {
                          return setState(
                            () => error = 'Password too weak',
                          );
                        }

                      default:
                        {
                          return setState(
                            () => error = 'Some error occured',
                          );
                        }
                    }
                  }
                },
                child: const Text("Register")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text('Already Registered? Login Here!'))
          ],
        ));
  }
}
