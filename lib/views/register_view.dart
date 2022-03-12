import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utils/show_error_dailog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final userCredential = await AuthService.firebase()
                        .createUser(email: email, password: password);
                    // print(userCredential);
                    final user = AuthService.firebase().currentUser;
                    await AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(
                      verifyEmailRoute,
                    );
                  } on EmailAlreadyInUseAuthException {
                    return await showErrorDailog(
                      context,
                      'Email already in use!',
                    );
                  } on InvalidEmailAuthException {
                    return await showErrorDailog(
                      context,
                      'Email is invalid!',
                    );
                  } on WeakPasswordAuthException {
                    return await showErrorDailog(context, 'Password too weak!');
                  } on GenerciAuthexception {
                    return await showErrorDailog(
                        context, 'Registration failed!');
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
