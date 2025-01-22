import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/follower_following_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/connect_socket.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/shared_pref.dart';

class GroupInfo2 extends StatefulWidget {
  final String groupId;
  const GroupInfo2({super.key, required this.groupId});

  @override
  State<GroupInfo2> createState() => _GroupInfo2State();
}

class _GroupInfo2State extends State<GroupInfo2> {
  var searchBar = TextEditingController();
  var groupName = TextEditingController();
  final searchDelay = SearchDelayFunction();
  FollowingFollowerModel _followerModel = FollowingFollowerModel();
  List<FollowingFollowerBody> followList = [];
  List<FollowingFollowerBody> saveList = [];
  List<String> saveList1 = [];
  List<String> newUserid = [];
  String adminId = '0';
  bool loader = true;
  bool stackLoader = false;

  @override
  void initState() {
    super.initState();
    addNewUserListener();
    getFollowFollowingApi(1, 1, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.orange2,
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  width: double.infinity,
                  color: MyColor.orange2,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: MyString.bold('addMembers'.tr, 18,
                              MyColor.white, TextAlign.start)),
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: MyColor.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            controller: searchBar,
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
                              suffixIcon: (searchBar.text
                                      .trim()
                                      .toString()
                                      .isNotEmpty)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          searchBar.text = '';
                                          getFollowFollowingApi(1, 1, '');
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: MyColor.orange2,
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
                                searchDelay.run(() {
                                  if (value.isNotEmpty) {
                                    getFollowFollowingApi(1, 1, value);
                                  }
                                  if (value.isEmpty) {
                                    getFollowFollowingApi(1, 1, '');
                                  }
                                  FocusManager.instance.primaryFocus!.unfocus();
                                });
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: followList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                margin: EdgeInsets.only(top: 10),
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
                                        Radius.circular(20))),
                                child: ListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -2),
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                    child: followList[index]
                                                .followRef!
                                                .profilePicture !=
                                            null
                                        ? Image.network(
                                            '${ApiStrings.mediaURl}${followList[index].followRef!.profilePicture.toString()}',
                                            height: 35,
                                            width: 35,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                    loadingProgress) =>
                                                (loadingProgress == null)
                                                    ? child
                                                    : Container(
                                                        height: 35,
                                                        width: 35,
                                                        child:
                                                            customProgressBar()))
                                        : Image.asset(
                                            'assets/images/onboard/placeholder_image.png',
                                            width: 35,
                                            height: 35,
                                          ),
                                  ),
                                  title: MyString.med(
                                      followList[index]
                                          .followRef!
                                          .name
                                          .toString(),
                                      16,
                                      MyColor.textBlack2,
                                      TextAlign.start),
                                  trailing:
                                      (followList[index].createGroupSelect)
                                          ? Icon(
                                              Icons.check,
                                              color: MyColor.orange2,
                                            )
                                          : const SizedBox(),
                                  onTap: () {
                                    setState(() {
                                      debugPrint(
                                          'click is ${followList[index].createGroupSelect}');
                                      followList[index].createGroupSelect =
                                          !followList[index].createGroupSelect;

                                      if (followList[index].createGroupSelect) {
                                        saveList1.add(
                                            followList[index].id.toString());

                                        newUserid.add(followList[index]
                                            .followRef!
                                            .id
                                            .toString());
                                      } else {
                                        saveList1.remove(
                                            followList[index].id.toString());
                                        newUserid.remove(followList[index]
                                            .followRef!
                                            .id
                                            .toString());
                                      }

                                      debugPrint(
                                          'save list 1 ${saveList1.toString()}');

                                      if (saveList1.contains(
                                          followList[index].id.toString())) {
                                        saveList.add(followList[index]);
                                      } else {
                                        for (var j = 0;
                                            j < saveList.length;
                                            j++) {
                                          if (saveList[j].id.toString() ==
                                              followList[index].id.toString()) {
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
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus!.unfocus();
                            print('NEW_USER_ID  $newUserid');
                            await addNewUser();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 25, bottom: 10, right: 40, left: 40),
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: MyColor.orange2,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 50,
                                ),
                                MyString.med('submit'.tr.toUpperCase(), 15,
                                    MyColor.white, TextAlign.center),
                                Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Image.asset(
                                      "assets/images/onboard/intro_button_icon.png"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (stackLoader) progressBar()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFollowFollowingApi(int loadPage, int type, String searchValues) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.followersFollowing}?page=${loadPage.toString()}&limit=200&search=$searchValues&type=${type.toString()}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      loader = false;
      stackLoader = false;
      followList.clear();
      _followerModel = FollowingFollowerModel.fromJson(result);

      for (int i = 0; i < _followerModel.data!.length; i++) {
        followList.add(_followerModel.data![i]);
        if (saveList1.contains(_followerModel.data![i].id.toString())) {
          followList[i].createGroupSelect = true;
        }
        setState(() {});
      }
    }
  }

  addNewUser() {
    Map mapping = {
      "userId": sharedPref.getString(SharedKey.userId).toString(),
      "members": newUserid.join(','),
      "groupId": widget.groupId.toString(),
    };
    socket.emit('add_member_to_group', mapping);
    debugPrint("add_member_to_group => $mapping");
  }

  addNewUserListener() {
    socket.on('add_member_to_group_listener', (newMessage) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    });
  }
}
