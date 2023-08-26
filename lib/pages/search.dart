import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rumaru_app/pages/componen/item_product.dart';
import 'package:rumaru_app/pages/profile.dart';
import 'package:rumaru_app/pages/search_detail.dart';

import '../utils/utils.dart';
import 'componen/shimmer_product.dart';
import 'detail_kost.dart';
import 'home.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
        children: [
          Text(
            'Search',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 10),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 7,
                  spreadRadius: 2,
                  color: Colors.blue.withOpacity(0.3),
                  offset: Offset(1, 2)),
            ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: search,
              onSubmitted: (value) {
                Utils.KEC_NOW = value;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchDetail(),
                    ));
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search by kecamatan',
                suffixIcon: IconButton(
                    onPressed: () {
                      search.clear();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey.shade400,
                    )),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Suggestion',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('kost')
                .orderBy('harga_kost', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView(
                  // padding: EdgeInsets.all(15),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2.8,
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 10,
                  color: Colors.blue.shade300.withOpacity(0.3),
                  offset: Offset(
                    -3,
                    0,
                  ))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
                },
                child: Image.asset(
                  'assets/img/home.png',
                  height: 40,
                )),
            TextButton(
                onPressed: () {},
                child: Image.asset(
                  'assets/img/search.png',
                  height: 40,
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(),
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
