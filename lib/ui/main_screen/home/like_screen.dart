import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/like_user_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class LikeScreen extends StatefulWidget {
  final String feedId;

  const LikeScreen({super.key, required this.feedId});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  var searchBar = TextEditingController();
  int paging = 1;
  final searchDelay = SearchDelayFunction();
  bool loader1 = true;
  bool stackLoader = false;
  LikeUserModel likeUserModel = LikeUserModel();
  List<LikeUserBody> likeUserList = [];

  @override
  void initState() {
    super.initState();
    getLikeUser(paging, '');
  }

  void _loadMoreData(int loaderPage) {
    setState(() {
      getLikeUser(loaderPage, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
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
            'likes'.tr.toUpperCase(), 18, MyColor.white, TextAlign.center),
        backgroundColor: MyColor.orange,
      ),
      body: SafeArea(
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter == 0) {
              if (likeUserList.length > 19) {
                paging++;
                _loadMoreData(paging);
              }
            }
            return false;
          },
          child: Stack(
            children: [
              Container(
                color: MyColor.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, right: 20, left: 20),
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColor.textFieldBorder),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                          suffixIcon: (searchBar.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty)
                              ? GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      stackLoader = true;
                                      searchBar.text = '';
                                      Future.delayed(Duration.zero, () async {
                                        paging = 1;
                                        await getLikeUser(paging,
                                            searchBar.text.trim().toString());
                                        setState(() {});
                                      });
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: MyColor.orange,
                                  ))
                              : Container(width: 10),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                          hintText: 'search'.tr,
                          hintStyle: TextStyle(
                              color: MyColor.textFieldBorder, fontSize: 14),
                        ),
                        onChanged: (value) {
                          setState(() {
                            stackLoader = true;
                            paging = 1;

                            searchDelay.run(() {
                              if (value.isNotEmpty) {
                                getLikeUser(paging, value);
                              }

                              if (value.isEmpty) {
                                getLikeUser(paging, '');
                              }
                              FocusManager.instance.primaryFocus!.unfocus();
                            });
                          });
                        },
                      ),
                    ),
                    loader1
                        ? Expanded(child: progressBar())
                        : Expanded(
                            child: ListView.builder(
                                itemCount: likeUserList.length,
                                padding: EdgeInsets.only(top: 8),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: likeUserList[index]
                                                    .user!
                                                    .profilePicture !=
                                                null
                                            ? Image.network(
                                                '${ApiStrings.mediaURl}${likeUserList[index].user!.profilePicture.toString()}',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                        loadingProgress) =>
                                                    (loadingProgress == null)
                                                        ? child
                                                        : customProgressBar())
                                            : Container(
                                                width: 50,
                                                height: 50,
                                                child: Center(
                                                    child: Image.asset(
                                                        'assets/images/onboard/placeholder_image.png',
                                                        width: 50,
                                                        height: 50))),
                                      ),
                                    ),
                                    title: MyString.bold(
                                        likeUserList[index]
                                            .user!
                                            .name
                                            .toString(),
                                        14,
                                        MyColor.black,
                                        TextAlign.start),
                                    /*    trailing: GestureDetector(
                                  onTap: () {
                                    stackLoader = true;
                                    followApi(likeUserList[index].user!.id.toString());
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: MyColor.yellowLite, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                    child: Container(
                                        margin: const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
                                        child: MyString.boldMultiLine(*/ /*_singlePostModel.data!.hasFollowed == 0 ? "follow".tr : */ /*"unfollow".tr, 14,
                                            MyColor.orange, TextAlign.center,1)),
                                  ),
                                ),
                */

                                    onTap: () {
                                      Map<String, dynamic> mapData = {
                                        'userID': likeUserList[index]
                                            .user!
                                            .id
                                            .toString()
                                      };
                                      Navigator.pushNamed(
                                          context, RoutesName.myProfile,
                                          arguments: mapData);
                                    },
                                  );
                                }),
                          ),
                  ],
                ),
              ),
              if (stackLoader) progressBar()
            ],
          ),
        ),
      ),
    );
  }

  getLikeUser(int paging, String search) {
    Future.delayed(Duration.zero, () async {
      var res = await AllApi.getMethodApi(
          '${ApiStrings.feedLikes}?page=${paging.toString()}&limit=20&search=${search.toString()}&feedId=${widget.feedId.toString()}');
      var result = jsonDecode(res.toString());
      if (result['status'] == 200) {
        setState(() {
          likeUserModel = LikeUserModel.fromJson(result);

          if (paging == 1) {
            likeUserList.clear();
          }

          for (int i = 0; i < likeUserModel.data!.length; i++) {
            likeUserList.add(likeUserModel.data![i]);
          }

          stackLoader = false;
          loader1 = false;
        });
      } else if (result['status'] == 401) {
        sharedPref.clear();
        sharedPref.setString(SharedKey.onboardScreen, 'OFF');
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.loginScreen, (route) => false);
      } else {
        toaster(context, result['message'].toString());
      }
    });
  }

  followApi(String followId) async {
    Map<String, String> mapData = {'followId': followId.toString()};
    var res =
        await AllApi.postMethodApi(ApiStrings.followUnfollowUser, mapData);
    var result = jsonDecode(res.toString());
    debugPrint('FOLLOW UNFOLLOW API RESPONSE_CODE IS ${result['status']}');
    if (result['status'] == 200) {
      paging = 1;
      getLikeUser(paging, '');
    } else {
      toaster(context, result['message'].toString());
    }
    setState(() {});
  }
}
