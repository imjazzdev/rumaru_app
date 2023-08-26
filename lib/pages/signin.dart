// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumaru_app/pages/forgot_password.dart';
import 'package:rumaru_app/pages/home.dart';
import 'package:rumaru_app/pages/signup.dart';

import '../utils/utils.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool _isvisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.only(left: 25, right: 25),
          child: ListView(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/img/logo-rumaru.png',
                    height: 180,
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, bottom: 15, right: 15, top: 0),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(
                            1,
                            4,
                          ),
                          blurRadius: 10,
                          spreadRadius: 2,
                          color: Colors.blue.withOpacity(0.2))
                    ]),
                child: Column(
                  children: [
                    TextField(
                      controller: emailC,
                      decoration: InputDecoration(
                          border: InputBorder.none, labelText: 'Email'),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.blue.shade50,
                    ),
                    TextField(
                      controller: passwordC,
                      obscureText: _isvisibility,
                      decoration: InputDecoration(
                          suffixIconColor: Colors.grey,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isvisibility = !_isvisibility;
                                });
                              },
                              icon: _isvisibility
                                  ? Icon(Icons.visibility)
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.blue.shade400,
                                    )),
                          border: InputBorder.none,
                          labelText: 'Password'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailC.text, password: passwordC.text);
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                          (route) => false);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-password') {
                        setState(() {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.warning,
                            title:
                                'Email & password incorrect. Please try again',
                            btnOkOnPress: () {},
                          ).show();

                          emailC.clear();
                          passwordC.clear();
                        });
                      } else if (e.code == 'user-not-found') {
                        setState(() {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.error,
                            title: 'User not found. Try again',
                            btnOkOnPress: () {},
                          ).show();

                          emailC.clear();
                          passwordC.clear();
                        });
                      }
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text(e.toString()),
                      //   backgroundColor: Colors.orange.shade400,
                      // ));
                    }
                  },
                  child: Text('Sign In', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(
                                email: emailC.text,
                              ),
                            ));
                      },
                      child: Text('Forgot password')),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ));
                      },
                      child: Text('Sign Up')),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: 'guest@gmail.com', password: '123456');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                      (route) => false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Lewati',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade500),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade500,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
