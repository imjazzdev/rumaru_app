import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumaru_app/pages/componen/item_review.dart';
import 'package:rumaru_app/pages/edit_detail_kost.dart';
import 'package:rumaru_app/pages/signin.dart';

import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/utils.dart';
import 'componen/item_fasilitas.dart';

class DetailKost extends StatefulWidget {
  final String img1;
  final String img2;
  final String img3;
  final String title_kost;
  final String information_detail;
  final String owner_kost_nama;
  final String owner_kost_wa;
  final String harga_kost;
  final String review1;
  final String review2;
  final String review3;
  final String listrik;

  final String lokasi_kecamatan;
  final double lokasi_latitude;
  final double lokasi_longitude;
  late bool lemari;
  late bool parkarea;
  late bool garden;
  late bool kamar_mandi;

  DetailKost(
      {required this.title_kost,
      required this.information_detail,
      required this.owner_kost_nama,
      required this.owner_kost_wa,
      required this.harga_kost,
      required this.lemari,
      required this.parkarea,
      required this.garden,
      required this.kamar_mandi,
      required this.listrik,
      required this.review1,
      required this.review2,
      required this.review3,
      required this.lokasi_kecamatan,
      required this.lokasi_latitude,
      required this.lokasi_longitude,
      required this.img1,
      required this.img2,
      required this.img3});

  @override
  State<DetailKost> createState() => _DetailKostState();
}

class _DetailKostState extends State<DetailKost> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(1.1455625, 104.0136126),
    zoom: 17.4746,
  );

  List<Marker> marker = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(1.1455625, 104.0136126),
      draggable: true,
    )
  ];

  Future addKeranjang() async {
    final dockeranjang =
        FirebaseFirestore.instance.collection('kost').doc(widget.title_kost);
    dockeranjang.set({
      'cart': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.email])
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                      aspectRatio: 1 / 1,
                      height: MediaQuery.of(context).size.height * 0.3,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration: const Duration(seconds: 5),
                      disableCenter: false,
                      pauseAutoPlayInFiniteScroll: true,
                      viewportFraction: 0.83,
                      enlargeCenterPage: true),
                  items: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 3,
                              offset: const Offset(2, 2),
                              color: Colors.blue.shade400)
                        ]),
                        child: CachedNetworkImage(
                          imageUrl: widget.img1,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          errorWidget: (context, url, error) => Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.wifi,
                                size: 60,
                                color: Colors.red,
                              ),
                              Text(
                                error.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          )),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.img2,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        errorWidget: (context, url, error) => Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi,
                              size: 60,
                              color: Colors.red,
                            ),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.img3,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        errorWidget: (context, url, error) => Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi,
                              size: 60,
                              color: Colors.red,
                            ),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title_kost,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.lokasi_kecamatan,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.blue),
                          ),
                        ],
                      ),
                      Utils.isPenyediaKost &&
                              Utils.USER_NOW == widget.owner_kost_nama
                          ? InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditDetailKost(
                                        imgURL1: widget.img1,
                                        imgURL2: widget.img2,
                                        imgURL3: widget.img3,
                                        title_kost: widget.title_kost,
                                        harga_kost: widget.harga_kost,
                                        informationdetail:
                                            widget.information_detail,
                                        kecamatan: widget.lokasi_kecamatan,
                                        latitude: widget.lokasi_latitude,
                                        longitude: widget.lokasi_longitude,
                                        lemari: widget.lemari,
                                        garden: widget.garden,
                                        kamarmandi: widget.kamar_mandi,
                                        parkarea: widget.parkarea,
                                      ),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/img/edit.png',
                                  height: 30,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    'Fasilitas',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.grey.shade700),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.lemari
                        ? ItemFasilitas(
                            color: Colors.amber.shade100,
                            icon: 'assets/img/cabinet.png',
                            title: 'Full\nfurnish',
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    widget.kamar_mandi
                        ? ItemFasilitas(
                            color: Colors.blue.shade100,
                            icon: 'assets/img/toilet.png',
                            title: 'Toilet\ndalam',
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    widget.parkarea
                        ? ItemFasilitas(
                            color: Colors.red.shade100,
                            icon: 'assets/img/parked-car.png',
                            title: 'Park\narea',
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    widget.garden
                        ? ItemFasilitas(
                            color: Colors.green.shade100,
                            icon: 'assets/img/flowers.png',
                            title: 'Garden\narea',
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
                  child: Text(
                    'Review',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.grey.shade700),
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView(
                    padding: const EdgeInsets.only(
                        left: 20, right: 15, top: 5, bottom: 5),
                    scrollDirection: Axis.horizontal,
                    children: [
                      ItemReview(
                        review: widget.review1,
                      ),
                      ItemReview(
                        review: widget.review2,
                      ),
                      ItemReview(
                        review: widget.review3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information detail',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.grey.shade700),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/img/user.png',
                                height: 50,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.owner_kost_nama,
                                style: TextStyle(fontSize: 18),
                              ),
                              const Text('Batam')
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    widget.information_detail,
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Harga Listrik (kWh/kVA) :',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'Rp. ${widget.listrik}',
                            style: const TextStyle(
                                color: Colors.amber, fontSize: 18),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.amber,
                            highlightColor: Colors.blue.shade50,
                            child: IconButton(
                                onPressed: () {
                                  try {
                                    launchUrl(Uri.parse(
                                        'https://www.plnbatam.com/tarif-listrik/'));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.orange.shade400,
                                    ));
                                  }
                                },
                                icon: const Icon(
                                  Icons.flash_on,
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    'Lokasi',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.grey.shade700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 2,
                          color: Colors.blue.withOpacity(0.2),
                          offset: const Offset(1, 2))
                    ]),
                    child: InkWell(
                      onTap: () {
                        Utils.openMap(
                            widget.lokasi_latitude, widget.lokasi_longitude);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          mapType: MapType.hybrid,
                          markers: marker.toSet(),
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
            Positioned(
              left: 20,
              top: 8,
              child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        height: 60,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.blue.shade50, Colors.blue.shade100],
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: Colors.blue.withOpacity(0.2),
                  offset: const Offset(
                    -3,
                    0,
                  ))
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.harga_kost,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  '/month',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser!.email ==
                        'guest@gmail.com') {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.warning,
                        title: 'Anda belum login\nIngin login?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignIn(),
                              ),
                              (route) => false);
                        },
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.warning,
                        title: 'Add to cart?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          addKeranjang();
                        },
                      ).show();
                    }
                  },
                  child: Image.asset(
                    'assets/img/add-to-cart.png',
                    height: 35,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    try {
                      launchUrl(
                          Uri.parse('https://wa.me/+${widget.owner_kost_wa}'));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.orange.shade400,
                      ));
                    }
                  },
                  child: Image.asset(
                    'assets/img/whatsapp.png',
                    height: 32,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
