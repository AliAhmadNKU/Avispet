import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/my_color.dart';


class CachedImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  bool? check;

   CachedImage({
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.check,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$url',
      width: width,
      height: height,
      fit: fit,
      progressIndicatorBuilder: _buildProgress,
       errorWidget: _buildError,
    );
  }

  Widget _buildProgress(_, __, DownloadProgress downloadProgress) {
    if (Platform.isIOS) {
      return _buildIOSProgressIndicator(downloadProgress);
    }
    return _buildAndroidProgressIndicator(downloadProgress);
  }

  Widget _buildIOSProgressIndicator(DownloadProgress downloadProgress) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _buildAndroidProgressIndicator(DownloadProgress downloadProgress) {
    return Center(
      child:  progressBar()
    );
  }


  progressBar() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 5,
        color: MyColor.white,
        backgroundColor: MyColor.orange2,
      ),
    );
  }
  Widget _buildError(_, __, ___) {

    return
      check ==true?
      Container(
        child: Center(
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/onboard/placeholder_image.png'),
          ),
        ),
      ) :  Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColor.orange2,
        child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 60, height: 60)),
      );
  }
}