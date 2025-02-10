import 'dart:convert';
import 'dart:io';
import 'package:avispets/models/chats/all_users_discussion_model.dart';
import 'package:avispets/models/chats/typing_check.dart';
import 'package:avispets/models/chats/user_individual_chats_model.dart';
import 'package:avispets/utils/apis/connect_socket.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/aa_common_model.dart';
import '../../../models/chats/single_chat.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/common_function/video_edit.dart';
import '../../../utils/my_color.dart';
import 'group_info.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  ChatScreen({super.key, required this.mapData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

enum SampleItem { report, delete }

class _ChatScreenState extends State<ChatScreen> {
  SampleItem? selectedItem;
  bool isShowEmoji = false;
  var msgField = TextEditingController();
  final _focusNode = FocusNode();
  int page = 1;
  bool loader = true;
  bool bottomMsgField = true;
  bool bottomCamera = false;
  var searchBar = TextEditingController();
  UserIndividualChatsModel _userIndividualChatsModel = UserIndividualChatsModel();
  List<ChatModel> _listChats = [];

  SingleChat singleChat = SingleChat();
  TypingCheck typingCheck = TypingCheck();

  List<Message> chatList = [];
  final searchDelay = SearchDelayFunction();
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  File? galleryFile;
  final picker = ImagePicker();
  late UserDiscussion user;

  @override
  void initState() {
    super.initState();
    // GetApi.getNotify(context, '');
    if(widget.mapData != null){
      user = widget.mapData!['user'];
    }

    Future.delayed(Duration.zero, () async {
      getUserIndividualChats();
      registerUserListener();
      attachIndividualChatListener();

      // getSingleChat();
      // getSingleChatListener();
      // checkSocketConnect();

      // readMessage();
      // readMessageListener();

      // sendMessageListener();
      // typingSocketListener();
    });
  }

  @override
  void dispose() {
    socketOff('register');
    socketOff('send_individual_message');
    socketOff('receive_message');
    checkSocketConnect();
// socketOff('get_chat_listener');
    // socketOff('read_data_status');
    // socketOff('typing');
    // socketOff('delete_data');
    // socketOff('new_group_message');
    // socketOff('new_message');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            FocusManager.instance.primaryFocus!.unfocus();
            bottomMsgField = true;
            bottomCamera = false;
          });
        },
        child: _buildChatUINEW()
        // _buildChatUIOLD(),
      ),
    );
  }

  senderMessage(int index) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: MyColor.orange2,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    chatList[index].messageType == 0
                        ? Container(
                            padding: EdgeInsets.all(10),
                            constraints:
                                BoxConstraints(maxWidth: 250, minWidth: 40),
                            child: SelectableText.rich(TextSpan(
                              children: extractText(
                                  chatList[index].message.toString(),
                                  colorM: Colors.white),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: 'poppins_medium',
                              ),
                            )))
                        : chatList[index].messageType == 1 ||
                                chatList[index].messageType == 2 ||
                                chatList[index].messageType == 3
                            ? GestureDetector(
                                onTap: () {
                                  _focusNode.unfocus();
                                  if (!chatList[index]
                                      .mediaUrl
                                      .toString()
                                      .contains("giphy.com/media")) {
                                    Map<String, dynamic> mapping = {
                                      'mediaType': chatList[index].messageType,
                                      'image':
                                          '${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}',
                                    };

                                    debugPrint(
                                        'image inke 1 ${chatList[index].messageType}');
                                    debugPrint(
                                        'image inke 2 ${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}');
                                    Navigator.pushNamed(
                                        context, RoutesName.reviewScreen,
                                        arguments: mapping);
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(15),
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: ClipRRect(
                                      child: chatList[index].messageType == 1 &&
                                              !chatList[index]
                                                  .mediaUrl
                                                  .toString()
                                                  .contains('giphy.com/media')
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Image.network(
                                                  '${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}',
                                                  height: 150,
                                                  loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) =>
                                                      (loadingProgress == null)
                                                          ? child
                                                          : customProgressBar()),
                                            )
                                          : chatList[index].messageType == 3
                                              ? Container(
                                                  child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      height: 80,
                                                      width: 150,
                                                      color: MyColor.cardColor,
                                                      child: Image.asset(
                                                        'assets/images/onboard/placeholder_image.png',
                                                        width: 30,
                                                        height: 30,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.play_circle,
                                                      color: MyColor.orange2,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ))
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Image.network(
                                                      '${chatList[index].mediaUrl.toString()}',
                                                      height: 150,
                                                      loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) =>
                                                          (loadingProgress ==
                                                                  null)
                                                              ? child
                                                              : customProgressBar()),
                                                ),
                                    )))
                            : chatList[index].messageType == 99
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: (chatList[index].postData != null)
                                        ? InkWell(
                                            onTap: () {
                                              Map<String, dynamic> mapData = {
                                                'from': 'home',
                                                'feedId': chatList[index]
                                                    .postData!
                                                    .id
                                                    .toString(),
                                                'userId': chatList[index]
                                                    .postData!
                                                    .animal!
                                                    .id
                                                    .toString(),
                                              };
                                              Navigator.pushNamed(context,
                                                  RoutesName.postDetail,
                                                  arguments: mapData);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (chatList[index]
                                                                .postData!
                                                                .feedImages !=
                                                            null &&
                                                        chatList[index]
                                                            .postData!
                                                            .feedImages!
                                                            .isNotEmpty)
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        child: chatList[index]
                                                                .postData!
                                                                .feedImages![0]
                                                                .image!
                                                                .isNotEmpty
                                                            ? Image.network(
                                                                '${ApiStrings.mediaURl}${chatList[index].postData!.feedImages![0].image.toString()}',
                                                                height: 150,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder: (context,
                                                                        child,
                                                                        loadingProgress) =>
                                                                    (loadingProgress ==
                                                                            null)
                                                                        ? child
                                                                        : customProgressBar())
                                                            : Container(
                                                                color: MyColor
                                                                    .cardColor,
                                                                child: Center(
                                                                    child: Image.asset('assets/images/onboard/placeholder_image.png', width: 35, height: 35))),
                                                      )
                                                    : Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                top: 15),
                                                        child:
                                                            SelectableText.rich(
                                                                TextSpan(
                                                          children: extractText(
                                                              chatList[index]
                                                                  .postData!
                                                                  .description
                                                                  .toString(),
                                                              colorM: MyColor
                                                                  .black),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'poppins_medium',
                                                          ),
                                                        ))),
                                                const SizedBox(height: 15),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'name1'.tr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'poppins_medium',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                MyColor.black,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  ': ${chatList[index].postData!.animal!.name.toString()}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'poppins_medium',
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: MyColor
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'race'.tr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'poppins_medium',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                MyColor.black,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  ': ${chatList[index].postData!.animal!.race.toString()}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'poppins_medium',
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: MyColor
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: 'gender1'.tr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'poppins_medium',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                MyColor.black,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  ': ${chatList[index].postData!.animal!.gender.toString().toLowerCase().tr}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'poppins_medium',
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: MyColor
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          Map<String, dynamic>
                                                              mapData = {
                                                            'from': 'home',
                                                            'feedId':
                                                                chatList[index]
                                                                    .postData!
                                                                    .id
                                                                    .toString(),
                                                            'userId':
                                                                chatList[index]
                                                                    .postData!
                                                                    .animal!
                                                                    .id
                                                                    .toString(),
                                                          };
                                                          Navigator.pushNamed(
                                                              context,
                                                              RoutesName
                                                                  .postDetail,
                                                              arguments:
                                                                  mapData);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: MyColor
                                                                  .orange2,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/icons/send_icon.png",
                                                                height: 15,
                                                                width: 15,
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                if (chatList[index]
                                                    .message
                                                    .toString()
                                                    .isNotEmpty)
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      child:
                                                          SelectableText.rich(
                                                              TextSpan(
                                                        children: extractText(
                                                            chatList[index]
                                                                .message
                                                                .toString(),
                                                            colorM:
                                                                MyColor.black),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'poppins_medium',
                                                        ),
                                                      )))
                                              ],
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.only(
                                                left: 15, top: 15, right: 15),
                                            child: MyString.italic(
                                                'deleteSender'.tr,
                                                12,
                                                MyColor.black,
                                                TextAlign.start),
                                          ),
                                  )
                                : Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 250, minWidth: 40),
                                    child: SelectableText.rich(TextSpan(
                                      children: extractText(
                                          chatList[index].message.toString(),
                                          colorM: Colors.black),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'poppins_medium',
                                      ),
                                    ))),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: MyString.medMultiLine(
                          timeValues(chatList[index].created.toString()),
                          8,
                          MyColor.white,
                          TextAlign.start,
                          3),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: chatList[index].senderImage != null &&
                      chatList[index].senderImage.toString().isNotEmpty
                  ? Image.network(
                      '${ApiStrings.mediaURl}${chatList[index].senderImage.toString()}',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/onboard/placeholder_image.png',
                      width: 35,
                      height: 35,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  senderMessageNew(int index) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: MyColor.orange2,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _listChats[index].messageType == 'text'
                        ? Container(
                        padding: EdgeInsets.all(10),
                        constraints:
                        BoxConstraints(maxWidth: 250, minWidth: 40),
                        child: SelectableText.rich(TextSpan(
                          children: extractText(
                              _listChats[index].message.toString(),
                              colorM: Colors.white),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'poppins_medium',
                          ),
                        )))
                        : _listChats[index].messageType == 'image'
                        ? GestureDetector(
                        onTap: () {
                          _focusNode.unfocus();
                          // if (!chatList[index]
                          //     .mediaUrl
                          //     .toString()
                          //     .contains("giphy.com/media")) {
                          //   Map<String, dynamic> mapping = {
                          //     'mediaType': chatList[index].messageType,
                          //     'image':
                          //     '${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}',
                          //   };
                          //
                          //   debugPrint(
                          //       'image inke 1 ${chatList[index].messageType}');
                          //   debugPrint(
                          //       'image inke 2 ${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}');
                          //   Navigator.pushNamed(
                          //       context, RoutesName.reviewScreen,
                          //       arguments: mapping);
                          // }
                        },
                        child: Container(
                            padding: EdgeInsets.all(15),
                            margin: const EdgeInsets.only(
                                top: 5, bottom: 5),
                            child: ClipRRect(
                              child: SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.65,
                                child: Image.network(
                                    '${_listChats[index].message}',
                                    height: 150,
                                    loadingBuilder: (context,
                                        child,
                                        loadingProgress) =>
                                    (loadingProgress == null)
                                        ? child
                                        : customProgressBar()),
                              )
                            )
                        ))
                        : chatList[index].messageType == 99
                        ? Container(
                      width: MediaQuery.of(context).size.width *
                          0.65,
                      child: (chatList[index].postData != null)
                          ? InkWell(
                        onTap: () {
                          Map<String, dynamic> mapData = {
                            'from': 'home',
                            'feedId': chatList[index]
                                .postData!
                                .id
                                .toString(),
                            'userId': chatList[index]
                                .postData!
                                .animal!
                                .id
                                .toString(),
                          };
                          Navigator.pushNamed(context,
                              RoutesName.postDetail,
                              arguments: mapData);
                        },
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            (chatList[index]
                                .postData!
                                .feedImages !=
                                null &&
                                chatList[index]
                                    .postData!
                                    .feedImages!
                                    .isNotEmpty)
                                ? ClipRRect(
                              borderRadius:
                              BorderRadius.only(
                                  topLeft: Radius
                                      .circular(
                                      10),
                                  topRight: Radius
                                      .circular(
                                      10)),
                              child: chatList[index]
                                  .postData!
                                  .feedImages![0]
                                  .image!
                                  .isNotEmpty
                                  ? Image.network(
                                  '${ApiStrings.mediaURl}${chatList[index].postData!.feedImages![0].image.toString()}',
                                  height: 150,
                                  width: double
                                      .infinity,
                                  fit: BoxFit
                                      .cover,
                                  loadingBuilder: (context,
                                      child,
                                      loadingProgress) =>
                                  (loadingProgress ==
                                      null)
                                      ? child
                                      : customProgressBar())
                                  : Container(
                                  color: MyColor
                                      .cardColor,
                                  child: Center(
                                      child: Image.asset('assets/images/onboard/placeholder_image.png', width: 35, height: 35))),
                            )
                                : Container(
                                padding:
                                EdgeInsets.only(
                                    left: 15,
                                    top: 15),
                                child:
                                SelectableText.rich(
                                    TextSpan(
                                      children: extractText(
                                          chatList[index]
                                              .postData!
                                              .description
                                              .toString(),
                                          colorM: MyColor
                                              .black),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily:
                                        'poppins_medium',
                                      ),
                                    ))),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'name1'.tr,
                                      style: TextStyle(
                                        fontFamily:
                                        'poppins_medium',
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400,
                                        color:
                                        MyColor.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          ': ${chatList[index].postData!.animal!.name.toString()}',
                                          style: TextStyle(
                                            fontFamily:
                                            'poppins_medium',
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight
                                                .w400,
                                            color: MyColor
                                                .black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'race'.tr,
                                      style: TextStyle(
                                        fontFamily:
                                        'poppins_medium',
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400,
                                        color:
                                        MyColor.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          ': ${chatList[index].postData!.animal!.race.toString()}',
                                          style: TextStyle(
                                            fontFamily:
                                            'poppins_medium',
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight
                                                .w400,
                                            color: MyColor
                                                .black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'gender1'.tr,
                                      style: TextStyle(
                                        fontFamily:
                                        'poppins_medium',
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400,
                                        color:
                                        MyColor.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          ': ${chatList[index].postData!.animal!.gender.toString().toLowerCase().tr}',
                                          style: TextStyle(
                                            fontFamily:
                                            'poppins_medium',
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight
                                                .w400,
                                            color: MyColor
                                                .black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 10),
                                  InkWell(
                                    onTap: () {
                                      Map<String, dynamic>
                                      mapData = {
                                        'from': 'home',
                                        'feedId':
                                        chatList[index]
                                            .postData!
                                            .id
                                            .toString(),
                                        'userId':
                                        chatList[index]
                                            .postData!
                                            .animal!
                                            .id
                                            .toString(),
                                      };
                                      Navigator.pushNamed(
                                          context,
                                          RoutesName
                                              .postDetail,
                                          arguments:
                                          mapData);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: MyColor
                                              .orange2,
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              50)),
                                      child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                              horizontal:
                                              10,
                                              vertical:
                                              5),
                                          child:
                                          Image.asset(
                                            "assets/images/icons/send_icon.png",
                                            height: 15,
                                            width: 15,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (chatList[index]
                                .message
                                .toString()
                                .isNotEmpty)
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 15),
                                  child:
                                  SelectableText.rich(
                                      TextSpan(
                                        children: extractText(
                                            chatList[index]
                                                .message
                                                .toString(),
                                            colorM:
                                            MyColor.black),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontFamily:
                                          'poppins_medium',
                                        ),
                                      )))
                          ],
                        ),
                      )
                          : Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15),
                        child: MyString.italic(
                            'deleteSender'.tr,
                            12,
                            MyColor.black,
                            TextAlign.start),
                      ),
                    )
                        : Container(
                        constraints: BoxConstraints(
                            maxWidth: 250, minWidth: 40),
                        child: SelectableText.rich(TextSpan(
                          children: extractText(
                              chatList[index].message.toString(),
                              colorM: Colors.black),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'poppins_medium',
                          ),
                        ))),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: MyString.medMultiLine(
                          formatDateTime(_listChats[index].createdAt.toString()),
                          8,
                          MyColor.white,
                          TextAlign.start,
                          3),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: _listChats[index].sender != null && _listChats[index].sender!.profilePicture != null &&
                  _listChats[index].sender!.profilePicture!.contains('http')
                  ? Image.network(
                '${_listChats[index].sender!.profilePicture}',
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/onboard/placeholder_image.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }


  receiverMessage(int index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Map<String, dynamic> mapData = {
                'userID': chatList[index].senderId.toString()
              };
              Navigator.pushNamed(context, RoutesName.myProfile,
                  arguments: mapData);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: chatList[index].senderImage != null &&
                      chatList[index].senderImage.toString().isNotEmpty
                  ? Image.network(
                      '${ApiStrings.mediaURl}${chatList[index].senderImage.toString()}',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/onboard/placeholder_image.png',
                      width: 35,
                      height: 35,
                    ),
            ),
          ),
          const SizedBox(width: 3),
          Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chatList[index].messageType == 0
                    ? Container(
                        padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                        constraints:
                            BoxConstraints(maxWidth: 250, minWidth: 40),
                        child: SelectableText.rich(TextSpan(
                          children: extractText(
                              chatList[index].message.toString(),
                              colorM: MyColor.textBlack0),
                          style: TextStyle(
                            fontSize: 12,
                            color: MyColor.textBlack0,
                            fontFamily: 'poppins_medium',
                          ),
                        )))
                    : chatList[index].messageType == 1 ||
                            chatList[index].messageType == 2 ||
                            chatList[index].messageType == 3
                        ? GestureDetector(
                            onTap: () {
                              _focusNode.unfocus();
                              if (!chatList[index]
                                  .mediaUrl
                                  .toString()
                                  .contains("giphy.com/media")) {
                                Map<String, dynamic> mapping = {
                                  'mediaType': chatList[index].messageType,
                                  'image':
                                      '${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}',
                                };

                                debugPrint(
                                    'image inke 1 ${chatList[index].messageType}');
                                debugPrint(
                                    'image inke 2 ${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}');
                                Navigator.pushNamed(
                                    context, RoutesName.reviewScreen,
                                    arguments: mapping);
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 15, top: 15, right: 15),
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: ClipRRect(
                                  child: chatList[index].messageType == 1 &&
                                          !chatList[index]
                                              .mediaUrl
                                              .toString()
                                              .contains('giphy.com/media')
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Image.network(
                                              '${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}',
                                              height: 150,
                                              loadingBuilder: (context, child,
                                                      loadingProgress) =>
                                                  (loadingProgress == null)
                                                      ? child
                                                      : customProgressBar()),
                                        )
                                      : chatList[index].messageType == 3
                                          ? Container(
                                              child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: 80,
                                                  width: 150,
                                                  color: MyColor.cardColor,
                                                  child: Image.asset(
                                                    'assets/images/onboard/placeholder_image.png',
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.play_circle,
                                                  color: MyColor.orange2,
                                                  size: 30,
                                                ),
                                              ],
                                            ))
                                          : SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Image.network(
                                                  '${chatList[index].mediaUrl.toString()}',
                                                  height: 150,
                                                  loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) =>
                                                      (loadingProgress == null)
                                                          ? child
                                                          : customProgressBar()),
                                            ),
                                )))
                        : chatList[index].messageType == 99
                            ? (chatList[index].postData != null)
                                ? InkWell(
                                    onTap: () {
                                      Map<String, dynamic> mapData = {
                                        'from': 'home',
                                        'feedId': chatList[index]
                                            .postData!
                                            .id
                                            .toString(),
                                        'userId': chatList[index]
                                            .postData!
                                            .animal!
                                            .id
                                            .toString(),
                                      };
                                      Navigator.pushNamed(
                                          context, RoutesName.postDetail,
                                          arguments: mapData);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          (chatList[index]
                                                          .postData!
                                                          .feedImages !=
                                                      null &&
                                                  chatList[index]
                                                      .postData!
                                                      .feedImages!
                                                      .isNotEmpty)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  child: chatList[index]
                                                          .postData!
                                                          .feedImages![0]
                                                          .image!
                                                          .isNotEmpty
                                                      ? Image.network('${ApiStrings.mediaURl}${chatList[index].postData!.feedImages![0].image.toString()}',
                                                          height: 150,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                                  child,
                                                                  loadingProgress) =>
                                                              (loadingProgress == null)
                                                                  ? child
                                                                  : customProgressBar())
                                                      : Container(
                                                          color:
                                                              MyColor.cardColor,
                                                          child: Center(
                                                              child: Image.asset(
                                                                  'assets/images/onboard/placeholder_image.png',
                                                                  width: 35,
                                                                  height: 35))),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15, top: 15),
                                                  child: SelectableText.rich(
                                                      TextSpan(
                                                    children: extractText(
                                                        chatList[index]
                                                            .postData!
                                                            .description
                                                            .toString(),
                                                        colorM: MyColor.black),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'poppins_medium',
                                                    ),
                                                  ))),
                                          const SizedBox(height: 15),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'name1'.tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'poppins_medium',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: MyColor.divideLine,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            ': ${chatList[index].postData!.animal!.name.toString()}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'poppins_medium',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: MyColor
                                                              .divideLine,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'race'.tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'poppins_medium',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: MyColor.divideLine,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            ': ${chatList[index].postData!.animal!.race.toString()}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'poppins_medium',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: MyColor
                                                              .divideLine,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'gender1'.tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'poppins_medium',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: MyColor.divideLine,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            ': ${chatList[index].postData!.animal!.gender.toString().toLowerCase().tr}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'poppins_medium',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: MyColor
                                                              .divideLine,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                InkWell(
                                                  onTap: () {
                                                    Map<String, dynamic>
                                                        mapData = {
                                                      'from': 'home',
                                                      'feedId': chatList[index]
                                                          .postData!
                                                          .id
                                                          .toString(),
                                                      'userId': chatList[index]
                                                          .postData!
                                                          .animal!
                                                          .id
                                                          .toString(),
                                                    };
                                                    Navigator.pushNamed(context,
                                                        RoutesName.postDetail,
                                                        arguments: mapData);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: MyColor.orange2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          MyString.med(
                                                              "view".tr,
                                                              10,
                                                              Colors.white,
                                                              TextAlign.center),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Image.asset(
                                                            "assets/images/icons/send_icon.png",
                                                            height: 15,
                                                            width: 15,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          if (chatList[index]
                                              .message
                                              .toString()
                                              .isNotEmpty)
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: SelectableText.rich(
                                                    TextSpan(
                                                  children: extractText(
                                                      chatList[index]
                                                          .message
                                                          .toString(),
                                                      colorM:
                                                          MyColor.divideLine),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'poppins_medium',
                                                  ),
                                                )))
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(
                                        left: 15, top: 15, right: 15),
                                    child: MyString.italic(
                                        'deleteReveicer'.tr,
                                        12,
                                        MyColor.divideLine,
                                        TextAlign.start),
                                  )
                            : Container(
                                constraints:
                                    BoxConstraints(maxWidth: 250, minWidth: 40),
                                child: SelectableText.rich(TextSpan(
                                  children: extractText(
                                      chatList[index].message.toString(),
                                      colorM: MyColor.white),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: 'poppins_medium',
                                  ),
                                ))),
                Padding(
                  padding:
                      EdgeInsets.only(left: 15, bottom: 8, top: 5, right: 15),
                  child: MyString.med(
                      timeValues(chatList[index].created.toString()),
                      8,
                      MyColor.textBlack0,
                      TextAlign.start),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  receiverMessageNew(int index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Map<String, dynamic> mapData = {
                'userID': chatList[index].senderId.toString()
              };
              Navigator.pushNamed(context, RoutesName.myProfile,
                  arguments: mapData);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: _listChats[index].sender!.profilePicture != null &&
                  _listChats[index].sender!.profilePicture!.contains('http')
                  ? Image.network(
                '${_listChats[index].sender!.profilePicture!}',
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/onboard/placeholder_image.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
          const SizedBox(width: 3),
          Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _listChats[index].messageType == 'text'
                    ? Container(
                    padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                    constraints:
                    BoxConstraints(maxWidth: 250, minWidth: 40),
                    child: SelectableText.rich(TextSpan(
                      children: extractText(
                          _listChats[index].message.toString(),
                          colorM: MyColor.textBlack0),
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColor.textBlack0,
                        fontFamily: 'poppins_medium',
                      ),
                    )))
                    : chatList[index].messageType == 1 ||
                    chatList[index].messageType == 2 ||
                    chatList[index].messageType == 3
                    ? GestureDetector(
                    onTap: () {
                      _focusNode.unfocus();
                      // if (!chatList[index]
                      //     .mediaUrl
                      //     .toString()
                      //     .contains("giphy.com/media")) {
                      //   Map<String, dynamic> mapping = {
                      //     'mediaType': chatList[index].messageType,
                      //     'image':
                      //     '${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}',
                      //   };
                      //
                      //   debugPrint(
                      //       'image inke 1 ${chatList[index].messageType}');
                      //   debugPrint(
                      //       'image inke 2 ${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}');
                      //   Navigator.pushNamed(
                      //       context, RoutesName.reviewScreen,
                      //       arguments: mapping);
                      // }
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15),
                        margin:
                        const EdgeInsets.only(top: 5, bottom: 5),
                        child: ClipRRect(
                          child: chatList[index].messageType == 1 &&
                              !chatList[index]
                                  .mediaUrl
                                  .toString()
                                  .contains('giphy.com/media')
                              ? SizedBox(
                            width: MediaQuery.of(context)
                                .size
                                .width *
                                0.65,
                            child: Image.network(
                                '${ApiStrings.mediaURl}${chatList[index].mediaUrl.toString()}',
                                height: 150,
                                loadingBuilder: (context, child,
                                    loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : customProgressBar()),
                          )
                              : chatList[index].messageType == 3
                              ? Container(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 150,
                                    color: MyColor.cardColor,
                                    child: Image.asset(
                                      'assets/images/onboard/placeholder_image.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  Icon(
                                    Icons.play_circle,
                                    color: MyColor.orange2,
                                    size: 30,
                                  ),
                                ],
                              ))
                              : SizedBox(
                            width: MediaQuery.of(context)
                                .size
                                .width *
                                0.65,
                            child: Image.network(
                                '${chatList[index].mediaUrl.toString()}',
                                height: 150,
                                loadingBuilder: (context,
                                    child,
                                    loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : customProgressBar()),
                          ),
                        )))
                    : chatList[index].messageType == 99
                    ? (chatList[index].postData != null)
                    ? InkWell(
                  onTap: () {
                    Map<String, dynamic> mapData = {
                      'from': 'home',
                      'feedId': chatList[index]
                          .postData!
                          .id
                          .toString(),
                      'userId': chatList[index]
                          .postData!
                          .animal!
                          .id
                          .toString(),
                    };
                    Navigator.pushNamed(
                        context, RoutesName.postDetail,
                        arguments: mapData);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.65,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: [
                        (chatList[index]
                            .postData!
                            .feedImages !=
                            null &&
                            chatList[index]
                                .postData!
                                .feedImages!
                                .isNotEmpty)
                            ? ClipRRect(
                          borderRadius:
                          BorderRadius.only(
                              topLeft:
                              Radius.circular(
                                  10),
                              topRight:
                              Radius.circular(
                                  10)),
                          child: chatList[index]
                              .postData!
                              .feedImages![0]
                              .image!
                              .isNotEmpty
                              ? Image.network('${ApiStrings.mediaURl}${chatList[index].postData!.feedImages![0].image.toString()}',
                              height: 150,
                              width:
                              double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context,
                                  child,
                                  loadingProgress) =>
                              (loadingProgress == null)
                                  ? child
                                  : customProgressBar())
                              : Container(
                              color:
                              MyColor.cardColor,
                              child: Center(
                                  child: Image.asset(
                                      'assets/images/onboard/placeholder_image.png',
                                      width: 35,
                                      height: 35))),
                        )
                            : Container(
                            padding: EdgeInsets.only(
                                left: 15, top: 15),
                            child: SelectableText.rich(
                                TextSpan(
                                  children: extractText(
                                      chatList[index]
                                          .postData!
                                          .description
                                          .toString(),
                                      colorM: MyColor.black),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily:
                                    'poppins_medium',
                                  ),
                                ))),
                        const SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'name1'.tr,
                                  style: TextStyle(
                                    fontFamily:
                                    'poppins_medium',
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w400,
                                    color: MyColor.divideLine,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                      ': ${chatList[index].postData!.animal!.name.toString()}',
                                      style: TextStyle(
                                        fontFamily:
                                        'poppins_medium',
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400,
                                        color: MyColor
                                            .divideLine,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'race'.tr,
                                  style: TextStyle(
                                    fontFamily:
                                    'poppins_medium',
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w400,
                                    color: MyColor.divideLine,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                      ': ${chatList[index].postData!.animal!.race.toString()}',
                                      style: TextStyle(
                                        fontFamily:
                                        'poppins_medium',
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400,
                                        color: MyColor
                                            .divideLine,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'gender1'.tr,
                                  style: TextStyle(
                                    fontFamily:
                                    'poppins_medium',
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w400,
                                    color: MyColor.divideLine,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                      ': ${chatList[index].postData!.animal!.gender.toString().toLowerCase().tr}',
                                      style: TextStyle(
                                        fontFamily:
                                        'poppins_medium',
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400,
                                        color: MyColor
                                            .divideLine,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Map<String, dynamic>
                                  mapData = {
                                    'from': 'home',
                                    'feedId': chatList[index]
                                        .postData!
                                        .id
                                        .toString(),
                                    'userId': chatList[index]
                                        .postData!
                                        .animal!
                                        .id
                                        .toString(),
                                  };
                                  Navigator.pushNamed(context,
                                      RoutesName.postDetail,
                                      arguments: mapData);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: MyColor.orange2,
                                      borderRadius:
                                      BorderRadius
                                          .circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal: 10,
                                        vertical: 5),
                                    child: Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        MyString.med(
                                            "view".tr,
                                            10,
                                            Colors.white,
                                            TextAlign.center),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          "assets/images/icons/send_icon.png",
                                          height: 15,
                                          width: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (chatList[index]
                            .message
                            .toString()
                            .isNotEmpty)
                          Container(
                              padding:
                              EdgeInsets.only(left: 15),
                              child: SelectableText.rich(
                                  TextSpan(
                                    children: extractText(
                                        chatList[index]
                                            .message
                                            .toString(),
                                        colorM:
                                        MyColor.divideLine),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontFamily:
                                      'poppins_medium',
                                    ),
                                  )))
                      ],
                    ),
                  ),
                )
                    : Container(
                  padding: EdgeInsets.only(
                      left: 15, top: 15, right: 15),
                  child: MyString.italic(
                      'deleteReveicer'.tr,
                      12,
                      MyColor.divideLine,
                      TextAlign.start),
                )
                    : Container(
                    constraints:
                    BoxConstraints(maxWidth: 250, minWidth: 40),
                    child: SelectableText.rich(TextSpan(
                      children: extractText(
                          chatList[index].message.toString(),
                          colorM: MyColor.white),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'poppins_medium',
                      ),
                    ))),
                Padding(
                  padding:
                  EdgeInsets.only(left: 15, bottom: 8, top: 5, right: 15),
                  child: MyString.med(
                      formatDateTime(_listChats[index].createdAt.toString()),
                      8,
                      MyColor.textBlack0,
                      TextAlign.start),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _openGiphyGet(int type) async {
    GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      apiKey: ApiStrings.gifKey,
      lang: GiphyLanguage.english,
      searchText: '',
      modal: true,
      showGIFs: type == 0 ? true : false,
      showEmojis: false,
      showStickers: type == 1 ? true : false,
    );

    print("GIF-IMAGE ${gif!.images!.original!.url}");

    sendMessage('', gif.images!.original!.url.toString(), 1); // gif

    setState(() {});
  }

  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
      allowCompression: true,
    );
    if (result != null) {
      String filePathWithBrackets = result.paths.toString();
      String filePath =
          filePathWithBrackets.substring(1, filePathWithBrackets.length - 1);
      if (filePath.endsWith('.mp4')) {
        print('RESULT IS  ::: ${filePath}');

        var res = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    VideoEditor1(file: File(filePath))));
        LoadingDialog.show(context);
        var res1 = await AllApi.onlyImage(res.toString());
        var result = jsonDecode(res1);
        LoadingDialog.hide(context);
        debugPrint('UPLOAD_IMAGE RESULT $result');
        if (result['status'] == 200) {
          setState(() {
            sendMessage('', result['data'].toString(), 1); // image
          });
        }
      } else {
        _pickedFile = XFile(filePath);
        if (_pickedFile != null) {
          setState(() {
            _pickedFile = _pickedFile;
            _cropImage();
          });
        }
      }
      setState(() {});
    } else {
      print('RESULT IS ELSE  ::: $result');
    }
  }

  cameraSelection() {
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logos/camera2.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  MyString.bold('selectAnyOption'.tr, 20, MyColor.black,
                      TextAlign.center),
                  const SizedBox(height: 15),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        pickImage(ImageSource.camera);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                              color: MyColor.orange2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: MyString.med('choosePicture'.tr, 20,
                              MyColor.white, TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        getVideo(ImageSource.camera);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                              color: MyColor.orange2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: MyString.med('chooseVideo'.tr, 20,
                              MyColor.white, TextAlign.center),
                        ),
                      ),
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

  Future pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _cropImage();
      });
    }
  }

  Future<void> getVideo(ImageSource img) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 2));
    XFile? xFilePick = pickedFile;
    if (xFilePick != null) {
      galleryFile = File(pickedFile!.path);

      LoadingDialog.show(context);
      var res = await AllApi.onlyImage(galleryFile!.path.toString());
      var result = jsonDecode(res);
      LoadingDialog.hide(context);
      debugPrint('UPLOAD_IMAGE RESULT $result');
      if (result['status'] == 200) {
        sendMessage('', result['data'].toString(), 3); //video
      }

      galleryFile = null;
    } else {}
    setState(
      () {},
    );
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'cropImage'.tr,
            toolbarColor: MyColor.cardColor,
            hideBottomControls: true,
            toolbarWidgetColor: MyColor.orange2,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Cropper'),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.page,
            size: const CropperSize(
              width: 200,
              height: 200,
            ),
            //viewPort: const CroppieViewPort(width: 480, height: 200, type: 'circle'),
          ),
        ],
      );
      if (croppedFile != null) {
        _croppedFile = croppedFile;

        var result1 = await FlutterImageCompress.compressWithFile(
          File(_croppedFile!.path).absolute.path,
          minWidth: 2300,
          minHeight: 1500,
          quality: 85, // Adjust the quality as needed, 0 - 100
        );

        // Storing the compressed image
        if (result1 != null) {
          final directory = await getApplicationDocumentsDirectory();
          final compressedImagePath = '${directory.path}/compressed_image.jpg';
          final compressedImageFile = File(compressedImagePath)
            ..writeAsBytesSync(result1);
          setState(() {
            galleryFile = compressedImageFile;
          });
        }
        print('COMPRESSED IMAGE ::  ${galleryFile}');

        // galleryFile = File(_croppedFile!.path.toString());

        LoadingDialog.show(context);
        var res = await AllApi.uploadChatImage(galleryFile!.path.toString());
        // var res = await AllApi.onlyImage(galleryFile!.path.toString());
        var result = jsonDecode(res);
        LoadingDialog.hide(context);
        debugPrint('UPLOAD_IMAGE RESULT $result');
        if (result['status'] == 200) {
          sendIndividualMessage(result['data']['imageUrl'].toString(), 'image');
          // sendMessage('', result['data'].toString(), 1); // image
        }
        setState(() {});
      } else {
        setState(() {});
      }
    }
  }

  CommonModel commonModel = CommonModel();

  moreOption(String endUrl, int type) async {
    Map<String, dynamic> mapData = {
      'userId': widget.mapData!['userId'].toString(),
    };
    var res = await AllApi.postMethodApi(endUrl, mapData);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      commonModel = CommonModel.fromJson(result);
      toaster(context, result['message'].toString());

      if (type == 1) {
        chatList.clear();
      }

      if (type == 2) {
        widget.mapData!['isBlock'] = widget.mapData!['isBlock'] == 0 ? 1 : 0;
        bottomMsgField = true;
      }

      setState(() {});
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['message'].toString());
    }
  }

  delete(int type) {
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
                border: Border.all(color: MyColor.orange2),
                borderRadius: BorderRadiusDirectional.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icons/del2.png',
                      width: 60, height: 60),
                  if (type == 1)
                    MyString.bold('clearConversation'.tr, 20, MyColor.redd,
                        TextAlign.center),
                  const SizedBox(height: 10),
                  if (type == 1)
                    MyString.med('clearConversationDesc'.tr, 12,
                        MyColor.textBlack0, TextAlign.center),
                  if (type == 2 && widget.mapData!['isBlock'] == 0)
                    MyString.bold(
                        'blockUser'.tr, 20, MyColor.redd, TextAlign.center),
                  const SizedBox(height: 10),
                  if (type == 2 && widget.mapData!['isBlock'] == 1)
                    MyString.bold(
                        'unblockUser'.tr, 20, MyColor.redd, TextAlign.center),
                  const SizedBox(height: 10),
                  if (type == 2 && widget.mapData!['isBlock'] == 0)
                    MyString.med('blockUserDesc'.tr, 12, MyColor.textBlack0,
                        TextAlign.center),
                  if (type == 2 && widget.mapData!['isBlock'] == 1)
                    MyString.med('unblockUserDesc'.tr, 12, MyColor.textBlack0,
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
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 59,
                              decoration: BoxDecoration(
                                  color: MyColor.bgColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(22))),
                              child: MyString.med('no'.tr, 16, MyColor.orange2,
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
                            if (type == 1) {
                              setState(() {
                                loader = true;
                              });
                              clearIndividualChat();
                              // clearChatSocket();
                              // clearChatSocketListener();
                            } else {
                              // await moreOption(ApiStrings.blockUnblockUser, type);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 59,
                              decoration: BoxDecoration(
                                  color: MyColor.orange2,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(22))),
                              child: MyString.med('yes'.tr, 16, MyColor.white,
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

  typingSocket(int type) {
    Map mapping = {
      "senderId": sharedPref.getString(SharedKey.userId).toString(),
      "receiverId": (widget.mapData!['groupId'] != "0")
          ? widget.mapData!['groupId'].toString()
          : widget.mapData!['userId'].toString(),
      "groupId": widget.mapData!['groupId'].toString(),
      "type": type
    };

    debugPrint("typing socket  ==> $mapping");
    socket.emit('typing', mapping);
  }

  typingSocketListener() {
    socket.on('typing', (newMessage) {
      setState(() {
        debugPrint("typing socket  ==> $newMessage");
        typingCheck = TypingCheck.fromJson(newMessage);
      });
    });
  }

  getSingleChat() {
    Map mapping = {
      "senderId": sharedPref.getString(SharedKey.userId).toString(),
      "receiverId": (widget.mapData!['groupId'] != "0")
          ? "0"
          : widget.mapData!['userId'].toString(),
      "groupId": (widget.mapData!['groupId'] != "0")
          ? widget.mapData!['groupId'].toString()
          : "0"
    };

    socket.emit('get_chat', mapping);
    debugPrint("CHAT_LISTENER => $mapping");
  }

  getSingleChatListener() {
    socket.on('get_chat_listener', (newMessage) {
      setState(() {
        debugPrint("CHAT_LISTENER ==> $newMessage");
        chatList.clear();
        singleChat = SingleChat.fromJson(newMessage);

        for (int i = 0; i < singleChat.message!.length; i++) {
          chatList.add(singleChat.message![i]);
        }

        debugPrint("CHAT_LISTENER ===> $singleChat");
        loader = false;
      });
    });
  }

  readMessage() {
    Map mapping;
    if (widget.mapData!['groupId'].toString() != "0") {
      mapping = {
        "userId": widget.mapData!['myId'].toString(),
        "groupId": widget.mapData!['groupId'].toString()
      };
    } else {
      mapping = {
        "userId": widget.mapData!['myId'].toString(),
        "user2Id": widget.mapData!['userId'].toString()
      };
    }
    socket.emit(
        (widget.mapData!['groupId'].toString() != "0")
            ? "read_group_chat"
            : 'read_unread',
        mapping);
    debugPrint("CHAT_LISTENER read=> $mapping");
  }

  readMessageListener() {
    socket.on('read_data_status', (newMessage) {
      setState(() {});
    });
  }

  sendMessage(String msg, String media, int type) {
    Map mapping = {
      "senderId": sharedPref.getString(SharedKey.userId).toString(),
      "receiverId": (widget.mapData!['groupId'].toString() != "0")
          ? "0"
          : widget.mapData!['userId'].toString(),
      "messageType": type
          .toString(), //0 :default, 1:image , 2:audio  3:video  4: post_shared
      "groupId": widget.mapData!['groupId'].toString(),
      "message": msg,
      "mediaUrl": media,
      "postId": 0,
    };
    socket.emit('send_message', mapping);
  }

  sendMessageListener() {
    socket.on(
        (widget.mapData!['groupId'].toString() != "0")
            ? "new_group_message"
            : 'new_message', (newMessage) {
      debugPrint("SEND_MESSAGE ==> $newMessage");

      String receiverId = newMessage['receiverId'].toString();
      String senderId = newMessage['senderId'].toString();
      String groupId = newMessage['groupId'].toString();

      debugPrint("111111111111 ==> ${receiverId}");
      debugPrint("11111111111 ==> ${senderId}");
      debugPrint("11111111111 ==> ${groupId}");

      debugPrint("222222222222 ==> ${widget.mapData!['userId'].toString()}");
      debugPrint("222222222222 ==> ${widget.mapData!['myId'].toString()}");
      debugPrint("222222222222 ==> ${widget.mapData!['groupId'].toString()}");

      if (widget.mapData!['groupId'].toString() != "0") {
        if (groupId.toString() == widget.mapData!['groupId'].toString()) {
          Message list = Message.fromJson(newMessage);
          chatList.insert(0, list);
          debugPrint("SEND_MESSAGE Full ==> $singleChat");
          if (this.mounted) {
            readMessage();
            setState(() {});
          }
        }
      } else {
        if ((widget.mapData!['userId'].toString() == receiverId &&
                widget.mapData!['myId'].toString() == senderId) ||
            (widget.mapData!['userId'].toString() == senderId &&
                widget.mapData!['myId'].toString() == receiverId)) {
          Message list = Message.fromJson(newMessage);
          chatList.insert(0, list);
          debugPrint("SEND_MESSAGE Full ==> $singleChat");
          if (this.mounted) {
            readMessage();
            setState(() {});
          }
        }
      }
    });
  }

  clearChatSocket() {
    Map mapping = {
      "userId": sharedPref.getString(SharedKey.userId).toString(),
      "user2Id": (widget.mapData!['groupId'] != "0")
          ? widget.mapData!['groupId'].toString()
          : widget.mapData!['userId'].toString(),
      // if type==1 then send groupID
      "type": (widget.mapData!['groupId'] != "0") ? '1' : '0',
    };
    debugPrint("delete_chat  ==> $mapping");
    socket.emit('delete_chat', mapping);
  }

  clearChatSocketListener() {
    socket.on('delete_data', (newMessage) {
      setState(() {
        FocusManager.instance.primaryFocus!.unfocus();
        // getSingleChat();
      });
    });
  }

  selectCameraLib(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, myState) {
            return Column(
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
                        Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            child: MyString.bold('chatMedia'.tr.toUpperCase(),
                                16, MyColor.black, TextAlign.center)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  _pickMedia();
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/post_library.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('attachments'.tr, 18,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  await selectImgVid(context);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/post_camera.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('camera'.tr, 18,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  selectImgVid(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, myState) {
            return Column(
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
                        Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            child: MyString.bold('chatMedia'.tr.toUpperCase(),
                                16, MyColor.black, TextAlign.center)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  pickImage(ImageSource.camera);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/post_library.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('choosePicture'.tr, 18,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  getVideo(ImageSource.camera);
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 100,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: MyColor.liteGrey,
                                          blurRadius: 2.0,
                                          offset: new Offset(0.0, 3.0),
                                        ),
                                      ],
                                      color: MyColor.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/select_video.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                      MyString.med('chooseVideo'.tr, 18,
                                          MyColor.black, TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<TextSpan> extractText(String rawString, {required Color colorM}) {
    List<TextSpan> textSpan = [];

    final urlRegExp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

    getLink(String linkString) {
      textSpan.add(
        TextSpan(
          text: linkString,
          style: new TextStyle(color: Colors.blue),
          recognizer: new TapGestureRecognizer()
            ..onTap = () async {
              debugPrint("sklhlkdshnfd ${linkString}");
              if (!await launchUrl(Uri.parse(linkString),
                  mode: LaunchMode.externalNonBrowserApplication)) {
                throw Exception(
                    'Could not launch ${Uri.parse(ApiStrings.privacy.toString())}');
              }
            },
        ),
      );
      return linkString;
    }

    getNormalText(String normalText) {
      textSpan.add(
        TextSpan(
          text: normalText,
          style: new TextStyle(color: colorM),
        ),
      );
      return normalText;
    }

    rawString.splitMapJoin(
      urlRegExp,
      onMatch: (m) => getLink("${m.group(0)}"),
      onNonMatch: (n) => getNormalText("${n.substring(0)}"),
    );

    return textSpan;
  }

  void attachIndividualChatListener() {
    socket.on('send_individual_message', (newMessage) {
      debugPrint("CHAT_OBJECT_SEND_EVENT ==> $newMessage");
    });
    socket.on('receive_message', (newMessage) {
      debugPrint("CHAT_OBJECT_RECEIVE_EVENT ==> $newMessage");
      setState(() {
        _listChats.insert(0,ChatModel.fromJson(newMessage));
      });
    });
  }

  sendIndividualMessage(String message, String type) {
    Map chat = {
      "senderId": int.parse(sharedPref.getString(SharedKey.userId)!),
      "receiverId": user.id,
      "message": message,
      "messageType": type
    };
    debugPrint("CHAT_OBJECT_SEND => $chat");
    socket.emit('send_individual_message', chat);
    setState(() {
      _listChats.insert(0,ChatModel.fromJson(chat));
    });
  }

  Widget _buildChatUIOLD() {
    return Scaffold(
        backgroundColor: MyColor.white,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: HeaderWidget(),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffEBEBEB)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13))),
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
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 12),
                    hintText: 'search'.tr,
                    hintStyle: TextStyle(color: MyColor.more, fontSize: 14),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus!.unfocus();

                            if (widget.mapData!['groupId'].toString() !=
                                '0') {
                              Map<String, dynamic> mapping = {
                                'groupId':
                                widget.mapData!['groupId'].toString(),
                              };

                              Map<String, String>? res =
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GroupInfoScreen(
                                              mapData: mapping)));
                              if (res != null) {
                                setState(() {
                                  widget.mapData!['totalMember'] =
                                      res['totalMember'].toString();
                                  widget.mapData!['userName'] =
                                      res['userName'].toString();
                                  if (res['userImage']
                                      .toString()
                                      .isNotEmpty) {
                                    widget.mapData!['userImage'] =
                                        res['userImage'].toString();
                                  }
                                });
                              }
                            } else {
                              Map<String, dynamic> mapData = {
                                'userID':
                                widget.mapData!['userId'].toString()
                              };
                              Navigator.pushNamed(
                                  context, RoutesName.myProfile,
                                  arguments: mapData);
                            }
                          },
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                            child: widget.mapData!['userImage']
                                .toString()
                                .isNotEmpty
                                ? Image.network(
                                widget.mapData!['userImage'].toString(),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child,
                                    loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : Container(
                                    height: 30,
                                    width: 30,
                                    child: customProgressBar()))
                                : Container(
                                width: 50,
                                height: 50,
                                color: MyColor.cardColor,
                                child: Center(
                                    child: Image.asset(
                                        'assets/images/onboard/placeholder_image.png',
                                        width: 35,
                                        height: 35))),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus!.unfocus();

                            if (widget.mapData!['groupId'].toString() !=
                                '0') {
                              Map<String, dynamic> mapping = {
                                'groupId':
                                widget.mapData!['groupId'].toString(),
                              };

                              Map<String, String>? res =
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GroupInfoScreen(
                                              mapData: mapping)));

                              if (res != null) {
                                setState(() {
                                  widget.mapData!['totalMember'] =
                                      res['totalMember'].toString();
                                  widget.mapData!['userName'] =
                                      res['userName'].toString();
                                  if (res['userImage']
                                      .toString()
                                      .isNotEmpty) {
                                    widget.mapData!['userImage'] =
                                        res['userImage'].toString();
                                  }
                                });
                              }
                            } else {
                              Map<String, dynamic> mapData = {
                                'userID':
                                widget.mapData!['userId'].toString()
                              };
                              Navigator.pushNamed(
                                  context, RoutesName.myProfile,
                                  arguments: mapData);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width *
                                      .5,
                                  child: MyString.boldMultiLine(
                                      (widget.mapData!['userName']
                                          .toString() ==
                                          "null")
                                          ? "No Name"
                                          : widget.mapData!['userName']
                                          .toString(),
                                      27,
                                      MyColor.title,
                                      TextAlign.start,
                                      1)),
                              (widget.mapData!['groupId'].toString() != '0')
                                  ? MyString.med(
                                  widget.mapData!['totalMember'] != 1
                                      ? '${'members'.tr}: ${widget.mapData!['totalMember'].toString()}'
                                      : '${'member'.tr}: ${widget.mapData!['totalMember'].toString()}',
                                  12,
                                  MyColor.white,
                                  TextAlign.start)
                                  : typingCheck.typing == 1 &&
                                  typingCheck.id.toString() !=
                                      sharedPref
                                          .getString(
                                          SharedKey.userId)
                                          .toString()
                                  ? MyString.med('typing...', 12,
                                  MyColor.white, TextAlign.start)
                                  : MyString.med(
                                  widget.mapData!['online'] == 0
                                      ? 'offline'.tr
                                      : 'online'.tr,
                                  12,
                                  MyColor.textBlack0,
                                  TextAlign.start),
                            ],
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<SampleItem>(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0))),
                      color: MyColor.white,
                      icon: Icon(
                        Icons.more_vert, // Change the icon here
                        color: MyColor.redd, // Change the color here
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
                            await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) {
                                  return delete(1);
                                });
                          },
                          value: null,
                          child: MyString.reg('clearConversation'.tr, 12,
                              MyColor.textBlack0, TextAlign.center),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              loader
                  ? Expanded(
                child: Container(
                  child: progressBar(),
                ),
              )
                  : chatList.isNotEmpty
                  ? Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: MyColor.card,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: ListView.builder(
                    itemCount: chatList.length,
                    shrinkWrap: true,
                    reverse: true,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    itemBuilder: (context, index) {
                      return (chatList[index].messageType == 4 ||
                          chatList[index].messageType == 6 ||
                          chatList[index].messageType == 5)
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: MyColor.linkBlurBlue,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: chatList[index].messageType ==
                                4
                                ? MyString.med(
                                (chatList[index].message.toString() ==
                                    "{GroupCreated}")
                                    ? 'groupCreated'.tr +
                                    " " +
                                    widget.mapData!['userName']
                                        .toString()
                                    : 'newMember'.tr,
                                12,
                                MyColor.black,
                                TextAlign.start)
                                : chatList[index].messageType == 6 ||
                                chatList[index].messageType ==
                                    5
                                ? MyString.med(
                                (chatList[index].message.toString() ==
                                    "removed" +
                                        " " +
                                        chatList[index]
                                            .senderName
                                            .toString())
                                    ? 'removed'.tr
                                    : 'left'.tr +
                                    " " +
                                    chatList[index]
                                        .senderName
                                        .toString(),
                                12,
                                MyColor.black,
                                TextAlign.start)
                                : SizedBox(),
                          ),
                        ],
                      )
                          : Padding(
                        padding: EdgeInsets.all(3),
                        child: sharedPref
                            .getString(
                            SharedKey.userId)
                            .toString() ==
                            chatList[index]
                                .senderId
                                .toString()
                            ? senderMessage(index)
                            : receiverMessage(index),
                      );
                    },
                  ),
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
                        color: MyColor.card,
                        width: double.infinity,
                        child: MyString.bold(
                            'noConversation'.tr,
                            12,
                            MyColor.textBlack0,
                            TextAlign.center)),
                  ],
                ),
              ),

              //messageField
              if (bottomMsgField && widget.mapData!['isBlock'] == 0)
                Container(
                  height: 51,
                  padding: const EdgeInsets.all(4),
                  margin:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      color: MyColor.white,
                      border: Border.all(color: Color(0xffFFEDED)),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(25))),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Flexible(
                        child: Container(
                          child: TextField(
                            minLines: 1,
                            maxLines: 3,
                            focusNode: _focusNode,
                            controller: msgField,
                            style: TextStyle(color: MyColor.black),
                            onChanged: (value) => setState(() {
                              typingSocket(1);

                              searchDelay.run(() {
                                typingSocket(2);
                              });
                            }),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (msgField.text
                                      .toString()
                                      .trim()
                                      .isEmpty)
                                    TextButton(
                                        onPressed: () {
                                          _focusNode.unfocus();
                                          Future.delayed(
                                              Duration(milliseconds: 200),
                                                  () async {
                                                // bottomCamera = !bottomCamera;
                                                // bottomMsgField = false;
                                                selectCameraLib(context);
                                                setState(() {});
                                              });
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(30, 30),
                                            tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap),
                                        child: Image.asset(
                                            "assets/images/onboard/attach_file.png",
                                            height: 15,
                                            fit: BoxFit.cover)),
                                  if (msgField.text
                                      .toString()
                                      .trim()
                                      .isEmpty)
                                    TextButton(
                                        onPressed: () {
                                          _openGiphyGet(0);
                                          setState(() {});
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(30, 30),
                                            tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap),
                                        child: Image.asset(
                                            "assets/images/onboard/gif.png",
                                            width: 15,
                                            height: 15,
                                            fit: BoxFit.cover)),
                                  TextButton(
                                      onPressed: () {
                                        _focusNode.unfocus();
                                        Future.delayed(
                                            Duration(milliseconds: 200),
                                                () async {
                                              isShowEmoji = true;
                                              setState(() {});
                                            });
                                      },
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(35, 30),
                                          tapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap),
                                      child: Image.asset(
                                          "assets/images/onboard/happiness.png",
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.cover)),
                                  if (msgField.text
                                      .toString()
                                      .trim()
                                      .isEmpty)
                                    InkWell(
                                      onTap: () {
                                        if (msgField.text
                                            .toString()
                                            .trim()
                                            .isNotEmpty) {
                                          sendMessage(
                                              msgField.text
                                                  .toString()
                                                  .trim(),
                                              '',
                                              0); // send
                                        }

                                        setState(() {
                                          msgField.text = '';
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: MyColor.orange2,
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8),
                                            child: Image.asset(
                                              "assets/images/icons/share.png",
                                              height: 10,
                                              width: 10,
                                              color: MyColor.white,
                                            )),
                                      ),
                                    ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              hintText: '${'message'.tr}',
                              hintStyle: TextStyle(
                                  color: MyColor.textBlack0, fontSize: 14),
                            ),
                            onTap: () {
                              if (isShowEmoji) {
                                setState(() => isShowEmoji = !isShowEmoji);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (widget.mapData!['blockBy'].toString() ==
                  widget.mapData!['myId'].toString() &&
                  widget.mapData!['isBlock'] == 1)
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return delete(2);
                        });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      color: MyColor.white,
                      child: Card(
                          color: MyColor.cardColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: MyString.med('blockedContact'.tr, 14,
                                MyColor.black, TextAlign.center),
                          ))),
                ),

              if (isShowEmoji)
                SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: EmojiPicker(
                    textEditingController: msgField,
                    config: Config(
                      emojiViewConfig: EmojiViewConfig(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                    onEmojiSelected: (category, emoji) {
                      setState(() {});
                    },
                  ),
                ),

              if (bottomCamera)
                Container(
                  decoration: BoxDecoration(
                      color: MyColor.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: MyColor.orange2,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: MyString.bold('chooseFiletype'.tr, 20,
                                MyColor.white, TextAlign.center)),
                        const SizedBox(height: 5),
                        ListTile(
                          leading: SizedBox(
                              height: 40.0,
                              width: 40.0, // fixed width and height
                              child: Image.asset(
                                  'assets/images/logos/camera2.png')),
                          title: MyString.med('camera'.tr, 18,
                              MyColor.textBlack, TextAlign.start),
                          onTap: () async {
                            // 1 for camera, 2 for videos
                            bottomMsgField = true;
                            bottomCamera = false;
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) {
                                bottomCamera = false;
                                return cameraSelection();
                              },
                            );

                            setState(() {});
                          },
                        ),
                        ListTile(
                          leading: SizedBox(
                              height: 40.0,
                              width: 40.0, // fixed width and height
                              child: Image.asset(
                                  'assets/images/logos/image.png')),
                          title: MyString.med('phoneLibrary'.tr, 18,
                              MyColor.textBlack, TextAlign.start),
                          onTap: () async {
                            bottomMsgField = true;
                            bottomCamera = false;
                            _pickMedia();
                            bottomCamera = false;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }

  Widget _buildChatUINEW() {
    return Scaffold(
        backgroundColor: MyColor.white,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: HeaderWidget(),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffEBEBEB)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13))),
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
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 12),
                    hintText: 'search'.tr,
                    hintStyle: TextStyle(color: MyColor.more, fontSize: 14),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus!.unfocus();

                          },
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                            child: user.profilePicture != null && user.profilePicture!.contains('http')
                                ? Image.network(
                                user.profilePicture!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child,
                                    loadingProgress) =>
                                (loadingProgress == null)
                                    ? child
                                    : Container(
                                    height: 30,
                                    width: 30,
                                    child: customProgressBar()))
                                : Container(
                                width: 50,
                                height: 50,
                                color: MyColor.cardColor,
                                child: Center(
                                    child: Image.asset(
                                        'assets/images/onboard/placeholder_image.png',
                                        width: 35,
                                        height: 35))),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus!.unfocus();

                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width *
                                      .5,
                                  child: MyString.boldMultiLine(
                                      (user.name == null)
                                          ? "No Name"
                                          : user.name!,
                                      27,
                                      MyColor.title,
                                      TextAlign.start,
                                      1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<SampleItem>(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0))),
                      color: MyColor.white,
                      icon: Icon(
                        Icons.more_vert, // Change the icon here
                        color: MyColor.redd, // Change the color here
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
                            await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) {
                                  return delete(1);
                                });
                          },
                          value: null,
                          child: MyString.reg('clearConversation'.tr, 12,
                              MyColor.textBlack0, TextAlign.center),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              loader
                  ? Expanded(
                child: Container(
                  child: progressBar(),
                ),
              )
                  : _listChats.isNotEmpty
                  ? Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: MyColor.card,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: ListView.builder(
                    itemCount: _listChats.length,
                    shrinkWrap: true,
                    reverse: true,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    itemBuilder: (context, index) {
                      final chat = _listChats[index];
                      final userId = int.parse(sharedPref.getString(SharedKey.userId)!);

                      return Padding(
                        padding: EdgeInsets.all(3),
                        child: chat.senderId ==
                            userId
                            ? senderMessageNew(index)
                            : receiverMessageNew(index),
                      );
                    },
                  ),
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
                        color: MyColor.card,
                        width: double.infinity,
                        child: MyString.bold(
                            'noConversation'.tr,
                            12,
                            MyColor.textBlack0,
                            TextAlign.center)),
                  ],
                ),
              ),

              //messageField
              if (bottomMsgField)
                Container(
                  height: 51,
                  padding: const EdgeInsets.all(4),
                  margin:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      color: MyColor.white,
                      border: Border.all(color: Color(0xffFFEDED)),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(25))),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Flexible(
                        child: Container(
                          child: TextField(
                            minLines: 1,
                            maxLines: 3,
                            focusNode: _focusNode,
                            controller: msgField,
                            style: TextStyle(color: MyColor.black),
                            onChanged: (value) => setState(() {
                              // typingSocket(1);

                              // searchDelay.run(() {
                              //   typingSocket(2);
                              // });
                            }),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    TextButton(
                                        onPressed: () {
                                          _focusNode.unfocus();
                                          Future.delayed(
                                              Duration(milliseconds: 200),
                                                  () async {
                                                // bottomCamera = !bottomCamera;
                                                // bottomMsgField = false;
                                                selectCameraLib(context);
                                                setState(() {});
                                              });
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(30, 30),
                                            tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap),
                                        child: Image.asset(
                                            "assets/images/onboard/attach_file.png",
                                            height: 15,
                                            fit: BoxFit.cover)),
                                    // TextButton(
                                    //     onPressed: () {
                                    //       _openGiphyGet(0);
                                    //       setState(() {});
                                    //     },
                                    //     style: TextButton.styleFrom(
                                    //         padding: EdgeInsets.zero,
                                    //         minimumSize: Size(30, 30),
                                    //         tapTargetSize:
                                    //         MaterialTapTargetSize
                                    //             .shrinkWrap),
                                    //     child: Image.asset(
                                    //         "assets/images/onboard/gif.png",
                                    //         width: 15,
                                    //         height: 15,
                                    //         fit: BoxFit.cover)),
                                  // TextButton(
                                  //     onPressed: () {
                                  //       _focusNode.unfocus();
                                  //       Future.delayed(
                                  //           Duration(milliseconds: 200),
                                  //               () async {
                                  //             isShowEmoji = true;
                                  //             setState(() {});
                                  //           });
                                  //     },
                                  //     style: TextButton.styleFrom(
                                  //         padding: EdgeInsets.zero,
                                  //         minimumSize: Size(35, 30),
                                  //         tapTargetSize:
                                  //         MaterialTapTargetSize
                                  //             .shrinkWrap),
                                  //     child: Image.asset(
                                  //         "assets/images/onboard/happiness.png",
                                  //         width: 20,
                                  //         height: 20,
                                  //         fit: BoxFit.cover)),
                                    InkWell(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        final message = msgField.text.trim();
                                        if(message.isEmpty) return;
                                        sendIndividualMessage(message, "text");
                                        msgField.clear();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: MyColor.orange2,
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8),
                                            child: Image.asset(
                                              "assets/images/icons/share.png",
                                              height: 10,
                                              width: 10,
                                              color: MyColor.white,
                                            )),
                                      ),
                                    ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              hintText: '${'message'.tr}',
                              hintStyle: TextStyle(
                                  color: MyColor.textBlack0, fontSize: 14),
                            ),
                            onTap: () {
                              if (isShowEmoji) {
                                setState(() => isShowEmoji = !isShowEmoji);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (widget.mapData!['blockBy'].toString() ==
                  widget.mapData!['myId'].toString() &&
                  widget.mapData!['isBlock'] == 1)
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return delete(2);
                        });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      color: MyColor.white,
                      child: Card(
                          color: MyColor.cardColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: MyString.med('blockedContact'.tr, 14,
                                MyColor.black, TextAlign.center),
                          ))),
                ),

              if (isShowEmoji)
                SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: EmojiPicker(
                    textEditingController: msgField,
                    config: Config(
                      emojiViewConfig: EmojiViewConfig(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                    onEmojiSelected: (category, emoji) {
                      setState(() {});
                    },
                  ),
                ),

              if (bottomCamera)
                Container(
                  decoration: BoxDecoration(
                      color: MyColor.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: MyColor.orange2,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: MyString.bold('chooseFiletype'.tr, 20,
                                MyColor.white, TextAlign.center)),
                        const SizedBox(height: 5),
                        ListTile(
                          leading: SizedBox(
                              height: 40.0,
                              width: 40.0, // fixed width and height
                              child: Image.asset(
                                  'assets/images/logos/camera2.png')),
                          title: MyString.med('camera'.tr, 18,
                              MyColor.textBlack, TextAlign.start),
                          onTap: () async {
                            // 1 for camera, 2 for videos
                            bottomMsgField = true;
                            bottomCamera = false;
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) {
                                bottomCamera = false;
                                return cameraSelection();
                              },
                            );

                            setState(() {});
                          },
                        ),
                        ListTile(
                          leading: SizedBox(
                              height: 40.0,
                              width: 40.0, // fixed width and height
                              child: Image.asset(
                                  'assets/images/logos/image.png')),
                          title: MyString.med('phoneLibrary'.tr, 18,
                              MyColor.textBlack, TextAlign.start),
                          onTap: () async {
                            bottomMsgField = true;
                            bottomCamera = false;
                            _pickMedia();
                            bottomCamera = false;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
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

  Future<void> getUserIndividualChats() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.userIndividualMessages}/${sharedPref.getString(SharedKey.userId)}/${user.id}");
    print(res);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      loader = false;
      _listChats.clear();
      _userIndividualChatsModel = UserIndividualChatsModel.fromJson(result);
      _listChats.addAll(_userIndividualChatsModel.data!);
      setState(() {});
    }
  }

  Future<void> clearIndividualChat() async {
    var res = await AllApi.deleteMethodApi(
        "${ApiStrings.chats}/details/${sharedPref.getString(SharedKey.userId)}/${user.id}/${ApiStrings.individual}", {});
    print(res);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _listChats.clear();
    }
    setState(() {
      loader = false;
    });
  }
}

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
