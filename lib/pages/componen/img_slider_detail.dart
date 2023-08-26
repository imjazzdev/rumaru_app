import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SliderDetail extends StatelessWidget {
  final String imgNet;
  SliderDetail(this.imgNet);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: imgNet.toString(),
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.image_rounded,
                  color: Colors.grey[400],
                  size: 300,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.image_rounded,
                  color: Colors.grey[400],
                  size: 300,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi,
                      color: Colors.red,
                      size: 40,
                    ),
                    Text('Check your connection $error',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
