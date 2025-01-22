import 'dart:async';
import 'dart:convert';

import 'package:avispets/models/my_animal_model.dart';
import 'package:avispets/ui/main_screen/home/comment_dialog.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../bloc/bloc_events.dart';
import '../../../bloc/bloc_states.dart';
import '../../../bloc/follow_bloc.dart';
import '../../../bloc/like_bookmark_bloc.dart';
import '../../../models/follower_following_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/connect_socket.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/shared_pref.dart';
import '../home/home_screen.dart';

class MyProfile extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const MyProfile({super.key, this.mapData});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

enum SampleItem { report, delete }

class _MyProfileState extends State<MyProfile> {
  late LikeBookmarkBloc _likeBookmarkBloc;
  late FollowUnfollowBloc _followUnfollowBloc;

  SampleItem? selectedItem;
  int currentTab = 1;
  int page = 1;

  bool pagerLoader = false;
  bool loader = true;
  bool profileLoader = true;
  bool stackLoader = false;
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

  var searchBarBottom = TextEditingController();
  var message = TextEditingController();
  FollowingFollowerModel _followerModel = FollowingFollowerModel();
  List<FollowingFollowerBody> followList = [];
  List<FollowingFollowerBody> selectedFollowList = [];

  @override
  void initState() {
    super.initState();
    GetApi.getNotify(context, '');
    _likeBookmarkBloc = LikeBookmarkBloc(context);
    _followUnfollowBloc = FollowUnfollowBloc(context);
    Future.delayed(Duration.zero, () async {
      await GetApi.getProfileApi(context, widget.mapData!['userID'].toString());
      await GetApi.getMyAnimalId(
          context, page, widget.mapData!['userID'].toString());
      await GetApi.getAllPost(context, currentTab, page, '', 0, 0, 0, '', '',
          '', widget.mapData!['userID'].toString());
      await getFollowFollowingApi(page, 2, '');
      setState(() {
        loader = false;
        profileLoader = false;
        stackLoader = false;
      });
    });
  }

  _loadMoreData(int loaderPage) async {
    if (GetApi.getPost.length >= 20) {
      await GetApi.getAllPost(context, currentTab, loaderPage, '', 0, 0, 0, '',
          '', '', widget.mapData!['userID'].toString());
    }
    setState(() {});
  }

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
  List<sortingItem> sortingList = [
    sortingItem(
        title: 'Date added : newest',
        subtitle: 'From newest to oldest',
        conditionCheck: false),
    sortingItem(
        title: 'Date added : oldest',
        subtitle: 'From oldest to newest',
        conditionCheck: false),
    sortingItem(
        title: 'Distance',
        subtitle: 'From nearest to farthest',
        conditionCheck: false),
    sortingItem(
        title: 'Highest rated', subtitle: 'From 5 to 1', conditionCheck: false),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (widget.mapData!['from'].toString() == 'notification') {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.mainPage, arguments: 0, (route) => false);
        } else {
          Navigator.pop(context);
        }
      },
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => _likeBookmarkBloc),
            BlocProvider(create: (context) => _followUnfollowBloc),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<LikeBookmarkBloc, BlocStates>(
                listener: (context, state) async {
                  if (state is Loading) {
                    LoadingDialog.show(context);
                  }
                  if (state is Loaded) {
                    page = 1;
                    await GetApi.getAllPost(context, currentTab, page, '', 0, 0,
                        0, '', '', '', widget.mapData!['userID'].toString());
                    LoadingDialog.hide(context);
                    setState(() {});
                  }
                },
              ),
              BlocListener<FollowUnfollowBloc, BlocStates>(
                listener: (context, state) {
                  if (state is Loading) {
                    LoadingDialog.show(context);
                  }
                  if (state is Loaded) {
                    GetApi.getProfileModel.data!.counts?.followingCount =
                        GetApi.getProfileModel.data!.counts?.followingCount == 0
                            ? 1
                            : 0;
                    LoadingDialog.hide(context);
                    setState(() {});
                  }
                },
              ),
            ],
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  page++;
                  _loadMoreData(page);
                }
                return false;
              },
              child: Scaffold(
                backgroundColor: MyColor.white,
                body: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderWidget(),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (!profileLoader)
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: GetApi.getProfileModel.data!
                                                          .profilePicture !=
                                                      null &&
                                                  GetApi.getProfileModel.data!
                                                      .profilePicture
                                                      .toString()
                                                      .isNotEmpty
                                              ? Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                        '${ApiStrings.mediaURl}${GetApi.getProfileModel.data!.profilePicture.toString()}',
                                                        fit: BoxFit.cover,
                                                        width: 50,
                                                        height: 50,
                                                        loadingBuilder: (context,
                                                                child,
                                                                loadingProgress) =>
                                                            (loadingProgress ==
                                                                    null)
                                                                ? child
                                                                : customProgressBar()),
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/images/onboard/placeholder_image.png',
                                                  width: 50,
                                                  height: 50),
                                        ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          MyString.bold(
                                              '${GetApi.getProfileModel.data!.name}',
                                              14,
                                              MyColor.title,
                                              TextAlign.start),
                                          // MyString.reg(
                                          //     '${(sharedPref.getString(SharedKey.languageValue).toString() == 'en') ? GetApi.getProfileModel.data!.userLevel!.name.toString() : GetApi.getProfileModel.data!.userLevel!.nameFr.toString()}',
                                          //     15,
                                          //     MyColor.orange2,
                                          // TextAlign.start)
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: (!profileLoader &&
                                            GetApi.getAnimalOther.isNotEmpty)
                                        ? SizedBox(
                                            height: 45,
                                            child: ListView.builder(
                                                itemCount: GetApi
                                                    .getAnimalOther.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              _animalInfo(GetApi
                                                                      .getAnimalOther[
                                                                  index]));
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10,
                                                          top: 5,
                                                          bottom: 5),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color:
                                                                MyColor.orange2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 10),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                ),
                                                                child: ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50),
                                                                    child: Image.network(
                                                                        '${ApiStrings.mediaURl}${GetApi.getAnimalOther[index].images.toString()}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        loadingBuilder: (context, child, loadingProgress) => (loadingProgress ==
                                                                                null)
                                                                            ? child
                                                                            : customProgressBar())),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              MyString.regMultiLine(
                                                                  GetApi
                                                                      .getAnimalOther[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                                  12,
                                                                  MyColor.black,
                                                                  TextAlign
                                                                      .center,
                                                                  2),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          )
                                        : SizedBox(
                                            height: 45,
                                          ),
                                  )
                                ],
                              ),
                            ),
                            // if (!profileLoader &&
                            //     GetApi.getProfileModel.data!.biography
                            //             .toString() !=
                            //         "null")
                            // GestureDetector(
                            //   onTap: () {
                            //     showDialog(
                            //         context: context,
                            //         builder: (context) => CommentDialog(
                            //             comment: GetApi
                            //                 .getProfileModel.data!.biography
                            //                 .toString()));
                            //   },
                            //   child: MyString.boldMultiLine(
                            //       (GetApi.getProfileModel.data!.biography
                            //                   .toString() ==
                            //               "null")
                            //           ? ""
                            //           : GetApi.getProfileModel.data!.biography
                            //               .toString(),
                            //       12,
                            //       Color(0xff6B7483),
                            //       TextAlign.start,
                            //       2),
                            // ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: MyColor.card,
                                border: Border.all(color: MyColor.stroke),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      MyString.reg(
                                        '${posts.length}',
                                        15,
                                        MyColor.orange2,
                                        TextAlign.start,
                                      ),
                                      MyString.bold(
                                        'Places',
                                        12,
                                        const Color(0xff707070),
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      MyString.reg(
                                        '${_followerModel?.metadata?.myFollowingsTotal?.toString() ?? "0"}',
                                        15,
                                        MyColor.orange2,
                                        TextAlign.start,
                                      ),
                                      MyString.bold(
                                        'Following',
                                        12,
                                        const Color(0xff707070),
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      MyString.reg(
                                        '${_followerModel?.metadata?.myFollowersTotal?.toString() ?? "0"}',
                                        15,
                                        MyColor.orange2,
                                        TextAlign.start,
                                      ),
                                      MyString.bold(
                                        '${'followers'.tr}${(_followerModel?.metadata?.myFollowersTotal ?? 0) > 1 ? "s" : ""}',
                                        12,
                                        const Color(0xff707070),
                                        TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: (!profileLoader)
                                      ? (sharedPref
                                                  .getString(SharedKey.userId)
                                                  .toString() !=
                                              GetApi.getProfileModel.data!.id
                                                  .toString())
                                          ? GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  _followUnfollowBloc.add(
                                                      GetFollowUnfollowEvent(
                                                          GetApi.getProfileModel
                                                              .data!.id
                                                              .toString()));
                                                });
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: GetApi
                                                                .getProfileModel
                                                                .data!
                                                                .counts
                                                                ?.followingCount ==
                                                            0
                                                        ? MyColor.orange2
                                                        : MyColor.white,
                                                    border: Border.all(
                                                        color: MyColor.orange2),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10,
                                                            left: 10,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: MyString.reg(
                                                        GetApi
                                                                    .getProfileModel
                                                                    .data!
                                                                    .counts
                                                                    ?.followingCount ==
                                                                0
                                                            ? "follow".tr
                                                            : "unfollow".tr,
                                                        12,
                                                        GetApi
                                                                    .getProfileModel
                                                                    .data!
                                                                    .counts
                                                                    ?.followingCount ==
                                                                0
                                                            ? MyColor.white
                                                            : MyColor.orange2,
                                                        TextAlign.center)),
                                              ),
                                            )
                                          : SizedBox()
                                      : SizedBox(),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: MyColor.stroke),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: GetApi.getProfileModel.data!.counts
                                                  ?.followingCount ==
                                              0
                                          ? Icon(
                                              Icons.notifications_none,
                                              color: MyColor.orange2,
                                            )
                                          : Icon(
                                              Icons.notifications_active,
                                              color: MyColor.orange2,
                                            ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Map<String, dynamic> mapData = {
                                          'userId': GetApi
                                              .getProfileModel.data!.id
                                              .toString(),
                                          'userName': GetApi
                                              .getProfileModel.data!.name
                                              .toString(),
                                          'userImage': GetApi.getProfileModel
                                                      .data!.profilePicture !=
                                                  null
                                              ? '${ApiStrings.mediaURl}${GetApi.getProfileModel.data!.profilePicture.toString()}'
                                              : "",
                                          'myId': sharedPref
                                              .getString(SharedKey.userId),
                                          'myImage': sharedPref
                                                  .getString(
                                                      SharedKey.userprofilePic)
                                                  .toString()
                                                  .endsWith('null')
                                              ? ""
                                              : sharedPref
                                                  .getString(
                                                      SharedKey.userprofilePic)
                                                  .toString(),
                                          'blockBy': '0',
                                          'isBlock': 0,
                                          'online': 0,
                                          'groupId': "0",
                                        };
                                        await Navigator.pushNamed(
                                            context, RoutesName.chatScreen,
                                            arguments: mapData);
                                      },
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MyColor.stroke),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Image.asset(
                                            'assets/images/icons/bottom_chat.png'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: 34,
                                      height: 34,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: MyColor.stroke),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Image.asset(
                                          'assets/images/icons/share.png'),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyString.bold('Places', 27, MyColor.title,
                                      TextAlign.start),
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
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  crossAxisSpacing:
                                      10, // Horizontal spacing between items
                                  mainAxisSpacing:
                                      2, // Vertical spacing between items
                                  childAspectRatio:
                                      0.70, // Aspect ratio for each grid item
                                ),
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Map<String, dynamic> mapData = {
                                            'postId': '',
                                          };
                                          Navigator.pushNamed(
                                              context, RoutesName.postDetail,
                                              arguments: mapData);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    MyString.reg(
                                                      '${post.title}',
                                                      12,
                                                      MyColor.orange2,
                                                      TextAlign.start,
                                                    ),
                                                    MyString.reg(
                                                      '${post.location}',
                                                      12,
                                                      MyColor.textBlack0,
                                                      TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.asset(
                                                    post.imageUrl,
                                                    width: double.infinity,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: Image.asset(
                                                              'assets/images/icons/heart_empty.png'),
                                                        ),
                                                        Flexible(
                                                          child: MyString.reg(
                                                            '${post.likes.toString()}',
                                                            12,
                                                            MyColor.textBlack0,
                                                            TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: Image.asset(
                                                            'assets/images/icons/bottom_chat.png',
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: MyString.reg(
                                                            '${post.comments.toString()}',
                                                            12,
                                                            MyColor.textBlack0,
                                                            TextAlign.start,
                                                          ),
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
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        if (stackLoader) progressBar()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  _animalInfo(MyAnimalModelBody animalOther) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadiusDirectional.circular(40)),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/logos/info.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                          color: MyColor.newBackgroundColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MyString.bold(
                            "Info", 20, MyColor.black, TextAlign.center),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyString.bold('nameAnimal'.tr, 14, MyColor.black,
                            TextAlign.start),
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(top: 3, bottom: 8),
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 8),
                              child: MyString.med('${animalOther.name}', 16,
                                  MyColor.black, TextAlign.start)),
                        ),
                        MyString.bold(
                            'species'.tr, 14, MyColor.black, TextAlign.start),
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(top: 3, bottom: 8),
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 8),
                              child: MyString.med(
                                  animalOther.type!.toLowerCase().tr,
                                  16,
                                  MyColor.black,
                                  TextAlign.start)),
                        ),
                        MyString.bold('${'breed'.tr}*', 14, MyColor.black,
                            TextAlign.start),
                        Container(
                          margin: EdgeInsets.only(top: 3, bottom: 8),
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 8),
                              child: MyString.med(animalOther.breed.toString(),
                                  16, MyColor.black, TextAlign.start)),
                        ),
                        MyString.bold(
                            'dob'.tr, 14, MyColor.black, TextAlign.start),
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(top: 3, bottom: 8),
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 8),
                              child: MyString.med(
                                  formatDateTimeShow(
                                              animalOther.dob.toString()) ==
                                          '01/01/1958'
                                      ? 'N/A'
                                      : formatDateTimeShow(
                                          animalOther.dob.toString()),
                                  16,
                                  MyColor.black,
                                  TextAlign.start)),
                        ),
                        MyString.bold(
                            'gender'.tr, 14, MyColor.black, TextAlign.start),
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(top: 3, bottom: 8),
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 8),
                              child: MyString.med(
                                  animalOther.gender
                                      .toString()
                                      .toLowerCase()
                                      .tr,
                                  16,
                                  MyColor.black,
                                  TextAlign.start)),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 30),
                                    decoration: BoxDecoration(
                                        color: MyColor.newBackgroundColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: MyString.med(
                                        'close'.tr.toUpperCase(),
                                        12,
                                        MyColor.white,
                                        TextAlign.center),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          );
        },
      ),
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

  void generateLink(BuildContext context) async {
    debugPrint("~~~generateLink~~~~");
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
    if (response.success) {
      if (followList.isNotEmpty) {
        message.clear();
        selectedFollowList.clear();
        shareSheet(context, response.result);
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
    debugPrint("share copy link is == ${GetApi.getPost[index].id.toString()}");

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
      ..addCustomMetadata('userId', GetApi.getPost[index].user!.id.toString())
      ..addCustomMetadata('feedId', GetApi.getPost[index].id.toString());

    buo = BranchUniversalObject(
        canonicalIdentifier: 'Avispets',
        canonicalUrl:
            '${ApiStrings.baseURl}${GetApi.getPost[index].feedImages.toString()}',
        // canonicalUrl: 'https://avispets-app.com/',
        title: 'Avispets',
        imageUrl:
            '${ApiStrings.baseURl}${GetApi.getPost[index].feedImages.toString()}',
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

  List<Widget> _buildPageIndicator(int length, int currentPage) {
    List<Widget> indicators = [];
    for (int i = 0; i < length; i++) {
      indicators.add(
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == i ? MyColor.newBackgroundColor : Colors.grey,
          ),
        ),
      );
    }
    return indicators;
  }

  shareSheet(BuildContext context, result) async {
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
                              InkWell(
                                onTap: () {
                                  Share.share(result);
                                },
                                child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            topRight: Radius.circular(40))),
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
                                            TextAlign.end))),
                              ),
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
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.40,
                              child: ListView.builder(
                                  itemCount: followList.length,
                                  padding: EdgeInsets.zero,
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
                                  String mess = '';
                                  if (message.text.isNotEmpty) {
                                    mess = result.toString() +
                                        "\n" +
                                        message.text.toString();
                                  } else {
                                    mess = result.toString();
                                  }
                                  if (selectedFollowList.isNotEmpty) {
                                    sendMessage(mess, '', 0, id.toString());
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

  sendMessage(String msg, String media, int type, String otherId) {
    Map mapping = {
      "senderId": sharedPref.getString(SharedKey.userId).toString(),
      "receiverId": otherId,
      "messageType": type.toString(), //0 :default, 1:image , 2:audio  3:video
      "groupId": "0",
      "message": msg,
      "mediaUrl": media
    };
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
}

class sortingItem {
  String title;
  String subtitle;
  bool conditionCheck;

  sortingItem({
    required this.title,
    required this.subtitle,
    this.conditionCheck = false,
  });
}
