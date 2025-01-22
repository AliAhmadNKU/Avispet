import 'package:avispets/ui/main_screen/map/search_bar.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/common_function/my_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  final Location _location = Location();
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];

  Future<void> _updateSuggestions(String query) async {
    if (query.isNotEmpty) {
      try {
        final suggestions = await GoogleMapsService.getPlaceSuggestions(query);
        setState(() {
          _suggestions = suggestions;
        });
      } catch (e) {
        setState(() {
          _suggestions = [];
        });
      }
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _location.onLocationChanged.listen((LocationData locationData) {
      if (_shouldFollowUserLocation &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(locationData.latitude!, locationData.longitude!),
          ),
        );
      }
    });
  }

  void _onMapTap(LatLng position) async {
    final address = await GoogleMapsService.getAddressFromLatLng(
        position.latitude, position.longitude);
    setState(() {
      _selectedMarkerPosition = position;
      _selectedAddress = address;
    });
  }

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
  void filterPosts(String category) {
    setState(() {
      filteredPosts = posts.where((post) => post.category == category).toList();
    });
  }

  void _filterPostsAndAddMarkers(String category) async {
    _shouldFollowUserLocation = false;
    final List<Marker> newMarkers = [];
    final filteredPosts =
        posts.where((post) => post.category == category).toList();
    for (var post in filteredPosts) {
      BitmapDescriptor customIcon =
          BitmapDescriptor.defaultMarker; // Fallback to default marker
      try {
        final matchingFilter = dataList.firstWhere(
          (filter) => filter.nickname == post.category,
        );

        if (matchingFilter != null) {
          customIcon = await getResizedMarker(matchingFilter.image, 100,
              100); // Adjust width and height as needed
        }
      } catch (e) {
        debugPrint('Error loading marker icon: $e');
      }
      newMarkers.add(
        Marker(
          markerId: MarkerId(post.title),
          position: LatLng(post.lat, post.long),
          onTap: () {
            setState(() {
              _selectedMarkerPosition = LatLng(post.lat, post.long);
              _selectedAddress = '${post.location}';
              _selectedPlace = '${post.title}';
              _selectedRating = '${post.rating}';
              _selectedReviews = '${post.reviews}';
              _selectedDistance = '${post.distance}';
              _selectedImage = '${post.imageUrl}';
            });
          },
          icon: customIcon,
        ),
      );
    }
    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);

      if (filteredPosts.isNotEmpty) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(filteredPosts.last.lat, filteredPosts.last.long),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    GetApi.getNotify(context, '');
    filteredPosts = posts;
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
            child: Stack(
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
                                child: HeaderWidget(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 35),
                                child: MyString.bold('${'explore'.tr}', 24,
                                    MyColor.title, TextAlign.center),
                              ),

                              //!@search-bar
                              Container(
                                height: 50,
                                margin: EdgeInsets.only(
                                    bottom: 25, right: 30, left: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: buildSearchBar(),
                                    ),
                                  ],
                                ),
                              ),
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
                                    child: HeaderWidget(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 35),
                                    child: MyString.bold('${'aroundYou'.tr}',
                                        24, MyColor.title, TextAlign.center),
                                  ),

                                  //!@search-bar
                                  Container(
                                    height: 50,
                                    margin: EdgeInsets.only(
                                        bottom: 25, right: 30, left: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: buildSearchBar(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Suggestions List
                                  buildCategoryFilter(),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: MyString.bold(
                                        '${filteredPosts.length} Results Found',
                                        18,
                                        MyColor.title,
                                        TextAlign.start),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredPosts
                                          .length, // Or filteredPosts.length if filtering applied
                                      itemBuilder: (context, index) {
                                        final post = filteredPosts[
                                            index]; // Use filteredPosts if filtering applied

                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Map<String, dynamic> mapData = {
                                                  'postId': '',
                                                };
                                                Navigator.pushNamed(context,
                                                    RoutesName.postDetail,
                                                    arguments: mapData);
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
                                                      child: Image.asset(
                                                        post.imageUrl, // Ensure this path is valid
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
                                                              post.title,
                                                              14,
                                                              MyColor.red,
                                                              TextAlign.start),
                                                          const SizedBox(
                                                              height: 4),
                                                          MyString.reg(
                                                              post.location,
                                                              12,
                                                              MyColor
                                                                  .textBlack0,
                                                              TextAlign.start),
                                                          MyString.reg(
                                                              post.category,
                                                              12,
                                                              MyColor
                                                                  .textBlack0,
                                                              TextAlign.start),
                                                          MyString.reg(
                                                              post.distance,
                                                              12,
                                                              MyColor
                                                                  .textBlack0,
                                                              TextAlign.start),
                                                          const SizedBox(
                                                              height: 4),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 16),
                                                              const SizedBox(
                                                                  width: 4),
                                                              MyString.reg(
                                                                  '${post.rating} (${post.reviews})',
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
                                    child: HeaderWidget(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 35),
                                    child: MyString.bold('${'simulateLoc'.tr}',
                                        24, MyColor.title, TextAlign.center),
                                  ),

                                  //!@search-bar
                                  Container(
                                    height: 50,
                                    margin: EdgeInsets.only(
                                        bottom: 25, right: 30, left: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: buildSearchBar(),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                child: Image.asset(
                                  '${_selectedImage}', // Ensure this path is valid
                                  width: 130,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyString.reg('${_selectedPlace}', 16,
                                      MyColor.red, TextAlign.start),
                                  MyString.reg('${_selectedDistance}', 12,
                                      MyColor.textBlack0, TextAlign.start),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      MyString.reg(
                                          '${_selectedRating} (${_selectedReviews})',
                                          12,
                                          MyColor.textBlack0,
                                          TextAlign.start),
                                    ],
                                  ),
                                ],
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
                      onTap: () {
                        setState(() {
                          currentTab = 3;
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
                          child: MyString.med('centerElseWhere'.tr, 13,
                              MyColor.white, TextAlign.center),
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
      height: 70,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              selectedCategory = dataList[index].nickname;
              _filterPostsAndAddMarkers(selectedCategory);
              filterPosts(selectedCategory);
            },
            child: Container(
              width: 70,
              child: Column(
                children: [
                  Image.asset(
                    '${dataList[index].image}',
                    height: 30,
                    width: 30,
                  ),
                  dataList[index].nickname == selectedCategory
                      ? MyString.bold('${dataList[index].name}', 10,
                          MyColor.title, TextAlign.center)
                      : MyString.reg('${dataList[index].name}', 10,
                          MyColor.title, TextAlign.center),
                  if (dataList[index].nickname == selectedCategory)
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
        onPlaceSelected: _convertAddressToLatLng,
      ),
    );
  }
}

class FilterModel {
  String image;
  String name;
  String nickname;

  FilterModel(this.image, this.name, this.nickname);
}
