import 'dart:convert';
import 'dart:io';

import 'package:avispets/models/chats/all_users_discussion_model.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/follower_following_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/connect_socket.dart';
import '../../../utils/common_function/crop_image.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/shared_pref.dart';

class CreateGroup2 extends StatefulWidget {
  final Map<String, dynamic>? mapData;
  // final List<FollowingFollowerBody> mapData;
  const CreateGroup2({super.key, required this.mapData});

  @override
  State<CreateGroup2> createState() => _CreateGroup2State();
}

class _CreateGroup2State extends State<CreateGroup2> {
  File? fileImage;
  String imageUrl = "";
  TextEditingController groupName = TextEditingController();
  List<String> idList = [];

  List<UserDiscussion> _listUserDiscussion = [];

  @override
  void initState() {
    super.initState();
    if(widget.mapData != null){
      _listUserDiscussion = widget.mapData!['user'];
    }
    // createGroupListener();
    registerUserListener();
    attachCreateGroupListener();

    // for (var i = 0; i < widget.mapData.length; i++) {
    //   idList.add(widget.mapData[i].followId.toString());
    // }
  }

  void registerUserListener() {
    checkSocketConnect();
    attachRegisterListener();
    socket.emit('register', int.parse(sharedPref.getString(SharedKey.userId)!));
  }

  void attachRegisterListener() {
    socket.on('register', (data) {
      debugPrint("REGISTER_EVENT ==> $data");
    });
  }

  @override
  void dispose() {
    // socketOff('create_group_listener');
    socketOff('register');
    socketOff('create_group_chat');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
          backgroundColor: MyColor.white,
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  _buildUINEW(),
                  // _buildUIOLD(),
                ],
              ),
            ),
          )),
    );
  }

  void createGroupSocket() {
    Map mapping = {
      "userId": sharedPref.getString(SharedKey.userId).toString(),
      "members": idList.join(','),
      "groupName":
          groupName.text.toString(), //0 :default, 1:image , 2:audio 3:video
      "groupIcon": imageUrl, //0 = image, 1 = video
    };
    debugPrint("Create Group Data --  $mapping");
    if (groupName.text.toString().isEmpty) {
      toaster(context, StringKey.enterGroupName);
    } else {
      setState(() {
        LoadingDialog.show(context);
      });
      socket.emit('create_group', mapping);
    }
  }

  void createGroupSocketNew() {
    Map mapping = {
      "userId": sharedPref.getString(SharedKey.userId).toString(),
      "memberIds": _listUserDiscussion.map((userItem) => userItem.id).toList(),
      "groupName": groupName.text.toString(), //0 :default, 1:image , 2:audio 3:video
      "groupIcon": imageUrl, //0 = image, 1 = video
    };
    debugPrint("Create Group Data --  $mapping");
    if (groupName.text.toString().isEmpty) {
      toaster(context, StringKey.enterGroupName);
    } else {
      setState(() {
        LoadingDialog.show(context);
      });
      socket.emit('create_group_chat', mapping);
    }
  }

  createGroupListener() {
    socket.on('create_group_listener', (createGroup) {
      debugPrint("Create Group Listener ==> $createGroup");
      LoadingDialog.hide(context);
      Navigator.pop(context, true);
    });
  }

  void attachCreateGroupListener() {
    socket.on('create_group_chat', (data) {
      debugPrint("CREATE_GROUP_EVENT ==> $data");
    });
  }

  // Widget _buildUIOLD() {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.all(0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           HeaderWidget2(),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //                 vertical: 20, horizontal: 30),
  //             child: MyString.bold('newGroup'.tr, 27,
  //                 MyColor.title, TextAlign.center),
  //           ),
  //           Container(
  //             padding:
  //             const EdgeInsets.symmetric(horizontal: 20.0),
  //             height: 50,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () async {
  //                     FocusManager.instance.primaryFocus!
  //                         .unfocus();
  //                     String? result = await cameraPhoto(
  //                         context, "create_group");
  //                     var returnImage;
  //                     if (result == '0') {
  //                       returnImage = await pickImage(
  //                           context, ImageSource.camera);
  //                     } else if (result == '1') {
  //                       returnImage = await pickImage(
  //                           context, ImageSource.gallery);
  //                     }
  //                     if (returnImage != null) {
  //                       fileImage = returnImage;
  //                       LoadingDialog.show(context);
  //                       var res = await AllApi.onlyImage(
  //                           fileImage!.path.toString());
  //                       var result = jsonDecode(res);
  //                       LoadingDialog.hide(context);
  //                       debugPrint('UPLOAD_IMAGE RESULT $result');
  //                       if (result['status'] == 200) {
  //                         imageUrl = result["data"];
  //                         debugPrint(
  //                             'UPLOAD_IMAGE URL $imageUrl');
  //                       }
  //                     }
  //                     setState(() {});
  //                   },
  //                   child: ClipRRect(
  //                     child: fileImage != null
  //                         ? Image.file(fileImage!,
  //                         width: 50,
  //                         height: 50,
  //                         fit: BoxFit.cover)
  //                         : Container(
  //                         width: 50,
  //                         height: 50,
  //                         child: Center(
  //                             child: Icon(
  //                               Icons.camera_alt,
  //                               color: Color(0xff878787),
  //                               size: 35,
  //                             ))),
  //                   ),
  //                 ),
  //                 Flexible(
  //                   child: Container(
  //                     height: 50,
  //                     child: TextField(
  //                       textAlign: TextAlign.start,
  //                       controller: groupName,
  //                       style: TextStyle(
  //                           color: MyColor.black, fontSize: 14),
  //                       decoration: InputDecoration(
  //                         border: OutlineInputBorder(
  //                             borderSide: BorderSide.none),
  //                         contentPadding:
  //                         const EdgeInsets.symmetric(
  //                             vertical: 5, horizontal: 12),
  //                         hintText: 'groupName'.tr,
  //                         hintStyle: TextStyle(
  //                             color: MyColor.textBlack0,
  //                             fontSize: 12),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Divider(
  //             color: Color(0xffEBEBEB), // Color of the divider
  //             thickness: 1, // Thickness of the line
  //             indent: 16, // Start padding
  //             endIndent: 16, // End padding
  //           ),
  //           SizedBox(height: 15),
  //           Container(
  //               padding: const EdgeInsets.symmetric(
  //                   horizontal: 30.0, vertical: 20),
  //               width: double.infinity,
  //               child: MyString.reg(
  //                   'members1'.tr + ': ${widget.mapData.length}',
  //                   12,
  //                   MyColor.textBlack0,
  //                   TextAlign.start)),
  //           ListView.builder(
  //             itemCount: widget.mapData.length,
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             padding: EdgeInsets.zero,
  //             itemBuilder: (context, index) {
  //               return Container(
  //                 padding: EdgeInsets.symmetric(
  //                     vertical: 15, horizontal: 20),
  //                 height: 74,
  //                 margin: EdgeInsets.only(
  //                     bottom: 10, right: 20, left: 20),
  //                 decoration: BoxDecoration(
  //                   color: MyColor.card,
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment:
  //                   MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Container(
  //                           alignment: Alignment.center,
  //                           height: 50,
  //                           child: ClipRRect(
  //                             borderRadius:
  //                             const BorderRadius.all(
  //                                 Radius.circular(50)),
  //                             child: widget
  //                                 .mapData[index]
  //                                 .followRef!
  //                                 .profilePicture !=
  //                                 null
  //                                 ? Image.network(
  //                                 '${ApiStrings.mediaURl}${widget.mapData[index].followRef!.profilePicture.toString()}',
  //                                 width: 50,
  //                                 height: 50,
  //                                 fit: BoxFit.cover,
  //                                 loadingBuilder: (context,
  //                                     child,
  //                                     loadingProgress) =>
  //                                 (loadingProgress ==
  //                                     null)
  //                                     ? child
  //                                     : Container(
  //                                     width: 50,
  //                                     child:
  //                                     customProgressBar()))
  //                                 : Image.asset(
  //                                 'assets/images/onboard/placeholder_image.png',
  //                                 width: 50),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         Container(
  //                             margin: EdgeInsets.only(top: 3),
  //                             width: 65,
  //                             child: MyString.medMultiLine(
  //                                 widget.mapData[index].followRef!
  //                                     .name
  //                                     .toString(),
  //                                 14,
  //                                 MyColor.redd,
  //                                 TextAlign.center,
  //                                 1)),
  //                       ],
  //                     ),
  //                     Image.asset(
  //                       'assets/images/icons/check.png',
  //                     )
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               checkSocketConnect();
  //               createGroupSocket();
  //             },
  //             child: Container(
  //               margin: const EdgeInsets.only(
  //                   right: 30, left: 30, top: 40),
  //               alignment: Alignment.center,
  //               height: 59,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                   color: MyColor.orange2,
  //                   borderRadius: const BorderRadius.all(
  //                       Radius.circular(22))),
  //               child: MyString.med('submit'.tr, 18,
  //                   MyColor.white, TextAlign.center),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildUINEW() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget2(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 30),
              child: MyString.bold('newGroup'.tr, 27,
                  MyColor.title, TextAlign.center),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!
                          .unfocus();
                      String? result = await cameraPhoto(
                          context, "create_group");
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
                        // var res = await AllApi.onlyImage(
                        //     fileImage!.path.toString());
                        var res = await AllApi.uploadChatImage(
                            fileImage!.path.toString());
                        var result = jsonDecode(res);
                        LoadingDialog.hide(context);
                        debugPrint('UPLOAD_IMAGE RESULT $result');
                        if (result['status'] == 200) {
                          imageUrl = result["data"]["imageUrl"];
                          debugPrint(
                              'UPLOAD_IMAGE URL $imageUrl');
                        }
                      }
                      setState(() {});
                    },
                    child: ClipRRect(
                      child: fileImage != null
                          ? Image.file(fileImage!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover)
                          : Container(
                          width: 50,
                          height: 50,
                          child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Color(0xff878787),
                                size: 35,
                              ))),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      height: 50,
                      child: TextField(
                        textAlign: TextAlign.start,
                        controller: groupName,
                        style: TextStyle(
                            color: MyColor.black, fontSize: 14),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none),
                          contentPadding:
                          const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                          hintText: 'groupName'.tr,
                          hintStyle: TextStyle(
                              color: MyColor.textBlack0,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xffEBEBEB), // Color of the divider
              thickness: 1, // Thickness of the line
              indent: 16, // Start padding
              endIndent: 16, // End padding
            ),
            SizedBox(height: 15),
            Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20),
                width: double.infinity,
                child: MyString.reg(
                    'members1'.tr + ': ${_listUserDiscussion.length}',
                    12,
                    MyColor.textBlack0,
                    TextAlign.start)),
            ListView.builder(
              itemCount: _listUserDiscussion.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final user = _listUserDiscussion[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                  height: 74,
                  margin: EdgeInsets.only(
                      bottom: 10, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: MyColor.card,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(50)),
                              child: user.profilePicture !=
                                  null && user.profilePicture!.contains('http')
                                  ? Image.network(
                                  '${user.profilePicture}',
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
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 3),
                              width: 65,
                              child: MyString.medMultiLine(
                                  user.name
                                      .toString(),
                                  14,
                                  MyColor.redd,
                                  TextAlign.center,
                                  1)),
                        ],
                      ),
                      Image.asset(
                        'assets/images/icons/check.png',
                      )
                    ],
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                // checkSocketConnect();
                createGroupSocketNew();
                // createGroupSocket();
              },
              child: Container(
                margin: const EdgeInsets.only(
                    right: 30, left: 30, top: 40),
                alignment: Alignment.center,
                height: 59,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: MyColor.orange2,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(22))),
                child: MyString.med('submit'.tr, 18,
                    MyColor.white, TextAlign.center),
              ),
            )
          ],
        ),
      ),
    );
  }
}
