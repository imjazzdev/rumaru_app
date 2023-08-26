import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ForgotPassword extends StatefulWidget {
  final String email;
  const ForgotPassword({super.key, required this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forgot password?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Reset your password by email ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 130,
                child: ElevatedButton(
                    onPressed: () async {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: widget.email);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 5),
                        content: Text('Check your email for reset password'),
                        backgroundColor: Colors.orange.shade400,
                      ));
                      Navigator.pop(context);
                    },
                    child: Text('Reset', style: TextStyle(fontSize: 16))))
          ],
        ),
      )),
    );
  }
}
