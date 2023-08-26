import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rumaru_app/pages/componen/img_slider_detail.dart';
import 'package:rumaru_app/pages/maps_add_kost.dart';
import 'package:rumaru_app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class AddKost extends StatefulWidget {
  const AddKost({super.key});

  @override
  State<AddKost> createState() => _AddKostState();
}

class _AddKostState extends State<AddKost> {
  TextEditingController titleC = TextEditingController();
  TextEditingController hargaC = TextEditingController();
  TextEditingController informasidetailC = TextEditingController();
  TextEditingController kecamatanC = TextEditingController();
  bool lemari = false;
  bool kamarmandi = false;
  bool parkarea = false;
  bool garden = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(1.1455625, 104.0136126),
    zoom: 17.4746,
  );

  Future createKost() async {
    final docKost =
        // ignore: unnecessary_string_interpolations
        FirebaseFirestore.instance.collection('kost').doc('${titleC.text}');
    final kost = Kost(
      nama_kost: titleC.text,
      harga_kost: hargaC.text,
      // harga_kost: NumberFormat.currency(
      //   locale: 'id',
      //   symbol: 'Rp ',
      // ).format(int.parse(hargaC.text)).toString(),
      information_detail: informasidetailC.text,
      imgURL1: imgURL1,
      imgURL2: imgURL2,
      imgURL3: imgURL3,
      keranjang: false,
      owner_nama: Utils.USER_NOW,
      owner_no_wa: Utils.USER_WA_NOW,
      lokasi_kecamatan: kecamatanC.text,
      lokasi_latitude: Utils.lokasi_latitude,
      lokasi_longitude: Utils.lokasi_longitude,
      fasilitas_lemari: lemari,
      fasilitas_kamarmandi: kamarmandi,
      fasilitas_parkarea: parkarea,
      fasilitas_garden: garden,
      listrik: '950',
      review: [
        'Lorem Ipsum is simply dummy text',
        'Unknown printer took a galley Ipsum be',
        'Lorem Ipsum has been industry Ipsum is'
      ],
    );
    final json = kost.toJson();
    await docKost.set(json);
  }

  String imgURL1 = '';
  File? imageFix1;

  String imgURL2 = '';
  File? imageFix2;

  String imgURL3 = '';
  File? imageFix3;

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    titleC.dispose();
    hargaC.dispose();
    kecamatanC.dispose();
    informasidetailC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: CarouselSlider(
                    options: CarouselOptions(
                        aspectRatio: 1 / 1,
                        height: MediaQuery.of(context).size.height * 0.3,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 10),
                        autoPlayAnimationDuration: Duration(seconds: 5),
                        disableCenter: false,
                        pauseAutoPlayInFiniteScroll: true,
                        viewportFraction: 0.75,
                        enlargeCenterPage: true),
                    items: [
                      imageFix1 != null
                          ? Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  imageFix1!,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: Offset(2, 2),
                                        color: Colors.grey.withOpacity(0.2))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/upload-kost.png',
                                    height: 200,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.blue.withOpacity(0.9),
                                    highlightColor: Colors.blue.shade50,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          Colors.blue.withOpacity(0.5),
                                      child: IconButton(
                                          onPressed: () async {
                                            ImagePicker imagePicker =
                                                ImagePicker();
                                            XFile? file =
                                                await imagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            Reference referenceRoot =
                                                FirebaseStorage.instance.ref();
                                            Reference referenceDirImages =
                                                referenceRoot.child('images');
                                            Reference referenceImageToUpload =
                                                referenceDirImages.child(
                                                    DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString());
                                            try {
                                              imageFix1 = File(file!.path);

                                              await referenceImageToUpload
                                                  .putFile(imageFix1!);
                                              setState(() {});
                                              imgURL1 =
                                                  await referenceImageToUpload
                                                      .getDownloadURL();
                                              print('LINK GAMBAR : $imgURL1');
                                            } catch (e) {
                                              print('ERROR IMAGE PICKER : $e');
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 35,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      //SliderDetail(imgNet),
                      imageFix2 != null
                          ? Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  imageFix2!,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: Offset(2, 2),
                                        color: Colors.grey.withOpacity(0.2))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/upload-kost.png',
                                    height: 200,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.blue.withOpacity(0.9),
                                    highlightColor: Colors.blue.shade50,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          Colors.blue.withOpacity(0.5),
                                      child: IconButton(
                                          onPressed: () async {
                                            ImagePicker imagePicker =
                                                ImagePicker();
                                            XFile? file =
                                                await imagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            Reference referenceRoot =
                                                FirebaseStorage.instance.ref();
                                            Reference referenceDirImages =
                                                referenceRoot.child('images');
                                            Reference referenceImageToUpload =
                                                referenceDirImages.child(
                                                    DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString());
                                            try {
                                              imageFix2 = File(file!.path);

                                              await referenceImageToUpload
                                                  .putFile(imageFix2!);
                                              setState(() {});
                                              imgURL2 =
                                                  await referenceImageToUpload
                                                      .getDownloadURL();
                                              print('LINK GAMBAR : $imgURL2');
                                            } catch (e) {
                                              print('ERROR IMAGE PICKER : $e');
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 35,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      //
                      imageFix3 != null
                          ? Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  imageFix3!,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: Offset(2, 2),
                                        color: Colors.grey.withOpacity(0.2))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/img/upload-kost.png',
                                    height: 200,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.blue.withOpacity(0.9),
                                    highlightColor: Colors.blue.shade50,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          Colors.blue.withOpacity(0.5),
                                      child: IconButton(
                                          onPressed: () async {
                                            ImagePicker imagePicker =
                                                ImagePicker();
                                            XFile? file =
                                                await imagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            Reference referenceRoot =
                                                FirebaseStorage.instance.ref();
                                            Reference referenceDirImages =
                                                referenceRoot.child('images');
                                            Reference referenceImageToUpload =
                                                referenceDirImages.child(
                                                    DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString());
                                            try {
                                              imageFix3 = File(file!.path);

                                              await referenceImageToUpload
                                                  .putFile(imageFix3!);
                                              setState(() {});
                                              imgURL3 =
                                                  await referenceImageToUpload
                                                      .getDownloadURL();
                                              print('LINK GAMBAR : $imgURL3');
                                            } catch (e) {
                                              print('ERROR IMAGE PICKER : $e');
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 35,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                //listview
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title Kost',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 3,
                                      color: Colors.grey.withOpacity(0.1),
                                      offset: Offset(2, 1))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: TextField(
                              controller: titleC,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: 'Title kost',
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kecamatan',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 3,
                                      color: Colors.grey.withOpacity(0.1),
                                      offset: Offset(2, 1))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: TextField(
                              controller: kecamatanC,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Kecamatan',
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Harga perbulan',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 3,
                                      color: Colors.grey.withOpacity(0.1),
                                      offset: Offset(2, 1))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextField(
                                    controller: hargaC,
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(
                                          decimalDigits: 0,
                                          locale: 'id',
                                          symbol: 'Rp')
                                    ],
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 18),
                                    decoration: InputDecoration(
                                      hintText: '800.000',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Information detail',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 3,
                                      color: Colors.grey.withOpacity(0.1),
                                      offset: Offset(2, 1))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: TextField(
                              controller: informasidetailC,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Ukuran 3x4, etc.',
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapSample(),
                                  ));
                            },
                            child: Container(
                              height: 150,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 3,
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: Offset(2, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(15)),
                              child: Utils.isMap
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: GoogleMap(
                                        mapType: MapType.terrain,
                                        initialCameraPosition: _kGooglePlex,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                        },
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/img/maps.jpg',
                                            width: double.maxFinite,
                                            fit: BoxFit.cover,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MapSample(),
                                                  ));
                                            },
                                            child: Stack(
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey
                                                      .withOpacity(0.3),
                                                  highlightColor:
                                                      Colors.grey.shade300,
                                                  child: const CircleAvatar(
                                                    radius: 45,
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 6,
                                                  bottom: 8,
                                                  child: Image.asset(
                                                    'assets/img/left-click.png',
                                                    height: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fasilitas',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 7, bottom: 7),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 3,
                                        color: Colors.grey.withOpacity(0.1),
                                        offset: Offset(2, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Lemari'),
                                              Checkbox(
                                                  value: lemari,
                                                  onChanged: (_) {
                                                    setState(() {
                                                      lemari = !lemari;
                                                    });
                                                  })
                                            ],
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Park area'),
                                              Checkbox(
                                                  value: parkarea,
                                                  onChanged: (_) {
                                                    setState(() {
                                                      parkarea = !parkarea;
                                                    });
                                                  })
                                            ],
                                          ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Kamar mandi'),
                                              Checkbox(
                                                  value: kamarmandi,
                                                  onChanged: (_) {
                                                    setState(() {
                                                      kamarmandi = !kamarmandi;
                                                    });
                                                  })
                                            ],
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Garden'),
                                              Checkbox(
                                                  value: garden,
                                                  onChanged: (_) {
                                                    setState(() {
                                                      garden = !garden;
                                                    });
                                                  })
                                            ],
                                          ))
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20,
              top: 13,
              child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      ))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (titleC.text == null ||
              hargaC.text == null ||
              informasidetailC.text == null ||
              kecamatanC.text == null ||
              imageFix1 == null ||
              imageFix2 == null ||
              imageFix3 == null ||
              Utils.lokasi_latitude == null) {
            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.warning,
              title: 'Mohon lengkapi data',
              btnOkOnPress: () {},
            ).show();
          } else {}

          createKost();
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            title: 'Data Disimpan',
            btnOkOnPress: () {
              Utils.isMap = false;
              Navigator.pop(context);
            },
          ).show();
        },
        child: Container(
          height: 45,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 15, bottom: 10, right: 15),
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 5,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(
                      -3,
                      0,
                    ))
              ]),
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Kost {
  final String nama_kost;
  final String harga_kost;
  final String information_detail;
  final String owner_nama;
  final String owner_no_wa;
  final String lokasi_kecamatan;
  final double lokasi_latitude;
  final double lokasi_longitude;
  final String imgURL1;
  final String imgURL2;
  final String imgURL3;
  final String listrik;
  final bool keranjang;
  final List<String> review;
  final bool fasilitas_lemari;
  final bool fasilitas_parkarea;
  final bool fasilitas_kamarmandi;
  final bool fasilitas_garden;

  Kost({
    required this.nama_kost,
    required this.harga_kost,
    required this.information_detail,
    required this.owner_nama,
    required this.owner_no_wa,
    required this.lokasi_kecamatan,
    required this.lokasi_latitude,
    required this.lokasi_longitude,
    required this.keranjang,
    required this.imgURL1,
    required this.imgURL2,
    required this.imgURL3,
    required this.listrik,
    required this.review,
    required this.fasilitas_lemari,
    required this.fasilitas_parkarea,
    required this.fasilitas_kamarmandi,
    required this.fasilitas_garden,
  });

  Map<String, dynamic> toJson() => {
        'nama_kost': nama_kost,
        'harga_kost': harga_kost,
        'information_detail': information_detail,
        'lokasi_kecamatan': lokasi_kecamatan,
        'lokasi_latlong': {
          'latitude': lokasi_latitude,
          'longitude': lokasi_longitude
        },
        'imgURL1': imgURL1,
        'imgURL2': imgURL2,
        'imgURL3': imgURL3,
        'listrik': listrik,
        'keranjang': keranjang,
        'review': review,
        'owner': {'nama': owner_nama, 'no_wa': owner_no_wa},
        'fasilitas_kost': {
          'lemari': fasilitas_lemari,
          'park_area': fasilitas_parkarea,
          'kamar_mandi': fasilitas_kamarmandi,
          'garden': fasilitas_garden
        },
      };
}
