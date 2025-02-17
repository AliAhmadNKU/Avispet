import 'package:avispets/models/events_response_model.dart';
import 'package:avispets/models/get_all_categories_model.dart';
import 'package:avispets/models/locations/get_location_name_address.dart';
import 'package:avispets/models/locations/location_by_category_response_model.dart';
import 'package:avispets/models/online_store_response_model.dart';
import 'package:avispets/ui/main_screen/map/search_bar.dart';
import 'package:avispets/ui/widgets/no_data_found.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/loader_screen.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:avispets/models/locations/get_location_name_address.dart' as LocationDataModel;
import '../../../../utils/my_color.dart';
import '../../../../utils/common_function/my_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationPackage;
import '../../../utils/apis/get_api.dart';
import '../../../utils/my_routes/route_name.dart';
import '../home/home_screen.dart';
import 'google_maps_service.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<BitmapDescriptor> getResizedMarker(
    String assetPath, int width, int height) async {
  final ByteData data = await rootBundle.load(assetPath);
  final ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
    targetHeight: height,
  );
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ByteData? resizedData =
      await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LocationPackage.Location _location = LocationPackage.Location();
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  LocationData? _locationData;
  EventsModel? _eventsModel;
  OnlineStoreModel? _onlineStoreModel;

  final Set<Marker> _markers = {};
  LatLng _initialPosition = const LatLng(37.7749, -122.4194); // San Francisco
  BitmapDescriptor? _customMarkerIcon;

  bool _shouldFollowUserLocation = true;
  LatLng? _selectedMarkerPosition;
  String? _selectedAddress;
  String? _selectedPlace;
  String? _selectedRating;
  String? _selectedReviews;
  String? _selectedDistance;
  String _selectedImage = 'assets/images/place.png';
  List<Data> categoriesList = [];

  LocationByCategoryResponseModel _locationByCategoryResponseModel = LocationByCategoryResponseModel();

  void _onMapCreated(GoogleMapController controller) {
    print('_onMapCreated => ');
    _mapController = controller;
    _location.onLocationChanged.listen((LocationPackage.LocationData locationData) {
      if (_shouldFollowUserLocation &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        _shouldFollowUserLocation = false;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(locationData.latitude!, locationData.longitude!),
          ),
        );
      }
    });
  }

  void _onMapTap(LatLng position) async {
    print('_onMapTap');
    final address = await GoogleMapsService.getAddressFromLatLng(
        position.latitude, position.longitude);
    setState(() {
      _selectedMarkerPosition = position;
      _selectedAddress = address;
    });
  }

  _onPlaceSelected(dynamic data) async {
    print('_onPlaceSelected => $data');
    if(data is LocationData){
      _locationData = data;
      // await _convertAddressToLatLng(_locationData!.address!);
    }
    else if(data is EventsModel){
      _eventsModel = data;
      // await _convertAddressToLatLng(_eventsModel!.name!);
    }
    else if(data is OnlineStoreModel){
      _onlineStoreModel = data;
      // await _convertAddressToLatLng(_onlineStoreModel!.address!);
    }

  }

  // _onPlaceSelected(dynamic locationData) async {
  //   await _convertAddressToLatLng(locationData.address!);
  // }

  Future<void> _convertAddressToLatLng(String address) async {
    const apiKey = 'AIzaSyBANJJlDplrqmPbPM2CK6suomwcrRmI_sU';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        final latLng = LatLng(location['lat'], location['lng']);
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(address),
              position: latLng,
              infoWindow: InfoWindow(title: address),
            ),
          );
        });
      }
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

  void _onMapTapDismiss() {
    setState(() {
      _selectedMarkerPosition = null;
      _selectedAddress = null;
      _selectedPlace = null;
      _selectedRating = null;
      _selectedReviews = null;
      _selectedDistance = null;
    });
  }

  bool loader = true;
  int page = 1;
  int currentTab = 1;
  String selectedCategory = '';

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

  List<Postssss> posts = [
    Postssss(
      title: 'Bar1',
      location: 'Berlin, Germany',
      category: 'bar',
      lat: 37.7749,
      long: -122.4194,
      distance: '2 KM',
      rating: 4.5,
      reviews: 563,
      likes: 100,
      comments: 50,
      timeAgo: '5 min ago',
      imageUrl: 'assets/images/place.png',
    ),
    Postssss(
      title: 'Petstore1',
      location: 'Munich, Germany',
      category: 'petstore',
      distance: '3 KM',
      lat: 37,
      long: -122,
      rating: 4.2,
      reviews: 432,
      likes: 100,
      comments: 50,
      timeAgo: '10 min ago',
      imageUrl: 'assets/images/place.png',
    ),
    Postssss(
      title: 'Hotel1',
      location: 'Berlin, Germany',
      category: 'hotel',
      distance: '2 KM',
      lat: 36,
      long: -122,
      rating: 4.5,
      reviews: 563,
      likes: 100,
      comments: 50,
      timeAgo: '5 min ago',
      imageUrl: 'assets/images/place.png',
    ),
  ];
  List<Postssss> filteredPosts = [];
  List<LocationModel> filteredPostsNew = [];

  double longitude = 0;

  double latitude = 0;

  void filterPosts(String category) {
    setState(() {
      filteredPosts = posts.where((post) => post.category == category).toList();
    });
  }

  void _filterPostsAndAddMarkers(String category) async {
    _shouldFollowUserLocation = false;
    final List<Marker> newMarkers = [];
    final filteredPosts =
    categoriesList.where((post) => post.name == category).toList();
    for (var post in filteredPosts) {
      BitmapDescriptor customIcon =
          BitmapDescriptor.defaultMarker; // Fallback to default marker
      try {
        final matchingFilter = categoriesList.firstWhere(
              (filter) => filter.name == post.name,
        );

        if (matchingFilter != null) {
          customIcon = await getResizedMarker(matchingFilter.icon!, 100,
              100); // Adjust width and height as needed
        }
      } catch (e) {
        debugPrint('Error loading marker icon: $e');
      }
      // newMarkers.add(
      //   Marker(
      //     markerId: MarkerId(post.title),
      //     position: LatLng(post.lat, post.long),
      //     onTap: () {
      //       setState(() {
      //         _selectedMarkerPosition = LatLng(post.lat, post.long);
      //         _selectedAddress = '${post.location}';
      //         _selectedPlace = '${post.title}';
      //         _selectedRating = '${post.rating}';
      //         _selectedReviews = '${post.reviews}';
      //         _selectedDistance = '${post.distance}';
      //         _selectedImage = '${post.imageUrl}';
      //       });
      //     },
      //     icon: customIcon,
      //   ),
      // );
    }
    // final filteredPosts =
    //     posts.where((post) => post.category == category).toList();
    // for (var post in filteredPosts) {
    //   BitmapDescriptor customIcon =
    //       BitmapDescriptor.defaultMarker; // Fallback to default marker
    //   try {
    //     final matchingFilter = dataList.firstWhere(
    //       (filter) => filter.nickname == post.category,
    //     );
    //
    //     if (matchingFilter != null) {
    //       customIcon = await getResizedMarker(matchingFilter.image, 100,
    //           100); // Adjust width and height as needed
    //     }
    //   } catch (e) {
    //     debugPrint('Error loading marker icon: $e');
    //   }
    //   newMarkers.add(
    //     Marker(
    //       markerId: MarkerId(post.title),
    //       position: LatLng(post.lat, post.long),
    //       onTap: () {
    //         setState(() {
    //           _selectedMarkerPosition = LatLng(post.lat, post.long);
    //           _selectedAddress = '${post.location}';
    //           _selectedPlace = '${post.title}';
    //           _selectedRating = '${post.rating}';
    //           _selectedReviews = '${post.reviews}';
    //           _selectedDistance = '${post.distance}';
    //           _selectedImage = '${post.imageUrl}';
    //         });
    //       },
    //       icon: customIcon,
    //     ),
    //   );
    // }
    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);

      // if (filteredPosts.isNotEmpty) {
      //   _mapController?.animateCamera(
      //     CameraUpdate.newLatLng(
      //       LatLng(filteredPosts.last.lat, filteredPosts.last.long),
      //     ),
      //   );
      // }
    });
  }

  @override
  void initState() {
    super.initState();
    // GetApi.getNotify(context, '');
    filteredPosts = posts;
    Future.delayed(Duration.zero, () async {
      await getAllCategoriesApi();
      await _getLocation();
      await getLocationByCategories(null);
    });
  }

  Future _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    longitude = position.longitude;
    latitude = position.latitude;
    _initialPosition = LatLng(latitude, longitude);

    setState(() {
      loader = false;
    });

    print('_getLocation | longitude ${longitude}');
    print('_getLocation | latitude ${latitude}');
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
      child: Scaffold(
          backgroundColor: MyColor.white,
          body: SafeArea(
            child: loader ? progressBar() : Stack(
              children: [
                Container(
                    child: currentTab == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: HeaderWidget(
                                  backIcon: false,
                                  onTap: (){
                                    // setState(() {
                                    //   currentTab = 1;
                                    // });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 35),
                                child: MyString.bold('${'explore'.tr}', 24,
                                    MyColor.title, TextAlign.center),
                              ),

                              //!@search-bar
                              // Container(
                              //   height: 50,
                              //   margin: EdgeInsets.only(
                              //       bottom: 25, right: 30, left: 30),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     children: [
                              //       Flexible(
                              //         child: buildSearchBar(),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Suggestions List
                              buildCategoryFilter(),
                              Expanded(
                                child: GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _initialPosition,
                                    zoom: 13.0,
                                  ),
                                  markers: _markers,
                                  onTap: _onMapTap,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                ),
                              ),
                            ],
                          )
                        : currentTab == 2
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: HeaderWidget(
                                      onTap: (){
                                        setState(() {
                                          currentTab = 1;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 35),
                                    child: MyString.bold('${'aroundYou'.tr}',
                                        24, MyColor.title, TextAlign.center),
                                  ),

                                  //!@search-bar
                                  // Container(
                                  //   height: 50,
                                  //   margin: EdgeInsets.only(
                                  //       bottom: 25, right: 30, left: 30),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Flexible(
                                  //         child: buildSearchBar(),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Suggestions List
                                  buildCategoryFilter(),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: MyString.bold(
                                        '${filteredPostsNew.length} Results Found',
                                        18,
                                        MyColor.title,
                                        TextAlign.start),
                                  ),
                                  Expanded(
                                    child:
                                    ListView.builder(
                                      itemCount: filteredPostsNew
                                          .length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final post = filteredPostsNew[
                                            index]; // Use filteredPosts if filtering applied

                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                // Map<String, dynamic> mapData = {
                                                //   'postId': '',
                                                // };
                                                // Navigator.pushNamed(context,
                                                //     RoutesName.postDetail,
                                                //     arguments: mapData);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .white, // Optional: Background color
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: post.profile!.isNotEmpty && post.profile!.contains('http') ?
                                                      Image.network(
                                                        post.profile!, // Ensure this path is valid
                                                        width: 130,
                                                        height: 110,
                                                        fit: BoxFit.cover,
                                                      ) : Image.asset(
                                                        'assets/images/onboard/placeholder_image.png',
                                                        width: 130,
                                                        height: 110,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          MyString.reg(
                                                              '${post.name}',
                                                              14,
                                                              MyColor.red,
                                                              TextAlign.start,
                                                          maxLines: 1),
                                                          const SizedBox(
                                                              height: 4),
                                                          MyString.reg(
                                                              '${post.address}',
                                                              12,
                                                              MyColor
                                                                  .textBlack0,
                                                              TextAlign.start, maxLines: 2),
                                                          MyString.reg(
                                                              '${selectedCategory}',
                                                              12,
                                                              MyColor
                                                                  .textBlack0,
                                                              TextAlign.start),
                                                          // MyString.reg(
                                                          //     post.distance,
                                                          //     12,
                                                          //     MyColor
                                                          //         .textBlack0,
                                                          //     TextAlign.start),
                                                          const SizedBox(
                                                              height: 4),
                                                          if(post.rating != null) Row(
                                                            children: [
                                                              const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 16),
                                                              const SizedBox(
                                                                  width: 4),
                                                              MyString.reg(
                                                                  '${post.rating}',
                                                                  15,
                                                                  MyColor
                                                                      .textBlack0,
                                                                  TextAlign
                                                                      .start),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              color: Color(
                                                  0xffEBEBEB), // Color of the divider
                                              thickness:
                                                  1, // Thickness of the line
                                              indent: 16, // Start padding
                                              endIndent: 16, // End padding
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: HeaderWidget(
                                      onTap: (){
                                        setState(() {
                                          currentTab = 1;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 35),
                                    child: MyString.bold('${'simulateLoc'.tr}',
                                        24, MyColor.title, TextAlign.center),
                                  ),

                                  //!@search-bar
                                  // Container(
                                  //   height: 50,
                                  //   margin: EdgeInsets.only(
                                  //       bottom: 25, right: 30, left: 30),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Flexible(
                                  //         child: buildSearchBar(),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              )),
                if (currentTab == 1 && _selectedMarkerPosition != null)
                  Positioned(
                    bottom: 25,
                    left: 30,
                    right: 30, // Adjust based on your UI layout
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 15, top: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: MyColor.orange2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                _onMapTapDismiss();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    //color: MyColor.card,
                                    borderRadius: BorderRadius.circular(50),
                                    // border:Border.all(color: MyColor.orange2)
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: MyColor.orange2,
                                    size: 20,
                                  )),
                            ),
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: _selectedImage.isNotEmpty && _selectedImage.contains('http') ?
                                Image.network(
                                  '${_selectedImage}', // Ensure this path is valid
                                  width: 130,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ) : Image.asset(
                                  'assets/images/onboard/placeholder_image.png',
                                  width: 130,
                                  height: 110,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width * 0.8,
                                      child: MyString.reg('${_selectedPlace}', 16,
                                          MyColor.red, TextAlign.start,maxLines: 1),
                                    ),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width * 0.6,
                                      child: MyString.reg('${_selectedAddress}', 12,
                                          MyColor.textBlack0, TextAlign.start,maxLines: 2),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        MyString.reg(
                                            '${_selectedRating}',
                                            12,
                                            MyColor.textBlack0,
                                            TextAlign.start),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_selectedMarkerPosition == null && currentTab == 1)
                  Positioned(
                    bottom: 15,
                    left: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentTab = 2;
                        });
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          width: 130,
                          decoration: BoxDecoration(
                              color: MyColor.orange2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(22))),
                          child: MyString.med(
                              'useLoc'.tr, 13, MyColor.white, TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                if (_selectedMarkerPosition == null && currentTab == 1)
                  Positioned(
                    bottom: 15,
                    right: 40,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _selectedMarkerPosition = null;
                          _selectedAddress = null;
                        });
                        _getLocation();
                        // setState(() {
                        //   currentTab = 3;
                        // });
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          width: 135,
                          decoration: BoxDecoration(
                              color: MyColor.orange2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(22))),
                          child:
                          MyString.med(
                              'centerElseWhere'.tr,
                              // 'centerElseWhere'.tr,
                              13,
                              MyColor.white, TextAlign.center)
                          ,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          )),
    );
  }

  Widget buildCategoryFilter() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.135,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: categoriesList.isEmpty ? 1 : categoriesList.length,
        // itemCount: dataList.length,
        itemBuilder: (context, index) {
          if(categoriesList.isEmpty){
            return NoDataFound();
          }
          return GestureDetector(
            onTap: () async {
              if(selectedCategory != categoriesList[index].name!){
                setState(() {
                  selectedCategory = categoriesList[index].name!;
                  _selectedMarkerPosition = null;
                  _selectedAddress = null;
                  _selectedImage = '';
                  _selectedRating = null;
                  filteredPostsNew.clear();
                });
                LoadingDialog.show(context);
                await getLocationByCategories(context);
              }
              // setState(() {
              //
              // });
              // selectedCategory = dataList[index].nickname;
              // _filterPostsAndAddMarkers(selectedCategory);
              // filterPosts(selectedCategory);
            },
            child: Container(
              width: 70,
              child: Column(
                children: [
                  categoriesList[index].icon != null
                      ? Image.network(
                        categoriesList[index].icon!,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error),
                      )
                      : Icon(Icons.category, size: 40),
                  categoriesList[index].name == selectedCategory
                      ? MyString.bold('${categoriesList[index].name}', 10,
                      MyColor.title, TextAlign.center)
                      : MyString.reg('${categoriesList[index].name}', 10,
                      MyColor.title, TextAlign.center),
                  // dataList[index].nickname == selectedCategory
                  //     ? MyString.bold('${dataList[index].name}', 10,
                  //         MyColor.title, TextAlign.center)
                  //     : MyString.reg('${dataList[index].name}', 10,
                  //         MyColor.title, TextAlign.center),
                  if (categoriesList[index].name == selectedCategory)
                  // if (dataList[index].nickname == selectedCategory)
                    Divider(
                      color: Colors.pink, // Color of the divider
                      thickness: 3, // Thickness of the line
                      indent: 5, // Start padding
                      endIndent: 5, // End padding
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      child: SearchingBar(
        onChanged: _updateSuggestions,
        onPlaceSelected: _onPlaceSelected,
      ),
    );
    return SizedBox();
  }

  Future<dynamic> _updateSuggestions(String query) async {
    print('_updateSuggestions => query $query');
    if(selectedCategory.toLowerCase().contains('store')){
      if(query.isNotEmpty) return [];
      return await getLocationByStore();
    }
    else if(selectedCategory.toLowerCase().contains('event')){
      if(query.isNotEmpty) return [];
      return await getLocationByEvent();
    }
    else if (query.isNotEmpty) {
      return await getLocationByNameNew(query);
      // await GoogleMapsService.getPlaceSuggestions(query);
    }
    return [];
  }

  Future<List<OnlineStoreModel>> getLocationByStore() async {
    try {
      final Map<String, dynamic> map = {
        "latitude": latitude,
        "longitude": longitude
      };

      print('getLocationByStore => $map');
      final response = await AllApi.postMethodApi(
          ApiStrings.fetchOnlineStores,
          map
      );
      var result = response is String ? jsonDecode(response) : response;
      if (result['status'] == 201) {
        OnlineStoreResponseModel onlineStoreResponseModel = OnlineStoreResponseModel.fromJson(result);
        return onlineStoreResponseModel.data!;
      } else {
        toaster(context, result['message'].toString());
      }
    } catch (e) {
      debugPrint("Error: {$e");
      toaster(context, "An error occurred while fetching categories.");
    }
    return [];
  }

  Future<List<EventsModel>> getLocationByEvent() async {
    try {
      final Map<String, String> queryParams = {
        'keyword': 'pets',
        'city': 'london',
        'size': '20',
      };

      print('getLocationByEvent => $queryParams');
      final response = await AllApi.getEvents(queryParams);
      var result = response is String ? jsonDecode(response) : response;
      if (result['status'] == 200) {
        EventsResponseModel eventsResponseModel = EventsResponseModel.fromJson(result);
        return eventsResponseModel.data!;
      } else {
        toaster(context, result['message'].toString());
      }
    } catch (e) {
      debugPrint("Error: {$e");
      toaster(context, "An error occurred while fetching categories.");
    }
    return [];
  }

  Future<List<LocationData>> getLocationByNameNew(String query) async {
    try {
      Map<String, dynamic> data = {
        "latitude": latitude,
        "longitude": longitude,
        "query": query,
        "radius": 500
      };

      print('getLocationByName => $data');
      var res = await AllApi.postMethodApi(
          ApiStrings.getLocationByNameAndAddress, data);
      print('========================$res');

      var result = res is String ? jsonDecode(res) : res;

      if (result['status'] == 201) {
        // Parse the response into the GetAllCategories model
        GetLocatioByName location = GetLocatioByName.fromJson(result);
        return location.data!;
        // setState(() {
        //   locationListByName = location.data ?? [];
        // });
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
    return [];
  }

  Future getAllCategoriesApi() async {
    try {
      var res = await AllApi.getMethodApi("${ApiStrings.getAllCategories}");
      print(res);
      var result = jsonDecode(res.toString());

      if (result['status'] == 200) {
        // Parse the response into the GetAllCategories model
        GetAllCategories categories = GetAllCategories.fromJson(result);
        setState(() {
          categoriesList = categories.data ?? [];
          selectedCategory = categoriesList.first.name!;
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

  Future getLocationByCategories(BuildContext? tempContext) async {
    try {
      final data = {
        "latitude": latitude,
        "longitude": longitude,
        "category": selectedCategory,
        "limit": 100,
        "conditions": "dogs.yes"
      };

      var res = await AllApi.postMethodApi("${ApiStrings.location}",data);
      print(res);
      var result = jsonDecode(res.toString());
      final List<Marker> newMarkers = [];

      if (result['status'] == 201) {
        _locationByCategoryResponseModel = LocationByCategoryResponseModel.fromJson(result);
        final locations = _locationByCategoryResponseModel.data;
        if(locations != null && locations.isNotEmpty){
          filteredPostsNew.clear();
          filteredPostsNew.addAll(locations);
          for(int i=0; i < locations.length; i++){
            newMarkers.add(
                Marker(
                  markerId: MarkerId(locations[i].address!),
                  position: LatLng(locations[i].latitude!.toDouble(), locations[i].longitude!.toDouble()),
                  // infoWindow: InfoWindow(
                  //   title: locations[i].name!,
                  //   snippet: '${selectedCategory} • ⭐ ${locations[i].rating} ${locations[i].address!}',
                  // ),
                  onTap: (){
                    _selectedPlace = locations[i].name!;
                    _selectedMarkerPosition = LatLng(locations[i].latitude!.toDouble(), locations[i].longitude!.toDouble());
                    _selectedAddress = locations[i].address!;
                    _selectedImage = locations[i].profile!;
                    _selectedRating = locations[i].rating!.toString();
                    setState(() {

                    });
                  }
                ));
          }
        }
      }
      _markers.clear();
      _markers.addAll(newMarkers);
      if(tempContext != null){
        LoadingDialog.hide(tempContext);
      }
      setState(() {

      });
    } catch (e) {
      debugPrint("Error: $e");
      toaster(context, "An error occurred while fetching categories.");
    }
  }

}

class FilterModel {
  String image;
  String name;
  String nickname;

  FilterModel(this.image, this.name, this.nickname);
}
