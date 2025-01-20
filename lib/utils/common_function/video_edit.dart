
import 'dart:io';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';
import '../../ui/main_screen/home/create_post.dart';


class VideoEditor extends StatefulWidget {
  final File file;
  const VideoEditor({super.key, required this.file});
  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {


  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
  late final Directory tempDir;
  bool loader =false;

  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds:0),
    maxDuration: const Duration(seconds: 120),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    debugPrint('Dispose method call ');
    super.dispose();
  }


  void _exportVideo() async {
    final startTrim = _controller.startTrim.inSeconds;
    final endTrim = _controller.endTrim.inSeconds;

    final Directory tempDir = await getTemporaryDirectory();
    final String outputPath = '${tempDir.path}/trimmed_video.mp4';

    // Delete the existing file if it exists
    final File outputFile = File(outputPath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }

    // Construct the FFmpeg command to trim and export the video
    final flutterFFmpeg = FFmpegKit();

    final command = '-i ${widget.file.path} -ss $startTrim -to $endTrim -c copy $outputPath';

    debugPrint('  command: $command');
    debugPrint('Output path: $outputPath');

    // Execute the FFmpeg command

    // final int result = await flutterFFmpeg.execute(command);
    final  result = await FFmpegKit.execute(command);

    debugPrint('  result: $result');

    // Check if the widget is still mounted
    if (!mounted) return;
    if (result == 0) {

      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreatePost()));
    } else {
      debugPrint('Error trimming video.   result code: $result');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error trimming video. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topNavBar(),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            physics:
                            const NeverScrollableScrollPhysics(),
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CropGridViewer.preview(
                                      controller: _controller),
                                  AnimatedBuilder(
                                    animation: _controller.video,
                                    builder: (_, __) => AnimatedOpacity(
                                      opacity:
                                      _controller.isPlaying ? 0 : 1,
                                      duration: kThemeAnimationDuration,
                                      child: GestureDetector(
                                        onTap: _controller.video.play,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration:
                                          const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CoverViewer(controller: _controller)
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              TabBar(
                                dividerColor: MyColor.cardColor,
                                indicatorColor: MyColor.orange,
                                tabs: [


                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Padding(padding: const EdgeInsets.all(5),
                                            child: Icon(Icons.content_cut,color: MyColor.orange)),
                                        MyString.bold('Trim', 12,MyColor.orange, TextAlign.center)
                                      ]),


                                  /*              Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Icon(Icons.video_label,color: MyColor.orange)),
                                      MyString.bold('Cover', 12,MyColor.orange, TextAlign.center)
                                    ],
                                  ),*/



                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: _trimSlider(),
                                    ),
                                    // _coverSelection(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isExporting,
                          builder: (_, bool export, Widget? child) =>
                              AnimatedSize(
                                duration: kThemeAnimationDuration,
                                child: export ? child : null,
                              ),
                          child: AlertDialog(
                            title: ValueListenableBuilder(
                              valueListenable: _exportingProgress,
                              builder: (_, double value, __) => Text(
                                "Exporting video ${(value * 100).ceil()}%",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [


            Expanded(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back,color: MyColor.orange),
                tooltip: 'Leave editor',
              ),
            ),
            VerticalDivider(endIndent: 22, indent: 22,color: MyColor.orange),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: Icon(Icons.rotate_left,color: MyColor.orange),
                tooltip: 'Rotate unclockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: Icon(Icons.rotate_right,color: MyColor.orange),
                tooltip: 'Rotate clockwise',
              ),
            ),
            VerticalDivider(endIndent: 22, indent: 22,color: MyColor.orange),
            Expanded(
              child: IconButton(
                onPressed: () {
                  _exportVideo();
                },
                icon: Icon(Icons.check,color: MyColor.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt())),style: TextStyle(color: MyColor.orange)),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: _controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(_controller.startTrim)),
                  const SizedBox(width: 10),
                  Text(formatter(_controller.endTrim)),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(textStyle: TextStyle(color: MyColor.cardColor,fontSize: 8),
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }

/*  Widget _coverSelection() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: CoverSelection(
            controller: _controller,
            size: height + 10,
            quantity: 8,
            selectedCoverBuilder: (cover, size) {
              return InkWell(
                onTap: () async{

                  debugPrint('THUMBNAIL VALUE 11 : ${_controller.selectedCoverVal!.thumbData.toString()}');

                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    cover,
                    Icon(
                      Icons.check_circle,
                      color: const CoverSelectionStyle().selectedBorderColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }*/
}



class VideoEditor1 extends StatefulWidget {
  final File file;
  const VideoEditor1({super.key, required this.file});
  @override
  State<VideoEditor1> createState() => _VideoEditor1State();
}

class _VideoEditor1State extends State<VideoEditor1> {


  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
  late final Directory tempDir;
  bool loader =false;

  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds:0),
    maxDuration: const Duration(seconds: 120),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    debugPrint('Dispose method call ');
    super.dispose();
  }


  void _exportVideo() async {
    final startTrim = _controller.startTrim.inSeconds;
    final endTrim = _controller.endTrim.inSeconds;


    final Directory tempDir = await getTemporaryDirectory();
    final String outputPath = '${tempDir.path}/trimmed_video.mp4';

    // Delete the existing file if it exists
    final File outputFile = File(outputPath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }

    // Construct the FFmpeg command to trim and export the video
    // final flutterFFmpeg = FlutterFFmpeg();
    final command = '-i ${widget.file.path} -ss $startTrim -to $endTrim -c copy $outputPath';

    debugPrint('FFmpeg command: $command');
    debugPrint('Output path: $outputPath');

    // Execute the FFmpeg command
    // final int result = await flutterFFmpeg.execute(command);
    final result = await FFmpegKit.execute(command);
    debugPrint('FFmpeg result: $result');

    // Check if the widget is still mounted
    if (!mounted) return;
    if (result == 0) {

      Navigator.pop(context,outputPath);

      // await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreatePost(image: null, video: outputPath)));



    } else {
      debugPrint('Error trimming video. FFmpeg result code: $result');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error trimming video. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topNavBar(),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            physics:
                            const NeverScrollableScrollPhysics(),
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CropGridViewer.preview(
                                      controller: _controller),
                                  AnimatedBuilder(
                                    animation: _controller.video,
                                    builder: (_, __) => AnimatedOpacity(
                                      opacity:
                                      _controller.isPlaying ? 0 : 1,
                                      duration: kThemeAnimationDuration,
                                      child: GestureDetector(
                                        onTap: _controller.video.play,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration:
                                          const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CoverViewer(controller: _controller)
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              TabBar(
                                dividerColor: MyColor.cardColor,
                                indicatorColor: MyColor.orange,
                                tabs: [
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Padding(padding: const EdgeInsets.all(5),
                                            child: Icon(Icons.content_cut,color: MyColor.orange)),
                                        MyString.bold('Trim', 12,MyColor.orange, TextAlign.center)
                                      ]),
                                  /*              Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Icon(Icons.video_label,color: MyColor.orange)),
                                      MyString.bold('Cover', 12,MyColor.orange, TextAlign.center)
                                    ],
                                  ),*/



                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: _trimSlider(),
                                    ),
                                    // _coverSelection(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isExporting,
                          builder: (_, bool export, Widget? child) =>
                              AnimatedSize(
                                duration: kThemeAnimationDuration,
                                child: export ? child : null,
                              ),
                          child: AlertDialog(
                            title: ValueListenableBuilder(
                              valueListenable: _exportingProgress,
                              builder: (_, double value, __) => Text(
                                "Exporting video ${(value * 100).ceil()}%",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [


            Expanded(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back,color: MyColor.orange),
                tooltip: 'Leave editor',
              ),
            ),
            VerticalDivider(endIndent: 22, indent: 22,color: MyColor.orange),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: Icon(Icons.rotate_left,color: MyColor.orange),
                tooltip: 'Rotate unclockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: Icon(Icons.rotate_right,color: MyColor.orange),
                tooltip: 'Rotate clockwise',
              ),
            ),
            VerticalDivider(endIndent: 22, indent: 22,color: MyColor.orange),
            Expanded(
              child: IconButton(
                onPressed: () {
                  _exportVideo();
                },
                icon: Icon(Icons.check,color: MyColor.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt())),style: TextStyle(color: MyColor.orange)),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: _controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(_controller.startTrim)),
                  const SizedBox(width: 10),
                  Text(formatter(_controller.endTrim)),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(textStyle: TextStyle(color: MyColor.cardColor,fontSize: 8),
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }
}