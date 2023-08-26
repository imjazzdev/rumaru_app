import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rumaru_app/pages/signin.dart';
import 'package:rumaru_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetail extends StatefulWidget {
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  TextEditingController telpC = TextEditingController();

  // Future updateTelp() async {
  //   final docOwnerTelp =
  //       FirebaseFirestore.instance.collection('kost').doc(Utils.USER_NOW);
  //   docOwnerTelp.update({'owner.no_wa': telpC.text});
  // }

  @override
  Widget build(BuildContext context) {
    if (Utils.USER_NOW != '') {
      if (Utils.isPenyediaKost == true) {
        return const ProfileDetailPenyedia();
      } else {
        return const ProfileDetailUser();
      }
    } else {
      return const ProfileDetailGuest();
    }
  }
}

class AjuanPenyedia {
  final String nama;
  final String email;
  final String no_wa;

  AjuanPenyedia({
    required this.nama,
    required this.email,
    required this.no_wa,
  });

  Map<String, dynamic> toJson() => {
        'nama_user': nama,
        'email': email,
        'no_wa': no_wa,
      };
}

class ProfileDetailPenyedia extends StatefulWidget {
  const ProfileDetailPenyedia({super.key});

  @override
  State<ProfileDetailPenyedia> createState() => _ProfileDetailPenyediaState();
}

class _ProfileDetailPenyediaState extends State<ProfileDetailPenyedia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(40),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/user.png',
              height: 200,
            ),
            Text(
              Utils.USER_NOW,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Penyedia',
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Contact Number', style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () {
                    try {
                      launchUrl(
                          Uri.parse('https://wa.me/+${Utils.USER_WA_NOW}'));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.orange.shade400,
                      ));
                    }
                  },
                  child: Image.asset(
                    'assets/img/whatsapp.png',
                    height: 30,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status', style: TextStyle(fontSize: 16)),
                Image.asset(
                  'assets/img/done.png',
                  height: 30,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ajuan penyedia kost',
                    style: TextStyle(fontSize: 16)),
                Image.asset(
                  'assets/img/done.png',
                  height: 30,
                )
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.question,
                    title: 'Log Out ?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                          (route) => false);
                    },
                  ).show();
                },
                child: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class ProfileDetailUser extends StatefulWidget {
  const ProfileDetailUser({super.key});

  @override
  State<ProfileDetailUser> createState() => _ProfileDetailUserState();
}

class _ProfileDetailUserState extends State<ProfileDetailUser> {
  bool _ajuanPenyedia = false;

  Future ajuanPenyedia() async {
    final doc = FirebaseFirestore.instance
        .collection('ajuan_penyedia_kost')
        .doc(FirebaseAuth.instance.currentUser!.email.toString());
    final kost = AjuanPenyedia(
        nama: Utils.USER_NOW,
        email: FirebaseAuth.instance.currentUser!.email.toString(),
        no_wa: Utils.USER_WA_NOW);
    final json = kost.toJson();
    await doc.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(40),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/user.png',
              height: 200,
            ),
            Text(
              Utils.USER_NOW,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Text(
              'User',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Contact Number', style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () {
                    try {
                      launchUrl(
                          Uri.parse('https://wa.me/+${Utils.USER_WA_NOW}'));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.orange.shade400,
                      ));
                    }
                  },
                  child: Image.asset(
                    'assets/img/whatsapp.png',
                    height: 30,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status', style: TextStyle(fontSize: 16)),
                Image.asset(
                  'assets/img/done.png',
                  height: 30,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ajuan penyedia kost',
                    style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.question,
                      title: 'Ingin jadi menyedia kost?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        ajuanPenyedia();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          elevation: 5,
                          duration: Duration(seconds: 5),
                          content: Text(
                            'Pengajuan dikirim, mohon tunggu acc',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          backgroundColor: Colors.blue,
                        ));
                      },
                    ).show();
                  },
                  child: Utils.isPenyediaKost
                      ? Image.asset(
                          'assets/img/done.png',
                          height: 30,
                        )
                      : Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                ),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.question,
                    title: 'Log Out ?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                          (route) => false);
                    },
                  ).show();
                },
                child: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class ProfileDetailGuest extends StatefulWidget {
  const ProfileDetailGuest({super.key});

  @override
  State<ProfileDetailGuest> createState() => _ProfileDetailGuestState();
}

class _ProfileDetailGuestState extends State<ProfileDetailGuest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(40),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/user.png',
              height: 200,
            ),
            Text(
              Utils.USER_NOW,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Guest',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Text('Anda belum login, Ingin login?'),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                      (route) => false);
                },
                child: const Text('Log In'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600),
              ),
            )
          ],
        ),
      )),
    );
  }
}
