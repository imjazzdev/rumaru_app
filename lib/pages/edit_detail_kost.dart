// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rumaru_app/pages/componen/img_slider_detail.dart';
import 'package:rumaru_app/pages/maps_add_kost.dart';
import 'package:rumaru_app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class EditDetailKost extends StatefulWidget {
  final String imgURL1;
  final String imgURL2;
  final String imgURL3;
  final String title_kost;
  final String harga_kost;
  final String informationdetail;
  final String kecamatan;
  final double latitude;
  final double longitude;
  bool lemari = false;
  bool kamarmandi = false;
  bool parkarea = false;
  bool garden = false;
  EditDetailKost(
      {super.key,
      required this.imgURL1,
      required this.imgURL2,
      required this.imgURL3,
      required this.title_kost,
      required this.harga_kost,
      required this.informationdetail,
      required this.kecamatan,
      required this.latitude,
      required this.longitude,
      required this.lemari,
      required this.garden,
      required this.kamarmandi,
      required this.parkarea});

  @override
  State<EditDetailKost> createState() => _EditDetailKostState();
}

class _EditDetailKostState extends State<EditDetailKost> {
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

  Future updateKost() async {
    final docKost =
        // ignore: unnecessary_string_interpolations
        FirebaseFirestore.instance.collection('kost').doc('${titleC.text}');
    docKost.update({
      'nama_kost': titleC.text,
      'harga_kost': hargaC.text,
      'information_detail': informasidetailC.text,
      'lokasi_kecamatan': kecamatanC.text,
      'lokasi_latlong.latitude': Utils.lokasi_latitude,
      'lokasi_latlong.longitude': Utils.lokasi_longitude,
      'imgURL1': imgURL1 == '' ? widget.imgURL1 : imgURL1,
      'imgURL2': imgURL2 == '' ? widget.imgURL2 : imgURL2,
      'imgURL3': imgURL3 == '' ? widget.imgURL3 : imgURL3,
      'fasilitas_kost.lemari': lemari,
      'fasilitas_kost.park_area': parkarea,
      'fasilitas_kost.kamar_mandi': kamarmandi,
      'fasilitas_kost.garden': garden,
    });
  }

  String imgURL1 = '';
  File? imageFix1;

  String imgURL2 = '';
  File? imageFix2;

  String imgURL3 = '';
  File? imageFix3;

  @override
  void initState() {
    titleC.text = widget.title_kost;
    hargaC.text = widget.harga_kost;
    kecamatanC.text = widget.kecamatan;
    informasidetailC.text = widget.informationdetail;
    Utils.lokasi_latitude = widget.latitude;
    Utils.lokasi_longitude = widget.longitude;
    lemari = widget.lemari;
    kamarmandi = widget.kamarmandi;
    parkarea = widget.parkarea;
    garden = widget.garden;
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
              size: 30,
            )),
        title: Text('Edit data kost'),
        centerTitle: true,
      ),
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
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.imgURL1,
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        fit: BoxFit.cover,
                                      )),
                                  Shimmer.fromColors(
                                    baseColor: Colors.white.withOpacity(0.9),
                                    highlightColor: Colors.blue.shade100,
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
                                            Icons.edit,
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
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.imgURL2,
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        fit: BoxFit.cover,
                                      )),
                                  Shimmer.fromColors(
                                    baseColor: Colors.white.withOpacity(0.9),
                                    highlightColor: Colors.blue.shade100,
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
                                            Icons.edit,
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
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.imgURL3,
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        fit: BoxFit.cover,
                                      )),
                                  Shimmer.fromColors(
                                    baseColor: Colors.white.withOpacity(0.9),
                                    highlightColor: Colors.blue.shade100,
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
                                            Icons.edit,
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
                              textAlign: TextAlign.justify,
                              minLines: 1,
                              maxLines: 10,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
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
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          updateKost();
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
