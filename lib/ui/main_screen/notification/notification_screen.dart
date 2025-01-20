import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/shared_pref.dart';

class NotificationScreen extends StatefulWidget {
  final int from;

  const NotificationScreen({super.key, required this.from});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

enum SampleItem { report, delete }

class _NotificationScreenState extends State<NotificationScreen> {
  SampleItem? selectedItem;
  final searchDelay = SearchDelayFunction();
  bool loader = true;
  var searchBar = TextEditingController();
  bool stackLoader = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await GetApi.getNotify(context, '');
      setState(() {

        loader = false;
        stackLoader = false;

      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.white,

        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    stackLoader = true;
                  });
                  await GetApi.getNotify(context, '');
                  setState(() {
                    stackLoader = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 31,
                                height: 31,
                                child: Image.asset(
                                  'assets/images/icons/prev.png',
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.pushNamed(context, RoutesName.friends);
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      'assets/images/icons/addfr.png',
                                      color: Color(0xff5B6170),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: 10,
                                ),


                                GestureDetector(
                                  onTap: () async {
                                    await changeLanguage(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset(
                                      'assets/images/icons/translation_login.png',
                                      color: Color(0xff4F2020),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: MyString.bold('notifications'.tr,
                            27, MyColor.title, TextAlign.center),
                      ),

                      //searching-bar
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(
                            bottom: 15, top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffEBEBEB)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5))),

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
                            suffixIcon: (searchBar.text.trim().toString().isNotEmpty)
                                ? GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        stackLoader = true;
                                        searchBar.text = '';
                                      });
                                      await GetApi.getNotify(context, '');
                                      setState(() {
                                        stackLoader = false;
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
                            setState(() {
                              stackLoader = true;
                            });
                            searchDelay.run(() async {
                              FocusManager.instance.primaryFocus!.unfocus();
                              if (value.isNotEmpty) {
                                await GetApi.getNotify(context, value);
                              }
                              if (value.isEmpty) {
                                await GetApi.getNotify(context, '');
                              }
                              setState(() {
                                stackLoader = false;
                              });
                            });
                          },
                        ),
                      ),

                      //card_Design
                      loader
                          ? Container(
                        height: MediaQuery.of(context).size.height/2,
                              child: progressBar(),
                            )
                          : GetApi.getNotification.data!.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: GetApi.getNotification.data!.length,
                                    padding: const EdgeInsets.only(top: 5, bottom: 50),
                                    itemBuilder: (context, index) {
                                      String mess = "";

                                      if (GetApi.getNotification.data![index].type == "ON_MESSAGE") {
                                        mess = GetApi.getNotification.data![index].senderRef!.name.toString() + ' ' + 'sendYouMess'.tr;
                                      }
                                      else if (GetApi.getNotification.data![index].type == "ON_FEED_COMMENT") {
                                        mess = GetApi.getNotification.data![index].senderRef!.name.toString() + ' ' + 'hasCommented'.tr;
                                      }
                                      else if (GetApi.getNotification.data![index].type == "ON_REPLY_COMMENT") {
                                        mess = GetApi.getNotification.data![index].senderRef!.name.toString() + ' ' + 'hasReplies'.tr;
                                      }
                                      else if (GetApi.getNotification.data![index].type == "ON_REPLY_TOPIC") {
                                        mess = GetApi.getNotification.data![index].senderRef!.name.toString() + ' ' + 'hasRepliesTopic'.tr;
                                      }
                                      else if (GetApi.getNotification.data![index].type == "ON_TOPIC_REPLY_LIKE") {
                                        mess = GetApi.getNotification.data![index].senderRef!.name.toString() + ' ' + 'likeTopic'.tr;
                                      }
                                      else if (GetApi.getNotification.data![index].type == "ON_USER_FOLLOW") {
                                        mess = GetApi.getNotification.data![index].senderRef!.name.toString() + ' ' + 'startFollow'.tr;
                                      }
                                      else if (GetApi.getNotification.data![index].type == "ON_FEED_LIKE") {
                                        mess = GetApi.getNotification.data![index].senderRef!.name.toString() + ' ' + 'feedLike'.tr;
                                      }

                                      return GestureDetector(
                                        onTap: () async {
                                          Map<String, dynamic> mapData = {'id': GetApi.getNotification.data![index].id.toString()};
                                          await AllApi.postMethodApi(ApiStrings.readNotification, mapData);

                                          if (GetApi.getNotification.data![index].tableId != 0) {
                                            if (GetApi.getNotification.data![index].type == 'ON_TOPIC_REPLY_LIKE') {
                                              if (GetApi.getNotification.data![index].payload != null) {
                                                Map<String, dynamic> mapping = {
                                                  'from': "notification_screen",
                                                  'topicTitle': GetApi.getNotification.data![index].payload!.title.toString(),
                                                  'forumId': int.parse(GetApi.getNotification.data![index].payload!.forumId.toString()),
                                                   'forumTopicId': int.parse(GetApi.getNotification.data![index].payload!.id.toString()),
                                                };
                                                await Navigator.pushNamed(context, RoutesName.forumReply, arguments: mapping);
                                              }
                                            }

                                            if (GetApi.getNotification.data![index].type == 'ON_REPLY_TOPIC') {
                                              if (GetApi.getNotification.data![index].payload != null) {
                                                Map<String, dynamic> mapping = {
                                                  'from': "notification_screen",
                                                  'topicTitle': GetApi.getNotification.data![index].payload!.title.toString(),
                                                  'forumId': int.parse(GetApi.getNotification.data![index].payload!.forumId.toString()),
                                                  'forumTopicId': int.parse(GetApi.getNotification.data![index].payload!.id.toString()),
                                                };
                                                await Navigator.pushNamed(context, RoutesName.forumReply, arguments: mapping);
                                              }
                                            }

                                            if (GetApi.getNotification.data![index].type == 'ON_FEED_COMMENT') {
                                              if (GetApi.getNotification.data![index].payload != null) {
                                                Map<String, dynamic> mapData = {'feedId': GetApi.getNotification.data![index].tableId.toString()};
                                                await Navigator.pushNamed(context, RoutesName.postDetail, arguments: mapData);
                                              }
                                            }

                                            if (GetApi.getNotification.data![index].type == 'ON_FEED_LIKE') {
                                              if (GetApi.getNotification.data![index].payload != null) {
                                                Map<String, dynamic> mapData = {'feedId': GetApi.getNotification.data![index].tableId.toString()};
                                                await Navigator.pushNamed(context, RoutesName.postDetail, arguments: mapData);
                                              }
                                            }

                                            if (GetApi.getNotification.data![index].type == 'ON_USER_FOLLOW') {
                                              if (GetApi.getNotification.data![index].payload != null) {
                                                Map<String, dynamic> mapData = {
                                                  'userID': GetApi.getNotification.data![index].senderRef!.id.toString()
                                                };
                                                Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                                              }
                                            }

                                            if (GetApi.getNotification.data![index].type == 'ON_MESSAGE') {
                                              if (GetApi.getNotification.data![index].payload != null) {
                                                Map<String, dynamic> mapData = {
                                                  'userId': GetApi.getNotification.data![index].payload!.senderId.toString(),
                                                  'userName': GetApi.getNotification.data![index].payload!.senderName.toString(),
                                                  'userImage': GetApi.getNotification.data![index].payload!.senderImage != null &&
                                                          GetApi.getNotification.data![index].payload!.senderImage.toString().isNotEmpty
                                                      ? '${ApiStrings.mediaURl}${GetApi.getNotification.data![index].payload!.senderImage.toString()}'
                                                      : '',
                                                  'myId': GetApi.getNotification.data![index].payload!.receiverId,
                                                  'myImage': sharedPref.getString(SharedKey.userprofilePic).toString().isEmpty
                                                      ? ""
                                                      : sharedPref.getString(SharedKey.userprofilePic).toString(),
                                                  'blockBy': '0',
                                                  'isBlock': 0,
                                                  'online': 0,
                                                  'groupId': "0",
                                                  'totalMember': ''
                                                };

                                                await Navigator.pushNamed(context, RoutesName.chatScreen, arguments: mapData);
                                              }
                                            }

                                            if (GetApi.getNotification.data![index].type == 'ON_REPLY_COMMENT') {
                                              if (GetApi.getNotification.data![index].payload != null) {
                                                Map<String, dynamic> mapData = {
                                                  'popUsed': false,
                                                  'feedId': GetApi.getNotification.data![index].payload!.feedId.toString(),
                                                  'parentId': GetApi.getNotification.data![index].payload!.replyId.toString(),
                                                  'userImage': sharedPref.getString(SharedKey.userprofilePic).toString().isEmpty
                                                      ? ""
                                                      : sharedPref.getString(SharedKey.userprofilePic).toString(),
                                                  'userId': sharedPref.getString(SharedKey.userId).toString(),
                                                  'userName': "",
                                                };

                                                await Navigator.pushNamed(context, RoutesName.replyScreen, arguments: mapData);
                                                setState(() {});
                                              }
                                            }
                                          }
                                          await GetApi.getNotify(context, '');
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 15, bottom: 5),
                                          decoration: BoxDecoration(

                                            color: GetApi.getNotification.data![index].isRead == 0 ? MyColor.card : MyColor.white,
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                //header
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child: ClipRRect(
                                                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                            child: GetApi.getNotification.data![index].senderRef!.profilePicture != null
                                                                ? Image.network(
                                                                    '${ApiStrings.mediaURl}${GetApi.getNotification.data![index].senderRef!.profilePicture.toString()}',
                                                                    width: 40,
                                                                    height: 40,
                                                                    fit: BoxFit.cover,
                                                                    loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                                                                        ? child
                                                                        : Image.asset(
                                                                            'assets/images/onboard/placeholder_image.png',
                                                                            width: 40,
                                                                            height: 40,
                                                                          ))
                                                                : Image.asset('assets/images/onboard/placeholder_image.png', width: 40, height: 40),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * .5,
                                                              child: MyString.boldMultiLine(GetApi.getNotification.data![index].senderRef!.name.toString(), 15,
                                                                  MyColor.redd, TextAlign.start,1),
                                                            ),
                                                            SizedBox(
                                                                width: MediaQuery.of(context).size.width * .5,
                                                                child: MyString.reg(mess, 13, MyColor.textBlack0, TextAlign.start)),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            width: 60,
                                                            margin: EdgeInsets.only(top: 23),
                                                            child: MyString.regMultiLine(GetApi.getNotification.data![index].createdAt.toString(), 13,
                                                                MyColor.red, TextAlign.center, 1)),
                                                      ],
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
                              : Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/onboard/placeholder_image.png',
                                        width: 120,
                                        height: 90,
                                      ),
                                      Container(
                                          width: double.infinity,
                                          child: MyString.reg('noNotification'.tr, 12, MyColor.textBlack0, TextAlign.center)),
                                    ],
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
              if (stackLoader) progressBar()
            ],
          ),
        ));
  }
}
