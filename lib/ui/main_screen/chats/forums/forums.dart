import 'dart:convert';
import 'package:avispets/models/forum/get_forum.dart';
import 'package:avispets/models/forum/my_reply_topic.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../../models/forum/forum_questions.dart';
import '../../../../utils/apis/connect_socket.dart';
import '../../../../utils/apis/get_api.dart';
import '../../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../../utils/common_function/dialogs/dialog_success.dart';
import '../../../../utils/common_function/my_string.dart';
import '../../../../utils/common_function/search_delay.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/shared_pref.dart';

class Forums extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  Forums({super.key, this.mapData});

  @override
  State<Forums> createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  GetForum getForum = GetForum();
  List<GetForumBody> forumList = [];

  ForumQuestionModel forumQuest = ForumQuestionModel();
  List<ForumQuestionBody> questionList = [];

  MyReplyTopic myReplyTopic = MyReplyTopic();
  List<MyReplyTopicBody> myReplyTopicList = [];

  bool loader = true;
  bool stackLoader = false;
  final searchDelay = SearchDelayFunction();

  int page = 1;
  var searchBar = TextEditingController();
  int currentTab = 1;
  int currentTabBreed = 1;

  @override
  void initState() {
    getForumApi(page, '', currentTabBreed);
    getForumQuestionApi(page, '');
    getReplyTopic(page, '');
    GetApi.getNotify(context, '');
    super.initState();
  }

  _loadMoreData(int loaderPage) {
    setState(() {
      getForumApi(loaderPage, '', currentTabBreed);
      getForumQuestionApi(loaderPage, '');
      getReplyTopic(loaderPage, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          if (forumList.length > 19) {
            page++;
            _loadMoreData(page);
          }
        }
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
            backgroundColor: MyColor.white,
            body: SafeArea(child: _builder(context))),
      ),
    );
  }

  filterBreed(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.white,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, myState) {
            return Container(
              constraints: BoxConstraints(maxHeight: 550, minHeight: 350),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      child: MyString.bold('filter'.tr.toUpperCase(), 20,
                          MyColor.white, TextAlign.center)),
                  ListTile(
                    title: MyString.med('SELECT ALL', 16,
                        MyColor.textFieldBorder, TextAlign.start),
                    trailing: Icon(Icons.check_box, color: MyColor.orange2),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: MyString.med('BREED NAME', 16,
                              MyColor.textFieldBorder, TextAlign.start),
                          trailing: Icon(
                              index == 1
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: MyColor.orange2),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      myState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 15, right: 25, left: 25),
                      alignment: Alignment.center,
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: MyColor.orange2,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: MyString.med(
                          'filter'.tr, 18, MyColor.white, TextAlign.center),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _builder(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25.0, right: 25, left: 25, top: 0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeaderWidget(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: MyString.bold(
                    '${'forums'.tr}', 27, MyColor.title, TextAlign.center),
              ),
              //!@search-bar
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffEBEBEB)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(13),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(13),
                                bottomRight: Radius.circular(50))),
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
                            suffixIcon: (searchBar.text
                                    .trim()
                                    .toString()
                                    .isNotEmpty)
                                ? GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();
                                        stackLoader = true;
                                        searchBar.text = '';

                                        (currentTab == 1)
                                            ? getForumApi(
                                                page, '', currentTabBreed)
                                            : (currentTab == 2)
                                                ? getForumQuestionApi(page, '')
                                                : (currentTab == 3)
                                                    ? getReplyTopic(page, '')
                                                    : getForumApi(page, '',
                                                        currentTabBreed);
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: MyColor.orange2,
                                    ))
                                : Container(
                                    width: 40,
                                    height: 40,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Color(0xff4F2020),
                                        borderRadius:
                                            BorderRadius.circular(150)),
                                    child: Image.asset(
                                        'assets/images/icons/filter.png')),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            hintText: 'search'.tr,
                            hintStyle: TextStyle(
                                color: MyColor.textBlack0, fontSize: 14),
                          ),
                          onChanged: (value) {
                            setState(() {
                              page = 1;
                              stackLoader = true;
                              searchDelay.run(() {
                                if (value.isNotEmpty) {
                                  (currentTab == 1)
                                      ? getForumApi(
                                          page, value, currentTabBreed)
                                      : (currentTab == 2)
                                          ? getForumQuestionApi(page, value)
                                          : (currentTab == 3)
                                              ? getReplyTopic(page, value)
                                              : getForumApi(
                                                  page, value, currentTabBreed);
                                }
                                if (value.isEmpty) {
                                  (currentTab == 1)
                                      ? getForumApi(page, '', currentTabBreed)
                                      : (currentTab == 2)
                                          ? getForumQuestionApi(page, '')
                                          : (currentTab == 3)
                                              ? getReplyTopic(page, '')
                                              : getForumApi(
                                                  page, '', currentTabBreed);
                                }

                                FocusManager.instance.primaryFocus!.unfocus();
                              });
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //!@Tab-bar
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 5),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            stackLoader = true;
                            page = 1;
                            getForumApi(page, '', currentTabBreed);
                            currentTab = 1;
                          });
                        },
                        child: Container(
                            height: 29,
                            decoration: BoxDecoration(
                                color: currentTab == 1
                                    ? MyColor.orange2
                                    : Color(0xffFFF9F),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              child: Center(
                                child: Flexible(
                                    child: MyString.medMultiLine(
                                        'home'.tr,
                                        12,
                                        currentTab == 1
                                            ? MyColor.white
                                            : MyColor.orange2,
                                        TextAlign.center,
                                        1)),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            stackLoader = true;
                            page = 1;
                            getForumQuestionApi(page, '');
                            currentTab = 2;
                          });
                        },
                        child: Container(
                            height: 29,
                            decoration: BoxDecoration(
                                color: currentTab == 2
                                    ? MyColor.orange2
                                    : Color(0xffFFF9F),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              child: Center(
                                child: Flexible(
                                    child: MyString.medMultiLine(
                                        'myThread'.tr,
                                        12,
                                        currentTab == 2
                                            ? MyColor.white
                                            : MyColor.orange2,
                                        TextAlign.center,
                                        1)),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                        child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          stackLoader = true;
                          page = 1;
                          getReplyTopic(page, '');
                          currentTab = 3;
                        });
                      },
                      child: Container(
                          height: 29,
                          decoration: BoxDecoration(
                              color: currentTab == 3
                                  ? MyColor.orange2
                                  : Color(0xffFFF9F),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            child: Center(
                              child: Flexible(
                                  child: MyString.medMultiLine(
                                      'myReply'.tr,
                                      12,
                                      currentTab == 3
                                          ? MyColor.white
                                          : MyColor.orange2,
                                      TextAlign.center,
                                      1)),
                            ),
                          )),
                    )),
                  ],
                ),
              ),

              //!@Tab-bar(breed)
              if (currentTab == 1)
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 5),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              stackLoader = true;
                              page = 1;
                              currentTabBreed = 1;
                              getForumApi(page, '', currentTabBreed);
                            });
                          },
                          child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  border: currentTabBreed == 1
                                      ? Border.all(color: MyColor.white)
                                      : Border.all(color: Color(0xffFFEDED)),
                                  color: currentTabBreed == 1
                                      ? Color(0xff800000)
                                      : MyColor.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Center(
                                  child: Flexible(
                                      child: MyString.medMultiLine(
                                          'dog'.tr,
                                          12,
                                          currentTabBreed == 1
                                              ? MyColor.white
                                              : MyColor.textFieldBorder,
                                          TextAlign.start,
                                          1)),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              stackLoader = true;
                              page = 1;
                              currentTabBreed = 2;
                              getForumApi(page, '', currentTabBreed);
                            });
                          },
                          child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  border: currentTabBreed == 2
                                      ? Border.all(color: MyColor.white)
                                      : Border.all(color: Color(0xffFFEDED)),
                                  color: currentTabBreed == 2
                                      ? Color(0xff800000)
                                      : MyColor.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50))),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Center(
                                  child: Flexible(
                                      child: MyString.medMultiLine(
                                          'cat'.tr,
                                          12,
                                          currentTabBreed == 2
                                              ? MyColor.white
                                              : MyColor.textFieldBorder,
                                          TextAlign.start,
                                          1)),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),

              //main-List
              if (currentTab == 1)
                loader
                    ? progressBar()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: forumList.length,
                          padding: EdgeInsets.only(bottom: 5),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                Map<String, dynamic> mapping = {
                                  'image': getForum.data![index].dogBreed
                                                  ?.icon !=
                                              null &&
                                          getForum.data![index].dogBreed!.icon
                                              .toString()
                                              .isNotEmpty
                                      ? '${ApiStrings.mediaURl}${getForum.data![index].dogBreed?.icon.toString()}'
                                      : '',
                                  'desc': sharedPref
                                              .getString(
                                                  SharedKey.languageValue)
                                              .toString() ==
                                          'en'
                                      ? getForum.data![index].description
                                          .toString()
                                      : getForum.data![index].descriptionFr
                                          .toString(),
                                  'topic': forumList[index]
                                      .dogBreed!
                                      .name
                                      .toString(),
                                  'forumId': forumList[index].id,
                                };
                                await Navigator.pushNamed(
                                    context, RoutesName.forumQuestion,
                                    arguments: mapping);
                                setState(() {
                                  loader = true;
                                  page = 1;
                                  getForumApi(page, '', currentTabBreed);
                                });
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 5),
                                decoration: BoxDecoration(
                                  color: MyColor.card,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                            child: forumList[index].dogBreed?.icon != null &&
                                                    forumList[index]
                                                        .dogBreed!
                                                        .icon
                                                        .toString()
                                                        .isNotEmpty
                                                ? Image.network(
                                                    '${ApiStrings.mediaURl}${forumList[index].dogBreed?.icon.toString()}',
                                                    width: 85,
                                                    height: 85,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) =>
                                                        (loadingProgress == null)
                                                            ? child
                                                            : customProgressBar())
                                                : Container(
                                                    width: 85,
                                                    height: 85,
                                                    color: MyColor.cardColor,
                                                    child: Center(
                                                        child: Image.asset(
                                                            'assets/images/onboard/placeholder_image.png',
                                                            width: 85,
                                                            height: 85))),
                                          ),
                                          SizedBox(width: 15),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .57,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyString.bold(
                                                    forumList[index]
                                                        .dogBreed!
                                                        .name
                                                        .toString(),
                                                    14,
                                                    Color(0xff4F2020),
                                                    TextAlign.start),
                                                const SizedBox(height: 5),
                                                if (forumList[index]
                                                        .description
                                                        .toString()
                                                        .isNotEmpty &&
                                                    forumList[index]
                                                            .description !=
                                                        null)
                                                  MyString.regMultiLine(
                                                      sharedPref
                                                                  .getString(
                                                                      SharedKey
                                                                          .languageValue)
                                                                  .toString() ==
                                                              'en'
                                                          ? forumList[index]
                                                              .description
                                                              .toString()
                                                          : forumList[index]
                                                              .descriptionFr
                                                              .toString(),
                                                      11,
                                                      MyColor.textBlack0,
                                                      TextAlign.start,
                                                      3),
                                                const SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    if (forumList[index]
                                                            .totalReplies !=
                                                        0)
                                                      Container(
                                                        child: MyString.reg(
                                                            '${(forumList[index].totalReplies == 1) ? 'reply'.tr : 'replies'.tr}: ${forumList[index].totalReplies.toString()}',
                                                            11,
                                                            MyColor.orange2,
                                                            TextAlign.start),
                                                      )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

              if (currentTab == 2)
                questionList.isNotEmpty
                    ? loader
                        ? progressBar()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: questionList.length,
                              padding: EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> mapping = {
                                      'topicTitle': questionList[index].title,
                                      'forumId': questionList[index].forumId,
                                      'forumTopicId': questionList[index].id,
                                    };
                                    await Navigator.pushNamed(
                                        context, RoutesName.forumReply,
                                        arguments: mapping);
                                    setState(() {
                                      loader = true;
                                      page = 1;
                                      getForumQuestionApi(page, '');
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, bottom: 5),
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
                                          Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                                child: questionList[index]
                                                            .user
                                                            ?.profilePicture !=
                                                        null
                                                    ? Image.network('${ApiStrings.mediaURl}${questionList[index].user?.profilePicture.toString()}',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                                child,
                                                                loadingProgress) =>
                                                            (loadingProgress == null)
                                                                ? child
                                                                : customProgressBar())
                                                    : Container(
                                                        width: 50,
                                                        height: 50,
                                                        color:
                                                            MyColor.cardColor,
                                                        child: Center(
                                                            child: Image.asset(
                                                                'assets/images/onboard/placeholder_image.png',
                                                                width: 50,
                                                                height: 50))),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              MyString.med(
                                                                  "${questionList[index].user!.firstName.toString()} ${questionList[index].user!.lastName.toString()}",
                                                                  12,
                                                                  MyColor.black,
                                                                  TextAlign
                                                                      .start),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .50,
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text: questionList[
                                                                            index]
                                                                        .title
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'roboto_medium',
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: MyColor
                                                                          .textBlack,
                                                                    ),
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            ' \u2022${questionList[index].createdAt.toString()}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'roboto_medium',
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              MyColor.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Map<String,
                                                                      dynamic>
                                                                  mapData = {
                                                                'forumTopicId':
                                                                    questionList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                'sendEmail':
                                                                    questionList[index].sendEmail ==
                                                                            0
                                                                        ? '1'
                                                                        : '0',
                                                              };

                                                              debugPrint(
                                                                  "ENABLE NOTIFICATION MAP DATA IS : $mapData");
                                                              var res = await AllApi
                                                                  .postMethodApi(
                                                                      ApiStrings
                                                                          .enableDisableForumNotification,
                                                                      mapData);
                                                              var result =
                                                                  jsonDecode(res
                                                                      .toString());
                                                              setState(() {
                                                                if (result[
                                                                        'status'] ==
                                                                    200) {
                                                                  questionList[
                                                                          index]
                                                                      .sendEmailEnable = !questionList[
                                                                          index]
                                                                      .sendEmailEnable;
                                                                  toaster(
                                                                      context,
                                                                      result['message']
                                                                          .toString());
                                                                } else {
                                                                  toaster(
                                                                      context,
                                                                      result['message']
                                                                          .toString());
                                                                }
                                                              });
                                                            },
                                                            style: TextButton.styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                minimumSize:
                                                                    Size(
                                                                        30, 30),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap),
                                                            child: Image.asset(
                                                                'assets/images/icons/notification.png',
                                                                color: questionList[
                                                                            index]
                                                                        .sendEmailEnable
                                                                    ? MyColor
                                                                        .orange2
                                                                    : MyColor
                                                                        .textFieldBorder,
                                                                width: 20,
                                                                height: 20),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: ReadMoreText(
                                                            questionList[index]
                                                                .description
                                                                .toString(),
                                                            trimMode:
                                                                TrimMode.Line,
                                                            trimLines: 3,
                                                            colorClickableText:
                                                                Colors.pink,
                                                            trimCollapsedText:
                                                                '${'more'.tr}',
                                                            trimExpandedText:
                                                                '',
                                                            moreStyle: TextStyle(
                                                                color: MyColor
                                                                    .orange2,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(color: MyColor.white),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 20, left: 50),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: TextButton(
                                                    onPressed: () async {
                                                      Map<String, dynamic>
                                                          mapping = {
                                                        'topicTitle':
                                                            questionList[index]
                                                                .title,
                                                        'forumId':
                                                            questionList[index]
                                                                .forumId,
                                                        'forumTopicId':
                                                            questionList[index]
                                                                .id,
                                                      };
                                                      await Navigator.pushNamed(
                                                          context,
                                                          RoutesName.forumReply,
                                                          arguments: mapping);
                                                      setState(() {
                                                        loader = true;
                                                        page = 1;
                                                        getForumQuestionApi(
                                                            page, '');
                                                      });
                                                    },
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minimumSize:
                                                            Size(50, 30),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              MyColor.orange2),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 7),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/icons/reply_icon.png",
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          if (questionList[
                                                                      index]
                                                                  .totalReplies !=
                                                              0)
                                                            Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            3,
                                                                        left:
                                                                            3),
                                                                child: MyString.bold(
                                                                    questionList[
                                                                            index]
                                                                        .totalReplies
                                                                        .toString(),
                                                                    14,
                                                                    MyColor
                                                                        .white,
                                                                    TextAlign
                                                                        .center)),
                                                          MyString.med(
                                                              (questionList[
                                                                                  index]
                                                                              .totalReplies !=
                                                                          0 &&
                                                                      questionList[index]
                                                                              .totalReplies !=
                                                                          1 &&
                                                                      questionList[index]
                                                                              .totalReplies !=
                                                                          null)
                                                                  ? '${'viewReply'.tr}'
                                                                  : questionList[index]
                                                                              .totalReplies ==
                                                                          1
                                                                      ? '${'reply'.tr}'
                                                                      : ' ${'reply'.tr}',
                                                              12,
                                                              MyColor.white,
                                                              TextAlign.start)
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (_) {
                                                        return _deleteQuestionDialog(
                                                            questionList[index]
                                                                .id
                                                                .toString());
                                                      },
                                                    );
                                                    setState(() {});
                                                  },
                                                  style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      minimumSize: Size(50, 30),
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: MyColor.grey),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 7),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/icons/delete_comment.png",
                                                          height: 15,
                                                          width: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        MyString.med(
                                                            'delete'.tr,
                                                            12,
                                                            MyColor.black,
                                                            TextAlign.start),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                    : loader
                        ? progressBar()
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
                                    child: MyString.bold(
                                        'noDataFound'.tr,
                                        16,
                                        MyColor.textFieldBorder,
                                        TextAlign.center)),
                              ],
                            ),
                          ),

              if (currentTab == 3)
                myReplyTopicList.isNotEmpty
                    ? loader
                        ? progressBar()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: myReplyTopicList.length,
                              padding: EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    Map<String, dynamic> mapping = {
                                      'topicTitle': questionList[index].title,
                                      'forumId':
                                          myReplyTopicList[index].forumId,
                                      'forumTopicId':
                                          myReplyTopicList[index].forumTopicId,
                                    };
                                    await Navigator.pushNamed(
                                        context, RoutesName.forumReply,
                                        arguments: mapping);
                                    setState(() {
                                      stackLoader = true;
                                      page = 1;
                                      getReplyTopic(page, '');
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, bottom: 5),
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
                                          Radius.circular(10)),
                                    ),
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
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    50)),
                                                        child: myReplyTopicList[
                                                                        index]
                                                                    .user!
                                                                    .profilePicture !=
                                                                null
                                                            ? Image.network(
                                                                '${ApiStrings.mediaURl}${myReplyTopicList[index].user!.profilePicture.toString()}',
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 30,
                                                                height: 30,
                                                                loadingBuilder: (context,
                                                                        child,
                                                                        loadingProgress) =>
                                                                    (loadingProgress ==
                                                                            null)
                                                                        ? child
                                                                        : customProgressBar())
                                                            : Image.asset(
                                                                'assets/images/onboard/placeholder_image.png',
                                                                width: 30,
                                                                height: 30,
                                                              ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .57,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text: myReplyTopicList[
                                                                      index]
                                                                  .forumTopic!
                                                                  .title
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'roboto_medium',
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: MyColor
                                                                    .textBlack,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      '  \u2022${myReplyTopicList[index].createdAt.toString()}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'roboto_medium',
                                                                    fontSize:
                                                                        12,
                                                                    color: MyColor
                                                                        .textFieldBorder,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .7,
                                                            child: MyString.med(
                                                                '${'replyBy'.tr}: ${myReplyTopicList[index].user!.firstName.toString()} ${myReplyTopicList[index].user!.lastName.toString()}',
                                                                12,
                                                                MyColor
                                                                    .textBlack,
                                                                TextAlign
                                                                    .start)),
                                                        myReplyTopicList[index]
                                                                .comment
                                                                .toString()
                                                                .startsWith(
                                                                    'https://')
                                                            ? Container(
                                                                height: 150,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                  child: Image.network(
                                                                      myReplyTopicList[
                                                                              index]
                                                                          .comment
                                                                          .toString(),
                                                                      loadingBuilder: (context,
                                                                              child,
                                                                              loadingProgress) =>
                                                                          (loadingProgress == null)
                                                                              ? child
                                                                              : customProgressBar()),
                                                                ),
                                                              )
                                                            : Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .7,
                                                                child:
                                                                    ReadMoreText(
                                                                  myReplyTopicList[
                                                                          index]
                                                                      .comment
                                                                      .toString(),
                                                                  trimMode:
                                                                      TrimMode
                                                                          .Line,
                                                                  trimLines: 3,
                                                                  colorClickableText:
                                                                      Colors
                                                                          .pink,
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
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        if (myReplyTopicList[
                                                                    index]
                                                                .isLiked ==
                                                            1) {
                                                          myReplyTopicList[
                                                                  index]
                                                              .isLiked = 0;
                                                          myReplyTopicList[
                                                                      index]
                                                                  .totalLikes =
                                                              myReplyTopicList[
                                                                          index]
                                                                      .totalLikes! -
                                                                  1;
                                                        } else {
                                                          myReplyTopicList[
                                                                  index]
                                                              .isLiked = 1;
                                                          myReplyTopicList[
                                                                      index]
                                                                  .totalLikes =
                                                              myReplyTopicList[
                                                                          index]
                                                                      .totalLikes! +
                                                                  1;
                                                        }

                                                        setState(() {});
                                                        likeForum(
                                                            myReplyTopicList[
                                                                    index]
                                                                .id
                                                                .toString());
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
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image.asset(
                                                              (myReplyTopicList[
                                                                              index]
                                                                          .isLiked ==
                                                                      1)
                                                                  ? 'assets/images/icons/like_click.png'
                                                                  : 'assets/images/icons/like.png',
                                                              width: 20,
                                                              height: 20),
                                                          if (myReplyTopicList[
                                                                      index]
                                                                  .totalLikes !=
                                                              0)
                                                            Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            1,
                                                                        left:
                                                                            3),
                                                                child: MyString.bold(
                                                                    myReplyTopicList[
                                                                            index]
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
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                    : loader
                        ? progressBar()
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
                                    child: MyString.bold(
                                        'noComments'.tr,
                                        16,
                                        MyColor.textFieldBorder,
                                        TextAlign.center)),
                              ],
                            ),
                          ),
            ],
          ),
          if (stackLoader) progressBar()
        ],
      ),
    );
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

  getForumApi(int page, String search, int type) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.forums}?type=$type&page=$page&limit=20&search=$search");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        getForum = GetForum.fromJson(result);
        loader = false;
        stackLoader = false;
        if (page == 1) {
          forumList.clear();
        }
        for (int i = 0; i < getForum.data!.length; i++) {
          forumList.add(getForum.data![i]);
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

  getForumQuestionApi(int page, String search) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.forumTopics}?userId=${sharedPref.getString(SharedKey.userId).toString()}&page=$page&limit=20&search=$search");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        forumQuest = ForumQuestionModel.fromJson(result);
        loader = false;
        stackLoader = false;
        if (page == 1) {
          questionList.clear();
        }
        for (int i = 0; i < forumQuest.data!.length; i++) {
          questionList.add(forumQuest.data![i]);

          if (forumQuest.data![i].sendEmail == 1) {
            questionList[i].sendEmailEnable = true;
          } else {
            questionList[i].sendEmailEnable = false;
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

  getReplyTopic(int page, String value) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.myForumReplies}?page=${page.toString()}&limit=20&search=$value");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        stackLoader = false;
        myReplyTopic = MyReplyTopic.fromJson(result);
        if (page == 1) {
          myReplyTopicList.clear();
        }
        for (int i = 0; i < myReplyTopic.data!.length; i++) {
          myReplyTopicList.add(myReplyTopic.data![i]);
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

  _deleteQuestionDialog(String CommentId) {
    print("COMMENT_ID :  $CommentId");
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
                borderRadius: BorderRadiusDirectional.circular(15)),
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
                  MyString.bold('dialogQuestionTitle'.tr, 20, MyColor.black,
                      TextAlign.center),
                  MyString.med('dialogQuestion'.tr, 12, MyColor.textFieldBorder,
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
                            myState(() {});
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
                                '${ApiStrings.deleteForumTopic}?id=$CommentId');
                            var result = jsonDecode(res.toString());
                            if (result['status'] == 200) {
                              Navigator.pop(context);
                              await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) {
                                  return success('dialogQuestionTitle'.tr, 0);
                                },
                              );

                              myState(() {
                                page = 1;
                                getForumQuestionApi(page, '');
                              });
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
}
