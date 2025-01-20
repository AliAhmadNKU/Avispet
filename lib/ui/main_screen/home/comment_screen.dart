import 'dart:convert';
import 'dart:io';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:readmore/readmore.dart';
import '../../../models/get_feed_comment_model.dart';
import '../../../models/send_feed_comment_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/dialogs/dialog_success.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/shared_pref.dart';

class CommentScreen extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const CommentScreen({super.key, this.mapData});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _focusNode = FocusNode();
  GiphyGif? _gif;

  GetFeedCommentModel commentModel = GetFeedCommentModel();
  SendFeedCommentModel sendFeedCommentModel = SendFeedCommentModel();
  bool isShowEmoji = false;
  List<GetFeedCommentModelBody> getComment = [];
  var msgField = TextEditingController();
  int page = 1;
  bool commentSending = false;
  bool loader = true;
  String? commentLen;

  void _loadMoreData(int loaderPage) {
    setState(() {
      feedCommentApi(
          widget.mapData!['feedId'].toString(), loaderPage.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    feedCommentApi(widget.mapData!['feedId'].toString(), page.toString());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, commentLen);
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
          backgroundColor: MyColor.orange2,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: MyColor.orange2,
            automaticallyImplyLeading: false,
            toolbarHeight: 90, // Set this height
            flexibleSpace: Container(
              color: MyColor.orange2,
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
                            onPressed: () => Navigator.pop(context),
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
                        MyString.bold('comment'.tr.toUpperCase(), 20,
                            MyColor.white, TextAlign.start),
                        SizedBox()
                      ],
                    ),
                    // SizedBox(height: 20,),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //
                    //         const SizedBox(width: 10),
                    //
                    //         GestureDetector(
                    //           onTap: () async {
                    //             FocusManager.instance.primaryFocus!.unfocus();
                    //
                    //               Map<String, dynamic> mapData = {'userID': widget.mapData!['userId'].toString()};
                    //               Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                    //           },
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.all(Radius.circular(50)),
                    //             child: widget.mapData!['userImage'].toString().isNotEmpty && widget.mapData!['userImage'].toString() != "null"
                    //                 ? Image.network(ApiStrings.mediaURl+widget.mapData!['userImage'].toString(),
                    //                 width: 35,
                    //                 height: 35,
                    //                 fit: BoxFit.cover,
                    //                 loadingBuilder: (context, child, loadingProgress) =>
                    //                 (loadingProgress == null) ? child : Container(height: 30, width: 30, child: customProgressBar()))
                    //                 : Container(
                    //                 width: 40,
                    //                 height: 40,
                    //                 color: MyColor.cardColor,
                    //                 child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 35, height: 35))),
                    //           ),
                    //         ),
                    //
                    //         const SizedBox(width: 5),
                    //
                    //         GestureDetector(
                    //           onTap: () async {
                    //             FocusManager.instance.primaryFocus!.unfocus();
                    //               Map<String, dynamic> mapData = {'userID': widget.mapData!['userId'].toString()};
                    //               Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                    //           },
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               Container(
                    //                   width: MediaQuery.of(context).size.width * .5,
                    //                   child: MyString.med(widget.mapData!['userName'].toString(), 15, MyColor.white, TextAlign.start)),
                    //               Container(
                    //                   width: MediaQuery.of(context).size.width * .5,
                    //                   child: MyString.bold(widget.mapData!['race'].toString(), 18, MyColor.white, TextAlign.start)),
                    //             ],
                    //           ),
                    //         ),
                    //
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              decoration: BoxDecoration(
                  color: MyColor.grey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: loader
                  ? Container(
                      child: progressBar(),
                    )
                  : Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: getComment.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: getComment.length,
                                      shrinkWrap: true,
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      itemBuilder: (context, index) {
                                        return (getComment[index].replyId ==
                                                null)
                                            ? Container(
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: MyColor.white,
                                                    boxShadow: <BoxShadow>[
                                                      new BoxShadow(
                                                        color: MyColor.liteGrey,
                                                        blurRadius: 2.0,
                                                        offset: new Offset(
                                                            0.0, 3.0),
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus!
                                                                    .unfocus();
                                                                Map<String,
                                                                        dynamic>
                                                                    mapData = {
                                                                  'userID': getComment[
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
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            50)),
                                                                child: getComment[index]
                                                                            .user!
                                                                            .profilePicture !=
                                                                        null
                                                                    ? Image.network(
                                                                        '${ApiStrings.mediaURl}${getComment[index].user!.profilePicture.toString()}',
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        loadingBuilder: (context, child, loadingProgress) => (loadingProgress ==
                                                                                null)
                                                                            ? child
                                                                            : Container(
                                                                                height: 50,
                                                                                width: 50,
                                                                                child: customProgressBar()))
                                                                    : Image.asset(
                                                                        'assets/images/onboard/placeholder_image.png',
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
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
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus!
                                                                        .unfocus();
                                                                    Map<String,
                                                                            dynamic>
                                                                        mapData =
                                                                        {
                                                                      'userID': getComment[
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
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.7,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                getComment[index].user!.name.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'roboto_medium',
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: MyColor.textBlack,
                                                                            ),
                                                                            children: [],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            width:
                                                                                80,
                                                                            child: MyString.medMultiLine(
                                                                                getComment[index].createdAt.toString(),
                                                                                10,
                                                                                MyColor.textFieldBorder,
                                                                                TextAlign.end,
                                                                                1)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.7,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      getComment[index]
                                                                              .comment
                                                                              .toString()
                                                                              .startsWith('https://')
                                                                          ? Container(
                                                                              height: 150,
                                                                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                child: Image.network(getComment[index].comment.toString(), loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : customProgressBar()),
                                                                              ),
                                                                            )
                                                                          : SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.60,
                                                                              child: ReadMoreText(
                                                                                getComment[index].comment.toString(),
                                                                                trimMode: TrimMode.Line,
                                                                                trimLines: 3,
                                                                                colorClickableText: Colors.pink,
                                                                                trimCollapsedText: '${'more'.tr}',
                                                                                trimExpandedText: '',
                                                                                moreStyle: TextStyle(color: MyColor.orange2, fontSize: 14, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (getComment[index].isLiked ==
                                                                                0) {
                                                                              getComment[index].isLiked = 1;
                                                                              getComment[index].totalLikes = (getComment[index].totalLikes! + 1);
                                                                            } else {
                                                                              getComment[index].isLiked = 0;
                                                                              getComment[index].totalLikes = (getComment[index].totalLikes! - 1);
                                                                            }

                                                                            commentLikeApi(widget.mapData!['feedId'].toString(),
                                                                                getComment[index].id.toString());
                                                                          },
                                                                          style: TextButton.styleFrom(
                                                                              padding: EdgeInsets.zero,
                                                                              minimumSize: Size(30, 40),
                                                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                                                          child: Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Image.asset((getComment[index].isLiked == 1) ? 'assets/images/icons/like_click.png' : 'assets/images/icons/like.png', width: 20, height: 20, fit: BoxFit.cover),
                                                                              if (getComment[index].totalLikes != 0 && getComment[index].totalLikes != null)
                                                                                Container(margin: EdgeInsets.only(right: 1, left: 3), child: MyString.bold(getComment[index].totalLikes.toString(), 10, MyColor.textFieldBorder, TextAlign.center)),
                                                                            ],
                                                                          )),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20,
                                                              left: 50),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            flex: 1,
                                                            child:
                                                                GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      Map<String,
                                                                              dynamic>
                                                                          mapData =
                                                                          {
                                                                        'popUsed':
                                                                            true,
                                                                        'feedId': widget
                                                                            .mapData!['feedId']
                                                                            .toString(),
                                                                        'parentId': getComment[index]
                                                                            .id
                                                                            .toString(),
                                                                        'userImage': getComment[index]
                                                                            .user!
                                                                            .profilePicture
                                                                            .toString(),
                                                                        'userId': getComment[index]
                                                                            .user!
                                                                            .id
                                                                            .toString(),
                                                                        'userName': getComment[index]
                                                                            .user!
                                                                            .name
                                                                            .toString(),
                                                                        'comment': getComment[index]
                                                                            .comment
                                                                            .toString(),
                                                                      };
                                                                      var res = await Navigator.pushNamed(
                                                                          context,
                                                                          RoutesName
                                                                              .replyScreen,
                                                                          arguments:
                                                                              mapData);
                                                                      getComment[index]
                                                                              .haveChildComments =
                                                                          int.parse(
                                                                              res.toString());
                                                                      page = 1;
                                                                      feedCommentApi(
                                                                          widget
                                                                              .mapData!['feedId']
                                                                              .toString(),
                                                                          page.toString());

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          color:
                                                                              MyColor.orange2),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              7),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            "assets/images/icons/reply_icon.png",
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          if (getComment[index].haveChildComments != 0 &&
                                                                              getComment[index].haveChildComments != null)
                                                                            Container(margin: EdgeInsets.only(right: 3, left: 3), child: MyString.bold(getComment[index].haveChildComments.toString(), 14, MyColor.white, TextAlign.center)),
                                                                          MyString.med(
                                                                              (getComment[index].haveChildComments != 0 && getComment[index].haveChildComments != 1 && getComment[index].haveChildComments != null)
                                                                                  ? '${'viewReply'.tr}'
                                                                                  : getComment[index].haveChildComments == 1
                                                                                      ? '${'reply'.tr}'
                                                                                      : '${'reply'.tr}',
                                                                              12,
                                                                              MyColor.white,
                                                                              TextAlign.start),
                                                                        ],
                                                                      ),
                                                                    )),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          (sharedPref.getString(
                                                                      SharedKey
                                                                          .userId) ==
                                                                  getComment[
                                                                          index]
                                                                      .userId
                                                                      .toString())
                                                              ? Flexible(
                                                                  flex: 1,
                                                                  child:
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            await showDialog(
                                                                              context: context,
                                                                              barrierDismissible: true,
                                                                              builder: (_) {
                                                                                return _deletePost(getComment[index].id.toString());
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(20), color: MyColor.grey),
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 7),
                                                                            child:
                                                                                Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Image.asset(
                                                                                  "assets/images/icons/delete_comment.png",
                                                                                  height: 15,
                                                                                  width: 15,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                MyString.med('delete'.tr, 12, MyColor.black, TextAlign.start),
                                                                              ],
                                                                            ),
                                                                          )),
                                                                )
                                                              : Flexible(
                                                                  flex: 1,
                                                                  child:
                                                                      SizedBox()),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox();
                                      })
                                  : Column(
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
                                        style: TextStyle(color: MyColor.black),
                                        onChanged: (value) => setState(() {}),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minimumSize:
                                                            Size(30, 30),
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
                                                        Duration(
                                                            milliseconds: 200),
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
                                                          widget.mapData![
                                                                  'feedId']
                                                              .toString(),
                                                          msgField.text
                                                              .trim()
                                                              .toString());
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
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
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 12),
                                          hintText: '${'addComment'.tr}',
                                          hintStyle: TextStyle(
                                              color: MyColor.textFieldBorder,
                                              fontSize: 14),
                                        ),
                                        onTap: () {
                                          if (isShowEmoji) {
                                            setState(() =>
                                                isShowEmoji = !isShowEmoji);
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
                              child: MyString.med('no'.tr, 20, MyColor.orange2,
                                  TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              commentSending = true;
                              deleteComment(id);
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) {
                                  return success('deleteComment'.tr, 0);
                                },
                              );
                            });
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

  _openGiphyGet(int type) async {
    // type 0 : gif, 1: sticker

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

    _gif = gif;
    print("GIF-IMAGE ${_gif!.images!.original!.url}");
    addCommentApi(widget.mapData!['feedId'].toString(),
        _gif!.images!.original!.url.toString());
    setState(() {});
  }

  feedCommentApi(String id, String loadPage) async {
    var res = await AllApi.getMethodApi(
        '${ApiStrings.feedComments}?page=$loadPage&limit=200&feedId=$id');
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
      commentLen = commentModel.metadata!.totalComments.toString();
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

  addCommentApi(String feedId, String textValue) async {
    Map<String, String> mapData = {
      'feedId': feedId.toString(),
      'comment': textValue
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
      feedCommentApi(widget.mapData!['feedId'].toString(), page.toString());
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
}
