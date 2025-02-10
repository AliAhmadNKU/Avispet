import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avispets/ui/main_screen/home/create_post.dart';
import 'package:avispets/ui/main_screen/home/home_screen.dart';
import 'package:avispets/ui/main_screen/map/map_page.dart';
import 'package:avispets/ui/main_screen/profile/profile_screen.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import '../../models/GlobalModel.dart';
import '../../models/get_profile_model.dart';
import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/apis/connect_socket.dart';
import '../../utils/apis/get_api.dart';
import '../../utils/common_function/dialogs/dialog_close_app.dart';
import '../../utils/common_function/toaster.dart';
import '../../utils/common_function/video_edit.dart';
import '../../utils/my_routes/route_name.dart';
import '../../utils/shared_pref.dart';
import 'chats/inbox_screen.dart';

class MainPage extends StatefulWidget {
  int index;

  MainPage({super.key, required this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

String referralCode = '';

class _MainPageState extends State<MainPage> {
  StreamSubscription<Map>? streamSubscriptionDeepLink;

  bool clickAdd = false;
  bool clickAdd1 = false;
  int isSelected = 0;
  int currentTab = 0;

  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  List<File> croppedFiles = [];
  File? galleryFile;
  final picker = ImagePicker();

  bool notificationLoader = true;

  static List<Widget> _widgetOptions = [
    HomeScreen(),
    MapScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    connectSocket();
    Future.delayed(Duration.zero, () async {
      currentTab = widget.index;
      notificationCount();
    });
  }

  @override
  void dispose() {
    streamSubscriptionDeepLink?.cancel();
    super.dispose();
  }

  notificationCount() {
    Future.delayed(Duration.zero, () async {
      bool result = await getProfileApi();
      // getGlobalApi();
      setState(() {
        debugPrint('NOTIFICATION COUNT :$result');
        notificationLoader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomAppBar(
          color: MyColor.white,
          shape: const CircularNotchedRectangle(),
          height: 60,
          notchMargin: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      notificationCount();
                      clickAdd = false;
                      currentTab = 0;
                      setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/icons/home.png',
                        width: 22,
                        height: 22,
                        color: currentTab == 0
                            ? MyColor.orange2
                            : Color(0xff5B6170),
                      ),
                    ),
                  )),
              Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      notificationCount();
                      clickAdd = false;
                      currentTab = 1;
                      setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/icons/group_icon.png',
                        width: 22,
                        height: 22,
                        color: currentTab == 1
                            ? MyColor.orange2
                            : Color(0xff5B6170),
                      ),
                    ),
                  )),
              Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, RoutesName.addPostScreen);
                    },
                    child: Container(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/icons/addpic.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  )),
              Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      notificationCount();
                      clickAdd = false;
                      currentTab = 2;
                      // GetApi.getProfileModel.data!.unreadMessageCount = 0;
                      setState(() {});
                    },
                    child:
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/chat.png',
                          width: 120,
                          height:120,
                          fit: BoxFit.cover,
                          color: currentTab == 2
                              ? MyColor.orange2
                              : Color(0xff5B6170),
                        ),
                        if (GetApi.getProfileModel.data != null &&
                            currentTab != 2 &&
                            GetApi.getProfileModel.data!.counts
                                    ?.notificationCount !=
                                null &&
                            GetApi.getProfileModel.data!.counts!
                                    .notificationCount! >
                                0)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                      ],
                    ),
                  )),
              Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      notificationCount();
                      clickAdd = false;
                      currentTab = 3;
                      setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/icons/user.png',
                        width: 22,
                        height: 22,
                        color: currentTab == 3
                            ? MyColor.orange2
                            : Color(0xff5B6170),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Future.delayed(Duration.zero, () async {
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return DialogCloseApp();
              },
            );
          });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: _widgetOptions[currentTab],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _cropImage();
      });
    }
  }

  //!@Cropping area
  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1080, ratioY: 1080),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'cropImage'.tr,
            toolbarColor: MyColor.cardColor,
            hideBottomControls:
                false, // Show bottom controls to allow adjustments
            toolbarWidgetColor: MyColor.orange2,
            lockAspectRatio: true, // Lock aspect ratio to square
            cropFrameColor:
                MyColor.orange2, // Optional: change crop frame color
            showCropGrid: true, // Optional: show grid for better guidance
          ),
          IOSUiSettings(
            title: 'cropImage'.tr,
            aspectRatioLockEnabled: true,
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.page,
            size: const CropperSize(
              width: 200,
              height: 200,
            ),
            //viewwMode: const CroppieViewPort(width: 480, height: 200, type: 'circle'),
          ),
        ],
      );

      if (croppedFile != null) {
        _croppedFile = croppedFile;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreatePost()));
        setState(() {});
      }
    }
  }

  Future<void> getVideo(ImageSource img) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 2));
    XFile? xFilePick = pickedFile;
    if (xFilePick != null) {
      galleryFile = File(pickedFile!.path);
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreatePost()));
      galleryFile = null;
    } else {}
    setState(
      () {},
    );
  }

  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        String filePathWithBrackets = result.paths.toString();
        String filePath =
            filePathWithBrackets.substring(1, filePathWithBrackets.length - 1);
        if (filePath.endsWith('.mp4')) {
          print('RESULT IS  ::: ${filePath}');
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      VideoEditor(file: File(filePath))));
        } else {
          _pickedFile = XFile(filePath);
          if (_pickedFile != null) {
            setState(() {
              _pickedFile = _pickedFile;
              _cropImage();
            });
          }
        }
      });
    } else {
      print('RESULT IS ELSE  ::: $result');
    }
  }

  Future<bool> getProfileApi() async {
    var res = await AllApi.getMethodApi(
        "user/${sharedPref.getString(SharedKey.userId)}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      GetApi.getProfileModel = GetProfileModel.fromJson(result);
      setState(() {});
      return true;
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
      return true;
    } else {
      toaster(context, result['message'].toString());
      return true;
    }
  }

  Future<bool> getGlobalApi() async {
    var res = await AllApi.getMethodApi("${ApiStrings.global}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      String versionCode = '';
      String buildNumber = '';
      String string = (await PackageInfo.fromPlatform()).version.toString();

      GetApi.globalModel = GlobalModel.fromJson(result);
      for (var i = 0; i < GetApi.globalModel.data!.length; i++) {
        if (Platform.isAndroid) {
          if (GetApi.globalModel.data![i].metaKey == "androidVersionNumber") {
            versionCode = GetApi.globalModel.data![i].metaValue.toString();
          }
        } else {
          if (GetApi.globalModel.data![i].metaKey == "appleVersionNumber") {
            versionCode = GetApi.globalModel.data![i].metaValue.toString();
          }
        }
      }
      var appVersion = Version.parse(string);
      var latestVersion = Version.parse(versionCode);

      debugPrint(
          "App Version : ${appVersion} ---- New Version : ${latestVersion}");
      if (appVersion < latestVersion) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: MyColor.orange2,
            builder: (_) {
              return updateDialog();
            });
      }

      return true;
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
      return true;
    } else {
      toaster(context, result['message'].toString());
      return true;
    }
  }

  selectCameraLib(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, myState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: MyColor.grey,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            child: MyString.bold(
                                'cameraGallery1'.tr.toUpperCase(),
                                16,
                                MyColor.black,
                                TextAlign.center)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  // Navigator.pop(context);
                                  // selectImageVideo(context);
                                  // setState(() {});
                                  Navigator.pop(context);
                                  picImageMultiple();
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/post_library.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('phoneLibrary'.tr, 13,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  // Navigator.pop(context);
                                  // await selectImgVid(context);
                                  // setState(() {});
                                  Navigator.pop(context);
                                  pickImage(ImageSource.camera);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/post_camera.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('camera'.tr, 13,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  selectImgVid(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, myState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: MyColor.grey,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            child: MyString.bold(
                                'cameraGallery1'.tr.toUpperCase(),
                                16,
                                MyColor.black,
                                TextAlign.center)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  pickImage(ImageSource.camera);
                                  // picImageMultiple();
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/post_library.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('choosePicture'.tr, 13,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  getVideo(ImageSource.camera);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/select_video.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('chooseVideo'.tr, 13,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  selectImageVideo(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, myState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: MyColor.grey,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            child: MyString.bold(
                                'cameraGallery1'.tr.toUpperCase(),
                                16,
                                MyColor.black,
                                TextAlign.center)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  picImageMultiple();
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/post_library.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('choosePicture'.tr, 13,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  getVideo(ImageSource.gallery);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/select_video.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('chooseVideo'.tr, 13,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> picImageMultiple() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedFile = pickedFile;
      if (_pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile!.path,
          aspectRatio: const CropAspectRatio(ratioX: 1080, ratioY: 1080),
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'cropImage'.tr,
              toolbarColor: MyColor.cardColor,
              hideBottomControls:
                  false, // Show bottom controls to allow adjustments
              toolbarWidgetColor: MyColor.orange2,
              lockAspectRatio: true, // Lock aspect ratio to square
              cropFrameColor:
                  MyColor.orange2, // Optional: change crop frame color
              showCropGrid: true, // Optional: show grid for better guidance
            ),
            IOSUiSettings(title: 'Cropper'),
            WebUiSettings(
              context: context,
              presentStyle: WebPresentStyle.page,
              size: const CropperSize(
                width: 200,
                height: 200,
              ),
              // viewwMode: const CroppieViewPort(width: 480, height: 200, type: 'circle'),
            ),
          ],
        );

        if (croppedFile != null) {
          List<File> imageList = [];
          _croppedFile = croppedFile;

          imageList.add(File(_croppedFile!.path));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreatePost()));
        }
      }
    }

    // // final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    // var selectedImages = await imagePicker.pickImage(source: ImageSource.gallery);
    //   // if (selectedImages!.isNotEmpty) {
    //   //   imageFileList.addAll(selectedImages);
    //   // }
    //   print("Image List Length:" + imageFileList.length.toString());
    //   setState((){});
    //
    //   List<File> imageList = [];
    //
    //
    //   if(imageFileList.length > 1){
    //
    //     if(imageFileList.length > 2){
    //       for(var i = 0; i < 2; i++){
    //         imageList.add(File(imageFileList[i].path));
    //       }
    //       toaster(context, "maxPhotos".tr);
    //     }else{
    //       for(var i = 0; i < imageFileList.length; i++){
    //         imageList.add(File(imageFileList[i].path));
    //       }
    //     }
    //     Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost(image: null, video: '',imageList:imageList)));
    //     setState(() {});
    //   }
    //   else{
    //
    //     final croppedFile = await ImageCropper().cropImage(
    //       sourcePath: File(imageFileList[0].path).path,
    //       aspectRatio: const CropAspectRatio(ratioX: 1080, ratioY: 1080),
    //       compressFormat: ImageCompressFormat.jpg,
    //       compressQuality: 100,
    //       uiSettings: [
    //         AndroidUiSettings(
    //           toolbarTitle: 'cropImage'.tr,
    //           toolbarColor: MyColor.cardColor,
    //           hideBottomControls: false, // Show bottom controls to allow adjustments
    //           toolbarWidgetColor: MyColor.orange,
    //           lockAspectRatio: true, // Lock aspect ratio to square
    //           cropFrameColor: MyColor.orange, // Optional: change crop frame color
    //           showCropGrid: true, // Optional: show grid for better guidance
    //         ),
    //         IOSUiSettings(title: 'Cropper'),
    //         WebUiSettings(
    //           context: context,
    //           presentStyle: CropperPresentStyle.page,
    //           boundary: const CroppieBoundary(
    //             width: 200,
    //             height: 200,
    //           ),
    //           viewPort: const CroppieViewPort(width: 480, height: 200, type: 'circle'),
    //         ),
    //       ],
    //     );
    //
    //     if (croppedFile != null) {
    //       _croppedFile = croppedFile;
    //       Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost(image: _croppedFile, video: '')));
    //       setState(() {});
    //     }
    //   }

    // MultiImageCrop.startCropping(
    //     context: context,
    //     aspectRatio: 4 / 3,
    //     activeColor: Colors.amber,
    //     pixelRatio: 3,
    //     files: List.generate(
    //         imageFileList!.length, (index) => File(imageFileList![index].path)),
    //     callBack: (List<File> images) {
    //       setState(() {
    //         croppedFiles = images;
    //         print("CroppedImage Length  ${croppedFiles.length}");
    //       });
    //     });
  }

  updateDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (context, myState) {
          return PopScope(
            canPop: false,
            child: Container(
              decoration: BoxDecoration(
                  color: MyColor.white,
                  borderRadius: BorderRadiusDirectional.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MyString.bold('update'.tr, 20, MyColor.black, TextAlign.center),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: MyString.med(
                          'updateDes'.tr, 14, MyColor.black, TextAlign.center),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () async {
                              if (Platform.isAndroid) {
                                if (!await launchUrl(Uri.parse(
                                    "https://play.google.com/store/apps/details?id=com.jeanne.avispetsApp&hl=en_IN"))) {
                                  throw Exception(
                                      'Could not launch ${Uri.parse("https://play.google.com/store/apps/details?id=com.jeanne.avispetsApp&hl=en_IN")}');
                                }
                              } else {
                                if (!await launchUrl(Uri.parse(
                                    "https://apps.apple.com/us/app/avispets/id6621248673"))) {
                                  throw Exception(
                                      'Could not launch ${Uri.parse("https://apps.apple.com/us/app/avispets/id6621248673")}');
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: MyColor.orange2,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: MyString.med('updateBtn'.tr, 20,
                                    MyColor.white, TextAlign.center),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
