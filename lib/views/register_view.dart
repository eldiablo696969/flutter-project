import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ireview/services/auth/auth_exceptions.dart';
import 'package:ireview/services/auth/bloc/auth_bloc.dart';
import 'package:ireview/services/auth/bloc/auth_event.dart';
import 'package:ireview/services/auth/bloc/auth_state.dart';
import 'package:ireview/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password !');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email Already In use !');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email !');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed To Register !');
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 63, 62, 62),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.black,
          title: const Text('Register'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          elevation: 10.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Create An Account To Start Writing Your notes!',
                    textAlign: TextAlign.center,
                  ),
                ),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email Here Please:',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 145, 147, 147)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password Here Please:',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 145, 147, 147)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            context.read<AuthBloc>().add(AuthEventRegister(
                                  email,
                                  password,
                                ));
                          },
                          child: const Text('Register')),
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                          child: const Text('Already Registered? Login Here!'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
