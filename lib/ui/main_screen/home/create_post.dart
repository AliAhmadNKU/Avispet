import 'dart:convert';
import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/brand_model.dart';
import 'package:avispets/models/get_category_model.dart';
import 'package:avispets/models/get_subcategory_model.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../bloc/create_post_bloc.dart';
import '../../../models/my_animal_model.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class CreatePost extends StatefulWidget {
  CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final String video = '';
  List<File>? imageList;

  MyAnimalModel _myAnimalModel = MyAnimalModel();
  GetCategoryModel _categoryModel = GetCategoryModel();
  BrandModel _brandModel = BrandModel();
  GetSubCategoryModel _subCategoryModel = GetSubCategoryModel();
  GetSubCategoryBody subCategoryBody = GetSubCategoryBody();

  var selectCategory = TextEditingController();
  var desc = TextEditingController();

  bool categoryLoader = true;

  bool categoryListOpen = false;

  String? categoryCode;

  String dropDownValue = '';
  String dropDownValue1 = '';
  String dropDownValue2 = '';

  var showToast = false;
  double value = 0.0;

  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  String poop = '';
  String clickIndex = '';

  PageController _pageController = PageController();
  int _currentPage = 0;

  late CreatePostBloc _postBloc;

  File? file;
  var thumbnail;

  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  Map<String, String> brandData = {};
  bool fromCreate = false;
  bool showDrop = false;

  @override
  void initState() {
    super.initState();
    _postBloc = CreatePostBloc(context);

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    if (video.isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        final info = await VideoCompress.compressVideo(
          File(video).path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
          includeAudio: true,
        );
        print(info!.path);
        setState(() {
          videoPlayerController = VideoPlayerController.file(File(info.path!))
            ..initialize().then((value) => setState(() {}));
          _customVideoPlayerController = CustomVideoPlayerController(
              context: context, videoPlayerController: videoPlayerController);
          Future.delayed(Duration.zero, () async {
            thumbnail = await VideoThumbnail.thumbnailFile(
              video: info.path!,
              thumbnailPath: (await getTemporaryDirectory()).path,
              imageFormat: ImageFormat.PNG,
              maxHeight: 64,
              // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
              quality: 75,
            );
            debugPrint('THUMBNAIL VALUE fileName: $thumbnail');
          });
        });
      });
    }

    if (_croppedFile != null) {
      Future.delayed(Duration.zero, () async {
        var result = await FlutterImageCompress.compressWithFile(
          File(_croppedFile!.path).absolute.path,
          minWidth: 2300,
          minHeight: 1500,
          quality: 85, // Adjust the quality as needed, 0 - 100
        );

        // Storing the compressed image
        if (result != null) {
          final directory = await getApplicationDocumentsDirectory();
          final compressedImagePath = '${directory.path}/compressed_image.jpg';
          final compressedImageFile = File(compressedImagePath)
            ..writeAsBytesSync(result);
          setState(() {
            file = compressedImageFile;
          });
        }
        setState(() {});
        print('COMPRESSED IMAGE ::  ${file}');
      });
    }
  }

  @override
  void dispose() async {
    if (video.isNotEmpty) {
      videoPlayerController.dispose();
      _customVideoPlayerController.dispose();
      debugPrint('Dispose method call');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _postBloc,
      child: BlocListener<CreatePostBloc, BlocStates>(
        listener: (context, state) {
          if (state is ValidationCheck) {
            toaster(context, state.value.toString());
          }
          if (state is Loading) {
            LoadingDialog.show(context);
          }
          if (state is Loaded) {
            LoadingDialog.hide(context);
          }
          if (state is NextScreen) {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.mainPage, arguments: 0, (route) => false);
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            backgroundColor: MyColor.white,
            body: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 3),
              decoration: BoxDecoration(
                  color: MyColor.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8, right: 8, left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyString.med('select2PhotoTitle'.tr, 16,
                                MyColor.black, TextAlign.start),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (imageList != null && imageList!.length < 2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyString.med('addAnother'.tr, 16, MyColor.black,
                                    TextAlign.start),
                                InkWell(
                                  onTap: () async {
                                    final pickedFile = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    if (pickedFile != null) {
                                      _pickedFile = pickedFile;
                                      if (_pickedFile != null) {
                                        final croppedFile = await ImageCropper()
                                            .cropImage(
                                                sourcePath: _pickedFile!.path,
                                                aspectRatio:
                                                    const CropAspectRatio(
                                                        ratioX: 1080,
                                                        ratioY: 1080),
                                                compressFormat:
                                                    ImageCompressFormat.jpg,
                                                compressQuality: 100,
                                                uiSettings: [
                                              AndroidUiSettings(
                                                toolbarTitle: 'cropImage'.tr,
                                                toolbarColor: MyColor.cardColor,
                                                hideBottomControls:
                                                    false, // Show bottom controls to allow adjustments
                                                toolbarWidgetColor:
                                                    MyColor.orange,
                                                lockAspectRatio:
                                                    true, // Lock aspect ratio to square
                                                cropFrameColor: MyColor
                                                    .orange, // Optional: change crop frame color
                                                showCropGrid:
                                                    true, // Optional: show grid for better guidance
                                              ),
                                              IOSUiSettings(title: 'Cropper'),
                                              WebUiSettings(
                                                context: context,
                                                presentStyle:
                                                    WebPresentStyle.page,
                                                size: const CropperSize(
                                                  width: 200,
                                                  height: 200,
                                                ),
                                              )
                                            ]);

                                        if (croppedFile != null) {
                                          setState(() {
                                            _croppedFile = croppedFile;
                                            imageList
                                                ?.add(File(_croppedFile!.path));
                                          });
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: MyColor.orange,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                        child: Icon(Icons.add,
                                            color: MyColor.white, size: 20)),
                                  ),
                                ),
                              ],
                            ),
                          if (imageList != null)
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                height: 280,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Stack(
                                  children: [
                                    PageView.builder(
                                      controller: _pageController,
                                      itemCount: imageList!.length,
                                      itemBuilder: (context, index) {
                                        return ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.file(
                                            imageList![index],
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: _buildPageIndicator(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (imageList == null)
                            SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: file != null
                                      ? Image.file(file!, fit: BoxFit.cover)
                                      : video.isNotEmpty
                                          ? CustomVideoPlayer(
                                              customVideoPlayerController:
                                                  _customVideoPlayerController)
                                          : Image.asset(
                                              'assets/images/logos/add_image.png',
                                            ),
                                )),
                          GestureDetector(
                            onTap: () {
                              credentialCheck();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 25, right: 30, left: 30),
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: MyColor.orange,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  MyString.med('savePost'.tr, 18, MyColor.white,
                                      TextAlign.center),
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Image.asset(
                                        "assets/images/onboard/intro_button_icon.png"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> myAnimalList = [];

  _myAnimal() async {
    var res =
        await AllApi.getMethodApi("${ApiStrings.myAnimals}?page=1&limit=20");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      myAnimalList.clear();
      _myAnimalModel = MyAnimalModel.fromJson(result);

      for (int i = 0; i < _myAnimalModel.data!.length; i++) {
        myAnimalList.add(_myAnimalModel.data![i].name.toString());
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    setState(() {});
  }

  List<String> categoryList = [];
  List<String> brandList = [];

  _getBrands(String search) async {
    var res = await AllApi.getMethodApi(
        '${ApiStrings.product_brands}?page=1&limit=100&search=$search');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      brandList.clear();
      _brandModel = BrandModel.fromJson(result);
      for (int i = 0; i < _brandModel.data!.length; i++) {
        (sharedPref.getString(SharedKey.languageValue).toString() == 'en')
            ? brandList.add(_brandModel.data![i].name.toString())
            : brandList.add(_brandModel.data![i].nameFr.toString());
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    setState(() {});
  }

  _getCategory() async {
    var res =
        await AllApi.getMethodApi('${ApiStrings.categories}?page=1&limit=100');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      categoryLoader = false;
      categoryList.clear();
      _categoryModel = GetCategoryModel.fromJson(result);
      for (int i = 0; i < _categoryModel.data!.length; i++) {
        (sharedPref.getString(SharedKey.languageValue).toString() == 'en')
            ? categoryList.add(_categoryModel.data![i].name.toString())
            : categoryList.add(_categoryModel.data![i].nameFr.toString());
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    setState(() {});
  }

  List<String> subCategoryList = [];

  credentialCheck() {
    List<String> imageArray = [];

    if (video.isNotEmpty) {
      imageArray.add(video);
    }

    if (_croppedFile != null) {
      imageArray.add(file!.path);
    }

    if (imageList != null) {
      for (var i = 0; i < imageList!.length; i++) {
        imageArray.add(imageList![i].path);
      }
    }

    List<Map<String, String>> selectedStarMapList = [];
    var data = jsonEncode(selectedStarMapList);
    var brandDataMap = jsonEncode(brandData);

    debugPrint("JKHGKJJHGrwere   ${data.toString()}");
    debugPrint("JKHGKJJHG   ${brandDataMap.toString()}");

    /*if (showToast) {
      toaster(context, 'selectStar'.tr);
      showToast = false;
    } else {
      _postBloc.add(GetCreatePostEvent(
          imageArray,
          thumbnail));
    }*/
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < imageList!.length; i++) {
      indicators.add(
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? MyColor.newBackgroundColor : Colors.grey,
          ),
        ),
      );
    }
    return indicators;
  }
}
