// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rumaru_app/pages/home.dart';

import '../utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstnameC = TextEditingController();
  TextEditingController lastnameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController telpC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController repasswordC = TextEditingController();
  bool _isCheck = false;
  @override
  Widget build(BuildContext context) {
    print('SAAT INI PENYEDIA KOST? ${Utils.isPenyediaKost}');
    return Scaffold(
      //appBar: AppBar(),
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.only(left: 25, right: 25),
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 3,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(2, 4))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: firstnameC,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'First name',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 3,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(2, 4))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: lastnameC,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Last name',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 3,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(2, 4))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: emailC,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 3,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(2, 4))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: telpC,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Telp',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 3,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(2, 4))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: passwordC,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Password (min. 6 char)',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 3,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(2, 4))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: repasswordC,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Re-enter password',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Penyedia Kost ?'),
              Checkbox(
                  value: _isCheck,
                  onChanged: (_) {
                    setState(() {
                      _isCheck = !_isCheck;
                    });
                  })
            ],
          )
        ],
      )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(25),
        child: SizedBox(
            height: 40,
            child: ElevatedButton(
                onPressed: () {
                  if (passwordC.text == repasswordC.text) {
                    print('PENYEDIA KOST? ${_isCheck}');
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.success,
                      body: const Center(
                        child: Text(
                          'Data Tersimpan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      btnOkOnPress: () {
                        createUser();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                            (route) => false);
                      },
                    ).show();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Konfirmasi password salah!'),
                      backgroundColor: Colors.orange.shade400,
                    ));
                  }
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16),
                ))),
      ),
    );
  }

  Future createUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailC.text, password: passwordC.text);
    final doc =
        FirebaseFirestore.instance.collection('user_kost').doc(emailC.text);
    final kost = UserKost(
        nama: '${firstnameC.text}  ${lastnameC.text}',
        email: emailC.text,
        no_wa: telpC.text,
        penyedia_kost: _isCheck);
    final json = kost.toJson();
    await doc.set(json);
  }
}

class UserKost {
  final String nama;
  final String email;
  final String no_wa;
  final bool penyedia_kost;

  UserKost({
    required this.nama,
    required this.email,
    required this.no_wa,
    required this.penyedia_kost,
  });

  Map<String, dynamic> toJson() => {
        'nama_user': nama,
        'email': email,
        'no_wa': no_wa,
        'penyedia_kost': penyedia_kost
      };
}
