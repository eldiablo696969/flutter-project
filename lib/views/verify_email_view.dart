import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ireview/services/auth/bloc/auth_bloc.dart';
import 'package:ireview/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('verify your email address:')),
      body: Column(children: [
        const Text(
            "we've sent you an Email Verification, Please open it to verify your account."),
        const Text(
            "if you haven't recieved a verification email yet, press the button below"),
        TextButton(
          onPressed: () {
            context
                .read<AuthBloc>()
                .add(const AuthEventSendEmailVerification());
          },
          child: const Text('Send Email Verification'),
        ),
        TextButton(
          onPressed: () async {
            context.read<AuthBloc>().add(const AuthEventLogOut());
          },
          child: const Text('Restart'),
        ),
      ]),
    );
  }
}
