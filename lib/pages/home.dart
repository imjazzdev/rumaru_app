import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rumaru_app/pages/add_kost.dart';
import 'package:rumaru_app/pages/componen/item_product.dart';
import 'package:rumaru_app/pages/componen/shimmer_product.dart';
import 'package:rumaru_app/pages/detail_kost.dart';
import 'package:rumaru_app/pages/profile.dart';
import 'package:rumaru_app/pages/search.dart';
import 'package:rumaru_app/utils/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getInfoKost();
  }

  var user_kost = FirebaseFirestore.instance.collection('user_kost');

  Future getInfoKost() async {
    var user_kost = await FirebaseFirestore.instance
        .collection('user_kost')
        .doc(FirebaseAuth.instance.currentUser!.email ?? '')
        .get();
    Utils.USER_NOW = user_kost['nama_user'] ?? 'Guest';
    Utils.USER_WA_NOW = user_kost['no_wa'] ?? '';
    Utils.isPenyediaKost = user_kost['penyedia_kost'] ?? false;
    print('USER SAAT INI : ${Utils.USER_NOW}');
    print('USER WA SAAT INI : ${Utils.USER_WA_NOW}');
    print('STATUS PENYEDIA SAAT INI : ${Utils.isPenyediaKost}');
  }

  final kost = FirebaseFirestore.instance.collection('kost');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0.8,
        centerTitle: true,
        backgroundColor: Colors.white,
        leadingWidth: 65,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset('assets/img/logo-rumaru.png'),
        ),
        actions: [
          FutureBuilder(
            future: user_kost
                .doc(FirebaseAuth.instance.currentUser!.email ?? '')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!['penyedia_kost'] == true) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue.shade300,
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddKost(),
                              ));
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 25,
                        )),
                  );
                } else {
                  return SizedBox();
                }
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: kost.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 2.7,
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
                                  information_detail: e['information_detail'],
                                  owner_kost_nama: e['owner']['nama'],
                                  owner_kost_wa: e['owner']['no_wa'],
                                  lokasi_kecamatan: e['lokasi_kecamatan'],
                                  lokasi_latitude: e['lokasi_latlong']
                                      ['latitude'],
                                  lokasi_longitude: e['lokasi_latlong']
                                      ['longitude'],
                                  lemari: e['fasilitas_kost']['lemari'],
                                  kamar_mandi: e['fasilitas_kost']
                                      ['kamar_mandi'],
                                  parkarea: e['fasilitas_kost']['park_area'],
                                  garden: e['fasilitas_kost']['garden'],
                                ),
                              ));
                        },
                        child: ItemProduct(
                          img: e['imgURL1'],
                          title: e['nama_kost'],
                          kecamatan: e['lokasi_kecamatan'],
                          harga: e['harga_kost'],
                        ),
                      ))
                  .toList(),
            );
          } else {
            return const ShimmerProduct();
          }
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 10,
                  color: Colors.blue.shade300.withOpacity(0.2),
                  offset: const Offset(
                    -3,
                    0,
                  ))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {},
                child: Image.asset(
                  'assets/img/home.png',
                  height: 40,
                )),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(),
                      ));
                },
                child: Image.asset(
                  'assets/img/search.png',
                  height: 40,
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ));
                },
                child: Image.asset(
                  'assets/img/profile.png',
                  height: 40,
                ))
          ],
        ),
      ),
    );
  }
}
