// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rumaru_app/pages/profile_detail.dart';
import 'package:rumaru_app/pages/signin.dart';
import 'package:rumaru_app/utils/utils.dart';

import 'componen/item_product.dart';
import 'componen/shimmer_product.dart';
import 'detail_kost.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    if (Utils.USER_NOW == 'Guest') {
      return ProfileGuest();
    } else {
      if (Utils.isPenyediaKost == true) {
        return ProfilePenyedia();
      } else {
        return ProfileUser();
      }
    }
  }
}

class ProfilePenyedia extends StatefulWidget {
  const ProfilePenyedia({super.key});

  @override
  State<ProfilePenyedia> createState() => _ProfilePenyediaState();
}

class _ProfilePenyediaState extends State<ProfilePenyedia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/img/user.png'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.USER_NOW,
                        style: TextStyle(fontSize: 18),
                      ),
                      Text('Batam')
                    ],
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDetail(),
                        ));
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 40,
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Kost yang di kelola',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('kost')
                .where(
                  'owner.nama',
                  isEqualTo: Utils.USER_NOW,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView(
                  padding: EdgeInsets.only(bottom: 15),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2.75,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  children: snapshot.data!.docs
                      .map((e) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailKost(
                                      title_kost: e['nama_kost'],
                                      img1: e['imgURL1'],
                                      img2: e['imgURL2'],
                                      img3: e['imgURL3'],
                                      review1: e['review'][0],
                                      review2: e['review'][1],
                                      review3: e['review'][2],
                                      listrik: e['listrik'],
                                      harga_kost: e['harga_kost'],
                                      lokasi_kecamatan: e['lokasi_kecamatan'],
                                      lokasi_latitude: e['lokasi_latlong']
                                          ['latitude'],
                                      lokasi_longitude: e['lokasi_latlong']
                                          ['longitude'],
                                      information_detail:
                                          e['information_detail'],
                                      owner_kost_nama: e['owner']['nama'],
                                      owner_kost_wa: e['owner']['no_wa'],
                                      lemari: e['fasilitas_kost']['lemari'],
                                      kamar_mandi: e['fasilitas_kost']
                                          ['kamar_mandi'],
                                      parkarea: e['fasilitas_kost']
                                          ['park_area'],
                                      garden: e['fasilitas_kost']['garden'],
                                    ),
                                  ));
                            },
                            child: ItemProduct(
                              img: e['imgURL1'],
                              title: e['nama_kost'],
                              kecamatan: e['lokasi_kecamatan'],
                              harga: e['harga_kost'],
                              iconDelete: Utils.isPenyediaKost
                                  ? InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.scale,
                                          dialogType: DialogType.question,
                                          title:
                                              'Yakin ingin menghapus \'${e['nama_kost']}\'?',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            FirebaseFirestore.instance
                                                .collection('kost')
                                                .doc(e['nama_kost'])
                                                .delete();
                                          },
                                        ).show();
                                      },
                                      child:
                                          Image.asset('assets/img/delete.png'),
                                    )
                                  : SizedBox(),
                            ),
                          ))
                      .toList(),
                );
              } else {
                return ShimmerProduct();
              }
            },
          ),
        ],
      )),
    );
  }
}

class ProfileUser extends StatelessWidget {
  const ProfileUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/img/user.png'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.USER_NOW,
                        style: TextStyle(fontSize: 18),
                      ),
                      Text('Batam')
                    ],
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDetail(),
                        ));
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 40,
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Kost yang masuk keranjang',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('kost')
                .where(
                  'cart',
                  arrayContains:
                      FirebaseAuth.instance.currentUser!.email.toString(),
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView(
                  padding: EdgeInsets.only(bottom: 15),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2.75,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  children: snapshot.data!.docs
                      .map((e) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailKost(
                                      title_kost: e['nama_kost'],
                                      img1: e['imgURL1'],
                                      img2: e['imgURL2'],
                                      img3: e['imgURL3'],
                                      review1: e['review'][0],
                                      review2: e['review'][1],
                                      review3: e['review'][2],
                                      listrik: e['listrik'],
                                      harga_kost: e['harga_kost'],
                                      lokasi_kecamatan: e['lokasi_kecamatan'],
                                      lokasi_latitude: e['lokasi_latlong']
                                          ['latitude'],
                                      lokasi_longitude: e['lokasi_latlong']
                                          ['longitude'],
                                      information_detail:
                                          e['information_detail'],
                                      owner_kost_nama: e['owner']['nama'],
                                      owner_kost_wa: e['owner']['no_wa'],
                                      lemari: e['fasilitas_kost']['lemari'],
                                      kamar_mandi: e['fasilitas_kost']
                                          ['kamar_mandi'],
                                      parkarea: e['fasilitas_kost']
                                          ['park_area'],
                                      garden: e['fasilitas_kost']['garden'],
                                    ),
                                  ));
                            },
                            child: ItemProduct(
                              img: e['imgURL1'],
                              title: e['nama_kost'],
                              kecamatan: e['lokasi_kecamatan'],
                              harga: e['harga_kost'],
                              iconDelete: Utils.isPenyediaKost
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.scale,
                                          dialogType: DialogType.question,
                                          title:
                                              'Yakin ingin menghapus \'${e['nama_kost']}\' dari keranjang?',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            FirebaseFirestore.instance
                                                .collection('kost')
                                                .doc(e['nama_kost'])
                                                .update({
                                              'cart': FieldValue.arrayRemove([
                                                FirebaseAuth
                                                    .instance.currentUser!.email
                                                    .toString()
                                              ])
                                            });
                                          },
                                        ).show();
                                      },
                                      child:
                                          Image.asset('assets/img/delete.png'),
                                    ),
                            ),
                          ))
                      .toList(),
                );
              } else {
                return ShimmerProduct();
              }
            },
          ),
        ],
      )),
    );
  }
}

class ProfileGuest extends StatelessWidget {
  const ProfileGuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(40),
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
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              'Anda belum login, Ingin login?',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    dialogType: DialogType.question,
                    title: 'Ingin login?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(),
                          ),
                          (route) => false);
                    },
                  ).show();
                },
                child: Text('Log In'),
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
