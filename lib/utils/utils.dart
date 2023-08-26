import 'package:url_launcher/url_launcher.dart';

class Utils {
  static bool isMap = false;
  static bool isPenyediaKost = false;

  static String KEC_NOW = '';

  static String USER_NOW = '';
  static String USER_WA_NOW = '';

  static Future openMap(double latitude, longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(googleUrl as Uri)) {
      await launchUrl(googleUrl as Uri);
    } else {
      throw 'TIDAK BISA MENAMPILKAN GMAPS';
    }
  }

  static late double lokasi_latitude;
  static late double lokasi_longitude;
  static const List<Map<String, dynamic>> lokasi_kost = [
    {
      'latlong': [1.144801, 104.016981],
      'kecamatan': 'Lubuk Baja'
    },
    {
      'latlong': [1.145617, 104.014886],
      'kecamatan': 'Lubuk Baja'
    },
    {
      'latlong': [1.157372, 104.025637],
      'kecamatan': 'Bengkong'
    },
    {
      'latlong': [1.083619, 104.120061],
      'kecamatan': 'Nongsa'
    },
    {
      'latlong': [1.037165, 103.975836],
      'kecamatan': 'Sagulung'
    },
    {
      'latlong': [1.037484, 103.974922],
      'kecamatan': 'Sagulung'
    },
    {
      'latlong': [1.110386, 104.065751],
      'kecamatan': 'Batam Kota'
    },
    {
      'latlong': [1.111378, 103.961622],
      'kecamatan': 'Sekupang'
    },
    {
      'latlong': [1.112585, 104.060376],
      'kecamatan': 'Batam Kota'
    },
    {
      'latlong': [1.162441, 104.007930],
      'kecamatan': 'Batu Ampar'
    },
    {
      'latlong': [1.049565, 103.980060],
      'kecamatan': 'Batu aji'
    },
    {
      'latlong': [1.139937, 104.009225],
      'kecamatan': 'Lubuk baja'
    }
  ];
}
