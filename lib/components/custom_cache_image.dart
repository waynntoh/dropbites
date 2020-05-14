import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCacheImage extends StatefulWidget {
  final String url;
  CustomCacheImage({this.url});

  @override
  _CustomCacheImageState createState() => _CustomCacheImageState();
}

class _CustomCacheImageState extends State<CustomCacheImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: widget.url,
      placeholder: (context, url) => new Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => new Icon(Icons.error_outline),
    );
  }
}
