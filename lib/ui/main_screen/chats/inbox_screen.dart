import 'dart:convert';

import 'package:avispets/models/chats/all_users_discussion_model.dart';
import 'package:avispets/models/chats/user_all_chats_model.dart';
import 'package:avispets/models/chats/user_group_model.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/aa_common_model.dart';
import '../../../models/chats/chat_inbox.dart';
import '../../../models/forum/get_forum.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/connect_socket.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

enum SampleItem { report, delete }

class _InboxScreenState extends State<InboxScreen> {
  bool loader = true;
  bool stackLoader = false;
  SampleItem? selectedItem;
  int deleteIndexSave = 0;
  CommonModel commonModel = CommonModel();
  ChatInbox chatInbox = ChatInbox();
  bool groupCreateEnable = false;
  TextEditingController searchController = TextEditingController();
  List<ChatInbox> inboxList = [];
  List<ChatInbox> dataHold = [];
  int currentTabBreed = 1;

  late Future<GetForum> futureForumData;

  UserAllChatsModel _userAllChatsModel = UserAllChatsModel();
  List<IndividualChats> _listChats = [];

  UserGroupModel _userGroupModel = UserGroupModel();
  List<GroupChatModel> _listGroupChats = [];

  @override
  void initState() {
    super.initState();
    // GetApi.getNotify(context, '');
    futureForumData = fetchForumData();
    Future.delayed(Duration.zero, () async {
      getAllUserChats();
      getAllGroupChats();
      // connectSocket();
      // inbox();
      // inboxListener();
      // sendMessageListener();
      // sendMessageListener1();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // socketOff('inbox_listener');
    // socketOff('new_group_message');
    // socketOff('new_message');
    // checkSocketConnect();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
          floatingActionButton: Container(
            child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: () async {
                  FocusManager.instance.primaryFocus!.unfocus();
                  Future.delayed(Duration(milliseconds: 100), () async {
                    var data = await Navigator.pushNamed(
                        context, RoutesName.createGroup);
                    if (data == true) {
                      loader = true;
                      groupCreateEnable = true;
                      inbox();
                    }
                  });
                },
                shape: CircleBorder(),
                backgroundColor: MyColor.orange2,
                child: Image.asset(
                  'assets/images/icons/bottom_chat.png',
                  width: 25,
                  height: 25,
                  color: MyColor.white,
                  fit: BoxFit.cover,
                )),
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColor.white,
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                inbox();
                searchController.clear();
              });
            },
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: MediaQuery.of(context).size.height * 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: HeaderWidget(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: MyString.bold('${'chats'.tr} & ${'forums'.tr} ',
                            27, MyColor.title, TextAlign.center),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffEBEBEB)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(13),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(13),
                                bottomRight: Radius.circular(50))),
                        child: TextField(
                          controller: searchController,
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
                              ),
                            ),
                            suffixIcon: GestureDetector(
                                onTap: () async {},
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Color(0xff4F2020),
                                        borderRadius:
                                            BorderRadius.circular(150)),
                                    child: Image.asset(
                                        'assets/images/icons/filter.png'))),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            hintText: 'search'.tr,
                            hintStyle:
                                TextStyle(color: MyColor.more, fontSize: 14),
                          ),
                          onChanged: (value) {
                            setState(() {
                              onSearchUsers(value.trim().toLowerCase());
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /* Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      stackLoader = true;
                                      currentTabBreed = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        border: currentTabBreed == 1
                                            ? Border.all(color: MyColor.white)
                                            : Border.all(
                                                color: Color(0xffFFEDED)),
                                        color: currentTabBreed == 1
                                            ? MyColor.orange2
                                            : Color(0xffFFF9F5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: MyString.med(
                                        'dog'.tr,
                                        12,
                                        currentTabBreed == 1
                                            ? MyColor.white
                                            : MyColor.orange2,
                                        TextAlign.center),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      stackLoader = true;
                                      currentTabBreed = 2;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        border: currentTabBreed == 2
                                            ? Border.all(color: MyColor.white)
                                            : Border.all(
                                                color: Color(0xffFFEDED)),
                                        color: currentTabBreed == 2
                                            ? MyColor.orange2
                                            : Color(0xffFFF9F5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: MyString.med(
                                        'cat'.tr,
                                        12,
                                        currentTabBreed == 2
                                            ? MyColor.white
                                            : MyColor.orange2,
                                        TextAlign.center),
                                  ),
                                )
                              ],
                            ),*/
                            GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus!.unfocus();
                                Future.delayed(Duration(milliseconds: 100),
                                    () async {
                                  Navigator.pushNamed(
                                      context, RoutesName.forum);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: MyString.med('Explore'.tr, 12,
                                    MyColor.orange2, TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<GetForum>(
                        future: futureForumData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(height: 150, child: progressBar());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error loading forums: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.data!.isEmpty) {
                            return Center(
                                child: Text('No forum data available.'));
                          }

                          final forumList = snapshot.data!.data!;
                          return Container(
                            height: 150,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: forumList.length,
                              itemBuilder: (context, index) {
                                final forum = forumList[index];
                                return GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> mapping = {
                                      'image': forum.dogBreed?.icon != null &&
                                              forum.dogBreed!.icon!.isNotEmpty
                                          ? '${ApiStrings.mediaURl}${forum.dogBreed!.icon}'
                                          : '',
                                      'desc': sharedPref.getString(
                                                  SharedKey.languageValue) ==
                                              'en'
                                          ? forum.description.toString()
                                          : forum.descriptionFr.toString(),
                                      'topic': forum.dogBreed!.name.toString(),
                                      'forumId': forum.id,
                                    };

                                    await Navigator.pushNamed(
                                      context,
                                      RoutesName.forumQuestion,
                                      arguments: mapping,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: forum.dogBreed?.icon != null
                                              ? Image.network(
                                                  '${ApiStrings.mediaURl}${forum.dogBreed!.icon}',
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                          child, progress) =>
                                                      progress == null
                                                          ? child
                                                          : customProgressBar(),
                                                )
                                              : Container(
                                                  width: 85,
                                                  height: 85,
                                                  color: MyColor.cardColor,
                                                  child: Center(
                                                    child: Image.asset(
                                                      'assets/images/onboard/placeholder_image.png',
                                                      width: 85,
                                                      height: 85,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          forum.dogBreed?.name ?? 'Unknown',
                                          style: TextStyle(fontSize: 8),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyString.bold('Individual ${'chats'.tr}',
                                27, MyColor.title, TextAlign.center),
                            GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus!.unfocus();
                                Future.delayed(Duration(milliseconds: 100),
                                    () async {
                                  Navigator.pushNamed(
                                      context, RoutesName.messagesScreen,
                                      arguments: {
                                        'group': false
                                      }
                                  );
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: MyString.med('more'.tr, 12,
                                    MyColor.orange2, TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // _buildAllChatsUIOLD(),
                      _buildAllChatsUINEW(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyString.bold('Group ${'chats'.tr}',
                                27, MyColor.title, TextAlign.center),
                            GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus!.unfocus();
                                Future.delayed(Duration(milliseconds: 100),
                                        () async {
                                      Navigator.pushNamed(
                                          context, RoutesName.messagesScreen,
                                        arguments: {
                                            'group': true
                                        }
                                      );
                                    });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: MyString.med('more'.tr, 12,
                                    MyColor.orange2, TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildAllGroupChatsUINEW(),
                      if (stackLoader) progressBar()
                    ],
                  )),
            ),
          )),
    );
  }

  onSearchUsers(String text) async {
    inboxList.clear();
    if (text.isEmpty) {
      FocusManager.instance.primaryFocus!.unfocus();
      setState(() {
        stackLoader = true;
        inbox();
      });
      return;
    }
    for (var userDetail in dataHold) {
      if (userDetail.name.toString().toLowerCase().contains(text) ||
          userDetail.lastMessage.toString().toLowerCase().contains(text))
        inboxList.add(userDetail);
    }
    setState(() {});
  }

  delete(int index) {
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
                  Image.asset('assets/images/icons/delete.png',
                      width: 60, height: 60),
                  const SizedBox(height: 10),
                  MyString.bold(
                      'deleteChat'.tr, 20, MyColor.black, TextAlign.center),
                  MyString.med('deleteChatDesc'.tr, 12, MyColor.textFieldBorder,
                      TextAlign.center),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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
                            Navigator.pop(context);

                            if (inboxList[index].groupId != 0) {
                              Map<String, dynamic> mapData = {
                                "userId": sharedPref
                                    .getString(SharedKey.userId)
                                    .toString(),
                                "members": sharedPref
                                    .getString(SharedKey.userId)
                                    .toString(),
                                "groupId": inboxList[index].groupId.toString()
                              };
                              socket.emit('leave_group', mapData);
                              deleteUserGroupListener();
                              deleteUserGroupListener1();
                            } else {
                              Map<String, dynamic> mapData = {
                                "userId": sharedPref
                                    .getString(SharedKey.userId)
                                    .toString(),
                                "user2Id": inboxList[index]
                                            .senderId!
                                            .toString() ==
                                        sharedPref
                                            .getString(SharedKey.userId)
                                            .toString()
                                    ? '${inboxList[index].receiverId!.toString()}'
                                    : '${inboxList[index].senderId!.toString()}',
                              };
                              socket.emit('delete_chat_listing', mapData);
                              deleteUserListListener();
                            }
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

  void _showCustomMenu(BuildContext context, Offset offset, int index) {
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
              await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) {
                    return delete(index);
                  });
            },
            child:
                MyString.reg('delete'.tr, 14, MyColor.black, TextAlign.center),
          ),
        ],
        position: RelativeRect.fromRect(
            Rect.fromLTWH(offset.dx, offset.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay.paintBounds.size.width,
                overlay.paintBounds.size.height)));
  }

  inbox() {
    if (socket.connected) {
      Map mapping = {
        "userId": sharedPref.getString(SharedKey.userId).toString()
      };
      socket.emit("inbox", mapping);
    } else {
      debugPrint("Socket is not connected. Retrying...");
      connectSocket();
    }
  }

  inboxListener() {
    socket.on('inbox_listener', (newMessage) {
      List<dynamic> list = newMessage;
      print("INBOX_LIST  $list}");
      if (this.mounted) {
        setState(() {
          loader = false;
          stackLoader = false;
          inboxList.clear();
          dataHold.clear();
          for (int i = 0; i < list.length; i++) {
            chatInbox = ChatInbox.fromJson(list[i]);
            inboxList.add(chatInbox);
            dataHold.add(chatInbox);
          }
          debugPrint("INBOX_LISTENER ==> $chatInbox");

          debugPrint("groupCreateEnable ==> $groupCreateEnable");
          if (groupCreateEnable) {
            groupCreateEnable = false;
            Map<String, dynamic> mapData = {
              'userId': inboxList[0].senderId!.toString() ==
                      sharedPref.getString(SharedKey.userId).toString()
                  ? '${inboxList[0].receiverId!.toString()}'
                  : '${inboxList[0].senderId!.toString()}',
              'userName': (inboxList[0].groupId!.toString() != "0")
                  ? inboxList[0].groupInfo!.groupName
                  : inboxList[0].senderId!.toString() ==
                          sharedPref.getString(SharedKey.userId).toString()
                      ? inboxList[0].name.toString()
                      : inboxList[0].senderName.toString(),
              'userImage': inboxList[0].groupId!.toString() != "0" &&
                      inboxList[0].groupInfo!.groupIcon != null &&
                      inboxList[0].groupInfo!.groupIcon.toString().isNotEmpty
                  ? '${ApiStrings.mediaURl}${inboxList[0].groupInfo!.groupIcon.toString()}'
                  : inboxList[0].userImage != null &&
                          inboxList[0].userImage.toString().isNotEmpty &&
                          inboxList[0].groupId!.toString() == "0"
                      ? '${ApiStrings.mediaURl}${inboxList[0].userImage.toString()}'
                      : '',
              'myId': inboxList[0].senderId!.toString() ==
                      sharedPref.getString(SharedKey.userId).toString()
                  ? '${inboxList[0].senderId!.toString()}'
                  : '${inboxList[0].receiverId!.toString()}',
              'myImage': sharedPref
                      .getString(SharedKey.userprofilePic)
                      .toString()
                      .isEmpty
                  ? ""
                  : sharedPref.getString(SharedKey.userprofilePic).toString(),
              'blockBy': '0',
              'isBlock': inboxList[0].isBlocked,
              'online': inboxList[0].onlineStatus,
              'groupId': inboxList[0].groupId.toString(),
              'totalMember': inboxList[0].groupId != 0
                  ? inboxList[0].groupInfo!.members!.length
                  : ''
            };
            FocusManager.instance.primaryFocus!.unfocus();
            Future.delayed(Duration(milliseconds: 100), () async {
              Navigator.pushNamed(context, RoutesName.chatScreen,
                  arguments: mapData);
            });
          }

          debugPrint("INBOX_LISTENER(chatInbox) ==> $newMessage");
        });
      }
    });
  }

  sendMessageListener() {
    socket.on("new_group_message", (newMessage) {
      debugPrint("SEND_MESSAGE ==> $newMessage");

      if (this.mounted) {
        setState(() {
          inbox();
        });
      }
    });
  }

  sendMessageListener1() {
    socket.on("new_message", (newMessage) {
      debugPrint("SEND_MESSAGE ==> $newMessage");
      if (this.mounted) {
        setState(() {
          inbox();
        });
      }
    });
  }

  deleteUserListListener() {
    socket.on("chat_list_data", (newMessage) {
      debugPrint("SEND_MESSAGE ==> $newMessage");
      inbox();
    });
  }

  deleteUserGroupListener() {
    socket.on("leave_group_member", (newMessage) {
      debugPrint("SEND_MESSAGE ==> $newMessage");
      inbox();
    });
  }

  deleteUserGroupListener1() {
    socket.on("youAreRemoved", (newMessage) {
      debugPrint("SEND_MESSAGE ==> $newMessage");
      inbox();
    });
  }

  Future<GetForum> fetchForumData() async {
    try {
      var res = await AllApi.getMethodApi(
          "${ApiStrings.forums}?type=1&page=1&limit=20");
      var result = jsonDecode(res.toString());

      if (result['status'] == 200) {
        return GetForum.fromJson(result);
      } else if (result['status'] == 401) {
        await sharedPref.clear();
        sharedPref.setString(SharedKey.onboardScreen, 'OFF');
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.loginScreen, (route) => false);
        throw Exception('Unauthorized access');
      } else {
        toaster(context, result['message'].toString());
        throw Exception(result['message']);
      }
    } catch (e) {
      throw Exception('Error fetching forum data: $e');
    }
  }

  Future getAllUserChats() async {
    try {
      var res = await AllApi.getMethodApi(
          "${ApiStrings.userAllChats}/${sharedPref.getString(SharedKey.userId)}");
      var result = jsonDecode(res.toString());

      if (result['status'] == 200) {
        _userAllChatsModel = UserAllChatsModel.fromJson(result);
        _listChats.addAll(_userAllChatsModel.data!.individualChats!);
        setState(() {

        });
      }
    } catch (e) {
      throw Exception('Error fetching forum data: $e');
    }
  }

  Future getAllGroupChats() async {
    try {
      var res = await AllApi.getMethodApi(
          "${ApiStrings.userGroupChats}/${sharedPref.getString(SharedKey.userId)}");
      var result = jsonDecode(res.toString());

      if (result['status'] == 200) {
        _userGroupModel = UserGroupModel.fromJson(result);
        _listGroupChats.addAll(_userGroupModel.data!);
        setState(() {

        });
      }
    } catch (e) {
      throw Exception('Error fetching forum data: $e');
    }
  }

  Widget _buildAllChatsUIOLD() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inboxList.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inboxList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPressStart: (value) {
                      _showCustomMenu(context,
                          value.globalPosition, index);
                    },
                    child: InkWell(
                      onTap: () async {
                        socketOff('new_group_message');
                        socketOff('new_message');

                        FocusManager
                            .instance.primaryFocus!
                            .unfocus();

                        Map<String, dynamic> mapData = {
                          'userId': inboxList[index]
                              .senderId!
                              .toString() ==
                              sharedPref
                                  .getString(
                                  SharedKey
                                      .userId)
                                  .toString()
                              ? '${inboxList[index].receiverId!.toString()}'
                              : '${inboxList[index].senderId!.toString()}',
                          'userName': (inboxList[index]
                              .groupId!
                              .toString() !=
                              "0")
                              ? inboxList[index]
                              .groupInfo!
                              .groupName
                              : inboxList[index]
                              .senderId!
                              .toString() ==
                              sharedPref
                                  .getString(
                                  SharedKey
                                      .userId)
                                  .toString()
                              ? inboxList[index]
                              .name
                              .toString()
                              : inboxList[index]
                              .senderName
                              .toString(),
                          'userImage': inboxList[index]
                              .groupId!
                              .toString() !=
                              "0" &&
                              inboxList[index]
                                  .groupInfo!
                                  .groupIcon !=
                                  null &&
                              inboxList[index]
                                  .groupInfo!
                                  .groupIcon
                                  .toString()
                                  .isNotEmpty
                              ? '${ApiStrings.mediaURl}${inboxList[index].groupInfo!.groupIcon.toString()}'
                              : inboxList[index]
                              .userImage !=
                              null &&
                              inboxList[index]
                                  .userImage
                                  .toString()
                                  .isNotEmpty &&
                              inboxList[index]
                                  .groupId!
                                  .toString() ==
                                  "0"
                              ? '${ApiStrings.mediaURl}${inboxList[index].userImage.toString()}'
                              : '',
                          'myId': inboxList[index]
                              .senderId!
                              .toString() ==
                              sharedPref
                                  .getString(
                                  SharedKey
                                      .userId)
                                  .toString()
                              ? '${inboxList[index].senderId!.toString()}'
                              : '${inboxList[index].receiverId!.toString()}',
                          'myImage': sharedPref
                              .getString(SharedKey
                              .userprofilePic)
                              .toString()
                              .isEmpty
                              ? ""
                              : sharedPref
                              .getString(SharedKey
                              .userprofilePic)
                              .toString(),
                          'blockBy': '0',
                          'isBlock': inboxList[index]
                              .isBlocked,
                          'online': inboxList[index]
                              .onlineStatus,
                          'groupId': inboxList[index]
                              .groupId
                              .toString(),
                          'totalMember':
                          inboxList[index]
                              .groupId !=
                              0
                              ? inboxList[index]
                              .groupInfo!
                              .members!
                              .length
                              : ''
                        };
                        FocusManager
                            .instance.primaryFocus!
                            .unfocus();
                        Future.delayed(
                            Duration(milliseconds: 100),
                                () async {
                              await Navigator.pushNamed(
                                  context,
                                  RoutesName.chatScreen,
                                  arguments: mapData);
                              inbox();
                            });

                        loader = true;
                        inbox();
                      },
                      child: Container(
                        margin:
                        EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: MyColor.card,
                            borderRadius:
                            BorderRadius.circular(
                                15)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Stack(
                                    alignment: Alignment
                                        .bottomRight,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: inboxList[index].userImage !=
                                            null &&
                                            inboxList[index]
                                                .userImage
                                                .toString()
                                                .isNotEmpty
                                            ? Center(
                                          child:
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            child: Image.network(
                                                '${ApiStrings.mediaURl}${inboxList[index].userImage.toString()}',
                                                fit: BoxFit.cover,
                                                width: 42,
                                                height: 42,
                                                loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : customProgressBar()),
                                          ),
                                        )
                                            : Image.asset(
                                            'assets/images/onboard/placeholder_image.png',
                                            width:
                                            42,
                                            height:
                                            42),
                                      ),
                                      if (inboxList[
                                      index]
                                          .onlineStatus ==
                                          1)
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                              color: Colors
                                                  .green,
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(50))),
                                        )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width *
                                              0.5,
                                          child:
                                          MyString
                                              .med(
                                            inboxList[
                                            index]
                                                .name
                                                .toString(),
                                            14,
                                            MyColor
                                                .redd,
                                            TextAlign
                                                .start,
                                          )),
                                      (inboxList[index]
                                          .lastMessage !=
                                          null)
                                          ? Container(
                                          width:
                                          200,
                                          child: MyString.medMultiLine(
                                              (inboxList[index].lastMessage.toString() == "{GroupCreated}")
                                                  ? 'groupCreated'.tr
                                                  : (inboxList[index].lastMessage.toString() == "{NewMemberAdded}")
                                                  ? 'newMember'.tr
                                                  : (inboxList[index].lastMessage.toString() == "removed")
                                                  ? 'removed'.tr
                                                  : (inboxList[index].lastMessage.toString() == "left")
                                                  ? 'left'.tr
                                                  : (inboxList[index].messageType.toString() == '99')
                                                  ? 'sharePost'.tr
                                                  : inboxList[index].lastMessage.toString(),
                                              12,
                                              MyColor.textBlack0,
                                              TextAlign.start,
                                              1))
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 30,
                                  child: (inboxList[
                                  index]
                                      .lastMessage !=
                                      null)
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
                                    children: [
                                      MyString.med(
                                          timeValues(inboxList[index]
                                              .createdAt
                                              .toString()),
                                          8,
                                          MyColor
                                              .textBlack0,
                                          TextAlign
                                              .center),
                                      if (inboxList[index]
                                          .unreadcount !=
                                          0)
                                        Container(
                                          margin: EdgeInsets.only(
                                              top:
                                              3),
                                          width:
                                          20,
                                          height:
                                          20,
                                          alignment:
                                          Alignment.center,
                                          decoration: BoxDecoration(
                                              color:
                                              MyColor.orange2,
                                              borderRadius: const BorderRadius.all(Radius.circular(50))),
                                          child: MyString.med(
                                              inboxList[index].unreadcount.toString(),
                                              12,
                                              MyColor.white,
                                              TextAlign.center),
                                        ),
                                    ],
                                  )
                                      : SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : Transform(
              transform:
              Matrix4.translationValues(0, 120, 0),
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
                      child: MyString.reg(
                          'noDataFound'.tr,
                          12,
                          MyColor.textBlack0,
                          TextAlign.center)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllChatsUINEW() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _listChats.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _listChats.length > 10 ? 10 : _listChats.length,
                itemBuilder: (context, index) {
                  final user = _listChats[index];
                  final currentUserID = int.parse(sharedPref.getString(SharedKey.userId)!);
                  final senderIsMe = currentUserID == user.senderId!;
                  final receiverIsMe = currentUserID == user.receiverId!;
                  final profileImage = senderIsMe
                      ? user.receiver != null
                      && user.receiver!.profilePicture != null
                      && user.receiver!.profilePicture!.contains('http')
                      ? user.receiver!.profilePicture!
                      : receiverIsMe
                      ? user.sender != null
                      && user.sender!.profilePicture != null
                      && user.sender!.profilePicture!.contains('http')
                      ? user.receiver!.profilePicture!
                      : ''
                      : ''
                      : '';
                  return GestureDetector(
                    onLongPressStart: (value) {
                      _showCustomMenu(context,
                          value.globalPosition, index);
                    },
                    child: InkWell(
                      onTap: () async {

                        FocusManager
                            .instance.primaryFocus!
                            .unfocus();

                        Future.delayed(
                            Duration(milliseconds: 100),
                                () async {
                              await Navigator.pushNamed(
                                  context,
                                  RoutesName.chatScreen,
                                  arguments: {
                                    'user': UserDiscussion(
                                      id: senderIsMe ? user.receiverId! : user.senderId,
                                      name: senderIsMe ? user.sender!.name : user.receiver!.name,
                                      email: '',
                                      profilePicture: senderIsMe ? user.sender!.profilePicture : user.receiver!.profilePicture,
                                    )
                                  }
                              );
                            });
                      },
                      child: Container(
                        margin:
                        EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: MyColor.card,
                            borderRadius:
                            BorderRadius.circular(
                                15)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Stack(
                                    alignment: Alignment
                                        .bottomRight,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: profileImage.isNotEmpty ?
                                        Center(
                                          child:
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            child: Image.network(
                                                '${profileImage}',
                                                fit: BoxFit.cover,
                                                width: 42,
                                                height: 42,
                                                loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : customProgressBar()),
                                          ),
                                        )
                                            : Image.asset(
                                            'assets/images/onboard/placeholder_image.png',
                                            width:
                                            42,
                                            height:
                                            42),
                                      ),
                                      // if (inboxList[
                                      // index]
                                      //     .onlineStatus ==
                                      //     1)
                                      //   Container(
                                      //     width: 12,
                                      //     height: 12,
                                      //     decoration: BoxDecoration(
                                      //         color: Colors
                                      //             .green,
                                      //         borderRadius:
                                      //         BorderRadius.all(
                                      //             Radius.circular(50))),
                                      //   )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width *
                                              0.5,
                                          child:
                                          MyString
                                              .med(
                                            senderIsMe
                                                ? _listChats[index].receiver!.name!
                                                : _listChats[index].sender!.name!,
                                            14,
                                            MyColor
                                                .redd,
                                            TextAlign
                                                .start,
                                          )),
                                      (_listChats[index]
                                          .lastMessage !=
                                          null)
                                          ? Container(
                                          width:
                                          200,
                                          child: MyString.medMultiLine(
                                              _listChats[index]
                                                  .lastMessage!.message!,
                                              12,
                                              MyColor.textBlack0,
                                              TextAlign.start,
                                              1))
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 30,
                                  child: (_listChats[
                                  index]
                                      .lastMessage !=
                                      null)
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
                                    children: [
                                      MyString.med(
                                          formatDateTime(_listChats[index]
                                              .createdAt
                                              .toString()),
                                          8,
                                          MyColor
                                              .textBlack0,
                                          TextAlign
                                              .center),
                                      // if (inboxList[index]
                                      //     .unreadcount !=
                                      //     0)
                                      //   Container(
                                      //     margin: EdgeInsets.only(
                                      //         top:
                                      //         3),
                                      //     width:
                                      //     20,
                                      //     height:
                                      //     20,
                                      //     alignment:
                                      //     Alignment.center,
                                      //     decoration: BoxDecoration(
                                      //         color:
                                      //         MyColor.orange2,
                                      //         borderRadius: const BorderRadius.all(Radius.circular(50))),
                                      //     child: MyString.med(
                                      //         inboxList[index].unreadcount.toString(),
                                      //         12,
                                      //         MyColor.white,
                                      //         TextAlign.center),
                                      //   ),
                                    ],
                                  )
                                      : SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : Transform(
              transform:
              Matrix4.translationValues(0, 120, 0),
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
                      child: MyString.reg(
                          'noDataFound'.tr,
                          12,
                          MyColor.textBlack0,
                          TextAlign.center)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllGroupChatsUINEW() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _listGroupChats.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _listGroupChats.length > 10 ? 10 : _listGroupChats.length,
                itemBuilder: (context, index) {
                  final user = _listGroupChats[index];
                  final currentUserID = int.parse(sharedPref.getString(SharedKey.userId)!);

                  final profileImage = user.groupIcon!;
                  return GestureDetector(
                    onLongPressStart: (value) {
                      _showCustomMenu(context,
                          value.globalPosition, index);
                    },
                    child: InkWell(
                      onTap: () async {

                        FocusManager
                            .instance.primaryFocus!
                            .unfocus();

                        Future.delayed(
                            Duration(milliseconds: 100),
                                () async {
                              await Navigator.pushNamed(
                                  context,
                                  RoutesName.groupChatScreen,
                                  arguments: {
                                    'group': user
                                  }
                              );
                            });
                      },
                      child: Container(
                        margin:
                        EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: MyColor.card,
                            borderRadius:
                            BorderRadius.circular(
                                15)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Stack(
                                    alignment: Alignment
                                        .bottomRight,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: profileImage.isNotEmpty ?
                                        Center(
                                          child:
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            child: Image.network(
                                                '${profileImage}',
                                                fit: BoxFit.cover,
                                                width: 42,
                                                height: 42,
                                                loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : customProgressBar()),
                                          ),
                                        )
                                            : Image.asset(
                                            'assets/images/onboard/placeholder_image.png',
                                            width:
                                            42,
                                            height:
                                            42),
                                      ),
                                      // if (inboxList[
                                      // index]
                                      //     .onlineStatus ==
                                      //     1)
                                      //   Container(
                                      //     width: 12,
                                      //     height: 12,
                                      //     decoration: BoxDecoration(
                                      //         color: Colors
                                      //             .green,
                                      //         borderRadius:
                                      //         BorderRadius.all(
                                      //             Radius.circular(50))),
                                      //   )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width *
                                              0.5,
                                          child:
                                          MyString
                                              .med(
                                            user.groupName!,
                                            14,
                                            MyColor
                                                .redd,
                                            TextAlign
                                                .start,
                                          )),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 30,
                                  child: (_listGroupChats[
                                  index]
                                      .createdAt !=
                                      null)
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
                                    children: [
                                      MyString.med(
                                          formatDateTime(_listGroupChats[index]
                                              .createdAt
                                              .toString()),
                                          8,
                                          MyColor
                                              .textBlack0,
                                          TextAlign
                                              .center),
                                      // if (inboxList[index]
                                      //     .unreadcount !=
                                      //     0)
                                      //   Container(
                                      //     margin: EdgeInsets.only(
                                      //         top:
                                      //         3),
                                      //     width:
                                      //     20,
                                      //     height:
                                      //     20,
                                      //     alignment:
                                      //     Alignment.center,
                                      //     decoration: BoxDecoration(
                                      //         color:
                                      //         MyColor.orange2,
                                      //         borderRadius: const BorderRadius.all(Radius.circular(50))),
                                      //     child: MyString.med(
                                      //         inboxList[index].unreadcount.toString(),
                                      //         12,
                                      //         MyColor.white,
                                      //         TextAlign.center),
                                      //   ),
                                    ],
                                  )
                                      : SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : Transform(
              transform:
              Matrix4.translationValues(0, 120, 0),
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
                      child: MyString.reg(
                          'noDataFound'.tr,
                          12,
                          MyColor.textBlack0,
                          TextAlign.center)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
