import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter_project/firebase_options.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  // this is our login page
  const LoginView({super.key});

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
      appBar: AppBar(title: const Text("Log In")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter your Email here.",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your Password here.",
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        // FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
                        try {
                          // handle user not found exception in log in.
                          final userCredential = FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          // print("Something Bad Happened");
                          // print(e.runtimeType);
                          // print(e.code);
                          if (e.code == "user-not-found") {
                            print("User not found.");
                          } else if (e.code == "wrong-password") {
                            print("WRONG PASSWORD");
                          } else {
                            print("SOMETHING WRONG HAPPENED!!");
                            print(e.code);
                          }
                        }
                      },
                      child: const Text("Register")),
                ],
              );
            default:
              return const Text(
                  "Loading...."); // if future is not finished then this text is seen, i.e,
            //if its very slow or whatever
          }
        },
      ),
    );
  }
}
