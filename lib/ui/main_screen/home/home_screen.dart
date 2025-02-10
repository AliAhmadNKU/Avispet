import 'dart:async';
import 'dart:convert';

import 'package:avispets/models/follower_following_model.dart';
import 'package:avispets/models/forum/all_forums_response_model.dart';
import 'package:avispets/models/forum/get_forum.dart';
import 'package:avispets/models/get_all_categories_model.dart';
import 'package:avispets/ui/widgets/no_data_found.dart';

import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/apis/connect_socket.dart';
import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/common_function/search_delay.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/get_all_post_modle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum SampleItem { report, delete }

class _HomeScreenState extends State<HomeScreen> {
  List<Object> places = [];

  bool isLoading = false;
  bool hasMore = true;


  List<Object> dataList = [
    // FilterModel(
    //     'assets/images/markers/Animalerie.png', 'Animalerie'.tr, 'petstore'),
    // FilterModel('assets/images/markers/Bars.png', 'Bars'.tr, 'bar'),
    // FilterModel('assets/images/markers/coffee.png', 'coffee'.tr, 'coffee'),
    // FilterModel('assets/images/markers/Evenement.png', 'Evenement'.tr, 'event'),
    // FilterModel(
    //     'assets/images/markers/Exposition.png', 'Exposition'.tr, 'expo'),
    // FilterModel('assets/images/markers/Hotel.png', 'Hotel'.tr, 'hotel'),
    // FilterModel(
    //     'assets/images/markers/localisation.png', 'localisation'.tr, 'loc'),
    // FilterModel('assets/images/markers/Parks.png', 'Parks'.tr, 'park'),
    // FilterModel(
    //     'assets/images/markers/Restaurants.png', 'Restaurants'.tr, 'resto'),
    // FilterModel(
    //     'assets/images/markers/supermarket.png', 'supermarket'.tr, 'market'),
    // FilterModel(
    //     'assets/images/markers/Toilettage.png', 'Toilettage'.tr, 'toilet'),
    // FilterModel(
    //     'assets/images/markers/Veterinaire.png', 'Veterinaire'.tr, 'vet'),
  ];
  //controllers
  var searchBar = TextEditingController();
  var searchBarBottom = TextEditingController();
  var message = TextEditingController();

  //menuOption
  SampleItem? selectedItem;

  // loaders
  bool pagerLoader = false;
  bool loader = true;
  bool stackLoader = false;

  String dogList = '';
  String catList = '';
  String subCat = '';
  String brandList = '';
  int filterCount = 0;
  List<GetForumBody> forumList = [];
  GetForum getForum = GetForum();

  AllForumsResponseModel _allForumsResponseModel = AllForumsResponseModel();

  //extra
  int page = 1;
  final searchDelay = SearchDelayFunction();

  //horizontal-list
  int horizontalPosition = 0;
  List<String> horizontalList = [
    'allFeeds'.tr,
    'myFeed'.tr,
    'favFeeds'.tr,
    'myFollowers'.tr
  ];

  String feedTitle = 'yourNewsFeed'.tr;

  int pillClick = 0;
  int showFollowerFeed = 0;

  List<String> items = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  List<bool> itemBool = List.generate(5, (index) => false);

  List<String> items1 = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  List<bool> item1Bool = List.generate(5, (index) => false);

  List<String> items2 = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  List<bool> item2Bool = List.generate(5, (index) => false);

  FollowingFollowerModel _followerModel = FollowingFollowerModel();
  List<FollowingFollowerBody> followList = [];
  List<FollowingFollowerBody> selectedFollowList = [];

  final ScrollController _controllerBottom = ScrollController();

  void _scrollDown() {
    _controllerBottom.animateTo(
      _controllerBottom.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  int currentTabBreed = 1;
  bool conditionCheck = false;

  @override
  void initState() {
    super.initState();

    getAllCategoriesApi();
    getAllPostsApi(page);
    getForumApi(page, '', currentTabBreed);
    // GetApi.getNotify(context, '');
  }
  // Image list
  List<String> images = [
    'assets/images/1dog.png',
    'assets/images/2dog.png'
  ];
  List<Postssss> postss = [
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
  List<Item> sortingList = [
    Item(
        title: 'Date added : newest',
        subtitle: 'From newest to oldest',
        conditionCheck: false),
    Item(
        title: 'Date added : oldest',
        subtitle: 'From oldest to newest',
        conditionCheck: false),
    Item(
        title: 'Distance',
        subtitle: 'From nearest to farthest',
        conditionCheck: false),
    Item(
        title: 'Highest rated', subtitle: 'From 5 to 1', conditionCheck: false),
  ];
  List<Data> categoriesList = [];
  List<Post> posts = [];
  List<Post> postsList = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  (notification.metrics.extentAfter == 0 && notification.metrics.axis == Axis.vertical)) {
                print('notification working');
                page++;
                // getAllPostsApi(page);
                // if (hasMore && !isLoading) {
                //
                // }


              }
              return false;
            },
            child: Scaffold(
                backgroundColor: MyColor.white,
                body: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      searchBar.text = '';
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Column(
                          children: [
                            HeaderWidget(backIcon: false,),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Column(
                                children: [
                                  _buildForumsUINEW(),
                                  // _buildForumsUIOLD(),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                        'assets/images/icons/noun_arr_left.png'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                        'assets/images/icons/noun_arr_right.png'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            buildSearchBar(),
                            buildCategoryFilter(),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                        'assets/images/icons/noun_arr_left.png'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                        'assets/images/icons/noun_arr_right.png'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyString.bold('YourNewsFeed'.tr, 14,
                                      MyColor.title, TextAlign.start),
                                  GestureDetector(
                                    onTap: () {
                                      sortingSheet(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                          'assets/images/icons/sort.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                ListView.builder(
                                  itemCount: postsList.length ,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final post = postsList[index];
                                    // if (index == postsList.length) {
                                    //   return Center(
                                    //     child: Padding(
                                    //       padding: EdgeInsets.all(10),
                                    //       child: CircularProgressIndicator(), // Show loading indicator
                                    //     ),
                                    //   );
                                    // }
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.pushNamed(
                                            context, RoutesName.postDetail,
                                            arguments: {
                                              'post': post
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: MyColor.card,
                                            borderRadius:
                                                BorderRadius.circular(22)),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                post.images[
                                                    0], // URL of the image
                                                width: 130,
                                                height: 110,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object error,
                                                        StackTrace?
                                                            stackTrace) {
                                                  // Fallback widget for error
                                                  return Container(
                                                    width: 130,
                                                    height: 110,
                                                    color: Colors.grey[
                                                        300], // Background color for placeholder
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .image_not_supported, // Fallback icon
                                                            color:
                                                                Colors.grey,
                                                            size: 40,
                                                          ),
                                                          Text(
                                                            'Image not found',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize:
                                                                    12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if(post.placeName != null) MyString.reg(
                                                    post.placeName!,
                                                    14,
                                                    MyColor.orange2,
                                                    TextAlign.start),
                                                MyString.reg(
                                                    post.category,
                                                    12,
                                                    MyColor.textBlack0,
                                                    TextAlign.start),
                                                MyString.reg(
                                                    post.websiteName ?? "",
                                                    12,
                                                    MyColor.textBlack0,
                                                    TextAlign.start),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Colors.amber,
                                                        size: 16),
                                                    MyString.reg(
                                                        '${post.overallRating}  ',
                                                        12,
                                                        MyColor.textBlack0,
                                                        TextAlign.start),
                                                  ],
                                                ),
                                                MyString.reg(
                                                    post.openingClosingHour ??
                                                        "",
                                                    8,
                                                    MyColor.textBlack0,
                                                    TextAlign.start),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 200,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))));
  }

  getForumApi(int page, String search, int type) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.forums}?type=$type&page=$page&limit=20&search=$search");
    var result = jsonDecode(res.toString());


    print("dfsdfsdfsdfsdfsd ${result}");

    if (result['status'] == 200) {
      setState(() {
        getForum = GetForum.fromJson(result);
        loader = false;
        stackLoader = false;
        if (page == 1) {
          forumList.clear();
        }
        for (int i = 0; i < getForum.data!.length; i++) {
          forumList.add(getForum.data![i]);
        }
      });
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['message'].toString());
    }
  }

  getForumApiV2(int page, String search, int type) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.forums}?type=$type&page=$page&limit=20&search=$search");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _allForumsResponseModel = AllForumsResponseModel.fromJson(result);
      loader = false;
      stackLoader = false;
    }  else {
      toaster(context, result['message'].toString());
    }
    setState(() {

    });
  }


  // Future<void> getAllPostsApi(int page) async {
  //   // if (isLoading || !hasMore) return; // Prevent duplicate calls
  //
  //   try {
  //     // setState(() {
  //     //   isLoading = true;
  //     // });
  //
  //     // Make the API call
  //     var res = await AllApi.getMethodApi("${ApiStrings.getAllFeed}?page=$page&limit=20");
  //     print('API Response: $res');
  //
  //     var result = jsonDecode(res.toString());
  //
  //     if (result['status'] == 200) {
  //       var posts = GetAllPostModel.fromJson(result);
  //
  //       setState(() {
  //         if (posts.data?.data?.post != null && posts.data!.data!.post!.isNotEmpty) {
  //           postsList.addAll(posts.data!.data!.post!.map((post) => Post.fromJson(post.toJson())));
  //         } else {
  //           // hasMore = false; // No more posts to fetch
  //         }
  //       });
  //
  //       print('Fetched Posts: ${postsList.length}');
  //     } else if (result['status'] == 401) {
  //       Navigator.pushNamedAndRemoveUntil(context, RoutesName.loginScreen, (route) => false);
  //     } else {
  //       toaster(context, result['message'].toString());
  //     }
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //     toaster(context, "An error occurred while fetching posts.");
  //   } finally {
  //     setState(() {
  //       // isLoading = false;
  //     });
  //   }
  // }
  Future<void> getAllPostsApi(int page) async {
    try {
      // Make the API call
      var res = await AllApi.getMethodApi("${ApiStrings.getAllFeed}?page=1&limit=20");
      print('=========================$res');

      // Decode the response
      var result = jsonDecode(res.toString());
      if (result['status'] == 200) {
        // Parse the response into the GetAllPostModel
        var posts = GetAllPostModel.fromJson(result);
        setState(() {
          // Update your local state with the data
          postsList = posts.data!.data!.post!
              .map((post) => Post.fromJson(post.toJson()))
              .toList();
          print('getAllPostsApi => total_post ${postsList.length}');
        });
      } else if (result['status'] == 401) {
        // Handle unauthorized access
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.loginScreen, (route) => false);
      } else {
        // Handle other errors
        toaster(context, result['message'].toString());
      }
    } catch (e) {
      // Handle exceptions
      debugPrint("Error: $e");
      toaster(context, "An error occurred while fetching posts.");
    }
  }

  getAllCategoriesApi() async {
    try {
      var res = await AllApi.getMethodApi("${ApiStrings.getAllCategories}");
      var result = jsonDecode(res.toString());
      // print('getAllCategoriesApi => $result');
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

  Widget buildCategoryFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyString.bold(
                  'Categories'.tr, 14, MyColor.title, TextAlign.start),
              /* GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  child: MyString.med(
                      'Explore'.tr, 12, MyColor.orange2, TextAlign.center),
                ),
              ),*/
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.135,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: categoriesList.isNotEmpty ? categoriesList.length : 1,
            itemBuilder: (context, index) {
              if(categoriesList.isEmpty){
                return NoDataFound();
              }
              return GestureDetector(
                onTap: () {
                  // Handle tap action here
                },
                child: Container(
                  width: 75,
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
                      SizedBox(height: 5),
                      Flexible(
                        child: Text(
                          categoriesList[index].name ?? "Unnamed",
                          style: TextStyle(
                            fontSize: 12,
                            color: MyColor.title,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // deepLinking..
  StreamController<String> controllerUri = StreamController<String>();
  BranchContentMetaData metadata = BranchContentMetaData();
  BranchUniversalObject? buo;
  BranchLinkProperties lp = BranchLinkProperties();
  BranchEvent? eventStandard;
  BranchEvent? eventCustom;
  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();

  void generateLink(BuildContext context, int index) async {
    debugPrint("~~~generateLink~~~~");
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
    if (response.success) {
      if (followList.isNotEmpty) {
        message.clear();
        selectedFollowList.clear();
        shareSheet(
            context, response.result, GetApi.getPost1[index].id.toString());
      } else {
        Share.share(response.result);
      }

      debugPrint("deeplink result ${response.result}");
      debugPrint("deeplink success ${response.success}");
      controllerUri.sink.add('${response.result}');
    } else {
      debugPrint("deeplink success ${response.success}");
      controllerUri.sink
          .add('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

  void initDeepLinkData(int index, String type) {
    debugPrint("share copy link is == ${GetApi.getPost1[index].id.toString()}");

    metadata = BranchContentMetaData()
      ..addCustomMetadata(
          'custom_string',
          (type == "0")
              ? "postPage"
              : (type == "1")
                  ? "adsPage"
                  : (type == "2")
                      ? "servicePage"
                      : "postPage")
      ..addCustomMetadata('page', 'home')
      ..addCustomMetadata('custom_bool', true)
      ..addCustomMetadata('from', 'deepLinking')
      ..addCustomMetadata('userId', GetApi.getPost1[index].user!.id.toString())
      ..addCustomMetadata('feedId', GetApi.getPost1[index].id.toString());

    buo = BranchUniversalObject(
        canonicalIdentifier: 'Avispets',
        canonicalUrl:
            '${ApiStrings.baseURl}${GetApi.getPost1[index].feedImages.toString()}',
        // canonicalUrl: 'https://avispets-app.com/',
        title: 'Avispets',
        imageUrl:
            '${ApiStrings.baseURl}${GetApi.getPost1[index].feedImages.toString()}',
        contentDescription:
            'Hey there! Check out this fantastic post just uploaded on the Avispets App. To view the post, simply click on the following deep link',
        contentMetadata: metadata,
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec: DateTime.now()
            .add(const Duration(days: 365))
            .millisecondsSinceEpoch);

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        campaign: 'campaign',
        tags: ['one', 'two', 'three'])
      ..addControlParam('\$uri_redirect_mode', '1')
      ..addControlParam('\$ios_nativelink', true)
      ..addControlParam('\$match_duration', 7200)
      ..addControlParam('\$always_deeplink', true)
      ..addControlParam('\$android_redirect_timeout', 750)
      ..addControlParam('referring_user_id', 'user_id');

    eventStandard = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART)
      ..transactionID = '12344555'
      ..currency = BranchCurrencyType.BRL
      ..revenue = 1.5
      ..shipping = 10.2
      ..tax = 12.3
      ..coupon = 'test_coupon'
      ..affiliation = 'test_affiliation'
      ..eventDescription = 'Event_description'
      ..searchQuery = 'item 123'
      ..adType = BranchEventAdType.BANNER
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
    eventCustom = BranchEvent.customEvent('Custom_event')
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }

  shareSheet(BuildContext context, result, String postId) async {
    selectedFollowList.clear();
    await getFollowFollowingApi(page, 2, '');
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context1, myState) {
            return SingleChildScrollView(
              controller: _controllerBottom,
              child: Column(
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
                          Stack(
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
                                      'sendTo'.tr.toUpperCase(),
                                      16,
                                      MyColor.black,
                                      TextAlign.center)),
                              Container(
                                  // width: double.infinity,
                                  height: 60,
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40))),
                                  child: InkWell(
                                    onTap: () {
                                      Share.share(result);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: MyColor.newBackgroundColor),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: MyString.bold(
                                            'moreChoices'.tr.toUpperCase(),
                                            12,
                                            MyColor.white,
                                            TextAlign.end)),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                              width: double.infinity,
                              child: MyString.med('sendDes'.tr, 12,
                                  MyColor.black, TextAlign.center)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(40))),
                            child: TextField(
                              controller: searchBarBottom,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style:
                                  TextStyle(color: MyColor.black, fontSize: 14),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'search'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                              onChanged: (value) async {
                                await getFollowFollowingApi(1, 2, value);
                                myState(() {});
                              },
                            ),
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: ListView.builder(
                                  itemCount: followList.length,
                                  padding: EdgeInsets.only(bottom: 25),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4,
                                          left: 4,
                                          bottom: 10,
                                          top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              followList[index]
                                                      .userRef!
                                                      .conditionCheck =
                                                  !followList[index]
                                                      .userRef!
                                                      .conditionCheck;
                                              if (followList[index]
                                                  .userRef!
                                                  .conditionCheck) {
                                                selectedFollowList
                                                    .add(followList[index]);
                                              } else {
                                                for (var i = 0;
                                                    i <
                                                        selectedFollowList
                                                            .length;
                                                    i++) {
                                                  if (followList[index]
                                                          .userRef!
                                                          .id ==
                                                      selectedFollowList[index]
                                                          .userRef!
                                                          .id) {
                                                    selectedFollowList
                                                        .removeAt(i);
                                                  }
                                                }
                                              }
                                              myState(() {});
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50)),
                                                  child: followList[index]
                                                              .userRef!
                                                              .profilePicture !=
                                                          null
                                                      ? Image.network(
                                                          '${ApiStrings.mediaURl}${followList[index].userRef!.profilePicture.toString()}',
                                                          height: 30,
                                                          width: 30,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                                  child,
                                                                  loadingProgress) =>
                                                              (loadingProgress ==
                                                                      null)
                                                                  ? child
                                                                  : Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      child:
                                                                          customProgressBar()))
                                                      : Image.asset(
                                                          'assets/images/onboard/placeholder_image.png',
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .43,
                                                    child:
                                                        MyString.medMultiLine(
                                                            followList[index]
                                                                .userRef!
                                                                .name
                                                                .toString(),
                                                            16,
                                                            MyColor.textBlack2,
                                                            TextAlign.start,
                                                            1)),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: InkWell(
                                              onTap: () {
                                                followList[index]
                                                        .userRef!
                                                        .conditionCheck =
                                                    !followList[index]
                                                        .userRef!
                                                        .conditionCheck;
                                                if (followList[index]
                                                    .userRef!
                                                    .conditionCheck) {
                                                  selectedFollowList
                                                      .add(followList[index]);
                                                } else {
                                                  for (var i = 0;
                                                      i <
                                                          selectedFollowList
                                                              .length;
                                                      i++) {
                                                    if (followList[index]
                                                            .userRef!
                                                            .id ==
                                                        selectedFollowList[
                                                                index]
                                                            .userRef!
                                                            .id) {
                                                      selectedFollowList
                                                          .removeAt(i);
                                                    }
                                                  }
                                                }
                                                myState(() {});
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: followList[index]
                                                            .userRef!
                                                            .conditionCheck
                                                        ? MyColor.orange
                                                        : MyColor.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: followList[index]
                                                        .userRef!
                                                        .conditionCheck
                                                    ? Icon(
                                                        Icons.check,
                                                        color: MyColor.white,
                                                        size: 15,
                                                      )
                                                    : Container(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(40))),
                            child: TextField(
                              controller: message,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style:
                                  TextStyle(color: MyColor.black, fontSize: 14),
                              onTap: () {
                                _scrollDown();
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: '${'message'.tr}',
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              for (var i = 0; i < followList.length; i++) {
                                if (followList[i].userRef!.conditionCheck) {
                                  String id =
                                      followList[i].userRef!.id.toString();
                                  if (selectedFollowList.isNotEmpty) {
                                    sendMessage(
                                        message.text.toString(),
                                        result.toString(),
                                        99,
                                        id.toString(),
                                        postId);
                                  } else {
                                    toaster(context, "");
                                  }
                                }
                              }

                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: MyColor.orange,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50))),
                              child: MyString.med("send".tr.toUpperCase(), 15,
                                  MyColor.white, TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  sendMessage(
      String msg, String media, int type, String otherId, String postId) {
    Map mapping = {
      "senderId": sharedPref.getString(SharedKey.userId).toString(),
      "receiverId": otherId,
      "messageType": type.toString(), //0 :default, 1:image , 2:audio  3:video
      "groupId": "0",
      "message": msg,
      "mediaUrl": media,
      'postId': postId
    };

    print('asdnasdhas  ${mapping}');
    socket.emit('send_message', mapping);
  }

  getFollowFollowingApi(int loadPage, int type, String searchValues) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.followersFollowing}?page=${loadPage.toString()}&limit=1000&search=$searchValues&type=${type.toString()}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      loader = false;
      followList.clear();
      stackLoader = false;
      _followerModel = FollowingFollowerModel.fromJson(result);
      for (int i = 0; i < _followerModel.data!.length; i++) {
        if (selectedFollowList.isNotEmpty) {
          for (int j = 0; j < selectedFollowList.length; j++) {
            if (_followerModel.data![i].userRef!.id ==
                selectedFollowList[j].userRef!.id) {
              _followerModel.data![i].userRef!.conditionCheck = true;
              followList.add(_followerModel.data![i]);
            } else {
              followList.add(_followerModel.data![i]);
            }
          }
        } else {
          followList.add(_followerModel.data![i]);
        }
      }
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  sortingSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColor.orange2),
                  color: MyColor.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(18))),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 5),
                            child: MyString.bold('Sort By'.tr, 18, MyColor.redd,
                                TextAlign.center)),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            child: Image.asset(
                              'assets/images/icons/cl.png',
                              height: 28,
                              width: 28,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: new BoxConstraints(
                        minHeight: 100,
                        maxHeight: MediaQuery.of(context).size.height / 1.5,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: ListView.builder(
                          itemCount: sortingList.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = sortingList[index];
                            return Padding(
                              padding: const EdgeInsets.all(7),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: MyString.reg(item.title, 12,
                                              MyColor.title, TextAlign.start),
                                        ),
                                        SizedBox(height: 5),
                                        MyString.reg(item.subtitle, 12,
                                            Color(0xffBEBEBE), TextAlign.start),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Toggle the conditionCheck value for the tapped item
                                          item.conditionCheck =
                                              !item.conditionCheck;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColor.orange2),
                                          color: MyColor.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: item.conditionCheck
                                              ? MyColor.orange2
                                              : MyColor.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForumsUIOLD() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forumList.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context)
                .size
                .width *
                0.95,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(15),
                  child: Container(
                      padding:
                      EdgeInsets.symmetric(
                          horizontal: 10),
                      width: double.infinity,
                      color: MyColor.white,
                      child: Center(
                          child: Image.asset(
                              width:
                              double.infinity,
                              fit:
                              BoxFit.fitWidth,
                              'assets/images/chi_salon.png'))),
                ),
                Positioned(
                    left: 35,
                    top: 40,
                    child: Container(
                      width: 200,
                      child: Row(
                        children: [
                          Flexible(
                              child: MyString.bold(
                                  '${forumList[index].dogBreed!.name.toString()} Salon',
                                  22,
                                  MyColor.title,
                                  TextAlign
                                      .start)),
                        ],
                      ),
                    )),
                Positioned(
                    left: 35,
                    top: 120,
                    child: Container(
                        padding:
                        EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10),
                        decoration: BoxDecoration(
                            color: MyColor.redd,
                            borderRadius:
                            BorderRadius
                                .circular(
                                15)),
                        child: GestureDetector(
                            onTap: () async {
                              // Map<String, dynamic>
                              //     mapping = {
                              //   'image': getForum
                              //                   .data![
                              //                       index]
                              //                   .dogBreed
                              //                   ?.icon !=
                              //               null &&
                              //           getForum
                              //               .data![
                              //                   index]
                              //               .dogBreed!
                              //               .icon
                              //               .toString()
                              //               .isNotEmpty
                              //       ? '${ApiStrings.mediaURl}${getForum.data![index].dogBreed?.icon.toString()}'
                              //       : '',
                              //   'desc': sharedPref
                              //               .getString(SharedKey
                              //                   .languageValue)
                              //               .toString() ==
                              //           'en'
                              //       ? getForum
                              //           .data![
                              //               index]
                              //           .description
                              //           .toString()
                              //       : getForum
                              //           .data![
                              //               index]
                              //           .descriptionFr
                              //           .toString(),
                              //   'topic': forumList[
                              //           index]
                              //       .dogBreed!
                              //       .name
                              //       .toString(),
                              //   'forumId':
                              //       forumList[
                              //               index]
                              //           .id,
                              // };
                              await Navigator.pushNamed(
                                  context,
                                  RoutesName
                                      .forumQuestion,
                                  arguments: {});
                              setState(() {
                                loader = true;
                                page = 1;
                                getForumApi(
                                    page,
                                    '',
                                    currentTabBreed);
                              });
                            },
                            child: MyString.bold(
                                'Join Now',
                                12,
                                MyColor.white,
                                TextAlign
                                    .start))))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForumsUINEW() {
    final List<String> imageUrls = [
      "assets/images/1dog.png",
      "assets/images/2dog.png",
    ];
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:imageUrls.length, /*_allForumsResponseModel.data != null ? _allForumsResponseModel.data!.length: 0,*/
        itemBuilder: (context, index) {
         // final forum = _allForumsResponseModel.data![index];
          return Container(
            width: MediaQuery.of(context)
                .size
                .width *
                0.95,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(15),
                  child: Container(
                      padding:
                      EdgeInsets.symmetric(
                          horizontal: 10),
                      width: double.infinity,

                      child: Center(
                          child: Image.asset(
                              width:
                              double.infinity,
                              fit:
                              BoxFit.fitWidth,
                              imageUrls[index]))),
                ),
                Positioned(
                    left: 35,
                    top: 40,
                    child: Container(
                      width: 200,
                      child: Row(
                        children: [
                          // Flexible(
                          //     child: MyString.bold(
                          //         '${forum.title.toString()}',
                          //         22,
                          //         MyColor.title,
                          //         TextAlign
                          //             .start)),
                        ],
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25,vertical: 40),
                      padding:
                      EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10),
                      decoration: BoxDecoration(
                          color: MyColor.redd,
                          borderRadius:
                          BorderRadius
                              .circular(
                              15)),
                      child: GestureDetector(
                          onTap: () async {
                            // await Navigator.pushNamed(
                            //     context,
                            //     RoutesName
                            //         .forumQuestion,
                            //     arguments: {});
                            // setState(() {
                            //   loader = true;
                            //   page = 1;
                            //   getForumApi(
                            //       page,
                            //       '',
                            //       currentTabBreed);
                            // });
                          },
                          child: MyString.bold(
                              'Join Now',
                              12,
                              MyColor.white,
                              TextAlign
                                  .start))),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class Item {
  String title;
  String subtitle;
  bool conditionCheck;

  Item({
    required this.title,
    required this.subtitle,
    this.conditionCheck = false,
  });
}

class Postssss {
  final String title;
  final String location;
  final String category;
  final String distance;
  final double lat;
  final double long;
  final double rating;
  final int reviews;
  final double likes;
  final double comments;
  final String timeAgo;
  final String imageUrl;

  Postssss({
    required this.title,
    required this.location,
    required this.category,
    required this.distance,
    required this.lat,
    required this.long,
    required this.rating,
    required this.reviews,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    required this.imageUrl,
  });
}

class PlaceDetailsScreen extends StatelessWidget {
  final Postssss place;

  const PlaceDetailsScreen({required this.place, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                place.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Place details
            Text(
              place.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              '${place.distance} KM away',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 24,
                ),
                Text(
                  '${place.rating.toStringAsFixed(1)} (${place.rating} reviews)',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
