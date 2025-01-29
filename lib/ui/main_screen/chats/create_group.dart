import 'dart:convert';

import 'package:avispets/models/chats/all_users_discussion_model.dart';
import 'package:avispets/ui/widgets/base_selection.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/follower_following_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/shared_pref.dart';

class CreateGroup extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const CreateGroup({super.key, this.mapData});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  FollowingFollowerModel _followerModel = FollowingFollowerModel();
  AllUsersDiscussionModel _allUsersDiscussionModel = AllUsersDiscussionModel();

  List<FollowingFollowerBody> followList = [];
  List<UserDiscussion> userDiscussionList = [];
  List<UserDiscussion> userDiscussionListTemp = [];
  List<FollowingFollowerBody> saveList = [];
  List<String> saveList1 = [];

  final Set<UserDiscussion> _selectedIndices = {};

  var searchBar = TextEditingController();

  int page = 1;
  bool loader = true;
  bool stackLoader = false;
  final searchDelay = SearchDelayFunction();

  String userId = '';
  String userName = '';
  String userImage = '';
  int isBlocked = 0;

  @override
  void initState() {
    super.initState();
    // getFollowFollowingApi(page, 1, '');
    getAllUsersForDiscussion();
    // GetApi.getNotify(context, '');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
          backgroundColor: MyColor.white,
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus!.unfocus();
                // _createGroupOld();
                if(_selectedIndices.isEmpty) return;
                var data = await Navigator.pushNamed(
                    context, RoutesName.createGroup2,
                    arguments: {
                      'user': _selectedIndices.toList()
                    }
                );
                if(data == true){
                  Navigator.pop(context, true);
                }
              },
              shape: CircleBorder(),
              backgroundColor: MyColor.orange2,
              child: saveList.length != 1
                  ? Icon(Icons.arrow_forward_outlined, color: MyColor.white)
                  : Image.asset('assets/images/icons/bottom_chat.png',
                      width: 25, height: 25, color: MyColor.white)),
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderWidget(),
                          MyString.bold('creategroup'.tr, 27, MyColor.title,
                              TextAlign.center),
                          Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffEBEBEB)),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(13),
                                      topRight: Radius.circular(50),
                                      bottomLeft: Radius.circular(13),
                                      bottomRight: Radius.circular(50))),
                              child: TextField(
                                controller: searchBar,
                                scrollPadding:
                                    const EdgeInsets.only(bottom: 50),
                                style: TextStyle(
                                    color: MyColor.black, fontSize: 14),
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
                                  suffixIcon: (searchBar.text
                                          .trim()
                                          .toString()
                                          .isNotEmpty)
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              FocusManager
                                                  .instance.primaryFocus!
                                                  .unfocus();
                                              searchBar.text = '';
                                              // stackLoader = false;
                                              getAllUsersForDiscussion();

                                              // getFollowFollowingApi(
                                              //     page, 1, '');
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: MyColor.orange2,
                                          ))
                                      : GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                              width: 40,
                                              height: 40,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff4F2020),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150)),
                                              child: Image.asset(
                                                  'assets/images/icons/filter.png'))),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 12),
                                  hintText: 'search'.tr,
                                  hintStyle: TextStyle(
                                      color: MyColor.textFieldBorder,
                                      fontSize: 14),
                                ),
                                onChanged: (value) {
                                  // setState(() {
                                  //   // page = 1;
                                  //   stackLoader = true;
                                  // });
                                  if (value.isNotEmpty) {
                                    userDiscussionListTemp = userDiscussionList.where((item) => item.name!.toLowerCase().contains(value.toLowerCase())).toList();
                                    // getFollowFollowingApi(page, 1, value);
                                  }
                                  if(value.isEmpty){
                                    userDiscussionListTemp = userDiscussionList;
                                  }
                                  setState(() {

                                  });
                                  // FocusManager.instance.primaryFocus!
                                  //     .unfocus();
                                },
                              )),
                          if (saveList.isNotEmpty)
                            Container(
                              margin:
                                  EdgeInsets.only(top: 3, right: 4, left: 4),
                              height: 100,
                              child: ListView.builder(
                                itemCount: saveList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 50,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50)),
                                                child: saveList[index]
                                                            .followRef!
                                                            .profilePicture !=
                                                        null
                                                    ? Image.network(
                                                        '${ApiStrings.mediaURl}${saveList[index].followRef!.profilePicture.toString()}',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                                child,
                                                                loadingProgress) =>
                                                            (loadingProgress ==
                                                                    null)
                                                                ? child
                                                                : Container(
                                                                    width: 50,
                                                                    child:
                                                                        customProgressBar()))
                                                    : Image.asset(
                                                        'assets/images/onboard/placeholder_image.png',
                                                        width: 50),
                                              ),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    // saveList.remove(index);

                                                    for (int i = 0;
                                                        i < followList.length;
                                                        i++) {
                                                      if (saveList[index]
                                                              .followRef!
                                                              .id ==
                                                          followList[i]
                                                              .followRef!
                                                              .id) {
                                                        saveList1.remove(
                                                            followList[i]
                                                                .id
                                                                .toString());
                                                        followList[i]
                                                                .createGroupSelect =
                                                            false;
                                                      }
                                                    }

                                                    saveList.removeAt(index);

                                                    debugPrint(
                                                        'save list  ${saveList.toString()}');
                                                    debugPrint(
                                                        'save list1 ${saveList1.toString()}');
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/images/icons/del2.png',
                                                  color: MyColor.orange2,
                                                  height: 14,
                                                  width: 17,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          loader
                              ? Container(
                                  child: progressBar(),
                                )
                              :
                          // _buildFollowersUI(),
                          _buildUsersUI(),
                        ],
                      ),
                    ),
                  ),
                  if (stackLoader) progressBar()
                ],
              ),
            ),
          )),
    );
  }

  // getFollowFollowingApi(int loadPage, int type, String searchValues) async {
  //   var res = await AllApi.getMethodApi(
  //       "${ApiStrings.followersFollowing}?page=${loadPage.toString()}&limit=200&search=$searchValues&type=${type.toString()}");
  //   var result = jsonDecode(res.toString());
  //   if (result['status'] == 200) {
  //     loader = false;
  //     stackLoader = false;
  //     followList.clear();
  //     _followerModel = FollowingFollowerModel.fromJson(result);
  //     for (int i = 0; i < _followerModel.data!.length; i++) {
  //       followList.add(_followerModel.data![i]);
  //
  //       if (saveList1.contains(_followerModel.data![i].id.toString())) {
  //         followList[i].createGroupSelect = true;
  //       }
  //     }
  //     setState(() {});
  //   }
  // }

  getAllUsersForDiscussion() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.allUsersDiscussion}");
    print(res);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      loader = false;
      stackLoader = false;
      userDiscussionList.clear();
      userDiscussionListTemp.clear();
      _allUsersDiscussionModel = AllUsersDiscussionModel.fromJson(result);
      userDiscussionList.addAll(_allUsersDiscussionModel.data!);
      userDiscussionListTemp.addAll(_allUsersDiscussionModel.data!);
      setState(() {});
    }
  }

  Widget _buildFollowersUI() {
    return ListView.builder(
      itemCount: followList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Container(
          padding:
          EdgeInsets.symmetric(vertical: 15),
          height: 74,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: MyColor.card,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            visualDensity: const VisualDensity(
                horizontal: 0, vertical: -4),
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(
                  Radius.circular(50)),
              child: followList[index]
                  .followRef!
                  .profilePicture !=
                  null
                  ? Image.network(
                  '${ApiStrings.mediaURl}${followList[index].followRef!.profilePicture.toString()}',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  loadingBuilder: (context,
                      child,
                      loadingProgress) =>
                  (loadingProgress == null)
                      ? child
                      : Container(
                      height: 40,
                      width: 40,
                      child:
                      customProgressBar()))
                  : Image.asset(
                'assets/images/onboard/placeholder_image.png',
                width: 40,
                height: 40,
              ),
            ),
            title: MyString.med(
                followList[index]
                    .followRef!
                    .name
                    .toString(),
                14,
                MyColor.redd,
                TextAlign.start),
            trailing: (followList[index]
                .createGroupSelect)
                ? Image.asset(
              'assets/images/icons/check.png',
            )
                : const SizedBox(),
            onTap: () {
              setState(() {
                debugPrint(
                    'click is ${followList[index].createGroupSelect}');

                followList[index]
                    .createGroupSelect =
                !followList[index]
                    .createGroupSelect;

                if (followList[index]
                    .createGroupSelect) {
                  saveList1.add(followList[index]
                      .id
                      .toString());
                } else {
                  saveList1.remove(followList[index]
                      .id
                      .toString());
                }

                debugPrint(
                    'save list 1 ${saveList1.toString()}');

                if (saveList1.contains(
                    followList[index]
                        .id
                        .toString())) {
                  saveList.add(followList[index]);
                } else {
                  for (var j = 0;
                  j < saveList.length;
                  j++) {
                    if (saveList[j].id.toString() ==
                        followList[index]
                            .id
                            .toString()) {
                      saveList.removeAt(j);
                    }
                  }
                }
                debugPrint(
                    'save list   ${saveList.toString()}');
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildUsersUI() {
    return ListView.builder(
      itemCount: userDiscussionListTemp.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final user = userDiscussionListTemp[index];
        return Container(
          padding:
          EdgeInsets.symmetric(vertical: 15),
          height: 74,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: MyColor.card,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            visualDensity: const VisualDensity(
                horizontal: 0, vertical: -4),
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(
                  Radius.circular(50)),
              child: user.profilePicture !=
                  null && user.profilePicture!.contains('http')
                  ? Image.network(
                  '${user.profilePicture.toString()}',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  loadingBuilder: (context,
                      child,
                      loadingProgress) =>
                  (loadingProgress == null)
                      ? child
                      : Container(
                      height: 40,
                      width: 40,
                      child:
                      customProgressBar()))
                  : Image.asset(
                'assets/images/onboard/placeholder_image.png',
                width: 40,
                height: 40,
              ),
            ),
            title: MyString.med(
                user.name.toString(),
                14,
                MyColor.redd,
                TextAlign.start),
            onTap: () async {
              await Navigator.pushNamed(
                  context,
                  RoutesName.chatScreen,
                arguments: {
                    'user': user
                }
              );
            },
            onLongPress: () {
              setState(() {
                if (_selectedIndices.contains(user)) {
                  _selectedIndices.remove(user); // Deselect if already selected
                } else {
                  _selectedIndices.add(user); // Select item
                }
              });
            },
            trailing: _selectedIndices.contains(user) ? BaseSelection() : null,
          ),
        );
      },
    );
  }

  Future<void> _createGroupOld() async {
    if (saveList.length != 1 && saveList.isNotEmpty) {
      var data = await Navigator.pushNamed(
          context, RoutesName.createGroup2,
          arguments: saveList);
      if (data == true) {
        Navigator.pop(context, true);
      }
    } else if (saveList.length == 1) {
      for (var j = 0; j < saveList.length; j++) {
        userId = saveList[j].followRef!.id.toString();
        userName = saveList[j].followRef!.name.toString();
        userImage = saveList[j].followRef!.profilePicture != null
            ? '${ApiStrings.mediaURl}${saveList[j].followRef!.profilePicture.toString()}'
            : '';
        isBlocked = int.parse(saveList[j].isBlocked.toString());
      }

      Map<String, dynamic> mapData = {
        'userId': userId,
        'userName': userName,
        'userImage': userImage,
        'myId': sharedPref.getString(SharedKey.userId).toString(),
        'myImage': sharedPref
            .getString(SharedKey.userprofilePic)
            .toString()
            .isEmpty
            ? ""
            : sharedPref
            .getString(SharedKey.userprofilePic)
            .toString(),
        'blockBy': '0',
        'isBlock': isBlocked,
        'online': 0,
        'groupId': '0',
        'totalMember': ''
      };

      await Navigator.pushReplacementNamed(
          context, RoutesName.chatScreen,
          arguments: mapData);
    } else {
      toaster(context, 'atLeastOneUser'.tr);
    }
  }
}
