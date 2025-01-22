import 'dart:convert';
import 'dart:io';

import 'package:avispets/models/follower_following_model.dart';
import 'package:avispets/ui/main_screen/chats/group_info2.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/chats/group_info.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/connect_socket.dart';
import '../../../utils/common_function/crop_image.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class GroupInfoScreen extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  GroupInfoScreen({
    super.key,
    this.mapData,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

enum SampleItem { editGroupName }

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  GroupInfo groupInfoMember = GroupInfo();
  List<GroupInfoMember> groupInfoList = [];
  int userLen = 0;
  bool loader = true;

  var searchBar = TextEditingController();
  var groupName = TextEditingController();
  final searchDelay = SearchDelayFunction();

  FollowingFollowerModel _followerModel = FollowingFollowerModel();
  List<FollowingFollowerBody> followList = [];
  List<FollowingFollowerBody> saveList = [];
  List<String> saveList1 = [];
  List<String> newUserid = [];
  String adminId = '0';
  String? imageSave;
  File? fileImage;
  SampleItem? selectedItem;

  @override
  void initState() {
    super.initState();

    checkSocketConnect();
    getFollowFollowingApi(1, 1, '');
    groupInfoSocket();
    groupInfoSocketListener();
    editGroupListener();

    leaveUserListener();
    leaveUserListener1();
  }

  @override
  void dispose() {
    super.dispose();
    socketOff('group_info');
    socketOff('edit_group');
    socketOff('add_member_to_group_listener');
    socketOff('youAreRemoved');
    socketOff('leave_group_member');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }

          Map<String, String> mapping = {
            'userImage': fileImage != null
                ? '${ApiStrings.mediaURl}${imageSave.toString()}'
                : (groupInfoMember.groupIcon != null &&
                        groupInfoMember.groupIcon.toString().isNotEmpty)
                    ? "${ApiStrings.mediaURl}${groupInfoMember.groupIcon.toString()}"
                    : "",
            'userName': groupName.text.trim().toString(),
            'totalMember': userLen.toString(),
          };

          Navigator.pop(context, mapping);
        },
        child: Scaffold(
          backgroundColor: MyColor.orange2,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
            backgroundColor: MyColor.orange2,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Map<String, String> mapping = {
                      'userImage': fileImage != null
                          ? '${ApiStrings.mediaURl}${imageSave.toString()}'
                          : (groupInfoMember.groupIcon != null &&
                                  groupInfoMember.groupIcon
                                      .toString()
                                      .isNotEmpty)
                              ? "${ApiStrings.mediaURl}${groupInfoMember.groupIcon.toString()}"
                              : "",
                      'userName': groupName.text.trim().toString(),
                      'totalMember': userLen.toString(),
                    };
                    Navigator.pop(context, mapping);
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(20, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Image.asset('assets/images/icons/back_icon.png',
                      height: 40, width: 40, color: MyColor.white),
                ),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * .6,
                    child: MyString.bold('groupInfo'.tr.toUpperCase(), 18,
                        MyColor.white, TextAlign.start)),
                (sharedPref.getString(SharedKey.userId).toString() == adminId)
                    ? PopupMenuButton<SampleItem>(
                        color: MyColor.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        icon: Icon(
                          Icons.more_vert, // Change the icon here
                          color: MyColor.white, // Change the color here
                        ),
                        initialValue: selectedItem,
                        onSelected: (SampleItem item) {
                          setState(() {
                            FocusManager.instance.primaryFocus!.unfocus();
                            selectedItem = item;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<SampleItem>>[
                          PopupMenuItem<SampleItem>(
                            onTap: () async {
                              FocusManager.instance.primaryFocus!.unfocus();
                              var res = await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) {
                                    return delete();
                                  });

                              if (res) {
                                groupInfoSocket();
                              }
                            },
                            value: null,
                            child: MyString.reg('changeGroupName'.tr, 14,
                                MyColor.black, TextAlign.center),
                          ),
                        ],
                      )
                    : SizedBox(width: 40),
              ],
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: MyColor.grey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: loader
                  ? progressBar()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: () async {
                              if (sharedPref
                                      .getString(SharedKey.userId)
                                      .toString() ==
                                  adminId) {
                                String? result =
                                    await cameraPhoto(context, "editGroup");
                                var returnImage;
                                if (result == '0') {
                                  returnImage = await pickImage(
                                      context, ImageSource.camera);
                                } else if (result == '1') {
                                  returnImage = await pickImage(
                                      context, ImageSource.gallery);
                                }
                                if (returnImage != null) {
                                  fileImage = returnImage;

                                  LoadingDialog.show(context);
                                  var res = await AllApi.onlyImage(
                                      fileImage!.path.toString());
                                  var result = jsonDecode(res);
                                  LoadingDialog.hide(context);
                                  debugPrint('UPLOAD_IMAGE RESULT $result');
                                  if (result['status'] == 200) {
                                    print(
                                        'RESULT-1 ${result["data"].toString()}');

                                    imageSave = result["data"].toString();
                                    editGroupSocket();
                                  }
                                  setState(() {});
                                }
                              }
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  child: fileImage != null
                                      ? Image.file(fileImage!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover)
                                      : groupInfoMember.groupIcon
                                              .toString()
                                              .isNotEmpty
                                          ? Image.network(
                                              "${ApiStrings.mediaURl}${groupInfoMember.groupIcon.toString()}",
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                      loadingProgress) =>
                                                  (loadingProgress == null)
                                                      ? child
                                                      : Container(
                                                          height: 100,
                                                          width: 100,
                                                          child:
                                                              customProgressBar()))
                                          : Container(
                                              width: 100,
                                              height: 100,
                                              color: MyColor.cardColor,
                                              child: Center(
                                                  child: Image.asset(
                                                      'assets/images/onboard/placeholder_image.png',
                                                      width: 35,
                                                      height: 35))),
                                ),
                                if (sharedPref
                                        .getString(SharedKey.userId)
                                        .toString() ==
                                    adminId)
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        color: MyColor.cardColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Icon(
                                      Icons.edit,
                                      color: MyColor.textFieldBorder,
                                      size: 15,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * .5,
                              child: MyString.bold(groupName.text.toString(),
                                  18, MyColor.black, TextAlign.center)),
                          MyString.med(
                              '${'group'.tr}: ${userLen.toString()} ${'members'.tr}',
                              12,
                              MyColor.textFieldBorder,
                              TextAlign.start),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
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
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 100),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                'assets/images/icons/search.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            )),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                        hintText: 'search'.tr,
                                        hintStyle: TextStyle(
                                            color: MyColor.textFieldBorder,
                                            fontSize: 14),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          onSearchTextChanged(value
                                              .trim()
                                              .toString()
                                              .toLowerCase());
                                        });
                                      },
                                    ),
                                  ),
                                  if (sharedPref
                                          .getString(SharedKey.userId)
                                          .toString() ==
                                      adminId)
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: ListTile(
                                        tileColor: MyColor.cardColor,
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: const VisualDensity(
                                            horizontal: 0, vertical: -3),
                                        leading: Container(
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: MyColor.yellowLite,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          height: 40,
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50)),
                                              child: Center(
                                                  child: Image.asset(
                                                      'assets/images/onboard/add_user.png',
                                                      width: 20,
                                                      height: 20))),
                                        ),
                                        title: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: MyString.med(
                                                'addMembers'.tr,
                                                14,
                                                MyColor.textBlack2,
                                                TextAlign.start)),
                                        onTap: () async {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          var res = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GroupInfo2(
                                                          groupId: widget
                                                              .mapData![
                                                                  'groupId']
                                                              .toString())));
                                          ;
                                          print('RESULT-2 $res');

                                          setState(() {
                                            loader = true;
                                            groupInfoSocket();
                                          });
                                        },
                                      ),
                                    ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: groupInfoList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onLongPressStart: (value) {
                                            if (sharedPref
                                                        .getString(
                                                            SharedKey.userId)
                                                        .toString() ==
                                                    adminId &&
                                                groupInfoList[index].isAdmin !=
                                                    1) {
                                              _showCustomMenu(context,
                                                  value.globalPosition, index);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                boxShadow: <BoxShadow>[
                                                  new BoxShadow(
                                                    color: MyColor.liteGrey,
                                                    blurRadius: 2.0,
                                                    offset:
                                                        new Offset(0.0, 3.0),
                                                  ),
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: ListTile(
                                              tileColor: MyColor.cardColor,
                                              contentPadding: EdgeInsets.zero,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: 0,
                                                      vertical: -2),
                                              leading: Container(
                                                width: 40,
                                                height: 40,
                                                child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(50)),
                                                    child: groupInfoList[index]
                                                                .userDetails!
                                                                .profilePicture !=
                                                            null
                                                        ? Image.network(
                                                            '${ApiStrings.mediaURl}${groupInfoList[index].userDetails!.profilePicture.toString()}',
                                                            width: 40,
                                                            height: 40,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (context, child, loadingProgress) =>
                                                                (loadingProgress == null)
                                                                    ? child
                                                                    : Container(
                                                                        width:
                                                                            50,
                                                                        child:
                                                                            customProgressBar()))
                                                        : Image.asset(
                                                            'assets/images/onboard/placeholder_image.png',
                                                            width: 40,
                                                            height: 40)),
                                              ),
                                              title: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: MyString.med(
                                                      '${groupInfoList[index].userDetails!.firstName.toString()} ${groupInfoList[index].userDetails!.lastName.toString()}',
                                                      14,
                                                      MyColor.textBlack2,
                                                      TextAlign.start)),
                                              trailing: groupInfoList[index]
                                                          .isAdmin ==
                                                      1
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: MyColor
                                                              .yellowLite,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          6))),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: MyString.med(
                                                                "groupAdmin".tr,
                                                                10,
                                                                MyColor
                                                                    .textBlack2,
                                                                TextAlign
                                                                    .start),
                                                          )),
                                                    )
                                                  : SizedBox(),
                                              onTap: () {
                                                Map<String, dynamic> mapData = {
                                                  'userID': groupInfoList[index]
                                                      .userDetails!
                                                      .id
                                                      .toString()
                                                };
                                                Navigator.pushNamed(context,
                                                    RoutesName.myProfile,
                                                    arguments: mapData);
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, left: 8.0, bottom: 8.0),
                            child: Card(
                              elevation: 0,
                              color: MyColor.cardColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      tileColor: MyColor.cardColor,
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -3),
                                      onTap: () async {
                                        var res = await showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (_) {
                                              return leaveGroup(
                                                  sharedPref
                                                      .getString(
                                                          SharedKey.userId)
                                                      .toString(),
                                                  "",
                                                  groupInfoMember.groupName
                                                      .toString());
                                            });
                                        if (res) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              RoutesName.mainPage,
                                              arguments: 2,
                                              (route) => false);
                                        }
                                      },
                                      leading: Container(
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: MyColor.yellowLite,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        height: 40,
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            child: Center(
                                                child: Image.asset(
                                                    'assets/images/icons/logout.png',
                                                    width: 20,
                                                    height: 20))),
                                      ),
                                      title: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: MyString.med(
                                              "ExitGroup".tr,
                                              14,
                                              MyColor.textBlack2,
                                              TextAlign.start)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    groupInfoList.clear();
    if (text.isEmpty) {
      setState(() {
        groupInfoSocket();
      });
      return;
    }
    for (var userDetail in groupInfoMember.members!) {
      if ((userDetail.userDetails!.firstName.toString().toLowerCase())
          .contains(text)) groupInfoList.add(userDetail);
    }
    setState(() {});
  }

  Widget AddFriendsSheet() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                width: double.infinity,
                color: MyColor.orange2,
                height: 50,
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                )),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border.all(color: MyColor.textFieldBorder),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                          myState(() {
                            FocusManager.instance.primaryFocus!.unfocus();
                            searchBar.text = '';
                            getFollowFollowingApi(1, 1, '');
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          color: MyColor.orange2,
                        ))
                    : Container(width: 10),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                hintText: 'search'.tr,
                hintStyle:
                    TextStyle(color: MyColor.textFieldBorder, fontSize: 14),
              ),
              onChanged: (value) {
                myState(() {
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
                return ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -2),
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: followList[index].followRef!.profilePicture != null
                        ? Image.network(
                            '${ApiStrings.mediaURl}${followList[index].followRef!.profilePicture.toString()}',
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : Container(
                                        height: 35,
                                        width: 35,
                                        child: customProgressBar()))
                        : Image.asset(
                            'assets/images/onboard/placeholder_image.png',
                            width: 35,
                            height: 35,
                          ),
                  ),
                  title: MyString.med(
                      followList[index].followRef!.name.toString(),
                      16,
                      MyColor.textBlack2,
                      TextAlign.start),
                  trailing: (followList[index].createGroupSelect)
                      ? Icon(
                          Icons.check,
                          color: MyColor.orange2,
                        )
                      : const SizedBox(),
                  onTap: () {
                    myState(() {
                      debugPrint(
                          'click is ${followList[index].createGroupSelect}');
                      followList[index].createGroupSelect =
                          !followList[index].createGroupSelect;

                      if (followList[index].createGroupSelect) {
                        saveList1.add(followList[index].id.toString());

                        newUserid
                            .add(followList[index].followRef!.id.toString());
                      } else {
                        saveList1.remove(followList[index].id.toString());
                        newUserid
                            .remove(followList[index].followRef!.id.toString());
                      }

                      debugPrint('save list 1 ${saveList1.toString()}');

                      if (saveList1.contains(followList[index].id.toString())) {
                        saveList.add(followList[index]);
                      } else {
                        for (var j = 0; j < saveList.length; j++) {
                          if (saveList[j].id.toString() ==
                              followList[index].id.toString()) {
                            saveList.removeAt(j);
                          }
                        }
                      }
                      debugPrint('save list   ${saveList.toString()}');
                    });
                  },
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus!.unfocus();
              print('RESULT-3  $newUserid');
            },
            child: Container(
              margin: const EdgeInsets.only(
                  top: 25, bottom: 10, right: 15, left: 15),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: MyColor.orange2,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: MyString.med(
                  'submit'.tr, 18, MyColor.white, TextAlign.center),
            ),
          ),
        ],
      );
    });
  }

  getFollowFollowingApi(int loadPage, int type, String searchValues) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.followersFollowing}?page=${loadPage.toString()}&limit=200&search=$searchValues&type=${type.toString()}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      loader = false;
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

  delete() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (context, myState) {
          return Container(
            decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadiusDirectional.circular(40)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyString.bold('changeGroupName'.tr, 16, MyColor.black,
                      TextAlign.center),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: MyColor.textFieldBorder),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: groupName,
                      scrollPadding: const EdgeInsets.only(bottom: 100),
                      style: TextStyle(color: MyColor.black, fontSize: 14),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        hintText: 'Group Name',
                        hintStyle: TextStyle(
                            color: MyColor.textFieldBorder, fontSize: 14),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      if (groupName.text.trim().toString().isNotEmpty) {
                        editGroupSocket();
                        groupName.text = groupName.text.trim().toString();
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 25, bottom: 10, right: 15, left: 15),
                      alignment: Alignment.center,
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: MyColor.orange2,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: MyString.med(
                          'submit'.tr, 18, MyColor.white, TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget leaveGroup(String id, String? firstName, String groupName) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (context, myState) {
          return Container(
            decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadiusDirectional.circular(40)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Image.asset('assets/images/icons/logout.png',
                      width: 30, height: 30),
                  const SizedBox(height: 10),
                  MyString.bold(
                      'remove'.tr, 20, MyColor.black, TextAlign.center),
                  MyString.med('${'areRemove'.tr}', 12, MyColor.textFieldBorder,
                      TextAlign.center),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, false);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: MyColor.bgColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: MyString.med('no'.tr, 20, MyColor.orange2,
                                  TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus!.unfocus();
                            Navigator.pop(context, true);
                            await leaveUser(id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: MyColor.orange2,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: MyString.med('yes'.tr, 20, MyColor.white,
                                  TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _showCustomMenu(BuildContext context, Offset offset, int index) {
    final RenderObject overlay =
        Overlay.of(context).context.findRenderObject()!;
    showMenu(
        context: context,
        color: MyColor.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        items: [
          PopupMenuItem(
            value: null,
            onTap: () async {
              print(
                  'REMOVE USER FROM THE GROUP ${groupInfoList[index].userDetails!.id.toString()}');
              await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) {
                    return leaveGroup(
                        groupInfoList[index].userDetails!.id.toString(),
                        groupInfoList[index].userDetails!.firstName.toString(),
                        groupInfoMember.groupName.toString());
                  });
            },
            child:
                MyString.reg('remove'.tr, 14, MyColor.black, TextAlign.center),
          ),
        ],
        position: RelativeRect.fromRect(
            Rect.fromLTWH(offset.dx, offset.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay.paintBounds.size.width,
                overlay.paintBounds.size.height)));
  }

  groupInfoSocket() {
    Map mapping = {
      "userId": sharedPref.getString(SharedKey.userId).toString(),
      "groupId": widget.mapData!['groupId'].toString(),
    };
    socket.emit('get_group_info', mapping);
  }

  groupInfoSocketListener() {
    socket.on('group_info', (newMessage) {
      setState(() {
        groupInfoList.clear();
        groupInfoMember = GroupInfo.fromJson(newMessage);
        for (int i = 0; i < groupInfoMember.members!.length; i++) {
          groupInfoList.add(groupInfoMember.members![i]);

          if (groupInfoList[i].isAdmin == 1) {
            adminId = groupInfoList[i].userId.toString();
          }
        }
        groupName.text = groupInfoMember.groupName.toString();
        print('ADMIN_ID id $adminId');
        loader = false;
        userLen = groupInfoList.length;
      });
    });
  }

  leaveUser(String memberId) {
    Map mapping = {
      "userId": sharedPref.getString(SharedKey.userId).toString(),
      "members": memberId,
      "groupId": widget.mapData!['groupId'].toString(),
    };
    print('REMOVE_SOCKET MAPPING $mapping');
    socket.emit('leave_group', mapping);
  }

  leaveUserListener() {
    socket.on('leave_group_member', (newMessage) {
      if (this.mounted) {
        setState(() {
          debugPrint("add_member_to_group_listener => $newMessage");
          groupInfoSocket();
        });
      }
    });
  }

  leaveUserListener1() {
    socket.on('youAreRemoved', (newMessage) {
      setState(() {
        debugPrint("add_member_to_group_listener => $newMessage");
        groupInfoSocket();
      });
    });
  }

  editGroupSocket() {
    Map mapping = {
      "userId": sharedPref.getString(SharedKey.userId).toString(),
      "groupId": widget.mapData!['groupId'].toString(),
      "groupName": groupName.text.trim().toString(),
      "groupIcon": fileImage != null
          ? imageSave
          : groupInfoMember.groupIcon != null
              ? groupInfoMember.groupIcon.toString()
              : "",
    };
    print('EDIT_SOCKET MAPPING : $mapping');
    socket.emit('edit_group_info', mapping);
  }

  editGroupListener() {
    socket.on('edit_group', (newMessage) {
      setState(() {});
    });
  }
}
