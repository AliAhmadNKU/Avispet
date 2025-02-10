import 'dart:convert';

import 'package:avispets/models/forum/all_forums_categories_response_model.dart';
import 'package:avispets/models/forum/forum_topics_response_model.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../../models/forum/forum_category.dart';
import '../../../../models/forum/forum_questions.dart';
import '../../../../utils/apis/all_api.dart';
import '../../../../utils/apis/api_strings.dart';
import '../../../../utils/apis/get_api.dart';
import '../../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../../utils/common_function/dialogs/dialog_success.dart';
import '../../../../utils/common_function/my_string.dart';
import '../../../../utils/common_function/search_delay.dart';
import '../../../../utils/common_function/toaster.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/shared_pref.dart';

class ForumQuestion extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const ForumQuestion({super.key, this.mapData});

  @override
  State<ForumQuestion> createState() => _ForumQuestionState();
}

enum SampleItem { report, delete }

class _ForumQuestionState extends State<ForumQuestion> {
  SampleItem? selectedItem;
  var searchBar = TextEditingController();

  ForumCategory forumCategory = ForumCategory();
  List<ForumCategoryBody> myCategoryStringList = [];
  List<String> filterList = [];

  ForumQuestionModel forumQuest = ForumQuestionModel();
  List<ForumQuestionBody> questionList = [];
  final searchDelay = SearchDelayFunction();
  int page = 1;
  bool loader = true;
  bool stackLoader = false;
  bool filterAllSelect = false;

  String headerName = 'allTopic'.tr;

  AllForumsCategoriesResponseModel _allForumsCategoriesResponseModel = AllForumsCategoriesResponseModel();
  ForumTopicsResponseModel _forumTopicsResponseModel = ForumTopicsResponseModel();

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: MyColor.white,
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus!.unfocus();
              Map<String, dynamic> mapping = {
                'forumId': widget.mapData!['forumId'],
                'image': widget.mapData!['image'],
              };
              await Navigator.pushNamed(context, RoutesName.createForum,
                  arguments: mapping);
              setState(() {
                loader = true;
                page = 1;
                getForumQuestionApi(page, '');
              });
            },
            shape: CircleBorder(),
            backgroundColor: MyColor.orange2,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            )),
        body: SafeArea(child: _builder()),
      ),
    );
  }

  Widget _builder() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(bottom: 25.0, right: 25, left: 25, top: 0),
      child: loader
          ? progressBar()
          : Stack(
              children: [
                _buildUINew(),
                // _buildUIOLD(),
                if (stackLoader) progressBar(),
              ],
            ),
    );
  }

  getForumQuestionApi(int page, String search) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.forumTopics}?forumId=${widget.mapData!['forumId']}&page=$page&limit=20&search=$search");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        forumQuest = ForumQuestionModel.fromJson(result);
        loader = false;
        stackLoader = false;
        if (page == 1) {
          questionList.clear();
        }

        if (filterList.isNotEmpty) {
          for (int j = 0; j < filterList.length; j++) {
            for (int i = 0; i < forumQuest.data!.length; i++) {
              if (filterList
                  .contains(forumQuest.data![i].forumCategoryId.toString())) {
                questionList.add(forumQuest.data![i]);
              }
            }
          }
        } else {
          for (int i = 0; i < forumQuest.data!.length; i++) {
            questionList.add(forumQuest.data![i]);

            if (forumQuest.data![i].sendEmail == 1) {
              questionList[i].sendEmailEnable = true;
            } else {
              questionList[i].sendEmailEnable = false;
            }
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
                border: Border.all(color: MyColor.orange2),
                borderRadius: BorderRadiusDirectional.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icons/del2.png',
                    width: 60,
                    height: 60,
                  ),
                  MyString.bold('dialogQuestionTitle'.tr, 18, MyColor.red,
                      TextAlign.center),
                  const SizedBox(height: 10),
                  MyString.med('dialogQuestion'.tr, 12, MyColor.textBlack0,
                      TextAlign.center),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                                      Radius.circular(10))),
                              child: MyString.med('yes'.tr, 16, MyColor.white,
                                  TextAlign.center),
                            ),
                          ),
                        ),
                      ),
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
                              height: 59,
                              decoration: BoxDecoration(
                                  color: MyColor.bgColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: MyString.med('no'.tr, 16, MyColor.orange2,
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
              height: myCategoryStringList.length >= 10 ? 550 : 350,
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: myCategoryStringList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 5),
                      itemBuilder: (context, index) {
                        return ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          title: MyString.med(
                              (sharedPref
                                          .getString(SharedKey.languageValue)
                                          .toString() ==
                                      'en')
                                  ? myCategoryStringList[index].name.toString()
                                  : myCategoryStringList[index]
                                      .nameFr
                                      .toString(),
                              16,
                              MyColor.textFieldBorder,
                              TextAlign.start),
                          trailing: filterList.isNotEmpty
                              ? Icon(Icons.check,
                                  color: filterList[0].toString() ==
                                          myCategoryStringList[index]
                                              .id
                                              .toString()
                                      ? MyColor.orange2
                                      : MyColor.white)
                              : SizedBox(),
                          onTap: () {
                            filterList.clear();

                            filterList
                                .add(myCategoryStringList[index].id.toString());
                            print('filter ids : $filterList');
                            Navigator.pop(context, '1');

                            /*        myCategoryStringList[index].isSelect = !myCategoryStringList[index].isSelect;

                            if (myCategoryStringList[index].isSelect) {
                              filterList.add(myCategoryStringList[index].id.toString());
                            } else {
                              filterList.remove(myCategoryStringList[index].id.toString());
                            }

                            print('filter ids : $filterList');
                            print('filter ids length: ${filterList.length}');
                            print('filter ids length()cate: ${myCategoryStringList.length}');
                            if (filterList.length == myCategoryStringList.length) {
                              filterAllSelect = true;
                            } else {
                              filterAllSelect = false;
                            }
                            */

                            myState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  /*      GestureDetector(
                    onTap: () {
                      myState(() {
                        if (filterList.isEmpty) {
                          toaster(context, 'atLeastOneCategory'.tr);
                        } else {
                          Navigator.pop(context, '1');
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 15, right: 25, left: 25),
                      alignment: Alignment.center,
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(color: MyColor.orange, borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: MyString.med('filter'.tr, 18, MyColor.white, TextAlign.center),
                    ),
                  ),*/
                ],
              ),
            );
          },
        );
      },
    );
  }

  getForumCategory() async {
    var res = await AllApi.getMethodApi(
        '${ApiStrings.forumCategories}?page=1&limit=50');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        myCategoryStringList.clear();
        forumCategory = ForumCategory.fromJson(result);
        for (int i = 0; i < forumCategory.data!.length; i++) {
          myCategoryStringList.add(forumCategory.data![i]);
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

  Future getData() async {
    await getForumCategories();
    await getForumTopics();
    setState(() {
      loader = false;
      stackLoader = false;
    });
    // await getForumQuestionApi(page, '');
    // GetApi.getNotify(context, '');
    // await getForumCategory();
  }

  Future getForumCategories() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.allForumCategories}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _allForumsCategoriesResponseModel = AllForumsCategoriesResponseModel.fromJson(result);
    }
  }

  Future getForumTopics() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.allForumTopicsById}/${widget.mapData!['forumId']}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _forumTopicsResponseModel = ForumTopicsResponseModel.fromJson(result);
    }
  }

  // Widget _buildUIOLD() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         HeaderWidget(),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(15),
  //                   child: widget.mapData!['image']
  //                       .toString()
  //                       .isNotEmpty
  //                       ? Image.network(
  //                     widget.mapData!['image'].toString(),
  //                     fit: BoxFit.cover,
  //                   )
  //                       : Container(
  //                       color: MyColor.white,
  //                       child: Center(
  //                           child: Image.asset(
  //                               'assets/images/onboard/placeholder_image.png',
  //                               fit: BoxFit.cover,
  //                               height: 50))),
  //                 ),
  //               ),
  //               Transform(
  //                 transform: Matrix4.translationValues(0, -30, 0),
  //                 child: Container(
  //                   width: double.infinity,
  //                   padding: EdgeInsets.all(15),
  //                   margin: EdgeInsets.symmetric(horizontal: 20),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(14),
  //                     color: MyColor.white,
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                           margin: const EdgeInsets.only(top: 5),
  //                           child: MyString.bold(
  //                               widget.mapData!['topic'].toString(),
  //                               14,
  //                               Color(0xff4F2020),
  //                               TextAlign.center)),
  //                       SizedBox(
  //                         height: 6,
  //                       ),
  //                       if (widget.mapData!['desc']
  //                           .toString()
  //                           .isNotEmpty &&
  //                           widget.mapData!['desc'].toString() !=
  //                               'null')
  //                         ReadMoreText(
  //                           widget.mapData!['desc'].toString(),
  //                           trimMode: TrimMode.Line,
  //                           trimLines: 2,
  //                           colorClickableText: Colors.pink,
  //                           trimCollapsedText: '${'more'.tr}',
  //                           trimExpandedText: '',
  //                           style: TextStyle(
  //                             fontSize: 12,
  //                             color: MyColor.textBlack0,
  //                             overflow: TextOverflow.ellipsis,
  //                             fontFamily: 'poppins_medium',
  //                           ),
  //                           moreStyle: TextStyle(
  //                               color: MyColor.orange2,
  //                               fontSize: 12),
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 physics: BouncingScrollPhysics(),
  //                 child: Container(
  //                   height: 60,
  //                   padding: EdgeInsets.symmetric(vertical: 10),
  //                   child: Row(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           filterList.clear();
  //                           headerName = 'allTopic'.tr;
  //                           getForumQuestionApi(page, '');
  //                         },
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(
  //                               right: 4, left: 4),
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                     color: MyColor.orange2),
  //                                 color: filterList.isEmpty
  //                                     ? MyColor.orange2
  //                                     : MyColor.white,
  //                                 borderRadius:
  //                                 const BorderRadius.all(
  //                                     Radius.circular(10))),
  //                             child: Container(
  //                                 alignment: Alignment.center,
  //                                 margin: const EdgeInsets.only(
  //                                     right: 15, left: 15),
  //                                 child: MyString.med(
  //                                     'allTopic'.tr,
  //                                     12,
  //                                     (filterList.isEmpty)
  //                                         ? MyColor.white
  //                                         : Color(0xff4F2020),
  //                                     TextAlign.center)),
  //                           ),
  //                         ),
  //                       ),
  //                       ListView.builder(
  //                           scrollDirection: Axis.horizontal,
  //                           physics: NeverScrollableScrollPhysics(),
  //                           itemCount: myCategoryStringList.length,
  //                           shrinkWrap: true,
  //                           itemBuilder: (context, index) {
  //                             return GestureDetector(
  //                               onTap: () {
  //                                 setState(() {
  //                                   filterList.clear();
  //                                   filterList.add(
  //                                       myCategoryStringList[index]
  //                                           .id
  //                                           .toString());
  //
  //                                   headerName = (sharedPref
  //                                       .getString(SharedKey
  //                                       .languageValue)
  //                                       .toString() ==
  //                                       'en')
  //                                       ? myCategoryStringList[
  //                                   index]
  //                                       .name
  //                                       .toString()
  //                                       : myCategoryStringList[
  //                                   index]
  //                                       .nameFr
  //                                       .toString();
  //                                   stackLoader = true;
  //                                   page = 1;
  //                                   getForumQuestionApi(page, '');
  //                                 });
  //                               },
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     right: 2, left: 1),
  //                                 child: Container(
  //                                   height: 40,
  //                                   alignment: Alignment.center,
  //                                   decoration: BoxDecoration(
  //                                       border: Border.all(
  //                                           color: MyColor.orange2),
  //                                       color: (filterList
  //                                           .isNotEmpty &&
  //                                           filterList[0]
  //                                               .toString() ==
  //                                               myCategoryStringList[
  //                                               index]
  //                                                   .id
  //                                                   .toString())
  //                                           ? MyColor.orange2
  //                                           : MyColor.white,
  //                                       borderRadius:
  //                                       const BorderRadius.all(
  //                                           Radius.circular(
  //                                               10))),
  //                                   child: Container(
  //                                       alignment: Alignment.center,
  //                                       height: 40,
  //                                       margin:
  //                                       const EdgeInsets.only(
  //                                           right: 15,
  //                                           left: 15),
  //                                       child: MyString.med(
  //                                           (sharedPref
  //                                               .getString(
  //                                               SharedKey
  //                                                   .languageValue)
  //                                               .toString() ==
  //                                               'en')
  //                                               ? myCategoryStringList[
  //                                           index]
  //                                               .name
  //                                               .toString()
  //                                               : myCategoryStringList[
  //                                           index]
  //                                               .nameFr
  //                                               .toString(),
  //                                           12,
  //                                           (filterList.isNotEmpty &&
  //                                               filterList[0]
  //                                                   .toString() ==
  //                                                   myCategoryStringList[index]
  //                                                       .id
  //                                                       .toString())
  //                                               ? MyColor.white
  //                                               : Color(0xff4F2020),
  //                                           TextAlign.center)),
  //                                 ),
  //                               ),
  //                             );
  //                           })
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(top: 15),
  //                 decoration: BoxDecoration(
  //                     border: Border.all(color: Color(0xffEBEBEB)),
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(13),
  //                         topRight: Radius.circular(50),
  //                         bottomLeft: Radius.circular(13),
  //                         bottomRight: Radius.circular(50))),
  //                 child: TextField(
  //                   controller: searchBar,
  //                   scrollPadding:
  //                   const EdgeInsets.only(bottom: 50),
  //                   style: TextStyle(
  //                       color: MyColor.black, fontSize: 14),
  //                   decoration: InputDecoration(
  //                     border: const OutlineInputBorder(
  //                       borderSide: BorderSide.none,
  //                     ),
  //                     prefixIcon: SizedBox(
  //                         width: 20,
  //                         height: 20,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Image.asset(
  //                             'assets/images/icons/search.png',
  //                             width: 20,
  //                             height: 20,
  //                           ),
  //                         )),
  //                     suffixIcon: (searchBar.text
  //                         .trim()
  //                         .toString()
  //                         .isNotEmpty)
  //                         ? GestureDetector(
  //                         onTap: () async {
  //                           setState(() {
  //                             stackLoader = true;
  //                             searchBar.text = '';
  //                             getForumQuestionApi(page, '');
  //                           });
  //                         },
  //                         child: Icon(
  //                           Icons.cancel,
  //                           color: MyColor.orange2,
  //                         ))
  //                         : Container(
  //                         width: 40,
  //                         height: 40,
  //                         padding: EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                             color: Color(0xff4F2020),
  //                             borderRadius:
  //                             BorderRadius.circular(150)),
  //                         child: Image.asset(
  //                             'assets/images/icons/filter.png')),
  //                     contentPadding: const EdgeInsets.symmetric(
  //                         vertical: 5, horizontal: 12),
  //                     hintText: 'search'.tr,
  //                     hintStyle: TextStyle(
  //                         color: MyColor.textBlack0, fontSize: 14),
  //                   ),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       page = 1;
  //                       stackLoader = true;
  //                       searchDelay.run(() {
  //                         if (value.isNotEmpty) {
  //                           getForumQuestionApi(page, value);
  //                         }
  //                         if (value.isEmpty) {
  //                           getForumQuestionApi(page, '');
  //                         }
  //                         FocusManager.instance.primaryFocus!
  //                             .unfocus();
  //                       });
  //                     });
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 15),
  //               MyString.bold(headerName.toString(), 14,
  //                   MyColor.title, TextAlign.center),
  //               const SizedBox(height: 5),
  //             ]),
  //
  //         //main-List
  //         questionList.isNotEmpty
  //             ? ListView.builder(
  //             itemCount: questionList.length,
  //             padding: EdgeInsets.only(bottom: 20, top: 10),
  //             physics: NeverScrollableScrollPhysics(),
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               return GestureDetector(
  //                 onTap: () async {
  //                   Map<String, dynamic> mapping = {
  //                     'topicTitle': questionList[index].title,
  //                     'forumId': questionList[index].forumId,
  //                     'forumTopicId': questionList[index].id,
  //                   };
  //                   await Navigator.pushNamed(
  //                       context, RoutesName.forumReply,
  //                       arguments: mapping);
  //                   setState(() {
  //                     loader = true;
  //                     page = 1;
  //                     getForumQuestionApi(page, '');
  //                   });
  //                 },
  //                 child: Container(
  //                   margin: EdgeInsets.symmetric(vertical: 8),
  //                   decoration: BoxDecoration(
  //                     border:
  //                     Border.all(color: MyColor.orange2),
  //                     color: MyColor.card,
  //                     borderRadius: const BorderRadius.all(
  //                         Radius.circular(8)),
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 10, vertical: 10),
  //                         child: Row(
  //                           mainAxisAlignment:
  //                           MainAxisAlignment.start,
  //                           crossAxisAlignment:
  //                           CrossAxisAlignment.start,
  //                           children: [
  //                             ClipRRect(
  //                               borderRadius: BorderRadius.all(
  //                                   Radius.circular(50)),
  //                               child: questionList[index]
  //                                   .user
  //                                   ?.profilePicture !=
  //                                   null
  //                                   ? Image.network('${ApiStrings.mediaURl}${questionList[index].user?.profilePicture.toString()}',
  //                                   width: 50,
  //                                   height: 50,
  //                                   fit: BoxFit.cover,
  //                                   loadingBuilder: (context,
  //                                       child,
  //                                       loadingProgress) =>
  //                                   (loadingProgress == null)
  //                                       ? child
  //                                       : customProgressBar())
  //                                   : Container(
  //                                   width: 50,
  //                                   height: 50,
  //                                   color:
  //                                   MyColor.cardColor,
  //                                   child: Center(
  //                                       child: Image.asset(
  //                                           'assets/images/onboard/placeholder_image.png',
  //                                           width: 50,
  //                                           height: 50))),
  //                             ),
  //                             SizedBox(
  //                               width: 10,
  //                             ),
  //                             Flexible(
  //                               child: Column(
  //                                 crossAxisAlignment:
  //                                 CrossAxisAlignment.start,
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.start,
  //                                 children: [
  //                                   Column(
  //                                     mainAxisAlignment:
  //                                     MainAxisAlignment
  //                                         .start,
  //                                     crossAxisAlignment:
  //                                     CrossAxisAlignment
  //                                         .start,
  //                                     children: [
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                         MainAxisAlignment
  //                                             .spaceBetween,
  //                                         children: [
  //                                           SizedBox(
  //                                             width: MediaQuery.of(
  //                                                 context)
  //                                                 .size
  //                                                 .width /
  //                                                 3,
  //                                             child: MyString
  //                                                 .medMultiLine(
  //                                                 "${questionList[index].user!.firstName.toString()} ${questionList[index].user!.lastName.toString()}",
  //                                                 13,
  //                                                 Color(
  //                                                     0xff4F2020),
  //                                                 TextAlign
  //                                                     .start,
  //                                                 1),
  //                                           ),
  //                                           Container(
  //                                               width: 80,
  //                                               child: MyString.medMultiLine(
  //                                                   '${questionList[index].createdAt.toString()}',
  //                                                   10,
  //                                                   MyColor
  //                                                       .textBlack0,
  //                                                   TextAlign
  //                                                       .center,
  //                                                   1)), //huuuuni
  //                                           Container(
  //                                             child: Flexible(
  //                                               flex: 1,
  //                                               child:
  //                                               TextButton(
  //                                                 onPressed:
  //                                                     () async {
  //                                                   Map<String,
  //                                                       dynamic>
  //                                                   mapping =
  //                                                   {
  //                                                     'topicTitle':
  //                                                     questionList[index]
  //                                                         .title,
  //                                                     'forumId':
  //                                                     questionList[index]
  //                                                         .forumId,
  //                                                     'forumTopicId':
  //                                                     questionList[index]
  //                                                         .id,
  //                                                   };
  //                                                   await Navigator.pushNamed(
  //                                                       context,
  //                                                       RoutesName
  //                                                           .forumReply,
  //                                                       arguments:
  //                                                       mapping);
  //                                                   setState(
  //                                                           () {
  //                                                         loader =
  //                                                         true;
  //                                                         page = 1;
  //                                                         getForumQuestionApi(
  //                                                             page,
  //                                                             '');
  //                                                       });
  //                                                 },
  //                                                 style: TextButton.styleFrom(
  //                                                     padding:
  //                                                     EdgeInsets
  //                                                         .zero,
  //                                                     minimumSize:
  //                                                     Size(
  //                                                         10,
  //                                                         10),
  //                                                     tapTargetSize:
  //                                                     MaterialTapTargetSize
  //                                                         .shrinkWrap),
  //                                                 child: Image
  //                                                     .asset(
  //                                                   "assets/images/icons/rep.png",
  //                                                   height: 20,
  //                                                   width: 20,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           (sharedPref.getString(
  //                                               SharedKey
  //                                                   .userId) ==
  //                                               questionList[
  //                                               index]
  //                                                   .userId
  //                                                   .toString())
  //                                               ? Flexible(
  //                                             flex: 1,
  //                                             child:
  //                                             TextButton(
  //                                               onPressed:
  //                                                   () async {
  //                                                 await showDialog(
  //                                                   context:
  //                                                   context,
  //                                                   barrierDismissible:
  //                                                   true,
  //                                                   builder:
  //                                                       (_) {
  //                                                     return _deleteQuestionDialog(questionList[index].id.toString());
  //                                                   },
  //                                                 );
  //                                                 bool
  //                                                 loader =
  //                                                 true;
  //                                                 setState(
  //                                                         () {});
  //                                                 getForumQuestionApi(
  //                                                     page,
  //                                                     '');
  //
  //                                                 getForumCategory();
  //                                               },
  //                                               style: TextButton.styleFrom(
  //                                                   padding: EdgeInsets
  //                                                       .zero,
  //                                                   minimumSize: Size(
  //                                                       10,
  //                                                       10),
  //                                                   tapTargetSize:
  //                                                   MaterialTapTargetSize.shrinkWrap),
  //                                               child:
  //                                               Container(
  //                                                 child: Image
  //                                                     .asset(
  //                                                   "assets/images/icons/del.png",
  //                                                   height:
  //                                                   15,
  //                                                   width:
  //                                                   15,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           )
  //                                               : Flexible(
  //                                               flex: 1,
  //                                               child:
  //                                               SizedBox()),
  //                                         ],
  //                                       ),
  //                                       SizedBox(
  //                                         child: Row(
  //                                           mainAxisAlignment:
  //                                           MainAxisAlignment
  //                                               .start,
  //                                           crossAxisAlignment:
  //                                           CrossAxisAlignment
  //                                               .start,
  //                                           children: [
  //                                             Container(
  //                                               width: MediaQuery.of(
  //                                                   context)
  //                                                   .size
  //                                                   .width /
  //                                                   1.7,
  //                                               child: RichText(
  //                                                 text:
  //                                                 TextSpan(
  //                                                   text: questionList[
  //                                                   index]
  //                                                       .title
  //                                                       .toString(),
  //                                                   style:
  //                                                   TextStyle(
  //                                                     fontFamily:
  //                                                     'poppins_medium',
  //                                                     fontSize:
  //                                                     12,
  //                                                     color: MyColor
  //                                                         .textBlack0,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             /* if (sharedPref.getString(
  //                                                                     SharedKey
  //                                                                         .userId) ==
  //                                                                 questionList[
  //                                                                         index]
  //                                                                     .userId
  //                                                                     .toString())
  //                                                               TextButton(
  //                                                                 onPressed:
  //                                                                     () async {
  //                                                                   Map<String,
  //                                                                           dynamic>
  //                                                                       mapData =
  //                                                                       {
  //                                                                     'forumTopicId':
  //                                                                         questionList[index]
  //                                                                             .id
  //                                                                             .toString(),
  //                                                                     'sendEmail': questionList[index].sendEmail ==
  //                                                                             0
  //                                                                         ? '1'
  //                                                                         : '0',
  //                                                                   };
  //
  //                                                                   debugPrint(
  //                                                                       "ENABLE NOTIFICATION MAP DATA IS : $mapData");
  //                                                                   var res = await AllApi.postMethodApi(
  //                                                                       ApiStrings
  //                                                                           .enableDisableForumNotification,
  //                                                                       mapData);
  //                                                                   var result =
  //                                                                       jsonDecode(
  //                                                                           res.toString());
  //                                                                   setState(
  //                                                                       () {
  //                                                                     if (result[
  //                                                                             'status'] ==
  //                                                                         200) {
  //                                                                       questionList[index]
  //                                                                           .sendEmailEnable = !questionList[
  //                                                                               index]
  //                                                                           .sendEmailEnable;
  //                                                                       toaster(
  //                                                                           context,
  //                                                                           result['message'].toString());
  //                                                                     } else {
  //                                                                       toaster(
  //                                                                           context,
  //                                                                           result['message'].toString());
  //                                                                     }
  //                                                                   });
  //                                                                 },
  //                                                                 style: TextButton.styleFrom(
  //                                                                     padding:
  //                                                                         EdgeInsets
  //                                                                             .zero,
  //                                                                     minimumSize:
  //                                                                         Size(
  //                                                                             30,
  //                                                                             30),
  //                                                                     tapTargetSize:
  //                                                                         MaterialTapTargetSize
  //                                                                             .shrinkWrap),
  //                                                                 child: Image.asset(
  //                                                                     'assets/images/icons/notification.png',
  //                                                                     color: questionList[index].sendEmailEnable
  //                                                                         ? MyColor
  //                                                                             .orange2
  //                                                                         : MyColor
  //                                                                             .textFieldBorder,
  //                                                                     width: 20,
  //                                                                     height:
  //                                                                         20),
  //                                                               ),*/
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   SizedBox(
  //                                     height: 5,
  //                                   ),
  //                                   /*Container(
  //                                                     child: ReadMoreText(
  //                                                       questionList[index]
  //                                                           .description
  //                                                           .toString(),
  //                                                       trimMode: TrimMode.Line,
  //                                                       trimLines: 3,
  //                                                       colorClickableText:
  //                                                           Colors.pink,
  //                                                       trimCollapsedText:
  //                                                           '${'more'.tr}',
  //                                                       trimExpandedText: '',
  //                                                       moreStyle: TextStyle(
  //                                                         color: MyColor
  //                                                             .textBlack0,
  //                                                         fontSize: 11,
  //                                                       ),
  //                                                     ),
  //                                                   ),*/
  //                                   Container(
  //                                     child: Row(
  //                                       crossAxisAlignment:
  //                                       CrossAxisAlignment
  //                                           .start,
  //                                       children: [
  //                                         Flexible(
  //                                           flex: 1,
  //                                           child: TextButton(
  //                                               onPressed:
  //                                                   () async {
  //                                                 Map<String,
  //                                                     dynamic>
  //                                                 mapping =
  //                                                 {
  //                                                   'topicTitle':
  //                                                   questionList[index]
  //                                                       .title,
  //                                                   'forumId': questionList[
  //                                                   index]
  //                                                       .forumId,
  //                                                   'forumTopicId':
  //                                                   questionList[index]
  //                                                       .id,
  //                                                 };
  //                                                 await Navigator.pushNamed(
  //                                                     context,
  //                                                     RoutesName
  //                                                         .forumReply,
  //                                                     arguments:
  //                                                     mapping);
  //                                                 setState(() {
  //                                                   loader =
  //                                                   true;
  //                                                   page = 1;
  //                                                   getForumQuestionApi(
  //                                                       page,
  //                                                       '');
  //                                                 });
  //                                               },
  //                                               style: TextButton.styleFrom(
  //                                                   padding:
  //                                                   EdgeInsets
  //                                                       .zero,
  //                                                   minimumSize:
  //                                                   Size(10,
  //                                                       10),
  //                                                   tapTargetSize:
  //                                                   MaterialTapTargetSize
  //                                                       .shrinkWrap),
  //                                               child:
  //                                               Container(
  //                                                 child: Row(
  //                                                   crossAxisAlignment:
  //                                                   CrossAxisAlignment
  //                                                       .start,
  //                                                   mainAxisAlignment:
  //                                                   MainAxisAlignment
  //                                                       .start,
  //                                                   children: [
  //                                                     if (questionList[index]
  //                                                         .totalReplies !=
  //                                                         0)
  //                                                       Container(
  //                                                           child: MyString.reg(
  //                                                               questionList[index].totalReplies.toString(),
  //                                                               11,
  //                                                               MyColor.orange2,
  //                                                               TextAlign.center)),
  //                                                     MyString.med(
  //                                                         (questionList[index].totalReplies != 0 && questionList[index].totalReplies != 1 && questionList[index].totalReplies != null)
  //                                                             ? ' ${'viewReply'.tr}'
  //                                                             : questionList[index].totalReplies == 1
  //                                                             ? ' ${'reply'.tr}'
  //                                                             : '0 ${'reply'.tr}',
  //                                                         11,
  //                                                         MyColor.orange2,
  //                                                         TextAlign.start)
  //                                                   ],
  //                                                 ),
  //                                               )),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             })
  //             : Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Image.asset(
  //               'assets/images/onboard/placeholder_image.png',
  //               width: 120,
  //               height: 90,
  //             ),
  //             Container(
  //                 width: double.infinity,
  //                 child: MyString.reg('noDataFound'.tr, 11,
  //                     MyColor.textBlack0, TextAlign.center)),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildUINew() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderWidget(),
          SizedBox(
            height: 20,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: widget.mapData!['image']
                        .toString()
                        .isNotEmpty
                        ? Image.network(
                      widget.mapData!['image'].toString(),
                      fit: BoxFit.cover,
                    )
                        : Container(
                        color: MyColor.white,
                        child: Center(
                            child: Image.asset(
                                'assets/images/onboard/placeholder_image.png',
                                fit: BoxFit.cover,
                                height: 50))),
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: MyColor.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: MyString.bold(
                                widget.mapData!['topic'].toString(),
                                14,
                                Color(0xff4F2020),
                                TextAlign.center)),
                        SizedBox(
                          height: 6,
                        ),
                        if (widget.mapData!['desc']
                            .toString()
                            .isNotEmpty &&
                            widget.mapData!['desc'].toString() !=
                                'null')
                          ReadMoreText(
                            widget.mapData!['desc'].toString(),
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            colorClickableText: Colors.pink,
                            trimCollapsedText: '${'more'.tr}',
                            trimExpandedText: '',
                            style: TextStyle(
                              fontSize: 12,
                              color: MyColor.textBlack0,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'poppins_medium',
                            ),
                            moreStyle: TextStyle(
                                color: MyColor.orange2,
                                fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          filterList.clear();
                          headerName = 'allTopic'.tr;
                          getForumQuestionApi(page, '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 4, left: 4),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyColor.orange2),
                                color: filterList.isEmpty
                                    ? MyColor.orange2
                                    : MyColor.white,
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    right: 15, left: 15),
                                child: MyString.med(
                                    'allTopic'.tr,
                                    12,
                                    (filterList.isEmpty)
                                        ? MyColor.white
                                        : Color(0xff4F2020),
                                    TextAlign.center)),
                          ),
                        ),
                      ),
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _allForumsCategoriesResponseModel.data != null ? _allForumsCategoriesResponseModel.data!.length : 0,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final category = _allForumsCategoriesResponseModel.data![index];
                            return GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   filterList.clear();
                                //   filterList.add(
                                //       myCategoryStringList[index]
                                //           .id
                                //           .toString());
                                //
                                //   headerName = (sharedPref
                                //       .getString(SharedKey
                                //       .languageValue)
                                //       .toString() ==
                                //       'en')
                                //       ? myCategoryStringList[
                                //   index]
                                //       .name
                                //       .toString()
                                //       : myCategoryStringList[
                                //   index]
                                //       .nameFr
                                //       .toString();
                                //   stackLoader = true;
                                //   page = 1;
                                //   getForumQuestionApi(page, '');
                                // });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 2, left: 1),
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MyColor.orange2),
                                      color: (filterList
                                          .isNotEmpty &&
                                          filterList[0]
                                              .toString() ==
                                              category
                                                  .id
                                                  .toString())
                                          ? MyColor.orange2
                                          : MyColor.white,
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(
                                              10))),
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      margin:
                                      const EdgeInsets.only(
                                          right: 15,
                                          left: 15),
                                      child: MyString.med(
                                          (sharedPref
                                              .getString(
                                              SharedKey
                                                  .languageValue)
                                              .toString() ==
                                              'en')
                                              ? category
                                              .name
                                              .toString()
                                              : category
                                              .nameFr
                                              .toString(),
                                          12,
                                          (filterList.isNotEmpty &&
                                              filterList[0]
                                                  .toString() ==
                                                  category
                                                      .id
                                                      .toString())
                                              ? MyColor.white
                                              : Color(0xff4F2020),
                                          TextAlign.center)),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffEBEBEB)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(13),
                          bottomRight: Radius.circular(50))),
                  child: TextField(
                    controller: searchBar,
                    scrollPadding:
                    const EdgeInsets.only(bottom: 50),
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
                            // setState(() {
                            //   stackLoader = true;
                            //   searchBar.text = '';
                            //   getForumQuestionApi(page, '');
                            // });
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
                      // setState(() {
                      //   page = 1;
                      //   stackLoader = true;
                      //   searchDelay.run(() {
                      //     if (value.isNotEmpty) {
                      //       getForumQuestionApi(page, value);
                      //     }
                      //     if (value.isEmpty) {
                      //       getForumQuestionApi(page, '');
                      //     }
                      //     FocusManager.instance.primaryFocus!
                      //         .unfocus();
                      //   });
                      // });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                MyString.bold(headerName.toString(), 14,
                    MyColor.title, TextAlign.center),
                const SizedBox(height: 5),
              ]),

          //main-List
          _forumTopicsResponseModel.data!.isNotEmpty
              ? ListView.builder(
              itemCount: _forumTopicsResponseModel.data!.length,
              padding: EdgeInsets.only(bottom: 20, top: 10),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final topic = _forumTopicsResponseModel.data![index];
                return GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> mapping = {
                      'topicTitle': topic.title,
                      'forumId': topic.forumId,
                      'forumTopicId': topic.id,
                    };
                    await Navigator.pushNamed(
                        context, RoutesName.forumReply,
                        arguments: mapping);
                    // setState(() {
                    //   loader = true;
                    //   page = 1;
                    //   getForumQuestionApi(page, '');
                    // });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: MyColor.orange2),
                      color: MyColor.card,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.all(
                              //       Radius.circular(50)),
                              //   child: questionList[index]
                              //       .user
                              //       ?.profilePicture !=
                              //       null
                              //       ? Image.network('${ApiStrings.mediaURl}${questionList[index].user?.profilePicture.toString()}',
                              //       width: 50,
                              //       height: 50,
                              //       fit: BoxFit.cover,
                              //       loadingBuilder: (context,
                              //           child,
                              //           loadingProgress) =>
                              //       (loadingProgress == null)
                              //           ? child
                              //           : customProgressBar())
                              //       : Container(
                              //       width: 50,
                              //       height: 50,
                              //       color:
                              //       MyColor.cardColor,
                              //       child: Center(
                              //           child: Image.asset(
                              //               'assets/images/onboard/placeholder_image.png',
                              //               width: 50,
                              //               height: 50))),
                              // ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width /
                                                  3,
                                              child: MyString
                                                  .medMultiLine(
                                                  "",
                                                  // "${questionList[index].user!.firstName.toString()} ${questionList[index].user!.lastName.toString()}",
                                                  13,
                                                  Color(
                                                      0xff4F2020),
                                                  TextAlign
                                                      .start,
                                                  1),
                                            ),
                                            Container(
                                                width: 80,
                                                child: MyString.medMultiLine(
                                                    '${formatDateTime(topic.createdAt!)}',
                                                    10,
                                                    MyColor
                                                        .textBlack0,
                                                    TextAlign
                                                        .center,
                                                    1)), //huuuuni
                                            // Container(
                                            //   child: Flexible(
                                            //     flex: 1,
                                            //     child:
                                            //     TextButton(
                                            //       onPressed:
                                            //           () async {
                                            //         Map<String,
                                            //             dynamic>
                                            //         mapping =
                                            //         {
                                            //           'topicTitle':
                                            //           questionList[index]
                                            //               .title,
                                            //           'forumId':
                                            //           questionList[index]
                                            //               .forumId,
                                            //           'forumTopicId':
                                            //           questionList[index]
                                            //               .id,
                                            //         };
                                            //         await Navigator.pushNamed(
                                            //             context,
                                            //             RoutesName
                                            //                 .forumReply,
                                            //             arguments:
                                            //             mapping);
                                            //         setState(
                                            //                 () {
                                            //               loader =
                                            //               true;
                                            //               page = 1;
                                            //               getForumQuestionApi(
                                            //                   page,
                                            //                   '');
                                            //             });
                                            //       },
                                            //       style: TextButton.styleFrom(
                                            //           padding:
                                            //           EdgeInsets
                                            //               .zero,
                                            //           minimumSize:
                                            //           Size(
                                            //               10,
                                            //               10),
                                            //           tapTargetSize:
                                            //           MaterialTapTargetSize
                                            //               .shrinkWrap),
                                            //       child: Image
                                            //           .asset(
                                            //         "assets/images/icons/rep.png",
                                            //         height: 20,
                                            //         width: 20,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            (sharedPref.getString(
                                                SharedKey
                                                    .userId) ==
                                                topic
                                                    .userId
                                                    .toString())
                                                ? Flexible(
                                              flex: 1,
                                              child:
                                              TextButton(
                                                onPressed:
                                                    () async {
                                                  await showDialog(
                                                    context:
                                                    context,
                                                    barrierDismissible:
                                                    true,
                                                    builder:
                                                        (_) {
                                                      return _deleteQuestionDialog(topic.id.toString());
                                                    },
                                                  );
                                                  // bool loader = true;
                                                  //           setState(() {});
                                                  //           getForumQuestionApi(
                                                  //               page, '');
                                                  //
                                                  //           getForumCategories();
                                                },
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets
                                                        .zero,
                                                    minimumSize: Size(
                                                        10,
                                                        10),
                                                    tapTargetSize:
                                                    MaterialTapTargetSize.shrinkWrap),
                                                child:
                                                Container(
                                                  child: Image
                                                      .asset(
                                                    "assets/images/icons/del.png",
                                                    height:
                                                    15,
                                                    width:
                                                    15,
                                                  ),
                                                ),
                                              ),
                                            )
                                                : Flexible(
                                                flex: 1,
                                                child:
                                                SizedBox()),
                                          ],
                                        ),
                                        SizedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width /
                                                    1.7,
                                                child: RichText(
                                                  text:
                                                  TextSpan(
                                                    text: topic
                                                        .title
                                                        .toString(),
                                                    style:
                                                    TextStyle(
                                                      fontFamily:
                                                      'poppins_medium',
                                                      fontSize:
                                                      12,
                                                      color: MyColor
                                                          .textBlack0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              /* if (sharedPref.getString(
                                                                      SharedKey
                                                                          .userId) ==
                                                                  questionList[
                                                                          index]
                                                                      .userId
                                                                      .toString())
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Map<String,
                                                                            dynamic>
                                                                        mapData =
                                                                        {
                                                                      'forumTopicId':
                                                                          questionList[index]
                                                                              .id
                                                                              .toString(),
                                                                      'sendEmail': questionList[index].sendEmail ==
                                                                              0
                                                                          ? '1'
                                                                          : '0',
                                                                    };

                                                                    debugPrint(
                                                                        "ENABLE NOTIFICATION MAP DATA IS : $mapData");
                                                                    var res = await AllApi.postMethodApi(
                                                                        ApiStrings
                                                                            .enableDisableForumNotification,
                                                                        mapData);
                                                                    var result =
                                                                        jsonDecode(
                                                                            res.toString());
                                                                    setState(
                                                                        () {
                                                                      if (result[
                                                                              'status'] ==
                                                                          200) {
                                                                        questionList[index]
                                                                            .sendEmailEnable = !questionList[
                                                                                index]
                                                                            .sendEmailEnable;
                                                                        toaster(
                                                                            context,
                                                                            result['message'].toString());
                                                                      } else {
                                                                        toaster(
                                                                            context,
                                                                            result['message'].toString());
                                                                      }
                                                                    });
                                                                  },
                                                                  style: TextButton.styleFrom(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      minimumSize:
                                                                          Size(
                                                                              30,
                                                                              30),
                                                                      tapTargetSize:
                                                                          MaterialTapTargetSize
                                                                              .shrinkWrap),
                                                                  child: Image.asset(
                                                                      'assets/images/icons/notification.png',
                                                                      color: questionList[index].sendEmailEnable
                                                                          ? MyColor
                                                                              .orange2
                                                                          : MyColor
                                                                              .textFieldBorder,
                                                                      width: 20,
                                                                      height:
                                                                          20),
                                                                ),*/
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    /*Container(
                                                      child: ReadMoreText(
                                                        questionList[index]
                                                            .description
                                                            .toString(),
                                                        trimMode: TrimMode.Line,
                                                        trimLines: 3,
                                                        colorClickableText:
                                                            Colors.pink,
                                                        trimCollapsedText:
                                                            '${'more'.tr}',
                                                        trimExpandedText: '',
                                                        moreStyle: TextStyle(
                                                          color: MyColor
                                                              .textBlack0,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),*/
                                    // Container(
                                    //   child: Row(
                                    //     crossAxisAlignment:
                                    //     CrossAxisAlignment
                                    //         .start,
                                    //     children: [
                                    //       Flexible(
                                    //         flex: 1,
                                    //         child: TextButton(
                                    //             onPressed:
                                    //                 () async {
                                    //               Map<String,
                                    //                   dynamic>
                                    //               mapping =
                                    //               {
                                    //                 'topicTitle':
                                    //                 questionList[index]
                                    //                     .title,
                                    //                 'forumId': questionList[
                                    //                 index]
                                    //                     .forumId,
                                    //                 'forumTopicId':
                                    //                 questionList[index]
                                    //                     .id,
                                    //               };
                                    //               await Navigator.pushNamed(
                                    //                   context,
                                    //                   RoutesName
                                    //                       .forumReply,
                                    //                   arguments:
                                    //                   mapping);
                                    //               setState(() {
                                    //                 loader =
                                    //                 true;
                                    //                 page = 1;
                                    //                 getForumQuestionApi(
                                    //                     page,
                                    //                     '');
                                    //               });
                                    //             },
                                    //             style: TextButton.styleFrom(
                                    //                 padding:
                                    //                 EdgeInsets
                                    //                     .zero,
                                    //                 minimumSize:
                                    //                 Size(10,
                                    //                     10),
                                    //                 tapTargetSize:
                                    //                 MaterialTapTargetSize
                                    //                     .shrinkWrap),
                                    //             child:
                                    //             Container(
                                    //               child: Row(
                                    //                 crossAxisAlignment:
                                    //                 CrossAxisAlignment
                                    //                     .start,
                                    //                 mainAxisAlignment:
                                    //                 MainAxisAlignment
                                    //                     .start,
                                    //                 children: [
                                    //                   if (questionList[index]
                                    //                       .totalReplies !=
                                    //                       0)
                                    //                     Container(
                                    //                         child: MyString.reg(
                                    //                             questionList[index].totalReplies.toString(),
                                    //                             11,
                                    //                             MyColor.orange2,
                                    //                             TextAlign.center)),
                                    //                   MyString.med(
                                    //                       (questionList[index].totalReplies != 0 && questionList[index].totalReplies != 1 && questionList[index].totalReplies != null)
                                    //                           ? ' ${'viewReply'.tr}'
                                    //                           : questionList[index].totalReplies == 1
                                    //                           ? ' ${'reply'.tr}'
                                    //                           : '0 ${'reply'.tr}',
                                    //                       11,
                                    //                       MyColor.orange2,
                                    //                       TextAlign.start)
                                    //                 ],
                                    //               ),
                                    //             )),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
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
              })
              : Column(
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
                  child: MyString.reg('noDataFound'.tr, 11,
                      MyColor.textBlack0, TextAlign.center)),
            ],
          )
        ],
      ),
    );
  }
}
