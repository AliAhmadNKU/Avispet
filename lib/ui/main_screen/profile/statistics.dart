import 'dart:convert';

import 'package:avispets/models/gamification/gamification_levels_response_model.dart';
import 'package:avispets/models/gamification/user_activities_response_model.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/shared_pref.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool isLoading = true;
  UserActivitiesResponseModel _userActivitiesResponseModel = UserActivitiesResponseModel();
  GamificationLevelsResponseModel _gamificationLevelsResponseModel = GamificationLevelsResponseModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // GetApi.getNotify(context, '');

    getData();
  }

  List<Color> levelColors = [
    Color(0xffED8631),
    MyColor.orange2,
    MyColor.red,
    MyColor.redd,
    Color(0xffFFC130),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: isLoading
          ? Container(
            child: progressBar(),
          )
          : SafeArea(child: _buildUINEW())
      // _buildUIOLD(),
    );
  }

  Future<void> getData() async {
    await getAllUserActivities();
    await getAllLevels();
    // await GetApi.getGamificationApi(
    //     context, sharedPref.getString(SharedKey.userId).toString());
    // await GetApi.getPointsHistoryApi(
    //     context, sharedPref.getString(SharedKey.userId).toString());


    setState(() {
      isLoading = false;
    });
  }

  pointHistorySheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.white,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              decoration: BoxDecoration(
                color: MyColor.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HeaderWidget(),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/icons/points.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 10),
                          MyString.bold("scoredPoints".tr, 27, MyColor.title,
                              TextAlign.start),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        color: MyColor.card,
                        constraints: new BoxConstraints(
                          minHeight: 100,
                          maxHeight: MediaQuery.of(context).size.height / 1.5,
                        ),
                        child: ListView.builder(
                            itemCount: GetApi.pointHistoryModel.data!.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                color: MyColor.white,
                                padding: const EdgeInsets.all(7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/icons/points_icon.png",
                                            height: 30,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1.5,
                                                  child: MyString.boldMultiLine(
                                                      GetApi.pointHistoryModel
                                                          .data![index].text
                                                          .toString(),
                                                      12,
                                                      MyColor.textFieldBorder,
                                                      TextAlign.start,
                                                      3)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              MyString.med(
                                                  GetApi.pointHistoryModel
                                                      .data![index].createdAt
                                                      .toString(),
                                                  12,
                                                  MyColor.textFieldBorder,
                                                  TextAlign.start),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  pointHistorySheetNew(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.white,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              decoration: BoxDecoration(
                color: MyColor.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HeaderWidget(),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/icons/points.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 10),
                          MyString.bold("scoredPoints".tr, 27, MyColor.title,
                              TextAlign.start),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyString.bold(
                            '${_userActivitiesResponseModel.data!.userProfile!.gamePoints}',
                            80,
                            MyColor.title,
                            TextAlign.start
                        ),
                        MyString.bold(
                            '+pts',
                            27,
                            MyColor.orange2,
                            TextAlign.start
                        ),
                      ],
                    )
                    // Container(
                    //     color: MyColor.card,
                    //     constraints: new BoxConstraints(
                    //       minHeight: 100,
                    //       maxHeight: MediaQuery.of(context).size.height / 1.5,
                    //     ),
                    //     child: ListView.builder(
                    //         itemCount: GetApi.pointHistoryModel.data!.length,
                    //         padding: EdgeInsets.zero,
                    //         shrinkWrap: true,
                    //         itemBuilder: (context, index) {
                    //           return Container(
                    //             color: MyColor.white,
                    //             padding: const EdgeInsets.all(7),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //               MainAxisAlignment.spaceBetween,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 SizedBox(
                    //                   child: Row(
                    //                     children: [
                    //                       Image.asset(
                    //                         "assets/images/icons/points_icon.png",
                    //                         height: 30,
                    //                       ),
                    //                       SizedBox(
                    //                         width: 10,
                    //                       ),
                    //                       Column(
                    //                         crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                         children: [
                    //                           Container(
                    //                               width:
                    //                               MediaQuery.of(context)
                    //                                   .size
                    //                                   .width /
                    //                                   1.5,
                    //                               child: MyString.boldMultiLine(
                    //                                   GetApi.pointHistoryModel
                    //                                       .data![index].text
                    //                                       .toString(),
                    //                                   12,
                    //                                   MyColor.textFieldBorder,
                    //                                   TextAlign.start,
                    //                                   3)),
                    //                           SizedBox(
                    //                             height: 5,
                    //                           ),
                    //                           MyString.med(
                    //                               GetApi.pointHistoryModel
                    //                                   .data![index].createdAt
                    //                                   .toString(),
                    //                               12,
                    //                               MyColor.textFieldBorder,
                    //                               TextAlign.start),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           );
                    //         })),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  levelsSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context1, myState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: MyColor.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderWidget(),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/level.png",
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MyString.bold(
                                'Levels', 27, MyColor.title, TextAlign.start),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                            child: ListView.builder(
                                itemCount: GetApi
                                    .gamification.mMetadata!.levels!.length,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: MyColor.card,
                                            border: Border.all(
                                                color: MyColor.stroke),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(7),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xffED8631),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6))),
                                              height: 29,
                                              padding: EdgeInsets.all(5),
                                              child: MyString.bold(
                                                  (sharedPref
                                                              .getString(SharedKey
                                                                  .languageValue)
                                                              .toString() ==
                                                          'en')
                                                      ? GetApi
                                                          .gamification
                                                          .mMetadata!
                                                          .levels![index]
                                                          .name
                                                          .toString()
                                                      : GetApi
                                                          .gamification
                                                          .mMetadata!
                                                          .levels![index]
                                                          .nameFr
                                                          .toString(),
                                                  12,
                                                  MyColor.white,
                                                  TextAlign.start),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: MyString.med(
                                                  "${GetApi.gamification.mMetadata!.levels![index].minPoints.toString()} - ${GetApi.gamification.mMetadata!.levels![index].maxPoints.toString()} pts",
                                                  12,
                                                  MyColor.textFieldBorder,
                                                  TextAlign.start),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  );
                                })),
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

  levelsSheetNew(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context1, myState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: MyColor.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderWidget(),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/level.png",
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MyString.bold(
                                'Levels', 27, MyColor.title, TextAlign.start),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                            child: ListView.builder(
                                itemCount: _gamificationLevelsResponseModel.data!.length,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final level =  _gamificationLevelsResponseModel.data![index];
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: MyColor.card,
                                            border: Border.all(
                                                color: MyColor.stroke),
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(7),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xffED8631),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(6))),
                                              height: 29,
                                              padding: EdgeInsets.all(5),
                                              child: MyString.bold(
                                                  (sharedPref
                                                      .getString(SharedKey
                                                      .languageValue)
                                                      .toString() ==
                                                      'en')
                                                      ? level
                                                      .name
                                                      .toString()
                                                      : level
                                                      .nameFr
                                                      .toString(),
                                                  12,
                                                  MyColor.white,
                                                  TextAlign.start),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: MyString.med(
                                                  "${level.minPoints.toString()} - ${level.maxPoints.toString()} pts",
                                                  12,
                                                  MyColor.textFieldBorder,
                                                  TextAlign.start),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  );
                                })),
                        _myActivitiesUI(),
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

  Future getAllUserActivities() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.userActivitiesGamification}/${sharedPref.getString(SharedKey.userId)}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _userActivitiesResponseModel = UserActivitiesResponseModel.fromJson(result);
    }
  }

  Widget _buildUIOLD() {
    return SingleChildScrollView(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 20.0, horizontal: 6),
        child: Column(
          children: [
            HeaderWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///myActivities
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyString.bold('myActivities'.tr, 27,
                        MyColor.title, TextAlign.start),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: MyColor.card),
                          child: Row(
                            children: [
                              Image.asset(
                                  'assets/images/icons/avis.png',
                                  width: 33,
                                  height: 33),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    MyString.bold(
                                        GetApi.getProfileModel.data!
                                            .counts!.postReviewCount
                                            .toString(),
                                        21,
                                        Color(0xff293444),
                                        TextAlign.center),
                                    MyString.med(
                                        'reviewSubmitted'.tr,
                                        12,
                                        MyColor.textBlack0,
                                        TextAlign.start)
                                  ]),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: MyColor.card),
                          child: Row(
                            children: [
                              Image.asset('assets/images/icons/qt.png',
                                  width: 33, height: 33),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    MyString.bold(
                                        GetApi
                                            .getProfileModel
                                            .data!
                                            .counts!
                                            .forumSubmissionCount
                                            .toString(),
                                        20,
                                        MyColor.black,
                                        TextAlign.center),
                                    MyString.med(
                                        'questionsSubmitted'.tr,
                                        12,
                                        MyColor.black,
                                        TextAlign.start)
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: MyColor.card),
                          child: Row(
                            children: [
                              Image.asset('assets/images/icons/msg.png',
                                  width: 33, height: 33),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    MyString.bold(
                                        GetApi.getProfileModel.data!
                                            .counts!.postCount
                                            .toString(),
                                        20,
                                        MyColor.black,
                                        TextAlign.center),
                                    MyString.med(
                                        'postsSubmitted'.tr,
                                        12,
                                        MyColor.black,
                                        TextAlign.start)
                                  ]),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: MyColor.card),
                          child: Row(
                            children: [
                              Image.asset('assets/images/icons/res.png',
                                  width: 33, height: 33),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    // MyString.bold(
                                    //     GetApi.getProfileModel.data!
                                    //         .answersSubmitted
                                    //         .toString(),
                                    //     20,
                                    //     MyColor.black,
                                    //     TextAlign.center),
                                    // MyString.med(
                                    //     'responsesSubmitted'.tr,
                                    //     12,
                                    //     MyColor.black,
                                    //     TextAlign.start)
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.9,
                  ),

                  ///Levels
                  InkWell(
                    onTap: () {
                      levelsSheet(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Color(0xffFFEDED))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/level.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // MyString.reg(
                              //     GetApi.getProfileModel.data!
                              //         .userLevel!.name
                              //         .toString(),
                              //     15,
                              //     MyColor.title,
                              //     TextAlign.start),
                            ],
                          ),
                          Row(
                            children: [
                              MyString.reg("moreLevels".tr, 12,
                                  MyColor.textBlack0, TextAlign.start),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/images/icons/back.png",
                                height: 8,
                                width: 8,
                                fit: BoxFit.cover,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  ///Scored Points
                  InkWell(
                    onTap: () {
                      if (GetApi.pointHistoryModel.data == null ||
                          GetApi.pointHistoryModel.data!.isEmpty) {
                        toaster(context, "noEarnHistory".tr);
                      } else {
                        pointHistorySheet(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Color(0xffFFEDED))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/points.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(width: 10),
                              MyString.reg("scoredPoints".tr, 15,
                                  MyColor.title, TextAlign.start),
                            ],
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: MyColor.orange2,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: MyString.reg(
                                  '+${GetApi.getProfileModel.data!.gamePoints.toString()} pts',
                                  12,
                                  MyColor.white,
                                  TextAlign.start)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  ///Ranking
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.ranking);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Color(0xffFFEDED))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/rank.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(width: 10),
                              MyString.reg("ranking".tr, 15,
                                  MyColor.title, TextAlign.start),
                            ],
                          ),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              // MyString.med(
                              //     GetApi
                              //         .getProfileModel.data!.userRanking
                              //         .toString(),
                              //     21,
                              //     Color(0xffFF7519),
                              //     TextAlign.start),
                              SizedBox(width: 10),
                              Image.asset(
                                "assets/images/icons/back.png",
                                height: 8,
                                width: 8,
                                fit: BoxFit.cover,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesName.badges);
                          },
                          child: MyString.bold("badgesTitle".tr, 18,
                              MyColor.title, TextAlign.start)),
                      /*InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesName.badges);
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: MyColor.white),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Row(
                              children: [
                                MyString.med("viewAll".tr, 11, MyColor.textFieldBorder, TextAlign.start),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 10,
                                  color: MyColor.textFieldBorder,
                                ),
                              ],
                            ),
                          ),
                        )*/
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    height: 105,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount:
                        (GetApi.gamification.data!.length > 5)
                            ? 5
                            : GetApi.gamification.data!.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Column(
                              children: [
                                (GetApi.gamification.data![index].icon == null)
                                    ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            50),
                                        color: MyColor.cardColor),
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                        child: Image.asset(
                                            'assets/images/onboard/placeholder_image.png',
                                            width: 50,
                                            height: 50)))
                                    : Image.network(ApiStrings.mediaURl + GetApi.gamification.data![index].icon.toString(),
                                    height: 50,
                                    loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    (loadingProgress == null)
                                        ? child
                                        : Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: MyColor.cardColor),
                                        width: 50,
                                        height: 50,
                                        child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 50, height: 50)))),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                    width: 100,
                                    child: MyString.medMultiLine(
                                        (sharedPref
                                            .getString(SharedKey
                                            .languageValue)
                                            .toString() ==
                                            'en')
                                            ? GetApi.gamification
                                            .data![index].name
                                            .toString()
                                            : GetApi.gamification
                                            .data![index].nameFr
                                            .toString(),
                                        8,
                                        MyColor.redd,
                                        TextAlign.center,
                                        1))
                              ],
                            ),
                          );
                        }),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                              'assets/images/icons/noun_arr_left.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                              'assets/images/icons/noun_arr_right.png'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUINEW() {
    return SingleChildScrollView(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            HeaderWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _myActivitiesUI(),

                  ///Levels
                  InkWell(
                    onTap: () {
                      levelsSheetNew(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Color(0xffFFEDED))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/level.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              MyString.reg(
                                  _userActivitiesResponseModel.data!.levels!.first.gamificationLevel!.name
                                      .toString(),
                                  15,
                                  MyColor.title,
                                  TextAlign.start),
                            ],
                          ),
                          Row(
                            children: [
                              MyString.reg("moreLevels".tr, 12,
                                  MyColor.textBlack0, TextAlign.start),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/images/icons/back.png",
                                height: 8,
                                width: 8,
                                fit: BoxFit.cover,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  ///Scored Points
                  InkWell(
                    onTap: () {
                      // if (_userActivitiesResponseModel.data == null ||
                      //     _userActivitiesResponseModel.data!.userProfile!.gamePoints == 0) {
                      //   toaster(context, "noEarnHistory".tr);
                      // } else {
                      //   pointHistorySheet(context);
                      // }
                      pointHistorySheetNew(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Color(0xffFFEDED))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/points.png",
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(width: 10),
                              MyString.reg("scoredPoints".tr, 15,
                                  MyColor.title, TextAlign.start),
                            ],
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: MyColor.orange2,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: MyString.reg(
                                  '+${ _userActivitiesResponseModel.data!.userProfile!.gamePoints.toString()} pts',
                                  12,
                                  MyColor.white,
                                  TextAlign.start)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  ///Ranking
                  // InkWell(
                  //   onTap: () {
                  //     // Navigator.pushNamed(context, RoutesName.ranking);
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 10, vertical: 10),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.white,
                  //         border: Border.all(color: Color(0xffFFEDED))),
                  //     child: Row(
                  //       mainAxisAlignment:
                  //       MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Image.asset(
                  //               "assets/images/icons/rank.png",
                  //               height: 30,
                  //               width: 30,
                  //             ),
                  //             SizedBox(width: 10),
                  //             MyString.reg("ranking".tr, 15,
                  //                 MyColor.title, TextAlign.start),
                  //           ],
                  //         ),
                  //         Row(
                  //           crossAxisAlignment:
                  //           CrossAxisAlignment.center,
                  //           children: [
                  //             // MyString.med(
                  //             //     GetApi
                  //             //         .getProfileModel.data!.userRanking
                  //             //         .toString(),
                  //             //     21,
                  //             //     Color(0xffFF7519),
                  //             //     TextAlign.start),
                  //             SizedBox(width: 10),
                  //             Image.asset(
                  //               "assets/images/icons/back.png",
                  //               height: 8,
                  //               width: 8,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  //
                  // SizedBox(
                  //   height: 20,
                  // ),

                  if(_userActivitiesResponseModel.data!.badges!.isNotEmpty) Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                // Navigator.pushNamed(
                                //     context, RoutesName.badges);
                              },
                              child: MyString.bold("badgesTitle".tr, 18,
                                  MyColor.title, TextAlign.start)),
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, RoutesName.badges);
                            },
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: MyColor.white),
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Row(
                                children: [
                                  MyString.med("viewAll".tr, 11, MyColor.textFieldBorder, TextAlign.start),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 10,
                                    color: MyColor.textFieldBorder,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        height: 105,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount:
                            (_userActivitiesResponseModel.data!.badges!.length > 5)
                                ? 5
                                : _userActivitiesResponseModel.data!.badges!.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final badge = _userActivitiesResponseModel.data!.badges![index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Column(
                                  children: [
                                    (badge.icon == null)
                                        ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                50),
                                            color: MyColor.cardColor),
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                            child: Image.asset(
                                                'assets/images/onboard/placeholder_image.png',
                                                width: 50,
                                                height: 50)))
                                        : Image.network(badge.icon,
                                        height: 50,
                                        loadingBuilder: (context, child,
                                            loadingProgress) =>
                                        (loadingProgress == null)
                                            ? child
                                            : Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: MyColor.cardColor),
                                            width: 50,
                                            height: 50,
                                            child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 50, height: 50)))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                        width: 100,
                                        child: MyString.medMultiLine(
                                            (sharedPref
                                                .getString(SharedKey
                                                .languageValue)
                                                .toString() ==
                                                'en')
                                                ? badge.name
                                                .toString()
                                                : badge.nameFr
                                                .toString(),
                                            8,
                                            MyColor.redd,
                                            TextAlign.center,
                                            1))
                                  ],
                                ),
                              );
                            }),
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                  'assets/images/icons/noun_arr_left.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                  'assets/images/icons/noun_arr_right.png'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getAllLevels() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.allGamificationLevels}?page=1&limit=10&pt=wb");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _gamificationLevelsResponseModel = GamificationLevelsResponseModel.fromJson(result);
    }
  }

  Widget _myActivitiesUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///myActivities
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyString.bold('myActivities'.tr, 27,
              MyColor.title, TextAlign.start),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyColor.card),
                child: Row(
                  children: [
                    Image.asset(
                        'assets/images/icons/avis.png',
                        width: 33,
                        height: 33),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          MyString.bold(
                              _userActivitiesResponseModel.data!.activityCounts!.postReviewCount
                                  .toString(),
                              21,
                              Color(0xff293444),
                              TextAlign.center),
                          MyString.med(
                              'reviewSubmitted'.tr,
                              12,
                              MyColor.textBlack0,
                              TextAlign.start)
                        ]),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyColor.card),
                child: Row(
                  children: [
                    Image.asset('assets/images/icons/qt.png',
                        width: 33, height: 33),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          MyString.bold(
                              _userActivitiesResponseModel.data!.activityCounts!.questionSubmitted
                                  .toString(),
                              20,
                              MyColor.black,
                              TextAlign.center),
                          MyString.med(
                              'questionsSubmitted'.tr,
                              12,
                              MyColor.black,
                              TextAlign.start)
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyColor.card),
                child: Row(
                  children: [
                    Image.asset('assets/images/icons/msg.png',
                        width: 33, height: 33),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          MyString.bold(
                              _userActivitiesResponseModel.data!.activityCounts!.answersSubmitted
                                  .toString(),
                              20,
                              MyColor.black,
                              TextAlign.center),
                          MyString.med(
                              'postsSubmitted'.tr,
                              12,
                              MyColor.black,
                              TextAlign.start)
                        ]),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyColor.card),
                child: Row(
                  children: [
                    Image.asset('assets/images/icons/res.png',
                        width: 33, height: 33),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          MyString.bold(
                              _userActivitiesResponseModel.data!.activityCounts!.forumSubmissionCount
                                  .toString(),
                              20,
                              MyColor.black,
                              TextAlign.center),
                          MyString.med(
                              'responsesSubmitted'.tr,
                              12,
                              MyColor.black,
                              TextAlign.start)
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.9,
        ),
      ],
    );
  }
}
