
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';

class Review extends StatefulWidget {

  final Map<String, dynamic>? mapData;

  Review({super.key, this.mapData});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  bool blockScroll =false;

  @override
  void initState() {
    super.initState();

    if(widget.mapData!['mediaType'] == 3){
      videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.mapData!['image'].toString()))..initialize().then((value) => setState(() {}));
      _customVideoPlayerController = CustomVideoPlayerController(context: context, videoPlayerController: videoPlayerController);
    }
  }


  @override
  void dispose() async {
    if(widget.mapData!['mediaType'] == 3){
      videoPlayerController.dispose();
      _customVideoPlayerController.dispose();
      debugPrint('Dispose method call');
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.black,
      appBar: AppBar(
                  surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: MyColor.black,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(20, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Image.asset('assets/images/icons/back_icon.png', color: MyColor.white),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          if(widget.mapData!['mediaType'] == 1)
            Expanded(
              child: Center(
                child: PinchZoomReleaseUnzoomWidget(
                  twoFingersOn: () => setState(() => blockScroll = true),
                  twoFingersOff: () => Future.delayed(Duration.zero, () => setState(() => blockScroll = false)),
                  minScale: 0.8,
                  maxScale: 4,
                  resetDuration: Duration.zero,
                  boundaryMargin: const EdgeInsets.only(bottom: 0),
                  clipBehavior: Clip.none,
                  maxOverlayOpacity: 0.1,
                  overlayColor: Colors.black,
                  fingersRequiredToPinch: -1,
                  child: Image.network(
                    widget.mapData!['image'].toString(),
                    filterQuality: FilterQuality.low, fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                        ? child
                        : Image.asset('assets/images/onboard/placeholder_image.png', height: 350, width: double.infinity, fit: BoxFit.cover),
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/onboard/placeholder_image.png', height: 350, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),


          if(widget.mapData!['mediaType'] == 3)
            Expanded(
              child:  Center(
                  child: videoPlayerController.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController),
                  )
                      : Container(child: Center(child: progressBar()))
              ),
            ),


        ],
      )
    );
  }
}
