import 'dart:convert';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:readmore/readmore.dart';
import '../../../models/get_feed_comment_model.dart';
import '../../../models/send_feed_comment_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/dialog_success.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class ReplyScreen extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const ReplyScreen({super.key, this.mapData});

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final _focusNode = FocusNode();

  GetFeedCommentModel commentModel = GetFeedCommentModel();
  SendFeedCommentModel sendFeedCommentModel = SendFeedCommentModel();
  bool isShowEmoji = false;
  List<GetFeedCommentModelBody> getComment = [];
  var msgField = TextEditingController();
  int page = 1;
  bool commentSending = false;
  bool loader = true;
  String? commentLen;

  _loadMoreData(int loaderPage) {
    setState(() {
      feedCommentApi(widget.mapData!['feedId'].toString(),
          loaderPage.toString(), widget.mapData!['parentId'].toString());
    });
  }

  @override
  void initState() {
    super.initState();
    feedCommentApi(widget.mapData!['feedId'].toString(), page.toString(),
        widget.mapData!['parentId'].toString());
    Future.delayed(Duration.zero, () async {
      await GetApi.getProfileApi(
          context, sharedPref.getString(SharedKey.userId).toString());
      loader = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (widget.mapData!['popUsed']) {
          Navigator.pop(context, commentLen);
        } else {
          Map<String, dynamic> mapData = {
            'from': 'reply',
            'feedId': widget.mapData!['feedId'].toString(),
          };

          Navigator.pushNamed(context, RoutesName.postDetail,
              arguments: mapData);
        }
      },
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter == 0) {
            page++;
            _loadMoreData(page);
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor.newBackgroundColor,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: MyColor.newBackgroundColor,
            automaticallyImplyLeading: false,
            toolbarHeight: 140, // Set this height
            flexibleSpace: Container(
              color: MyColor.newBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: TextButton(
                            onPressed: () {
                              if (widget.mapData!['popUsed']) {
                                Navigator.pop(context, commentLen);
                              } else {
                                Map<String, dynamic> mapData = {
                                  'from': 'reply',
                                  'feedId':
                                      widget.mapData!['feedId'].toString(),
                                };
                                Navigator.pushNamed(
                                    context, RoutesName.postDetail,
                                    arguments: mapData);
                              }
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(20, 20),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            child: Image.asset(
                                'assets/images/icons/back_icon.png',
                                height: 30,
                                width: 30,
                                color: MyColor.white),
                          ),
                        ),
                        MyString.bold('${'reply'.tr}(S)'.toUpperCase(), 20,
                            MyColor.white, TextAlign.start),
                        SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),

                        // GestureDetector(
                        //   onTap: () async {
                        //     FocusManager.instance.primaryFocus!.unfocus();
                        //
                        //     Map<String, dynamic> mapData = {'userID': widget.mapData!['userId'].toString()};
                        //     Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                        //   },
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.all(Radius.circular(50)),
                        //     child: widget.mapData!['userImage'].toString().isNotEmpty && widget.mapData!['userImage'].toString() != "null"
                        //         ? Image.network((widget.mapData!['userImage'].toString().isEmpty)?widget.mapData!['userImage'].toString():ApiStrings.mediaURl+widget.mapData!['userImage'].toString(),
                        //         width: 35,
                        //         height: 35,
                        //         fit: BoxFit.cover,
                        //         loadingBuilder: (context, child, loadingProgress) =>
                        //         (loadingProgress == null) ? child : Container(height: 30, width: 30, child: customProgressBar()))
                        //         : Container(
                        //         width: 40,
                        //         height: 40,
                        //         color: MyColor.cardColor,
                        //         child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 35, height: 35))),
                        //   ),
                        // ),

                        const SizedBox(width: 5),

                        Flexible(
                            child: MyString.boldMultiLine(
                                widget.mapData!['comment'].toString(),
                                15,
                                MyColor.white,
                                TextAlign.start,
                                2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            bottom: true,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              decoration: BoxDecoration(
                  color: MyColor.grey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: loader
                            ? Container(
                                child: progressBar(),
                              )
                            : getComment.isNotEmpty
                                ? ListView.builder(
                                    itemCount: getComment.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(bottom: 10),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(10),
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
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    FocusManager
                                                        .instance.primaryFocus!
                                                        .unfocus();
                                                    Map<String, dynamic>
                                                        mapData = {
                                                      'userID':
                                                          getComment[index]
                                                              .user!
                                                              .id
                                                              .toString()
                                                    };
                                                    Navigator.pushNamed(context,
                                                        RoutesName.myProfile,
                                                        arguments: mapData);
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    child: getComment[index]
                                                                .user!
                                                                .profilePicture !=
                                                            null
                                                        ? Image.network(
                                                            '${ApiStrings.mediaURl}${getComment[index].user!.profilePicture.toString()}',
                                                            height: 30,
                                                            width: 30,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (context,
                                                                    child,
                                                                    loadingProgress) =>
                                                                (loadingProgress ==
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
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          FocusManager.instance
                                                              .primaryFocus!
                                                              .unfocus();
                                                          Map<String, dynamic>
                                                              mapData = {
                                                            'userID':
                                                                getComment[
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
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.35,
                                                              child: RichText(
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                text: TextSpan(
                                                                  text: getComment[
                                                                          index]
                                                                      .user!
                                                                      .name
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'poppins_medium',
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: MyColor
                                                                        .textBlack,
                                                                  ),
                                                                  children: [],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                child: MyString.medMultiLine(
                                                                    getComment[
                                                                            index]
                                                                        .createdAt
                                                                        .toString(),
                                                                    10,
                                                                    MyColor
                                                                        .textFieldBorder,
                                                                    TextAlign
                                                                        .end,
                                                                    1)),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.65,
                                                            child: getComment[
                                                                        index]
                                                                    .comment
                                                                    .toString()
                                                                    .startsWith(
                                                                        'https://')
                                                                ? Container(
                                                                    height: 150,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                      child: Image.network(
                                                                          getComment[index]
                                                                              .comment
                                                                              .toString(),
                                                                          loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                                                                              ? child
                                                                              : customProgressBar()),
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    child:
                                                                        ReadMoreText(
                                                                      getComment[
                                                                              index]
                                                                          .comment
                                                                          .toString(),
                                                                      trimMode:
                                                                          TrimMode
                                                                              .Line,
                                                                      trimLines:
                                                                          3,
                                                                      colorClickableText:
                                                                          Colors
                                                                              .pink,
                                                                      trimCollapsedText:
                                                                          '${'more'.tr}',
                                                                      trimExpandedText:
                                                                          '',
                                                                      moreStyle: TextStyle(
                                                                          color: MyColor
                                                                              .newBackgroundColor,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                          ),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (getComment[
                                                                            index]
                                                                        .isLiked ==
                                                                    0) {
                                                                  getComment[
                                                                          index]
                                                                      .isLiked = 1;
                                                                  getComment[
                                                                          index]
                                                                      .totalLikes = (getComment[
                                                                              index]
                                                                          .totalLikes! +
                                                                      1);
                                                                } else {
                                                                  getComment[
                                                                          index]
                                                                      .isLiked = 0;
                                                                  getComment[
                                                                          index]
                                                                      .totalLikes = (getComment[
                                                                              index]
                                                                          .totalLikes! -
                                                                      1);
                                                                }
                                                                commentLikeApi(
                                                                    widget
                                                                        .mapData![
                                                                            'feedId']
                                                                        .toString(),
                                                                    getComment[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                              },
                                                              style: TextButton.styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  minimumSize:
                                                                      Size(30,
                                                                          40),
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
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                      (getComment[index].isLiked ==
                                                                              1)
                                                                          ? 'assets/images/icons/like_click.png'
                                                                          : 'assets/images/icons/like.png',
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                  if (getComment[index]
                                                                              .totalLikes !=
                                                                          0 &&
                                                                      getComment[index]
                                                                              .totalLikes !=
                                                                          null)
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                1,
                                                                            left:
                                                                                3),
                                                                        child: MyString.bold(
                                                                            getComment[index].totalLikes.toString(),
                                                                            10,
                                                                            MyColor.textFieldBorder,
                                                                            TextAlign.center)),
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 20, left: 35, top: 8),
                                              child: (sharedPref.getString(
                                                          SharedKey.userId) ==
                                                      getComment[index]
                                                          .userId
                                                          .toString())
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        await showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          builder: (_) {
                                                            return _deletePost(
                                                                getComment[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                          },
                                                        );
                                                      },
                                                      child: MyString.med(
                                                          'delete'.tr,
                                                          12,
                                                          MyColor
                                                              .textFieldBorder,
                                                          TextAlign.start))
                                                  : Container(),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                : Column(
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
                                              'noReply'.tr,
                                              16,
                                              MyColor.textFieldBorder,
                                              TextAlign.center)),
                                    ],
                                  ),
                      ),

                      //messageField
                      Container(
                        height: 60,
                        padding: const EdgeInsets.all(4),
                        color: MyColor.grey,
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Flexible(
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
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
                                            .isNotEmpty)
                                          InkWell(
                                            onTap: () {
                                              _focusNode.unfocus();
                                              commentSending = true;
                                              isShowEmoji = false;
                                              if (msgField.text
                                                  .trim()
                                                  .isNotEmpty) {
                                                addCommentApi(
                                                    widget.mapData!['feedId']
                                                        .toString(),
                                                    msgField.text
                                                        .trim()
                                                        .toString(),
                                                    widget.mapData!['parentId']
                                                        .toString());
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                  color: MyColor
                                                      .newBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
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
                                        color: MyColor.textFieldBorder,
                                        fontSize: 14),
                                  ),
                                  onTap: () {
                                    if (isShowEmoji) {
                                      setState(
                                          () => isShowEmoji = !isShowEmoji);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
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
                  if (commentSending) progressBar()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _deletePost(String id) {
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
                              child: MyString.med('no'.tr, 20, MyColor.orange,
                                  TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            commentSending = true;
                            await deleteComment(id);
                            Navigator.pop(context);
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) {
                                return success('deleteComment'.tr, 0);
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: MyColor.orange,
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

  feedCommentApi(String id, String loadPage, String parentId) async {
    var res = await AllApi.getMethodApi(
        '${ApiStrings.feedComments}?page=$loadPage&limit=20&feedId=$id&parentId=$parentId');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      loader = false;
      commentSending = false;
      if (loadPage == '1') {
        getComment.clear();
      }
      commentModel = GetFeedCommentModel.fromJson(result);
      print('RESULT IS get $result');

      for (int i = 0; i < commentModel.data!.length; i++) {
        getComment.add(commentModel.data![i]);
        if (getComment[i].isLiked == 1) {
          getComment[i].likeEnable = true;
        } else {
          getComment[i].likeEnable = false;
        }
      }

      print('RESULT IS List $getComment');
      commentLen = getComment.length.toString();
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    setState(() {});
  }

  addCommentApi(String feedId, String textValue, String parentId) async {
    Map<String, String> mapData = {
      'feedId': feedId.toString(),
      'comment': textValue,
      'parentId': parentId
    };
    var res = await AllApi.postMethodApi(ApiStrings.feedComment, mapData);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      sendFeedCommentModel = SendFeedCommentModel.fromJson(result);
      sendFeedCommentModel.data!.isLiked = 0;
      sendFeedCommentModel.data!.totalLikes = 0;
      getComment.add(sendFeedCommentModel.data!);
      msgField.text = '';
      commentSending = false;
      print(getComment);
      commentLen = getComment.length.toString();
    }
    setState(() {});
  }

  commentLikeApi(String feedId, String textValue) async {
    Map<String, String> mapData = {
      'feedId': feedId.toString(),
      'feedCommentId': textValue
    };
    var res = await AllApi.postMethodApi(ApiStrings.likefeedComment, mapData);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {}
    setState(() {});
  }

  deleteComment(String id) async {
    var res = await AllApi.deleteMethodApiQuery(
        "${ApiStrings.deleteFeedComment}?id=$id");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      feedCommentApi(widget.mapData!['feedId'].toString(), page.toString(),
          widget.mapData!['parentId'].toString());
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

  GiphyGif? _gif;
  void _openGiphyGet(int type) async {
    // type 0 : gif, 1: sticker

    GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      apiKey: ApiStrings.gifKey,
      lang: GiphyLanguage.english,
      // Optional - defaults to GiphyLanguage.english
      searchText: 'funny',
      // Optional - defaults to ""
      modal: true,
      showGIFs: type == 0 ? true : false,
      showEmojis: false,
      showStickers: type == 1 ? true : false,
    );

    _gif = gif;
    print("GIF-IMAGE ${_gif!.images!.original!.url}");
    addCommentApi(
        widget.mapData!['feedId'].toString(),
        _gif!.images!.original!.url.toString(),
        widget.mapData!['parentId'].toString());
    setState(() {});
  }
}
