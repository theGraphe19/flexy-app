import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageZoomScreen extends StatefulWidget {
  static const routeName = '/image-zoom-screen';

  @override
  _ImageZoomScreenState createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  String image;

  @override
  Widget build(BuildContext context) {
    image = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      body: Hero(
        tag: image,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.white),
          imageProvider: NetworkImage(
            'https://developers.thegraphe.com/flexy/storage/app/product_images/$image',
          ),
        ),
      ),
    );
  }
}
