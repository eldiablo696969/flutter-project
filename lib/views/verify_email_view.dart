import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
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
      backgroundColor: const Color.fromARGB(255, 41, 39, 39),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.black,
        title: const Text('verify your email address'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                '''Please check your email for the verification link we've sent you. 
  (If you cant find the email, Please check you spam folder)''',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(const AuthEventSendEmailVerification());
            },
            child: const Text('Send Email Verification'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: const Text('Back To Login'),
          ),
        ]),
      ),
    );
  }
}
