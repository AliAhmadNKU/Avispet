import 'dart:convert';
import 'dart:io';

import 'package:avispets/models/aa_common_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:readmore/readmore.dart';
import '../../../../models/forum/forum_reply.dart';
import '../../../../utils/apis/all_api.dart';
import '../../../../utils/apis/api_strings.dart';
import '../../../../utils/common_function/dialogs/dialog_success.dart';
import '../../../../utils/common_function/my_string.dart';
import '../../../../utils/common_function/toaster.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/my_routes/route_name.dart';
import '../../../../utils/shared_pref.dart';

class ForumReply extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const ForumReply({super.key, this.mapData});

  @override
  State<ForumReply> createState() => _ForumReplyState();
}

enum SampleItem { report, delete }

class _ForumReplyState extends State<ForumReply> {
  SampleItem? selectedItem;
  var searchBar = TextEditingController();
  bool isShowEmoji = false;
  final _focusNode = FocusNode();
  GiphyGif? gif;
  var msgField = TextEditingController();
  CommonModel commonModel = CommonModel();
  bool loader = true;
  bool stackLoader = false;
  ForumReplyModel replyModel = ForumReplyModel();
  List<ForumReplyBody> replyList = [];

  @override
  void initState() {
    getForumReplyApi(
        widget.mapData!['forumId'], widget.mapData!['forumTopicId']);
    super.initState();
  }

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
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          backgroundColor: MyColor.orange2,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: MyColor.orange2,
            leading: Container(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  if (widget.mapData!['from'].toString() == 'notification') {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.mainPage,
                        arguments: 0,
                        (route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(20, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Image.asset('assets/images/icons/back_icon.png',
                    color: MyColor.white),
              ),
            ),
            title: Container(
                width: MediaQuery.of(context).size.width * .6,
                child: MyString.boldMultiLine('${'reply'.tr}(S)'.toUpperCase(),
                    18, MyColor.white, TextAlign.center, 1)),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: MyColor.grey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: MyColor.orange2,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 5,
                              offset: const Offset(2, 2), // Shadow position
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 5,
                              offset: Offset(-2, -2),
                            ),
                          ],
                        ),
                        child: Container(
                            margin: EdgeInsets.only(top: 8, bottom: 8),
                            child: MyString.bold(
                                widget.mapData!['topicTitle'].toString(),
                                14,
                                MyColor.white,
                                TextAlign.center)),
                      ),

                      loader
                          ? Expanded(
                              child: Container(
                                child: progressBar(),
                              ),
                            )
                          : replyList.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                      itemCount: replyList.length,
                                      shrinkWrap: true,
                                      reverse: false,
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          decoration: BoxDecoration(
                                              color: MyColor.white,
                                              boxShadow: <BoxShadow>[
                                                new BoxShadow(
                                                  color: MyColor.liteGrey,
                                                  blurRadius: 2.0,
                                                  offset: new Offset(0.0, 3.0),
                                                ),
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Map<String,
                                                                      dynamic>
                                                                  mapData = {
                                                                'userID': replyList[
                                                                        index]
                                                                    .user!
                                                                    .id
                                                                    .toString()
                                                              };
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  RoutesName
                                                                      .myProfile,
                                                                  arguments:
                                                                      mapData);
                                                            },
                                                            child: SizedBox(
                                                              width: 50,
                                                              height: 50,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            50)),
                                                                child: replyList[index]
                                                                            .user!
                                                                            .profilePicture !=
                                                                        null
                                                                    ? Image.network(
                                                                        '${ApiStrings.mediaURl}${replyList[index].user!.profilePicture.toString()}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        loadingBuilder: (context, child, loadingProgress) => (loadingProgress ==
                                                                                null)
                                                                            ? child
                                                                            : customProgressBar())
                                                                    : Image
                                                                        .asset(
                                                                        'assets/images/onboard/placeholder_image.png',
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Map<String,
                                                                          dynamic>
                                                                      mapData =
                                                                      {
                                                                    'userID': replyList[
                                                                            index]
                                                                        .user!
                                                                        .id
                                                                        .toString()
                                                                  };
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      RoutesName
                                                                          .myProfile,
                                                                      arguments:
                                                                          mapData);
                                                                },
                                                                child: MyString.medMultiLine(
                                                                    '${replyList[index].user!.firstName.toString()} ${replyList[index].user!.lastName.toString()}',
                                                                    12,
                                                                    MyColor
                                                                        .textBlack,
                                                                    TextAlign
                                                                        .start,
                                                                    1),
                                                              ),
                                                              Container(
                                                                child: MyString.medMultiLine(
                                                                    '${replyList[index].createdAt.toString()}',
                                                                    10,
                                                                    MyColor
                                                                        .textFieldBorder,
                                                                    TextAlign
                                                                        .start,
                                                                    1),
                                                              ),
                                                              replyList[index]
                                                                      .comment
                                                                      .toString()
                                                                      .startsWith(
                                                                          'https://')
                                                                  ? Container(
                                                                      height:
                                                                          150,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(15)),
                                                                        child: Image.network(
                                                                            replyList[index]
                                                                                .comment
                                                                                .toString(),
                                                                            loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                                                                                ? child
                                                                                : customProgressBar()),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              8),
                                                                      width: (sharedPref.getString(SharedKey.userId) != replyList[index].userId.toString())
                                                                          ? MediaQuery.of(context).size.width *
                                                                              0.70
                                                                          : MediaQuery.of(context).size.width *
                                                                              .55,
                                                                      child:
                                                                          ReadMoreText(
                                                                        replyList[index]
                                                                            .comment
                                                                            .toString(),
                                                                        trimMode:
                                                                            TrimMode.Line,
                                                                        trimLines:
                                                                            3,
                                                                        colorClickableText:
                                                                            Colors.pink,
                                                                        trimCollapsedText:
                                                                            '${'more'.tr}',
                                                                        trimExpandedText:
                                                                            '',
                                                                        moreStyle: TextStyle(
                                                                            color: MyColor
                                                                                .orange2,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextButton(
                                                            onPressed: () {
                                                              if (replyList[
                                                                          index]
                                                                      .isLiked ==
                                                                  0) {
                                                                replyList[index]
                                                                    .isLiked = 1;
                                                                replyList[index]
                                                                        .totalLikes =
                                                                    replyList[index]
                                                                            .totalLikes! +
                                                                        1;
                                                              } else {
                                                                replyList[index]
                                                                    .isLiked = 0;
                                                                replyList[index]
                                                                        .totalLikes =
                                                                    replyList[index]
                                                                            .totalLikes! -
                                                                        1;
                                                              }

                                                              setState(() {});
                                                              likeForum(replyList[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                            },
                                                            style: TextButton.styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                minimumSize:
                                                                    Size(
                                                                        50, 30),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Image.asset(
                                                                    (replyList[index].isLiked ==
                                                                            1)
                                                                        ? 'assets/images/icons/like_click.png'
                                                                        : 'assets/images/icons/like.png',
                                                                    width: 20,
                                                                    height: 20),
                                                                if (replyList[
                                                                            index]
                                                                        .totalLikes !=
                                                                    0)
                                                                  Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              1,
                                                                          left:
                                                                              3),
                                                                      child: MyString.bold(
                                                                          replyList[index]
                                                                              .totalLikes
                                                                              .toString(),
                                                                          14,
                                                                          MyColor
                                                                              .textFieldBorder,
                                                                          TextAlign
                                                                              .center)),
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (sharedPref.getString(
                                                        SharedKey.userId) ==
                                                    replyList[index]
                                                        .userId
                                                        .toString())
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          FocusManager.instance
                                                              .primaryFocus!
                                                              .unfocus();
                                                          await showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder: (_) {
                                                              return _deleteCommentDialog(
                                                                  replyList[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                            },
                                                          );
                                                          setState(() {});
                                                        },
                                                        style: TextButton.styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            minimumSize:
                                                                Size(50, 30),
                                                            tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap),
                                                        child: Image.asset(
                                                            'assets/images/logos/delete.png',
                                                            width: 18,
                                                            color: MyColor.red,
                                                            height: 18),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      if (!replyList[index]
                                                          .comment
                                                          .toString()
                                                          .startsWith(
                                                              'https://'))
                                                        TextButton(
                                                          onPressed: () async {
                                                            if (replyList[index]
                                                                .comment
                                                                .toString()
                                                                .startsWith(
                                                                    'https://')) {
                                                              await _openGiphyGet(
                                                                  0,
                                                                  replyList[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                            } else {
                                                              await showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      true,
                                                                  builder: (_) {
                                                                    return _editComment(
                                                                        replyList[index]
                                                                            .id
                                                                            .toString(),
                                                                        replyList[index]
                                                                            .comment
                                                                            .toString());
                                                                  });
                                                            }

                                                            setState(() {});
                                                          },
                                                          style: TextButton.styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              minimumSize:
                                                                  Size(50, 30),
                                                              tapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap),
                                                          child: Image.asset(
                                                              'assets/images/icons/edit.png',
                                                              width: 18,
                                                              height: 18),
                                                        ),
                                                    ],
                                                  )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/onboard/placeholder_image.png',
                                        width: 120,
                                        height: 90,
                                      ),
                                      Container(
                                          width: double.infinity,
                                          child: MyString.bold(
                                              'noComments'.tr,
                                              16,
                                              MyColor.textFieldBorder,
                                              TextAlign.center)),
                                    ],
                                  ),
                                ),

                      //messageField
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: MyColor.white,
                              boxShadow: <BoxShadow>[
                                new BoxShadow(
                                  color: MyColor.liteGrey,
                                  blurRadius: 2.0,
                                  offset: new Offset(0.0, 3.0),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: TextField(
                            minLines: 1,
                            maxLines: 3,
                            focusNode: _focusNode,
                            controller: msgField,
                            autofocus: true,
                            style: TextStyle(color: MyColor.black),
                            onChanged: (value) => setState(() {}),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (msgField.text.toString().trim().isEmpty)
                                    TextButton(
                                        onPressed: () {
                                          _openGiphyGet(0, "send");
                                          setState(() {});
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(30, 30),
                                            tapTargetSize: MaterialTapTargetSize
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
                                              MaterialTapTargetSize.shrinkWrap),
                                      child: Image.asset(
                                          "assets/images/onboard/happiness.png",
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.cover)),
                                  if (msgField.text
                                      .toString()
                                      .trim()
                                      .isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          stackLoader = true;

                                          sendComment("");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: MyColor.orange2,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Row(
                                            children: [
                                              MyString.med(
                                                  "send".tr,
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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              hintText: '${'addComment'.tr}',
                              hintStyle: TextStyle(
                                  color: MyColor.textFieldBorder, fontSize: 14),
                            ),
                            onTap: () {
                              if (isShowEmoji) {
                                setState(() => isShowEmoji = !isShowEmoji);
                              }
                            },
                          ),
                        ),
                      ),

                      if (isShowEmoji)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .4,
                          child: EmojiPicker(
                            textEditingController: msgField,
                            config: Config(
                              emojiViewConfig: EmojiViewConfig(
                                columns: 7,
                                emojiSizeMax:
                                    32 * (Platform.isIOS ? 1.30 : 1.0),
                              ),
                            ),
                            onEmojiSelected: (category, emoji) {
                              setState(() {});
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
    );
  }

  getForumReplyApi(int forumId, int forumTopicId) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.forumTopicReplies}?forumId=$forumId&forumTopicId=$forumTopicId");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        replyModel = ForumReplyModel.fromJson(result);
        loader = false;
        stackLoader = false;
        replyList.clear();
        for (int i = 0; i < replyModel.data!.length; i++) {
          replyList.add(replyModel.data![i]);

          if (replyModel.data![i].isLiked == 1) {
            replyModel.data![i].likeEnable = true;
          } else {
            replyModel.data![i].likeEnable = false;
          }
        }
      });
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['message'].toString());
    }
  }

  sendComment(String gifUrl) async {
    print('FORUM_ID ${widget.mapData!['forumId'].toString()}');
    print('FORUM_TOPIC_ID ${widget.mapData!['forumTopicId'].toString()}');

    Map<String, dynamic> dataMapping = {};
    if (gifUrl.isNotEmpty) {
      dataMapping = {
        'forumId': widget.mapData!['forumId'].toString(),
        'forumTopicId': widget.mapData!['forumTopicId'].toString(),
        'comment': gifUrl,
      };
    } else {
      dataMapping = {
        'forumId': widget.mapData!['forumId'].toString(),
        'forumTopicId': widget.mapData!['forumTopicId'].toString(),
        'comment': msgField.text.trim().toString(),
      };
    }

    var res =
        await AllApi.postMethodApi(ApiStrings.replyForumTopic, dataMapping);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        msgField.text = '';
        commonModel = CommonModel.fromJson(result);
        getForumReplyApi(
            widget.mapData!['forumId'], widget.mapData!['forumTopicId']);
      });
    }
  }

  _openGiphyGet(int type, String from) async {
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

    if (from == "send") {
      sendComment(gif.images!.original!.url.toString());
    } else {
      FocusManager.instance.primaryFocus!.unfocus();
      Map<String, String> mapData = {
        'replyId': from,
        'comment': gif.images!.original!.url.toString(),
      };

      stackLoader = true;
      var res =
          await AllApi.postMethodApi(ApiStrings.replyForumTopicReply, mapData);
      var result = jsonDecode(res.toString());
      if (result['status'] == 200) {
        getForumReplyApi(
            widget.mapData!['forumId'], widget.mapData!['forumTopicId']);
      }
    }

    setState(() {});
  }

  likeForum(String forumTopicReplyId) async {
    print('$forumTopicReplyId');
    Map<String, String> mapData = {
      'forumTopicReplyId': forumTopicReplyId,
    };
    var res = await AllApi.postMethodApi(ApiStrings.likeForumReply, mapData);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {});
    }
  }

  _deleteCommentDialog(String CommentId) {
    print("COMMENT_ID :  $CommentId");
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
                    'assets/images/icons/delete.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  MyString.bold('dialogCommentTitle'.tr, 20, MyColor.black,
                      TextAlign.center),
                  MyString.med('dialogComment'.tr, 12, MyColor.textFieldBorder,
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
                            var res = await AllApi.deleteMethodApiQuery(
                                '${ApiStrings.deleteForumReply}?id=$CommentId');
                            var result = jsonDecode(res.toString());
                            if (result['status'] == 200) {
                              Navigator.pop(context);
                              await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) {
                                  return success('deleteComment'.tr, 0);
                                },
                              );
                              getForumReplyApi(widget.mapData!['forumId'],
                                  widget.mapData!['forumTopicId']);
                              setState(() {});
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

  _editComment(String commentId, String comment) {
    var groupName = TextEditingController();
    groupName.text = comment;
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
                  MyString.bold(
                      'editText'.tr, 16, MyColor.black, TextAlign.center),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: MyColor.textFieldBorder),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      minLines: 1,
                      maxLines: 4,
                      controller: groupName,
                      scrollPadding: const EdgeInsets.only(bottom: 100),
                      style: TextStyle(color: MyColor.black, fontSize: 14),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'editText'.tr,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        hintStyle: TextStyle(
                            color: MyColor.textFieldBorder, fontSize: 14),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      Map<String, String> mapData = {
                        'replyId': commentId,
                        'comment': groupName.text.trim().toString(),
                      };

                      if (groupName.text.trim().toString().isNotEmpty) {
                        stackLoader = true;
                        var res = await AllApi.postMethodApi(
                            ApiStrings.replyForumTopicReply, mapData);
                        var result = jsonDecode(res.toString());
                        if (result['status'] == 200) {
                          Navigator.pop(context);
                          getForumReplyApi(widget.mapData!['forumId'],
                              widget.mapData!['forumTopicId']);
                        }
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
}
