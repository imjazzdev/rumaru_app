import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../utils/utils.dart';
import 'componen/item_product.dart';
import 'componen/shimmer_product.dart';
import 'detail_kost.dart';

class SearchDetail extends StatelessWidget {
  var kost = FirebaseFirestore.instance
      .collection('kost')
      .where('lokasi_kecamatan', isEqualTo: Utils.KEC_NOW);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey.shade800,
            )),
        title: Text(Utils.KEC_NOW),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: kost.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                    lokasi_latitude: e['lokasi_latlong'][0],
                                    lokasi_longitude: e['lokasi_latlong'][1],
                                    information_detail: e['information_detail'],
                                    owner_kost_nama: e['owner']['nama'],
                                    owner_kost_wa: e['owner']['no_wa'],
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
      ),
    );
  }
}
