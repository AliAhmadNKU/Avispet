import 'dart:convert';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:avispets/ui/main_screen/map/search_bar.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/common_function/my_string.dart';
import '../../../../utils/my_routes/route_name.dart';
import '../../../bloc/bloc_events.dart';
import '../../../bloc/bloc_states.dart';
import '../../../bloc/create_post_bloc.dart';
import '../../../models/get_all_categories_model.dart';
import '../../../models/locations/get_location_name_address.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/crop_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/toaster.dart';
import '../map/google_maps_service.dart';
import '../map/map_page.dart';
import 'package:http/http.dart' as http;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loader = true;
  int page = 1;
  bool isLoadingLocation = false;
  int currentTab = 1;
  var showToast = false;
  File? fileImage;
  final String video = '';
  CroppedFile? _croppedFile;
  File? file;
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  late CreatePostBloc _postBloc;
  TextEditingController searchBar = TextEditingController();

  //post fields
  String selectedCategory = 'petstore';
  Map<String, dynamic>? currPos;
  double lat = 0;
  double long = 0;
  int cr1 = 1;
  int cr2 = 1;
  int cr3 = 1;
  int cr4 = 1;
  int cr5 = 1;
  bool smallDogsAllowed = false;
  bool bigDogsAllowed = false;
  bool childPresence = false;
  bool allDogsAllowed = false;
  bool leashRequired = false;
  bool greenSpacesNearby = false;
  List<File> imageList = [];
  var thumbnail;

  //lists
  List<FilterModel> dataList = [
    FilterModel(
        'assets/images/markers/Animalerie.png', 'Animalerie'.tr, 'petstore'),
    FilterModel('assets/images/markers/Bars.png', 'Bars'.tr, 'bar'),
    FilterModel('assets/images/markers/coffee.png', 'coffee'.tr, 'coffee'),
    FilterModel('assets/images/markers/Evenement.png', 'Evenement'.tr, 'event'),
    FilterModel(
        'assets/images/markers/Exposition.png', 'Exposition'.tr, 'expo'),
    FilterModel('assets/images/markers/Hotel.png', 'Hotel'.tr, 'hotel'),
    FilterModel(
        'assets/images/markers/localisation.png', 'localisation'.tr, 'loc'),
    FilterModel('assets/images/markers/Parks.png', 'Parks'.tr, 'park'),
    FilterModel(
        'assets/images/markers/Restaurants.png', 'Restaurants'.tr, 'resto'),
    FilterModel(
        'assets/images/markers/supermarket.png', 'supermarket'.tr, 'market'),
    FilterModel(
        'assets/images/markers/Toilettage.png', 'Toilettage'.tr, 'toilet'),
    FilterModel(
        'assets/images/markers/Veterinaire.png', 'Veterinaire'.tr, 'vet'),
  ];
  List<CriteriaModel> CriteriasList = [
    CriteriaModel(
      title: 'Atmosphere and environment',
      subtitle: '(score from 1 to 5)',
      data: [
        CriteriaModelBody(l1: '1: Very unpleasant (noisy, dirty, unsafe).'),
        CriteriaModelBody(
            l2: '2: Not very pleasant, several notable problems.'),
        CriteriaModelBody(l3: '3: Acceptable, some areas for improvement.'),
        CriteriaModelBody(l4: '4: Nice and clean, good environment.'),
        CriteriaModelBody(l5: '5: Excellent, very pet friendly.')
      ],
    ),
    CriteriaModel(
      title: 'Safety for animals',
      subtitle: '(score from 1 to 5)',
      data: [
        CriteriaModelBody(l1: '1: Very dangerous for animals (high risks).'),
        CriteriaModelBody(l2: '2: Risks present but manageable.'),
        CriteriaModelBody(l3: '3: Acceptable, some concerns.'),
        CriteriaModelBody(l4: '4: Generally safe for animals.'),
        CriteriaModelBody(l5: '5: Very safe, excellent security measures.')
      ],
    ),
    CriteriaModel(
        title: 'Accessibility and infrastructure',
        subtitle: '(score from 1 to 5)',
        data: [
          CriteriaModelBody(
              l1: '1: Very difficult to access with an animal (no ramps, stairs).'),
          CriteriaModelBody(
              l2: '2: Difficult to access, little suitable infrastructure.'),
          CriteriaModelBody(l3: '3: Acceptable, some easy access.'),
          CriteriaModelBody(l4: '4: Well accessible with good infrastructure.'),
          CriteriaModelBody(l5: '5: Perfectly accessible, excellent layout.')
        ]),
    CriteriaModel(
        title: 'Social interactions',
        subtitle: '(score from 1 to 5)',
        data: [
          CriteriaModelBody(
              l1: '1: No opportunities to socialize (pets or owners).'),
          CriteriaModelBody(
              l2: '2: Few interactions possible, closed atmosphere.'),
          CriteriaModelBody(l3: '3: Casual interactions, neutral atmosphere.'),
          CriteriaModelBody(
              l4: '4: Good socializing opportunities, friendly atmosphere.'),
          CriteriaModelBody(
              l5: '5: Excellent interactions, very welcoming to animals and their owners.')
        ]),
    CriteriaModel(
        title: 'Value for money',
        subtitle: '(score from 1 to 5)',
        data: [
          CriteriaModelBody(
              l1: '1: Very poor value for money (too expensive for what is offered).'),
          CriteriaModelBody(l2: '2: Bad ratio, limited options for the price.'),
          CriteriaModelBody(l3: '3: Acceptable, good value for money.'),
          CriteriaModelBody(l4: '4: Good value for money, satisfactory.'),
          CriteriaModelBody(
              l5: '5: Excellent value for money, high quality services.')
        ])
  ];
  int? selectedIndex;

  // List of toggle options
  final List<String> toggleOptions = ['byName'.tr, 'byAddress'.tr, 'url'.tr];

  final List<Map<String, String>> places = [
    {
      'icon': 'assets/images/icons/dish.png',
      'title': 'Animalerie Lyvry-Gargan',
      'distance': '2.7 km',
      'address': '47-53 Boulevard de l\'Europe',
      'users': '13.1K users'
    },
    {
      'icon': 'assets/images/icons/dish.png',
      'title': 'Villmorin (Animalie Vilmorin)',
      'distance': '9 km',
      'address': '4 rue du foulard grouge',
      'users': '4 users'
    },
    {
      'icon': 'assets/images/icons/dish.png',
      'title': 'Animado',
      'distance': '4 km',
      'address': '37 boulevard michel',
      'users': '9 users'
    },
    {
      'icon': 'assets/images/icons/dish.png',
      'title': 'Animale de Chatelet',
      'distance': '6.9 km',
      'address': '2 rue de la Franc',
      'users': 'N/A'
    },
  ];
  List<Data> categoriesList = [];
  List<LocationData> locationListByName = [];

  getAllCategoriesApi() async {
    try {
      var res = await AllApi.getMethodApi("${ApiStrings.getAllCategories}");
      print(res);
      var result = jsonDecode(res.toString());

      if (result['status'] == 200) {
        // Parse the response into the GetAllCategories model
        GetAllCategories categories = GetAllCategories.fromJson(result);
        setState(() {
          categoriesList = categories.data ?? [];
        });
      } else if (result['status'] == 401) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.loginScreen, (route) => false);
      } else {
        toaster(context, result['message'].toString());
      }
    } catch (e) {
      debugPrint("Error: $e");
      toaster(context, "An error occurred while fetching categories.");
    }
  }

  String currentTimeZone = "";
  String longitude = "";
  String latitude = "";
  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    longitude = position.longitude.toString();
    latitude = position.latitude.toString();
  }

  getLocationByName() async {
    try {
      print('==================');

      Map<String, dynamic> data = {
        "latitude": 40.7128,
        "longitude": 74.0060,
        "query": "KFC",
        "radius": 500
      };
      var res = await AllApi.postMethodApii(
          ApiStrings.getLocationByNameAndAddress, data);

      var result = res is String ? jsonDecode(res) : res;

      if (result['status'] == 201) {
        // Parse the response into the GetAllCategories model
        GetLocatioByName location = GetLocatioByName.fromJson(result);
        setState(() {
          locationListByName = location.data ?? [];
        });
      } else if (result['status'] == 401) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.loginScreen, (route) => false);
      } else {
        toaster(context, result['message'].toString());
      }
    } catch (e) {
      debugPrint("Error: {$e");
      toaster(context, "An error occurred while fetching categories.");
    }
  }

  getAllCatergoryandLocation() async {
    // await getAllCategoriesApi();
    // await _getLocation();
    // await getLocationByName();
  }

  @override
  void initState() {
    super.initState();
    getAllCatergoryandLocation();
    GetApi.getNotify(context, '');
    _postBloc = CreatePostBloc(context);
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

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffEBEBEB)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(13),
              bottomRight: Radius.circular(50))),
      child: TextField(
        controller: searchBar,
        scrollPadding: const EdgeInsets.only(bottom: 50),
        style: TextStyle(color: MyColor.black, fontSize: 14),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          prefixIcon: SizedBox(
              width: 20,
              height: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/icons/search.png',
                  width: 20,
                  height: 20,
                ),
              )),
          suffixIcon: GestureDetector(
            onTap: () async {
              Navigator.pushNamed(context, RoutesName.filterScreen);
            },
            child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xff4F2020),
                    borderRadius: BorderRadius.circular(150)),
                child: Image.asset('assets/images/icons/filter.png')),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          hintText: 'search'.tr,
          hintStyle: TextStyle(color: MyColor.textBlack0, fontSize: 14),
        ),
        onChanged: (value) {},
      ),
    );
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
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          page++;
        }
        return false;
      },
      child: BlocProvider(
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
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HeaderWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: MyString.bold('${'addPost'.tr}', 27,
                                MyColor.title, TextAlign.center),
                          ),
                          buildSearchBar(),
                          SizedBox(
                            height: 20,
                          ),
                          currentTab == 1
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   height: 50,
                                    //   margin: EdgeInsets.only(
                                    //       bottom: 25, right: 15, left: 15),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.center,
                                    //     children: [
                                    //       Flexible(
                                    //         child: Container(
                                    //           child: SearchingBar(
                                    //               onChanged: _updateSuggestions,
                                    //               onPlaceSelected:
                                    //                   _getLocation),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Container(
                                    //   height: 70,
                                    //   child: ListView.builder(
                                    //     padding: EdgeInsets.zero,
                                    //     scrollDirection: Axis.horizontal,
                                    //     shrinkWrap: true,
                                    //     itemCount: dataList.length,
                                    //     itemBuilder: (context, index) {
                                    //       return GestureDetector(
                                    //         onTap: () async {
                                    //           setState(() {
                                    //             selectedCategory =
                                    //                 dataList[index].nickname;
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           width: 70,
                                    //           child: Column(
                                    //             children: [
                                    //               Image.asset(
                                    //                 '${dataList[index].image}',
                                    //                 height: 30,
                                    //                 width: 30,
                                    //               ),
                                    //               dataList[index].nickname ==
                                    //                       selectedCategory
                                    //                   ? MyString.bold(
                                    //                       '${dataList[index].name}',
                                    //                       10,
                                    //                       MyColor.title,
                                    //                       TextAlign.center)
                                    //                   : MyString.reg(
                                    //                       '${dataList[index].name}',
                                    //                       10,
                                    //                       MyColor.title,
                                    //                       TextAlign.center),
                                    //               if (dataList[index]
                                    //                       .nickname ==
                                    //                   selectedCategory)
                                    //                 Divider(
                                    //                   color: MyColor
                                    //                       .orange2, // Color of the divider
                                    //                   thickness:
                                    //                       3, // Thickness of the line
                                    //                   indent:
                                    //                       5, // Start padding
                                    //                   endIndent:
                                    //                       5, // End padding
                                    //                 ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await getLocationByName();
                                        },
                                        child: Text('GET')),

                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: categoriesList.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              // Handle tap action here
                                            },
                                            child: Container(
                                              width: 75,
                                              child: Column(
                                                children: [
                                                  categoriesList[index].icon !=
                                                          null
                                                      ? Image.network(
                                                          categoriesList[index]
                                                              .icon!,
                                                          height: 40,
                                                          width: 40,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Icon(Icons.error),
                                                        )
                                                      : Icon(Icons.category,
                                                          size: 40),
                                                  SizedBox(height: 5),
                                                  Flexible(
                                                    child: Text(
                                                      categoriesList[index]
                                                              .name ??
                                                          "Unnamed",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: MyColor.title,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: List.generate(
                                    //       toggleOptions.length, (index) {
                                    //     bool isSelected =
                                    //         index == selectedIndex;

                                    //     return GestureDetector(
                                    //       onTap: () {
                                    //         setState(() {
                                    //           selectedIndex =
                                    //               index; // Update the selected index
                                    //         });
                                    //       },
                                    //       child: Container(
                                    //         padding: const EdgeInsets.symmetric(
                                    //             horizontal: 10),
                                    //         alignment: Alignment.center,
                                    //         height: 50,
                                    //         width: Get.width / 3.5,
                                    //         decoration: BoxDecoration(
                                    //           color: isSelected
                                    //               ? MyColor.orange2
                                    //               : MyColor.card,
                                    //           borderRadius:
                                    //               const BorderRadius.all(
                                    //                   Radius.circular(18)),
                                    //         ),
                                    //         child: MyString.reg(
                                    //           toggleOptions[index],
                                    //           15,
                                    //           isSelected
                                    //               ? MyColor.white
                                    //               : MyColor.orange2,
                                    //           TextAlign.center,
                                    //         ),
                                    //       ),
                                    //     );
                                    //   }),
                                    // ),
                                    if (selectedIndex != null)
                                      Column(
                                        children: [
                                          Container(
                                            height: Get.height / 2,
                                            child: ListView.builder(
                                              itemCount: places.length,
                                              itemBuilder: (context, index) {
                                                final place = places[index];
                                                return Card(
                                                  elevation: 0,
                                                  color: MyColor.white,
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: ListTile(
                                                    leading: Image.asset(
                                                      place['icon']!,
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                    title: Text(
                                                      place['title']!,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(place['address']!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                        Text(
                                                          'Added by ${place['users']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                      place['distance']!,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                RoutesName.addPostDetail,
                                              );
                                            },
                                            child: Center(
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 59,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: MyColor.orange2,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                22))),
                                                child: isLoadingLocation
                                                    ? CircularProgressIndicator()
                                                    : MyString.med(
                                                        'createANewPlace'.tr,
                                                        18,
                                                        MyColor.white,
                                                        TextAlign.center),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 15),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: MyColor.card,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(22))),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              width: 49,
                                              height: 53,
                                              'assets/images/icons/carte.png'),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyString.bold(
                                                    'Tips'.tr,
                                                    14,
                                                    MyColor.redd,
                                                    TextAlign.start),
                                                MyString.med(
                                                    'Enter the name or adress of the place to add it your maps'
                                                        .tr,
                                                    12,
                                                    MyColor.title,
                                                    TextAlign.start),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, bottom: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                              flex: 4,
                                              child: MyString.med(
                                                  "orContinueWith".tr,
                                                  12,
                                                  MyColor.textBlack0,
                                                  TextAlign.start)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: isLoadingLocation
                                          ? null
                                          : getCurrentLocation,
                                      child: Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 59,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: MyColor.orange2,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(22))),
                                          child: isLoadingLocation
                                              ? CircularProgressIndicator()
                                              : MyString.med(
                                                  'useCurrLoc'.tr,
                                                  18,
                                                  MyColor.white,
                                                  TextAlign.center),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : loader
                                  ? Container(height: 150, child: progressBar())
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Divider(
                                          color: Color(
                                              0xffEBEBEB), // Color of the divider
                                          thickness: 1, // Thickness of the line
                                          indent: 16, // Start padding
                                          endIndent: 16, // End padding
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              MyString.bold(
                                                  '${currPos!['address']}',
                                                  18,
                                                  MyColor.title,
                                                  TextAlign.start),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 10),
                                          child: MyString.reg(
                                              '${'Evaluate the quality of service'.tr}',
                                              12,
                                              MyColor.textBlack0,
                                              TextAlign.center),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.54,
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: CriteriasList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 4),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        10))),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  MyColor.card,
                                                              border: Border.all(
                                                                  color: MyColor
                                                                      .orange2),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          10))),
                                                          child: ExpansionTile(
                                                            backgroundColor:
                                                                MyColor.orange2,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            collapsedBackgroundColor:
                                                                MyColor.card,
                                                            collapsedShape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            title: MyString.bold(
                                                                '${CriteriasList[index].title}',
                                                                14,
                                                                CriteriasList[
                                                                            index]
                                                                        .isExpanded
                                                                    ? MyColor
                                                                        .white
                                                                    : MyColor
                                                                        .redd,
                                                                TextAlign
                                                                    .start),
                                                            subtitle: MyString.reg(
                                                                '${CriteriasList[index].subtitle}',
                                                                12,
                                                                CriteriasList[
                                                                            index]
                                                                        .isExpanded
                                                                    ? MyColor
                                                                        .white
                                                                    : MyColor
                                                                        .redd,
                                                                TextAlign
                                                                    .start),
                                                            trailing:
                                                                Image.asset(
                                                              CriteriasList[
                                                                          index]
                                                                      .isExpanded
                                                                  ? 'assets/images/icons/minus.png'
                                                                  : 'assets/images/icons/addpic.png',
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                            onExpansionChanged:
                                                                (bool
                                                                    expanded) {
                                                              setState(() {
                                                                CriteriasList[
                                                                            index]
                                                                        .isExpanded =
                                                                    expanded;
                                                              });
                                                            },
                                                            children: [
                                                              ...?CriteriasList[
                                                                      index]
                                                                  .data
                                                                  ?.map(
                                                                      (criteriaBody) {
                                                                return Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          18.0,
                                                                      vertical:
                                                                          2),
                                                                  color: MyColor
                                                                      .card,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      if (criteriaBody
                                                                              .l1 !=
                                                                          null)
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: MyString.reg(criteriaBody.l1!, 12, MyColor.textBlack0, TextAlign.start),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      if (criteriaBody
                                                                              .l2 !=
                                                                          null)
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: MyString.reg(criteriaBody.l2!, 12, MyColor.textBlack0, TextAlign.start),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      if (criteriaBody
                                                                              .l3 !=
                                                                          null)
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: MyString.reg(criteriaBody.l3!, 12, MyColor.textBlack0, TextAlign.start),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      if (criteriaBody
                                                                              .l4 !=
                                                                          null)
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: MyString.reg(criteriaBody.l4!, 12, MyColor.textBlack0, TextAlign.start),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      if (criteriaBody
                                                                              .l5 !=
                                                                          null)
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: MyString.reg(criteriaBody.l5!, 12, MyColor.textBlack0, TextAlign.start),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              Container(
                                                                color: MyColor
                                                                    .card,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            18,
                                                                        vertical:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    MyString.reg(
                                                                        'Rating: ',
                                                                        12,
                                                                        MyColor
                                                                            .red,
                                                                        TextAlign
                                                                            .start),
                                                                    RatingBar
                                                                        .builder(
                                                                      unratedColor:
                                                                          Color(
                                                                              0xffBEBEBE),
                                                                      itemSize:
                                                                          15,
                                                                      initialRating:
                                                                          1,
                                                                      minRating:
                                                                          1,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          true,
                                                                      itemCount:
                                                                          5,
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                      onRatingUpdate:
                                                                          (rating) {
                                                                        setState(
                                                                            () {
                                                                          index == 0
                                                                              ? cr1 = rating.toInt()
                                                                              : index == 1
                                                                                  ? cr2 = rating.toInt()
                                                                                  : index == 2
                                                                                      ? cr3 = rating.toInt()
                                                                                      : index == 3
                                                                                          ? cr4 = rating.toInt()
                                                                                          : cr5 = rating.toInt();
                                                                          ;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              MyString.bold(
                                                  '${'Category'.tr} :',
                                                  12,
                                                  MyColor.title,
                                                  TextAlign.start),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              MyString.reg(
                                                  '${selectedCategory}',
                                                  12,
                                                  MyColor.title,
                                                  TextAlign.start),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              MyString.bold(
                                                  '${'Reservation Platform : '.tr}',
                                                  12,
                                                  MyColor.title,
                                                  TextAlign.start),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              MyString.reg(
                                                  '${currPos!['website']}',
                                                  12,
                                                  MyColor.textBlack0,
                                                  TextAlign.start),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              MyString.bold(
                                                  '${'Additional information to share & specify : '.tr}',
                                                  12,
                                                  MyColor.title,
                                                  TextAlign.start),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              MyString.reg(
                                                  '${currPos!['openingHours']}',
                                                  12,
                                                  MyColor.textBlack0,
                                                  TextAlign.start),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              MyString.bold(
                                                  '${'Add photos for you and your followers'.tr}',
                                                  14,
                                                  MyColor.title,
                                                  TextAlign.start),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height:
                                              imageList.length >= 3 ? 230 : 110,
                                          width: double.infinity,
                                          child: GridView.builder(
                                            itemCount: imageList.length + 1,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  3, // Number of items per row
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                            ),
                                            itemBuilder: (context, index) {
                                              if (index == imageList.length) {
                                                // Add More Button
                                                return GestureDetector(
                                                  onTap: () async {
                                                    String? result =
                                                        await cameraPhoto(
                                                            context,
                                                            "add_post");
                                                    var returnImage;

                                                    // Pick image from Camera or Gallery
                                                    if (result == '0') {
                                                      returnImage =
                                                          await pickImage(
                                                              context,
                                                              ImageSource
                                                                  .camera);
                                                    } else if (result == '1') {
                                                      returnImage =
                                                          await pickImage(
                                                              context,
                                                              ImageSource
                                                                  .gallery);
                                                    }

                                                    // Add image to list after cropping
                                                    if (returnImage != null) {
                                                      fileImage = returnImage;
                                                      imageList.add(File(
                                                          fileImage!.path));
                                                    }

                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.white,
                                                      border: Border.all(
                                                          color:
                                                              MyColor.orange2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/icons/addpic.png',
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                        Center(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              'addAnother'.tr,
                                                              style: TextStyle(
                                                                  color: MyColor
                                                                      .orange2)),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                // Display selected images
                                                return Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.file(
                                                        imageList[index],
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // Remove image from list
                                                          setState(() {
                                                            imageList.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red
                                                                .withOpacity(
                                                                    0.8),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 18,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // First Column
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    toggleSwitch(
                                                      label:
                                                          "Suitable for small dogs",
                                                      value: smallDogsAllowed,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          smallDogsAllowed =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    toggleSwitch(
                                                      label:
                                                          "Suitable for big dogs",
                                                      value: bigDogsAllowed,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          bigDogsAllowed =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    toggleSwitch(
                                                      label:
                                                          "Presence of child",
                                                      value: childPresence,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          childPresence =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Second Column
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    toggleSwitch(
                                                      label: "All dogs allowed",
                                                      value: allDogsAllowed,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          allDogsAllowed =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    toggleSwitch(
                                                      label:
                                                          "Dog leash obligatory",
                                                      value: leashRequired,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          leashRequired =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    toggleSwitch(
                                                      label:
                                                          "Green spaces nearby\n(-10 min walk)",
                                                      value: greenSpacesNearby,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          greenSpacesNearby =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Color(
                                              0xffEBEBEB), // Color of the divider
                                          thickness: 1, // Thickness of the line
                                          indent: 16, // Start padding
                                          endIndent: 16, // End padding
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/icons/phone.png',
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  MyString.med(
                                                      '${currPos!['phone']}',
                                                      12,
                                                      MyColor.textBlack0,
                                                      TextAlign.center),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            credentialCheck();
                                          },
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 20),
                                              alignment: Alignment.center,
                                              height: 45,
                                              width: 162,
                                              decoration: BoxDecoration(
                                                  color: MyColor.orange2,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(22))),
                                              child: MyString.med(
                                                  'savePost'.tr,
                                                  18,
                                                  MyColor.white,
                                                  TextAlign.center),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                          //=============================================
                          Column(
                            children: [
                              Container(
                                height: Get.height / 2,
                                child: ListView.builder(
                                  itemCount: locationListByName.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 0,
                                      color: MyColor.white,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: ListTile(
                                        leading: Image.network(
                                          locationListByName[index]
                                              .profile
                                              .toString(),
                                          width: 40,
                                          height: 40,
                                        ),
                                        title: Text(
                                          locationListByName[index]
                                              .name
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                locationListByName[index]
                                                    .address
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                            Text(
                                              'Rating by ${locationListByName[index].userRating.toString()} users',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          locationListByName[index]
                                              .source
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.addPostDetail,
                                  );
                                },
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 59,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: MyColor.orange2,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(22))),
                                    child: isLoadingLocation
                                        ? CircularProgressIndicator()
                                        : MyString.med('createANewPlace'.tr, 18,
                                            MyColor.white, TextAlign.center),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget toggleSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.6,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: MyColor.orange2,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ),
        Flexible(
            child:
                MyString.reg(label, 11, MyColor.textBlack0, TextAlign.start)),
      ],
    );
  }

  void credentialCheck() {
    List<String> imageArray = [];

    // Add video if available
    if (video.isNotEmpty) {
      imageArray.add(video);
    }

    // Add cropped file if available
    if (_croppedFile != null) {
      imageArray.add(file!.path);
    }

    // Add images from the list if available
    if (imageList != null) {
      for (var i = 0; i < imageList!.length; i++) {
        imageArray.add(imageList![i].path);
      }
    }

    // Check if imageArray is empty
    if (imageArray.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please add at least one image or video before proceeding.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: MyColor.orange2,
        textColor: MyColor.white,
        fontSize: 12.0,
      );
      return;
    }

    _postBloc.add(GetCreatePostEvent(
      selectedCategory,
      currPos,
      lat,
      long,
      cr1,
      cr2,
      cr3,
      cr4,
      cr5,
      smallDogsAllowed,
      bigDogsAllowed,
      childPresence,
      allDogsAllowed,
      leashRequired,
      greenSpacesNearby,
      imageArray,
      thumbnail,
    ));
  }

  Future<void> _updateSuggestions(String query) async {
    if (query.isNotEmpty) {
      await GoogleMapsService.getPlaceSuggestions(query);
    }
  }

  Future<void> _getLocations(String address) async {
    const apiKey = 'AIzaSyBANJJlDplrqmPbPM2CK6suomwcrRmI_sU';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        setState(() {
          lat = location['lat'];
          long = location['lng'];
          currentTab = 2;
        });
        Future.delayed(Duration(milliseconds: 100), () async {
          Map<String, dynamic>? curPos =
              await GoogleMapsService.getLocationInfo(lat, long);
          setState(() {
            currPos = curPos;
          });
          if (currPos != null) {
            loader = false;
          }
        });
      }
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        currentTab = 2;
      });
      Future.delayed(Duration(milliseconds: 100), () async {
        Map<String, dynamic>? curPos =
            await GoogleMapsService.getLocationInfo(lat, long);
        setState(() {
          currPos = curPos;
        });
        if (currPos != null) {
          loader = false;
        }
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }
}

class CriteriaModel {
  String? title;
  String? subtitle;
//extra
  bool isExpanded = false;

  List<CriteriaModelBody>? data;

  CriteriaModel({
    this.title,
    this.subtitle,
    this.data,
  });
}

class CriteriaModelBody {
  int? id;
  String? l5;
  String? l4;
  String? l3;
  String? l2;
  String? l1;

  CriteriaModelBody({
    this.id,
    this.l5,
    this.l4,
    this.l3,
    this.l2,
    this.l1,
  });
}
