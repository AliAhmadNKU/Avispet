import 'dart:convert';

import 'package:avispets/models/follower_following_model.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class Followers extends StatefulWidget {
  int tab;
  Followers({super.key, required this.tab});

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  int currentTab = 1;
  int page = 1;

  var searchBar = TextEditingController();
  FollowingFollowerModel _followerModel = FollowingFollowerModel();
  List<FollowingFollowerBody> followList = [];
  final searchDelay = SearchDelayFunction();
  bool loader = true;
  bool listLoader = false;
  bool stackLoader = false;

  @override
  void initState() {
    super.initState();
    currentTab = widget.tab;
    getFollowFollowingApi(page, currentTab, '');
  }

  void _loadMoreData(int loaderPage) {
    setState(() {
      getFollowFollowingApi(loaderPage, currentTab, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
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
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: MyColor.orange,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(20, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Image.asset('assets/images/icons/back_icon.png',
                    color: MyColor.white),
              ),
            ),
            title: MyString.bold(
                currentTab == 1
                    ? 'friends'.tr.toUpperCase()
                    : 'followers'.tr.toUpperCase(),
                18,
                MyColor.white,
                TextAlign.center),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  stackLoader = true;
                  page = 1;
                  getFollowFollowingApi(page, currentTab, '');
                });
              },
              child: Stack(
                children: [
                  loader
                      ? Container(
                          child: progressBar(),
                        )
                      : Column(
                          children: [
                            /* Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: MyColor.textFieldBorder), borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            'assets/images/icons/search.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )),
                                    suffixIcon: (searchBar.text.trim().toString().isNotEmpty)
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                FocusManager.instance.primaryFocus!.unfocus();
                                              listLoader = true;
                                              searchBar.text = '';
                                              getFollowFollowingApi(page, currentTab, '');
                                              });
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              color: MyColor.orange,
                                            ))
                                        : Container(width: 10),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                    hintText: 'search'.tr,
                                    hintStyle: TextStyle(color: MyColor.textFieldBorder, fontSize: 14),
                                  ),
                                  onChanged: (value) {
                                    page = 1;
                                    listLoader = true;
                                    searchDelay.run(() {
                                      if (value.isNotEmpty) {
                                        getFollowFollowingApi(page, currentTab, value);
                                      }
                                      if (value.isEmpty) {
                                        getFollowFollowingApi(page, currentTab, '');
                                      }
                                    });
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),*/
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          listLoader = true;
                                          currentTab = 1;
                                          searchBar.text = '';
                                          page = 1;
                                          getFollowFollowingApi(
                                              page, currentTab, '');
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 35,
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              color: currentTab == 2
                                                  ? MyColor.cardColor
                                                  : MyColor.yellowLite),
                                          child: MyString.med(
                                              '${'friends'.tr} (${_followerModel.metadata!.myFollowingsTotal.toString()})',
                                              14,
                                              currentTab == 2
                                                  ? MyColor.textBlack3
                                                  : MyColor.orange,
                                              TextAlign.center),
                                        ),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          listLoader = true;
                                          currentTab = 2;
                                          searchBar.text = '';
                                          page = 1;
                                          getFollowFollowingApi(
                                              page, currentTab, '');
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          height: 35,
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              color: currentTab == 1
                                                  ? MyColor.cardColor
                                                  : MyColor.yellowLite),
                                          child: MyString.med(
                                              '${'followers'.tr} (${_followerModel.metadata!.myFollowersTotal.toString()})',
                                              14,
                                              currentTab == 1
                                                  ? MyColor.textBlack3
                                                  : MyColor.orange,
                                              TextAlign.center),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            if (currentTab == 1)
                              listLoader
                                  ? Expanded(child: progressBar())
                                  : followList.isNotEmpty
                                      ? Expanded(
                                          child: ListView.builder(
                                            itemCount: followList.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        FocusManager.instance
                                                            .primaryFocus!
                                                            .unfocus();
                                                        Map<String, dynamic>
                                                            mapData = {
                                                          'userID':
                                                              followList[index]
                                                                  .followRef!
                                                                  .id
                                                                  .toString()
                                                        };
                                                        Navigator.pushNamed(
                                                            context,
                                                            RoutesName
                                                                .myProfile,
                                                            arguments: mapData);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50)),
                                                            child: followList[
                                                                            index]
                                                                        .followRef!
                                                                        .profilePicture !=
                                                                    null
                                                                ? Image.network(
                                                                    '${ApiStrings.mediaURl}${followList[index].followRef!.profilePicture.toString()}',
                                                                    height: 30,
                                                                    width: 30,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    loadingBuilder: (context, child, loadingProgress) => (loadingProgress ==
                                                                            null)
                                                                        ? child
                                                                        : Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                            child:
                                                                                customProgressBar()))
                                                                : Image.asset(
                                                                    'assets/images/onboard/placeholder_image.png',
                                                                    width: 30,
                                                                    height: 30,
                                                                  ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              MyString.med(
                                                                  followList[
                                                                          index]
                                                                      .followRef!
                                                                      .name
                                                                      .toString(),
                                                                  16,
                                                                  MyColor
                                                                      .textBlack2,
                                                                  TextAlign
                                                                      .center),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        stackLoader = true;
                                                        followApi(
                                                            followList[index]
                                                                .followId
                                                                .toString());
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: MyColor
                                                                .yellowLite,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        10))),
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10,
                                                                    left: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: MyString.bold(
                                                                "unfollow".tr,
                                                                14,
                                                                MyColor.orange,
                                                                TextAlign
                                                                    .center)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/onboard/placeholder_image.png',
                                                width: 120,
                                                height: 90,
                                              ),
                                              Container(
                                                  width: double.infinity,
                                                  child: MyString.bold(
                                                      'noFriends'.tr,
                                                      16,
                                                      MyColor.textFieldBorder,
                                                      TextAlign.center)),
                                            ],
                                          ),
                                        ),
                            if (currentTab == 2)
                              listLoader
                                  ? Expanded(child: progressBar())
                                  : followList.isNotEmpty
                                      ? Expanded(
                                          child: ListView.builder(
                                            itemCount: followList.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        FocusManager.instance
                                                            .primaryFocus!
                                                            .unfocus();
                                                        Map<String, dynamic>
                                                            mapData = {
                                                          'userID':
                                                              followList[index]
                                                                  .userRef!
                                                                  .id
                                                                  .toString()
                                                        };
                                                        Navigator.pushNamed(
                                                            context,
                                                            RoutesName
                                                                .myProfile,
                                                            arguments: mapData);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50)),
                                                            child: followList[
                                                                            index]
                                                                        .userRef!
                                                                        .profilePicture !=
                                                                    null
                                                                ? Image.network(
                                                                    '${ApiStrings.mediaURl}${followList[index].userRef!.profilePicture.toString()}',
                                                                    height: 30,
                                                                    width: 30,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    loadingBuilder: (context, child, loadingProgress) => (loadingProgress ==
                                                                            null)
                                                                        ? child
                                                                        : Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                            child:
                                                                                customProgressBar()))
                                                                : Image.asset(
                                                                    'assets/images/onboard/placeholder_image.png',
                                                                    width: 30,
                                                                    height: 30,
                                                                  ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              MyString.med(
                                                                  followList[
                                                                          index]
                                                                      .userRef!
                                                                      .name
                                                                      .toString(),
                                                                  16,
                                                                  MyColor
                                                                      .textBlack2,
                                                                  TextAlign
                                                                      .center),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        stackLoader = true;
                                                        removeUser(
                                                            followList[index]
                                                                .id
                                                                .toString());
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: MyColor
                                                                .yellowLite,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        10))),
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10,
                                                                    left: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: MyString.bold(
                                                                "remove".tr,
                                                                14,
                                                                MyColor.orange,
                                                                TextAlign
                                                                    .center)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/onboard/placeholder_image.png',
                                                width: 120,
                                                height: 90,
                                              ),
                                              Container(
                                                  width: double.infinity,
                                                  child: MyString.bold(
                                                      'noFollower'.tr,
                                                      16,
                                                      MyColor.textFieldBorder,
                                                      TextAlign.center)),
                                            ],
                                          ),
                                        ),
                          ],
                        ),
                  if (stackLoader) progressBar()
                ],
              ),
            ),
          )),
    );
  }

  Future<bool> getFollowFollowingApi(
      int loadPage, int type, String searchValues) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.followersFollowing}?page=${loadPage.toString()}&limit=20&search=$searchValues&type=${type.toString()}");
    debugPrint(
        "${ApiStrings.followersFollowing}?page=${loadPage.toString()}&limit=20&type=${type.toString()}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      loader = false;
      listLoader = false;
      stackLoader = false;
      if (loadPage == 1) {
        followList.clear();
      }
      _followerModel = FollowingFollowerModel.fromJson(result);
      for (int i = 0; i < _followerModel.data!.length; i++) {
        followList.add(_followerModel.data![i]);
      }
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  followApi(String followId) async {
    Map<String, String> mapData = {'followId': followId.toString()};
    var res =
        await AllApi.postMethodApi(ApiStrings.followUnfollowUser, mapData);
    var result = jsonDecode(res.toString());
    debugPrint('FOLLOW UNFOLLOW API RESPONSE_CODE IS ${result['status']}');
    loader = false;
    if (result['status'] == 200) {
      page = 1;
      getFollowFollowingApi(page, currentTab, '');
    } else {
      toaster(context, result['message'].toString());
    }
    setState(() {});
  }

  removeUser(String userId) async {
    var res = await AllApi.deleteMethodApiQuery(
        "${ApiStrings.removeFollowing}?id=$userId");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      page = 1;
      getFollowFollowingApi(page, currentTab, '');
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['message'].toString());
    }
    setState(() {});
  }
}
