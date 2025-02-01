import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/all_users_model.dart';
import 'package:avispets/models/chats/all_users_discussion_model.dart';
import 'package:avispets/models/follower_user_response_model.dart';
import 'package:avispets/models/following_user_response_model.dart';
import 'package:avispets/models/get_suggestion_list.dart';
import 'package:avispets/ui/widgets/no_data_found.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/follow_bloc.dart';
import '../../../models/follower_following_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/search_delay.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late FollowUnfollowBloc _followUnfollowBloc;

  FollowingFollowerModel _followerModel = FollowingFollowerModel();
  AllUsers allUsers = AllUsers();
  GetSuggestionList _getSuggestionList = GetSuggestionList();

  List<FollowingFollowerBody> followList = [];
  List<GetSuggestionBody> suggestionList = [];

  bool loader = true;
  bool stackLoader = false;
  final searchDelay = SearchDelayFunction();

  int listLen = 0;
  int page = 1;
  bool showHalfList = true;

  bool listLoader = false;
  int currentTab = 1;
  var searchBar = TextEditingController();
  bool search = false;

  FollowingUserResponseModel _followingUserResponseModel = FollowingUserResponseModel();
  FollowerUserResponseModel _followerUserResponseModel = FollowerUserResponseModel();
  AllUsersDiscussionModel _allUsersDiscussionModel = AllUsersDiscussionModel();

  @override
  void initState() {
    super.initState();
    _followUnfollowBloc = FollowUnfollowBloc(context);
    getAllUsersUpdated();
    // getFollowFollowingApi(page, currentTab, '');
    // getSuggestionApi();
    // GetApi.getNotify(context, '');
  }

  showFinalListShow(bool showHalfList, int listLen) {
    // if (showHalfList) {
    //   if (listLen >= 5) {
    //     this.listLen = 5;
    //   } else {
    //     this.listLen = _followerModel.data!.length;
    //   }
    // } else {
    this.listLen = _followerModel.data!.length;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _followUnfollowBloc,
      child: BlocListener<FollowUnfollowBloc, BlocStates>(
        listener: (context, state) {
          if (state is Loading) {
            LoadingDialog.show(context);
          }
          if (state is Loaded) {
            LoadingDialog.hide(context);
            if(currentTab == 1){
              getFollowerUsers();
            }
            else if(currentTab == 2){
              getFollowingUsers();
            }
            // getFollowFollowingApi(page, currentTab, '');
            // getSuggestionApi();
            // LoadingDialog.hide(context);
            // setState(() {});
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: Scaffold(
              backgroundColor: MyColor.white,
              body: SafeArea(
                child: _buildUINEW()
                // _buildUIOLD(),
              )),
        ),
      ),
    );
  }

  Future getFollowingUsers() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.getFollowingUsers}/${sharedPref.getString(SharedKey.userId)}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _followingUserResponseModel = FollowingUserResponseModel.fromJson(result);
      getFollowerUsers();
    }
  }

  Future getFollowerUsers() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.getFollowerUsers}/${sharedPref.getString(SharedKey.userId)}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _followerUserResponseModel = FollowerUserResponseModel.fromJson(result);
      setState(() {
        loader = false;
      });
    }
  }

  Future getAllUsersUpdated() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.allUsersDiscussion}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      _allUsersDiscussionModel = AllUsersDiscussionModel.fromJson(result);
      getFollowingUsers();
    }
  }

  getFollowFollowingApi(int loadPage, int type, String searchValues) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.followersFollowing}?page=${loadPage.toString()}&limit=200&search=$searchValues&type=${type.toString()}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      // loader = false;
      followList.clear();
      stackLoader = false;
      listLoader = false;
      _followerModel = FollowingFollowerModel.fromJson(result);
      for (int i = 0; i < _followerModel.data!.length; i++) {
        followList.add(_followerModel.data![i]);
      }
      listLen = followList.length;
      print('LIST LENGTH $listLen');
      showFinalListShow(showHalfList, listLen);
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  getAllUsers(String searchValues) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.allUsers}?search=$searchValues");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      // loader = false;
      stackLoader = false;
      listLoader = false;
      allUsers = AllUsers.fromJson(result);
      search = true;
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  getSuggestionApi() async {
    var res = await AllApi.getMethodApi("${ApiStrings.suggestedFriends}");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      suggestionList.clear();
      _getSuggestionList = GetSuggestionList.fromJson(result);
      for (int i = 0; i < _getSuggestionList.data!.length; i++) {
        if (_getSuggestionList.data![i].isFollowing == 0) {
          suggestionList.add(_getSuggestionList.data![i]);
        }
      }
      setState(() {});
    } else {}
  }

  removeUser(String userId) async {
    var res = await AllApi.deleteMethodApiQuery(
        "${ApiStrings.removeFollowing}?id=$userId");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      page = 1;
      getFollowFollowingApi(page, currentTab, '');
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

  // Widget _buildUIOLD() {
  //   return Stack(
  //     children: [
  //       Container(
  //         height: MediaQuery.of(context).size.height,
  //         padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: loader
  //             ? Container(
  //           child: progressBar(),
  //         )
  //             : SingleChildScrollView(
  //           physics: (currentTab == 2)
  //               ? NeverScrollableScrollPhysics()
  //               : BouncingScrollPhysics(),
  //           child: Padding(
  //             padding:
  //             const EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding:
  //                   const EdgeInsets.only(bottom: 15),
  //                   child: Row(
  //                     mainAxisAlignment:
  //                     MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () => Navigator.pop(context),
  //                         child: Container(
  //                           width: 31,
  //                           height: 31,
  //                           child: Image.asset(
  //                             'assets/images/icons/prev.png',
  //                           ),
  //                         ),
  //                       ),
  //                       Row(
  //                         mainAxisAlignment:
  //                         MainAxisAlignment.center,
  //                         children: [
  //                           Stack(
  //                             children: [
  //                               GestureDetector(
  //                                 onTap: () async {
  //                                   FocusManager
  //                                       .instance.primaryFocus
  //                                       ?.unfocus();
  //                                   Navigator.pushNamed(
  //                                     context,
  //                                     RoutesName.notification,
  //                                     arguments: 1,
  //                                   );
  //                                 },
  //                                 child: Container(
  //                                   width: 25,
  //                                   height: 25,
  //                                   child: Image.asset(
  //                                     'assets/images/icons/notif.png',
  //                                     color: const Color(
  //                                         0xff5B6170),
  //                                   ),
  //                                 ),
  //                               ),
  //                               if (GetApi.getNotification
  //                                   .data !=
  //                                   null &&
  //                                   GetApi.getNotification
  //                                       .data!.length >
  //                                       0)
  //                                 Positioned(
  //                                   right: 0,
  //                                   top: 0,
  //                                   child: Container(
  //                                     height: 15,
  //                                     width: 15,
  //                                     decoration:
  //                                     const BoxDecoration(
  //                                       color:
  //                                       Color(0xff00C03A),
  //                                       borderRadius:
  //                                       BorderRadius.all(
  //                                           Radius
  //                                               .circular(
  //                                               100)),
  //                                     ),
  //                                     child: Text(
  //                                       '${GetApi.getNotification.data!.length}',
  //                                       style:
  //                                       const TextStyle(
  //                                         color: Colors.white,
  //                                         fontSize: 10,
  //                                         fontWeight:
  //                                         FontWeight.bold,
  //                                       ),
  //                                       textAlign:
  //                                       TextAlign.center,
  //                                     ),
  //                                   ),
  //                                 ),
  //                             ],
  //                           ),
  //                           const SizedBox(width: 10),
  //                           GestureDetector(
  //                             onTap: () async {
  //                               await changeLanguage(context);
  //                             },
  //                             child: Container(
  //                               width: 25,
  //                               height: 25,
  //                               child: Image.asset(
  //                                 'assets/images/icons/translation_login.png',
  //                                 color:
  //                                 const Color(0xff4F2020),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 MyString.bold('friends'.tr, 27,
  //                     MyColor.title, TextAlign.center),
  //                 Container(
  //                   height: 40,
  //                   margin: const EdgeInsets.only(
  //                       bottom: 15, top: 10),
  //                   decoration: BoxDecoration(
  //                       border: Border.all(
  //                           color: Color(0xffEBEBEB)),
  //                       borderRadius: BorderRadius.all(
  //                           Radius.circular(5))),
  //                   child: TextField(
  //                     controller: searchBar,
  //                     scrollPadding:
  //                     const EdgeInsets.only(bottom: 50),
  //                     style: TextStyle(
  //                         color: MyColor.black, fontSize: 14),
  //                     decoration: InputDecoration(
  //                       border: const OutlineInputBorder(
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       prefixIcon: SizedBox(
  //                         width: 20,
  //                         height: 20,
  //                         child: Padding(
  //                           padding:
  //                           const EdgeInsets.all(8.0),
  //                           child: Image.asset(
  //                             'assets/images/icons/search.png',
  //                             width: 20,
  //                             height: 20,
  //                           ),
  //                         ),
  //                       ),
  //                       contentPadding:
  //                       const EdgeInsets.symmetric(
  //                           vertical: 5, horizontal: 12),
  //                       hintText: 'search'.tr,
  //                       hintStyle: TextStyle(
  //                           color: MyColor.more,
  //                           fontSize: 14),
  //                     ),
  //                     onChanged: (value) {
  //                       setState(() {
  //                         if (value.length > 1) {
  //                           stackLoader = true;
  //                           getAllUsers(value);
  //                         }
  //                         if (value.isEmpty) {
  //                           stackLoader = true;
  //                           getAllUsers('');
  //                         }
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 if (searchBar.text.isEmpty)
  //                   Column(
  //                     mainAxisAlignment:
  //                     MainAxisAlignment.start,
  //                     crossAxisAlignment:
  //                     CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Flexible(
  //                               flex: 1,
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   FocusManager.instance
  //                                       .primaryFocus!
  //                                       .unfocus();
  //                                   listLoader = true;
  //                                   currentTab = 1;
  //                                   searchBar.text = '';
  //                                   page = 1;
  //                                   getFollowFollowingApi(
  //                                       page, currentTab, '');
  //                                   setState(() {});
  //                                 },
  //                                 child: Container(
  //                                   height: 43,
  //                                   alignment:
  //                                   Alignment.center,
  //                                   margin:
  //                                   const EdgeInsets.only(
  //                                       right: 10),
  //                                   width: double.infinity,
  //                                   decoration: BoxDecoration(
  //                                       borderRadius:
  //                                       const BorderRadius
  //                                           .all(Radius
  //                                           .circular(
  //                                           16)),
  //                                       color: currentTab == 2
  //                                           ? MyColor.white
  //                                           : MyColor
  //                                           .orange2),
  //                                   child: MyString.med(
  //                                       '${_followerModel.metadata!.myFollowingsTotal.toString()} ${'following'.tr}${int.parse(_followerModel.metadata!.myFollowingsTotal.toString()) > 1 ? "s" : ""}',
  //                                       14,
  //                                       currentTab == 2
  //                                           ? MyColor.title
  //                                           : MyColor.white,
  //                                       TextAlign.center),
  //                                 ),
  //                               )),
  //                           Flexible(
  //                               flex: 1,
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   FocusManager.instance
  //                                       .primaryFocus!
  //                                       .unfocus();
  //                                   listLoader = true;
  //                                   currentTab = 2;
  //                                   searchBar.text = '';
  //                                   page = 1;
  //                                   getFollowFollowingApi(
  //                                       page, currentTab, '');
  //                                   setState(() {});
  //                                 },
  //                                 child: Container(
  //                                   margin:
  //                                   const EdgeInsets.only(
  //                                       left: 10),
  //                                   height: 43,
  //                                   alignment:
  //                                   Alignment.center,
  //                                   width: double.infinity,
  //                                   decoration: BoxDecoration(
  //                                       border: Border.all(
  //                                           color: MyColor
  //                                               .orange2),
  //                                       borderRadius:
  //                                       const BorderRadius
  //                                           .all(Radius
  //                                           .circular(
  //                                           16)),
  //                                       color: currentTab == 1
  //                                           ? MyColor.white
  //                                           : MyColor
  //                                           .orange2),
  //                                   child: MyString.med(
  //                                       '${_followerModel.metadata!.myFollowersTotal.toString()} ${'followers'.tr}${int.parse(_followerModel.metadata!.myFollowersTotal.toString()) > 1 ? "s" : ""}',
  //                                       14,
  //                                       currentTab == 1
  //                                           ? MyColor.title
  //                                           : MyColor.white,
  //                                       TextAlign.center),
  //                                 ),
  //                               )),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       if (currentTab == 1)
  //                         listLoader
  //                             ? progressBar()
  //                             : ListView.builder(
  //                           itemCount: listLen,
  //                           shrinkWrap: true,
  //                           physics:
  //                           NeverScrollableScrollPhysics(),
  //                           padding: EdgeInsets.only(
  //                               bottom: 10, top: 20),
  //                           itemBuilder:
  //                               (context, index) {
  //                             return Row(
  //                               mainAxisAlignment:
  //                               MainAxisAlignment
  //                                   .spaceBetween,
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment
  //                                   .center,
  //                               children: [
  //                                 GestureDetector(
  //                                   onTap: () {
  //                                     FocusManager
  //                                         .instance
  //                                         .primaryFocus!
  //                                         .unfocus();
  //                                     Map<String,
  //                                         dynamic>
  //                                     mapData = {
  //                                       'userID': followList[
  //                                       index]
  //                                           .followRef!
  //                                           .id
  //                                           .toString()
  //                                     };
  //                                     Navigator.pushNamed(
  //                                         context,
  //                                         RoutesName
  //                                             .myProfile,
  //                                         arguments:
  //                                         mapData);
  //                                   },
  //                                   child: Row(
  //                                     children: [
  //                                       Container(
  //                                         height: 62,
  //                                         width: 62,
  //                                         padding:
  //                                         EdgeInsets
  //                                             .all(
  //                                             5),
  //                                         decoration:
  //                                         BoxDecoration(
  //                                           border: Border.all(
  //                                               color: Color(
  //                                                   0xffFFEDED)),
  //                                           borderRadius:
  //                                           const BorderRadius
  //                                               .all(
  //                                               Radius.circular(50)),
  //                                         ),
  //                                         child:
  //                                         ClipRRect(
  //                                           borderRadius:
  //                                           const BorderRadius
  //                                               .all(
  //                                               Radius.circular(50)),
  //                                           child: followList[index].followRef!.profilePicture !=
  //                                               null
  //                                               ? Image.network(
  //                                               '${ApiStrings.mediaURl}${followList[index].followRef!.profilePicture.toString()}',
  //                                               height:
  //                                               42,
  //                                               width:
  //                                               42,
  //                                               fit: BoxFit
  //                                                   .cover,
  //                                               loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
  //                                                   ? child
  //                                                   : Container(height: 30, width: 30, child: customProgressBar()))
  //                                               : Image.asset(
  //                                             'assets/images/onboard/placeholder_image.png',
  //                                             width:
  //                                             42,
  //                                             height:
  //                                             42,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                           width: 15),
  //                                       SizedBox(
  //                                         width: MediaQuery.of(
  //                                             context)
  //                                             .size
  //                                             .width *
  //                                             0.4,
  //                                         child: MyString.med(
  //                                             followList[
  //                                             index]
  //                                                 .followRef!
  //                                                 .name
  //                                                 .toString(),
  //                                             13,
  //                                             MyColor
  //                                                 .redd,
  //                                             TextAlign
  //                                                 .start),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Flexible(
  //                                   child:
  //                                   GestureDetector(
  //                                     onTap: () async {
  //                                       _followUnfollowBloc.add(
  //                                           GetFollowUnfollowEvent(followList[
  //                                           index]
  //                                               .followId
  //                                               .toString()));
  //                                       setState(() {});
  //                                     },
  //                                     child: Container(
  //                                       padding:
  //                                       EdgeInsets
  //                                           .all(5),
  //                                       alignment:
  //                                       Alignment
  //                                           .center,
  //                                       decoration: BoxDecoration(
  //                                           color: MyColor
  //                                               .orange2,
  //                                           borderRadius:
  //                                           const BorderRadius
  //                                               .all(
  //                                               Radius.circular(8))),
  //                                       child: Container(
  //                                           child: MyString.med(
  //                                               "unfollow"
  //                                                   .tr,
  //                                               12,
  //                                               MyColor
  //                                                   .white,
  //                                               TextAlign
  //                                                   .center)),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             );
  //                           },
  //                         ),
  //                       if (currentTab == 2)
  //                         listLoader
  //                             ? progressBar()
  //                             : followList.isNotEmpty
  //                             ? Container(
  //                           height: MediaQuery.of(
  //                               context)
  //                               .size
  //                               .height *
  //                               .60,
  //                           child: ListView.builder(
  //                             padding:
  //                             EdgeInsets.only(
  //                                 bottom: 50,
  //                                 top: 10),
  //                             itemCount:
  //                             followList.length,
  //                             itemBuilder:
  //                                 (context, index) {
  //                               return Padding(
  //                                 padding:
  //                                 const EdgeInsets
  //                                     .only(
  //                                     right: 4,
  //                                     left: 4,
  //                                     bottom:
  //                                     20),
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment
  //                                       .spaceBetween,
  //                                   crossAxisAlignment:
  //                                   CrossAxisAlignment
  //                                       .center,
  //                                   children: [
  //                                     GestureDetector(
  //                                       onTap: () {
  //                                         FocusManager
  //                                             .instance
  //                                             .primaryFocus!
  //                                             .unfocus();
  //                                         Map<String,
  //                                             dynamic>
  //                                         mapData =
  //                                         {
  //                                           'userID': followList[index]
  //                                               .userRef!
  //                                               .id
  //                                               .toString()
  //                                         };
  //                                         Navigator.pushNamed(
  //                                             context,
  //                                             RoutesName
  //                                                 .myProfile,
  //                                             arguments:
  //                                             mapData);
  //                                       },
  //                                       child: Row(
  //                                         children: [
  //                                           ClipRRect(
  //                                             borderRadius: const BorderRadius
  //                                                 .all(
  //                                                 Radius.circular(50)),
  //                                             child: followList[index].userRef!.profilePicture != null
  //                                                 ? Image.network('${ApiStrings.mediaURl}${followList[index].userRef!.profilePicture.toString()}', height: 42, width: 42, fit: BoxFit.cover, loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : Container(height: 42, width: 42, child: customProgressBar()))
  //                                                 : Image.asset(
  //                                               'assets/images/onboard/placeholder_image.png',
  //                                               width: 42,
  //                                               height: 42,
  //                                             ),
  //                                           ),
  //                                           const SizedBox(
  //                                               width:
  //                                               8),
  //                                           Container(
  //                                               width: MediaQuery.of(context).size.width *
  //                                                   .43,
  //                                               child: MyString.medMultiLine(
  //                                                   followList[index].userRef!.name.toString(),
  //                                                   13,
  //                                                   MyColor.redd,
  //                                                   TextAlign.start,
  //                                                   1)),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Flexible(
  //                                       child:
  //                                       GestureDetector(
  //                                         onTap:
  //                                             () {
  //                                           stackLoader =
  //                                           true;
  //                                           removeUser(followList[index]
  //                                               .id
  //                                               .toString());
  //                                         },
  //                                         child:
  //                                         Container(
  //                                           padding:
  //                                           EdgeInsets.all(5),
  //                                           alignment:
  //                                           Alignment.center,
  //                                           decoration: BoxDecoration(
  //                                               color:
  //                                               MyColor.white,
  //                                               border: Border.all(color: MyColor.orange2),
  //                                               borderRadius: const BorderRadius.all(Radius.circular(8))),
  //                                           child: Container(
  //                                               child: MyString.reg(
  //                                                   "remove".tr,
  //                                                   12,
  //                                                   MyColor.redd,
  //                                                   TextAlign.center)),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         )
  //                             : Column(
  //                           crossAxisAlignment:
  //                           CrossAxisAlignment
  //                               .center,
  //                           mainAxisAlignment:
  //                           MainAxisAlignment
  //                               .center,
  //                           children: [
  //                             Image.asset(
  //                               'assets/images/onboard/placeholder_image.png',
  //                               width: 120,
  //                               height: 90,
  //                             ),
  //                             Container(
  //                                 width: double
  //                                     .infinity,
  //                                 child: MyString.reg(
  //                                     'noFollower'
  //                                         .tr,
  //                                     12,
  //                                     MyColor
  //                                         .textBlack0,
  //                                     TextAlign
  //                                         .center)),
  //                           ],
  //                         ),
  //                       if (currentTab == 1)
  //                         Column(
  //                           mainAxisAlignment:
  //                           MainAxisAlignment.start,
  //                           crossAxisAlignment:
  //                           CrossAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                                 child: MyString.bold(
  //                                     'suggestions'.tr,
  //                                     14,
  //                                     MyColor.title,
  //                                     TextAlign.start)),
  //                           ],
  //                         ),
  //                       if (suggestionList.isNotEmpty &&
  //                           currentTab == 1)
  //                         Container(
  //                           margin: const EdgeInsets.only(
  //                               top: 10, bottom: 85),
  //                           width: double.infinity,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   color: MyColor.stroke)),
  //                           child: ListView.builder(
  //                               physics:
  //                               const NeverScrollableScrollPhysics(),
  //                               itemCount:
  //                               suggestionList.length,
  //                               padding: EdgeInsets.only(
  //                                   bottom: 10, top: 20),
  //                               shrinkWrap: true,
  //                               scrollDirection:
  //                               Axis.vertical,
  //                               itemBuilder:
  //                                   (context, index) {
  //                                 return Row(
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment
  //                                       .spaceBetween,
  //                                   crossAxisAlignment:
  //                                   CrossAxisAlignment
  //                                       .center,
  //                                   children: [
  //                                     GestureDetector(
  //                                       onTap: () {
  //                                         FocusManager
  //                                             .instance
  //                                             .primaryFocus!
  //                                             .unfocus();
  //                                         Map<String, dynamic>
  //                                         mapData = {
  //                                           'userID':
  //                                           suggestionList[
  //                                           index]
  //                                               .id
  //                                               .toString()
  //                                         };
  //                                         Navigator.pushNamed(
  //                                             context,
  //                                             RoutesName
  //                                                 .myProfile,
  //                                             arguments:
  //                                             mapData);
  //                                       },
  //                                       child: Row(
  //                                         children: [
  //                                           Container(
  //                                             height: 62,
  //                                             width: 62,
  //                                             padding:
  //                                             EdgeInsets
  //                                                 .all(5),
  //                                             decoration:
  //                                             BoxDecoration(
  //                                               border: Border.all(
  //                                                   color: Color(
  //                                                       0xffFFEDED)),
  //                                               borderRadius:
  //                                               const BorderRadius
  //                                                   .all(
  //                                                   Radius.circular(
  //                                                       50)),
  //                                             ),
  //                                             child:
  //                                             ClipRRect(
  //                                               borderRadius:
  //                                               const BorderRadius
  //                                                   .all(
  //                                                   Radius.circular(
  //                                                       50)),
  //                                               child: suggestionList[index]
  //                                                   .profilePicture !=
  //                                                   null
  //                                                   ? Image.network(
  //                                                   '${ApiStrings.mediaURl}${suggestionList[index].profilePicture.toString()}',
  //                                                   height:
  //                                                   42,
  //                                                   width:
  //                                                   42,
  //                                                   fit: BoxFit
  //                                                       .cover,
  //                                                   loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
  //                                                       ? child
  //                                                       : Container(height: 42, width: 42, child: customProgressBar()))
  //                                                   : Image.asset(
  //                                                 'assets/images/onboard/placeholder_image.png',
  //                                                 width:
  //                                                 42,
  //                                                 height:
  //                                                 42,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           const SizedBox(
  //                                               width: 15),
  //                                           Container(
  //                                               width: MediaQuery.of(
  //                                                   context)
  //                                                   .size
  //                                                   .width *
  //                                                   0.4,
  //                                               child: MyString.med(
  //                                                   suggestionList[
  //                                                   index]
  //                                                       .name
  //                                                       .toString(),
  //                                                   13,
  //                                                   MyColor
  //                                                       .redd,
  //                                                   TextAlign
  //                                                       .start)),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Flexible(
  //                                       child:
  //                                       GestureDetector(
  //                                         onTap: () {
  //                                           _followUnfollowBloc.add(
  //                                               GetFollowUnfollowEvent(
  //                                                   suggestionList[
  //                                                   index]
  //                                                       .id
  //                                                       .toString()));
  //                                           setState(() {});
  //                                         },
  //                                         child: Container(
  //                                           padding:
  //                                           EdgeInsets
  //                                               .all(5),
  //                                           alignment:
  //                                           Alignment
  //                                               .center,
  //                                           decoration: BoxDecoration(
  //                                               color: MyColor
  //                                                   .orange2,
  //                                               borderRadius:
  //                                               const BorderRadius
  //                                                   .all(
  //                                                   Radius.circular(
  //                                                       8))),
  //                                           child: Container(
  //                                               child: MyString.med(
  //                                                   "follow"
  //                                                       .tr,
  //                                                   12,
  //                                                   MyColor
  //                                                       .white,
  //                                                   TextAlign
  //                                                       .center)),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 );
  //                               }),
  //                         )
  //                     ],
  //                   ),
  //                 if (searchBar.text.isNotEmpty &&
  //                     allUsers.data != null)
  //                   ListView.builder(
  //                     itemCount: allUsers.data!.length,
  //                     shrinkWrap: true,
  //                     physics: NeverScrollableScrollPhysics(),
  //                     padding: EdgeInsets.only(
  //                         bottom: 10, top: 10),
  //                     itemBuilder: (context, index) {
  //                       return Padding(
  //                         padding: const EdgeInsets.only(
  //                             right: 4, left: 4, bottom: 20),
  //                         child: Row(
  //                           mainAxisAlignment:
  //                           MainAxisAlignment
  //                               .spaceBetween,
  //                           crossAxisAlignment:
  //                           CrossAxisAlignment.center,
  //                           children: [
  //                             GestureDetector(
  //                               onTap: () {
  //                                 FocusManager
  //                                     .instance.primaryFocus!
  //                                     .unfocus();
  //                                 Map<String, dynamic>
  //                                 mapData = {
  //                                   'userID': allUsers
  //                                       .data![index].id
  //                                       .toString()
  //                                 };
  //                                 Navigator.pushNamed(context,
  //                                     RoutesName.myProfile,
  //                                     arguments: mapData);
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   ClipRRect(
  //                                     borderRadius:
  //                                     const BorderRadius
  //                                         .all(
  //                                         Radius.circular(
  //                                             50)),
  //                                     child: allUsers
  //                                         .data![
  //                                     index]
  //                                         .profilePicture !=
  //                                         null
  //                                         ? Image.network(
  //                                         '${ApiStrings.mediaURl}${allUsers.data![index].profilePicture.toString()}',
  //                                         height: 30,
  //                                         width: 30,
  //                                         fit: BoxFit
  //                                             .cover,
  //                                         loadingBuilder: (context,
  //                                             child,
  //                                             loadingProgress) =>
  //                                         (loadingProgress ==
  //                                             null)
  //                                             ? child
  //                                             : Container(
  //                                             height:
  //                                             30,
  //                                             width:
  //                                             30,
  //                                             child:
  //                                             customProgressBar()))
  //                                         : Image.asset(
  //                                       'assets/images/onboard/placeholder_image.png',
  //                                       width: 30,
  //                                       height: 30,
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 8),
  //                                   Column(
  //                                     mainAxisAlignment:
  //                                     MainAxisAlignment
  //                                         .start,
  //                                     crossAxisAlignment:
  //                                     CrossAxisAlignment
  //                                         .start,
  //                                     children: [
  //                                       SizedBox(
  //                                         width: MediaQuery.of(
  //                                             context)
  //                                             .size
  //                                             .width *
  //                                             0.5,
  //                                         child: MyString.med(
  //                                             allUsers
  //                                                 .data![
  //                                             index]
  //                                                 .name
  //                                                 .toString(),
  //                                             16,
  //                                             MyColor
  //                                                 .textBlack2,
  //                                             TextAlign
  //                                                 .start),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //
  //                             // Flexible(
  //                             //   child: GestureDetector(
  //                             //     onTap: () async {
  //                             //       _followUnfollowBloc.add(GetFollowUnfollowEvent(followList[index].followId.toString()));
  //                             //       setState(() {});
  //                             //     },
  //                             //     child: Container(
  //                             //       alignment: Alignment.center,
  //                             //       decoration:
  //                             //
  //                             //       BoxDecoration(color: MyColor.orange2,
  //                             //           boxShadow: <BoxShadow>[
  //                             //             new BoxShadow(
  //                             //               color: MyColor.liteGrey,
  //                             //               blurRadius: 2.0,
  //                             //               offset: new Offset(0.0, 3.0),
  //                             //             ),
  //                             //           ],
  //                             //           borderRadius: const BorderRadius.all(Radius.circular(20))),
  //                             //       child: Container(
  //                             //           margin: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
  //                             //           child: MyString.boldMultiLine("unfollow".tr, 14, MyColor.white, TextAlign.center,1)),
  //                             //     ),
  //                             //   ),
  //                             // ),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                   )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       if (stackLoader) progressBar()
  //     ],
  //   );
  // }

  Widget _buildUINEW() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: loader
              ? Container(
            child: progressBar(),
          )
              : SingleChildScrollView(
            physics: (currentTab == 2)
                ? NeverScrollableScrollPhysics()
                : BouncingScrollPhysics(),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus();
                                    Navigator.pushNamed(
                                      context,
                                      RoutesName.notification,
                                      arguments: 1,
                                    );
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset(
                                      'assets/images/icons/notif.png',
                                      color: const Color(
                                          0xff5B6170),
                                    ),
                                  ),
                                ),
                                if (GetApi.getNotification
                                    .data !=
                                    null &&
                                    GetApi.getNotification
                                        .data!.length >
                                        0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration:
                                      const BoxDecoration(
                                        color:
                                        Color(0xff00C03A),
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius
                                                .circular(
                                                100)),
                                      ),
                                      child: Text(
                                        '${GetApi.getNotification.data!.length}',
                                        style:
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                        textAlign:
                                        TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                await changeLanguage(context);
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  'assets/images/icons/translation_login.png',
                                  color:
                                  const Color(0xff4F2020),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MyString.bold('friends'.tr, 27,
                      MyColor.title, TextAlign.center),
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
                            padding:
                            const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/icons/search.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        hintText: 'search'.tr,
                        hintStyle: TextStyle(
                            color: MyColor.more,
                            fontSize: 14),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.length > 1) {
                            stackLoader = true;
                            getAllUsers(value);
                          }
                          if (value.isEmpty) {
                            stackLoader = true;
                            getAllUsers('');
                          }
                        });
                      },
                    ),
                  ),
                  if (searchBar.text.isEmpty)
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance
                                        .primaryFocus!
                                        .unfocus();
                                    if(currentTab != 1){
                                      currentTab = 1;
                                      searchBar.text = '';
                                      setState(() {});
                                    }
                                    // listLoader = true;

                                    // page = 1;
                                    // getFollowFollowingApi(
                                    //     page, currentTab, '');
                                    // setState(() {});
                                  },
                                  child: Container(
                                    margin:
                                    const EdgeInsets.only(
                                        left: 10),
                                    height: 43,
                                    alignment:
                                    Alignment.center,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyColor
                                                .orange2,
                                          width: 1
                                        ),
                                        borderRadius:
                                        const BorderRadius
                                            .all(Radius
                                            .circular(
                                            16)
                                        ),
                                        color: currentTab == 1
                                            ? MyColor
                                            .orange2 :
                                        MyColor.white),
                                    child: MyString.med(
                                        '${_followerUserResponseModel.data!.length} ${'followers'.tr}${_followerUserResponseModel.data!.isNotEmpty && _followerUserResponseModel.data!.length! > 1 ? "s" : ""}',
                                        14,
                                        currentTab == 1
                                            ? MyColor.white
                                            : MyColor.title,
                                        TextAlign.center),
                                  ),
                                )),
                            SizedBox(
                              width: 30,
                            ),
                            Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance
                                        .primaryFocus!
                                        .unfocus();
                                    if(currentTab != 2){
                                      currentTab = 2;
                                      searchBar.text = '';
                                      setState(() {});
                                    }
                                    // FocusManager.instance
                                    //     .primaryFocus!
                                    //     .unfocus();
                                    // listLoader = true;
                                    // currentTab = 1;
                                    // searchBar.text = '';
                                    // page = 1;
                                    // getFollowFollowingApi(
                                    //     page, currentTab, '');
                                    // setState(() {});
                                  },
                                  child: Container(
                                    height: 43,
                                    alignment:
                                    Alignment.center,
                                    margin:
                                    const EdgeInsets.only(
                                        right: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(16),),
                                        border: Border.all(
                                          color: MyColor
                                              .orange2, // Change to your desired border color
                                          width: 1.0, // Border width
                                        ),
                                        color: currentTab == 2
                                            ? MyColor
                                            .orange2 :
                                        MyColor.white),
                                    child: MyString.med(
                                        '${_followingUserResponseModel.data!.length} ${'following'.tr}${_followingUserResponseModel.data!.length > 1 ? "s" : ""}',
                                        14,
                                        currentTab == 2
                                            ? MyColor.white
                                            : MyColor.title,
                                        TextAlign.center),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (currentTab == 1)
                          listLoader
                              ? progressBar()
                              : ListView.builder(
                            itemCount: _followerUserResponseModel.data!.isEmpty ? 1 : _followerUserResponseModel.data!.length,
                            shrinkWrap: true,
                            physics:
                            NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                bottom: 10, top: 20),
                            itemBuilder:
                                (context, index) {
                              if(_followerUserResponseModel.data!.isEmpty){
                                return NoDataFound();
                              }
                              final followerUser = _followerUserResponseModel.data![index];
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
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
                                        'userID': followerUser.followerId
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
                                      children: [
                                        Container(
                                          height: 62,
                                          width: 62,
                                          padding:
                                          EdgeInsets
                                              .all(
                                              5),
                                          decoration:
                                          BoxDecoration(
                                            border: Border.all(
                                                color: Color(
                                                    0xffFFEDED)),
                                            borderRadius:
                                            const BorderRadius
                                                .all(
                                                Radius.circular(50)),
                                          ),
                                          child:
                                          ClipRRect(
                                            borderRadius:
                                            const BorderRadius
                                                .all(
                                                Radius.circular(50)),
                                            child: followerUser.following !=
                                                null && followerUser.following!.profilePicture !=
                                                null && followerUser.following!.profilePicture!.contains('http')
                                                ? Image.network(
                                                '${followerUser.following!.profilePicture}',
                                                height:
                                                42,
                                                width:
                                                42,
                                                fit: BoxFit
                                                    .cover,
                                                loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                                                    ? child
                                                    : Container(height: 30, width: 30, child: customProgressBar()))
                                                : Image.asset(
                                              'assets/images/onboard/placeholder_image.png',
                                              width:
                                              42,
                                              height:
                                              42,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 15),
                                        if(followerUser.following != null) SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width *
                                              0.4,
                                          child: MyString.med(
                                              '${followerUser.following!.name}',
                                              13,
                                              MyColor
                                                  .redd,
                                              TextAlign
                                                  .start),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child:
                                    GestureDetector(
                                      onTap: () async {
                                        _followUnfollowBloc.add(
                                            GetFollowUnfollowEvent(followerUser.followerId
                                                .toString()));
                                        // setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                        EdgeInsets
                                            .all(5),
                                        alignment:
                                        Alignment
                                            .center,
                                        decoration: BoxDecoration(
                                            color: MyColor
                                                .white,
                                            border: Border.all(
                                              color: MyColor.orange2,
                                              width: 1
                                            ) ,
                                            borderRadius:
                                            const BorderRadius
                                                .all(
                                                Radius.circular(8))),
                                        child: Container(
                                            child: MyString.med(
                                                "follow"
                                                    .tr,
                                                12,
                                                MyColor
                                                    .title,
                                                TextAlign
                                                    .center)),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        if (currentTab == 2)
                          listLoader
                              ? progressBar()
                              : _followingUserResponseModel.data!.isNotEmpty
                              ? Container(
                            height: MediaQuery.of(
                                context)
                                .size
                                .height *
                                .60,
                            child: ListView.builder(
                              padding:
                              EdgeInsets.only(
                                  bottom: 50,
                                  top: 10),
                              itemCount:
                              _followingUserResponseModel.data!.isEmpty ? 1 : _followingUserResponseModel.data!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) {
                                if(_followingUserResponseModel.data!.isEmpty){
                                  return NoDataFound();
                                }
                                final followingUser = _followingUserResponseModel.data![index];
                                return Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                      right: 4,
                                      left: 4,
                                      bottom:
                                      20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
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
                                            'userID': followingUser.followingId
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
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius
                                                  .all(
                                                  Radius.circular(50)),
                                              child: followingUser.following!.profilePicture != null
                                              && followingUser.following!.profilePicture!.contains('http')
                                                  ? Image.network('${followingUser.following!.profilePicture}', height: 42, width: 42, fit: BoxFit.cover, loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : Container(height: 42, width: 42, child: customProgressBar()))
                                                  : Image.asset(
                                                'assets/images/onboard/placeholder_image.png',
                                                width: 42,
                                                height: 42,
                                              ),
                                            ),
                                            const SizedBox(
                                                width:
                                                8),
                                            Container(
                                                width: MediaQuery.of(context).size.width *
                                                    .43,
                                                child: MyString.medMultiLine(
                                                    '${followingUser.following!.name}',
                                                    13,
                                                    MyColor.redd,
                                                    TextAlign.start,
                                                    1)),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child:
                                        GestureDetector(
                                          onTap:
                                              () {
                                                _followUnfollowBloc.add(
                                                    GetFollowUnfollowEvent(followingUser.followingId
                                                        .toString()));
                                            // stackLoader =
                                            // true;
                                            // removeUser(followList[index]
                                            //     .id
                                            //     .toString());
                                          },
                                          child:
                                          Container(
                                            padding:
                                            EdgeInsets.all(5),
                                            alignment:
                                            Alignment.center,
                                            decoration: BoxDecoration(
                                                color:
                                                MyColor.orange2,
                                                border: Border.all(color: MyColor.orange2),
                                                borderRadius: const BorderRadius.all(Radius.circular(8))),
                                            child: Container(
                                                child: MyString.reg(
                                                    "unfollow".tr,
                                                    12,
                                                    MyColor.white,
                                                    TextAlign.center)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                              : Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              Image.asset(
                                'assets/images/onboard/placeholder_image.png',
                                width: 120,
                                height: 90,
                              ),
                              Container(
                                  width: double
                                      .infinity,
                                  child: MyString.reg(
                                      'noFollower'
                                          .tr,
                                      12,
                                      MyColor
                                          .textBlack0,
                                      TextAlign
                                          .center)),
                            ],
                          ),
                        if (currentTab == 1)
                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: MyString.bold(
                                      'suggestions'.tr,
                                      14,
                                      MyColor.title,
                                      TextAlign.start)),
                            ],
                          ),
                        if (_allUsersDiscussionModel.data!.isNotEmpty &&
                            currentTab == 1)
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 85),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyColor.stroke)),
                            child: ListView.builder(
                                physics:
                                const NeverScrollableScrollPhysics(),
                                itemCount:
                                _allUsersDiscussionModel.data!.isEmpty ? 1 : _allUsersDiscussionModel.data!.length,
                                padding: EdgeInsets.only(
                                    bottom: 10, top: 20),
                                shrinkWrap: true,
                                scrollDirection:
                                Axis.vertical,
                                itemBuilder:
                                    (context, index) {
                                  if(_allUsersDiscussionModel.data!.isEmpty){
                                    return NoDataFound();
                                  }
                                  final user = _allUsersDiscussionModel.data![index];
                                  return Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
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
                                            'userID': user.id
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
                                          children: [
                                            Container(
                                              height: 62,
                                              width: 62,
                                              padding:
                                              EdgeInsets
                                                  .all(5),
                                              decoration:
                                              BoxDecoration(
                                                border: Border.all(
                                                    color: Color(
                                                        0xffFFEDED)),
                                                borderRadius:
                                                const BorderRadius
                                                    .all(
                                                    Radius.circular(
                                                        50)),
                                              ),
                                              child:
                                              ClipRRect(
                                                borderRadius:
                                                const BorderRadius
                                                    .all(
                                                    Radius.circular(
                                                        50)),
                                                child: user
                                                    .profilePicture !=
                                                    null && user
                                                    .profilePicture!.contains('http')
                                                    ? Image.network(
                                                    '${user
                                                        .profilePicture}',
                                                    height:
                                                    42,
                                                    width:
                                                    42,
                                                    fit: BoxFit
                                                        .cover,
                                                    loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                                                        ? child
                                                        : Container(height: 42, width: 42, child: customProgressBar()))
                                                    : Image.asset(
                                                  'assets/images/onboard/placeholder_image.png',
                                                  width:
                                                  42,
                                                  height:
                                                  42,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 15),
                                            Container(
                                                width: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width *
                                                    0.4,
                                                child: MyString.med(
                                                    user
                                                        .name
                                                        .toString(),
                                                    13,
                                                    MyColor
                                                        .redd,
                                                    TextAlign
                                                        .start)),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child:
                                        GestureDetector(
                                          onTap: () async {
                                            _followUnfollowBloc.add(
                                                GetFollowUnfollowEvent(user.id!
                                                    .toString()));
                                            // setState(() {});
                                          },
                                          child: Container(
                                            padding:
                                            EdgeInsets
                                                .all(5),
                                            alignment:
                                            Alignment
                                                .center,
                                            decoration: BoxDecoration(
                                                color: MyColor
                                                    .white,
                                                border: Border.all(
                                                    color: MyColor.orange2,
                                                    width: 1
                                                ) ,
                                                borderRadius:
                                                const BorderRadius
                                                    .all(
                                                    Radius.circular(8))),
                                            child: Container(
                                                child: MyString.med(
                                                    "follow"
                                                        .tr,
                                                    12,
                                                    MyColor
                                                        .title,
                                                    TextAlign
                                                        .center)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          )
                      ],
                    ),
                  // if (searchBar.text.isNotEmpty &&
                  //     allUsers.data != null)
                  //   ListView.builder(
                  //     itemCount: allUsers.data!.length,
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     padding: EdgeInsets.only(
                  //         bottom: 10, top: 10),
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.only(
                  //             right: 4, left: 4, bottom: 20),
                  //         child: Row(
                  //           mainAxisAlignment:
                  //           MainAxisAlignment
                  //               .spaceBetween,
                  //           crossAxisAlignment:
                  //           CrossAxisAlignment.center,
                  //           children: [
                  //             GestureDetector(
                  //               onTap: () {
                  //                 FocusManager
                  //                     .instance.primaryFocus!
                  //                     .unfocus();
                  //                 Map<String, dynamic>
                  //                 mapData = {
                  //                   'userID': allUsers
                  //                       .data![index].id
                  //                       .toString()
                  //                 };
                  //                 Navigator.pushNamed(context,
                  //                     RoutesName.myProfile,
                  //                     arguments: mapData);
                  //               },
                  //               child: Row(
                  //                 children: [
                  //                   ClipRRect(
                  //                     borderRadius:
                  //                     const BorderRadius
                  //                         .all(
                  //                         Radius.circular(
                  //                             50)),
                  //                     child: allUsers
                  //                         .data![
                  //                     index]
                  //                         .profilePicture !=
                  //                         null
                  //                         ? Image.network(
                  //                         '${ApiStrings.mediaURl}${allUsers.data![index].profilePicture.toString()}',
                  //                         height: 30,
                  //                         width: 30,
                  //                         fit: BoxFit
                  //                             .cover,
                  //                         loadingBuilder: (context,
                  //                             child,
                  //                             loadingProgress) =>
                  //                         (loadingProgress ==
                  //                             null)
                  //                             ? child
                  //                             : Container(
                  //                             height:
                  //                             30,
                  //                             width:
                  //                             30,
                  //                             child:
                  //                             customProgressBar()))
                  //                         : Image.asset(
                  //                       'assets/images/onboard/placeholder_image.png',
                  //                       width: 30,
                  //                       height: 30,
                  //                     ),
                  //                   ),
                  //                   const SizedBox(width: 8),
                  //                   Column(
                  //                     mainAxisAlignment:
                  //                     MainAxisAlignment
                  //                         .start,
                  //                     crossAxisAlignment:
                  //                     CrossAxisAlignment
                  //                         .start,
                  //                     children: [
                  //                       SizedBox(
                  //                         width: MediaQuery.of(
                  //                             context)
                  //                             .size
                  //                             .width *
                  //                             0.5,
                  //                         child: MyString.med(
                  //                             allUsers
                  //                                 .data![
                  //                             index]
                  //                                 .name
                  //                                 .toString(),
                  //                             16,
                  //                             MyColor
                  //                                 .textBlack2,
                  //                             TextAlign
                  //                                 .start),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //
                  //             // Flexible(
                  //             //   child: GestureDetector(
                  //             //     onTap: () async {
                  //             //       _followUnfollowBloc.add(GetFollowUnfollowEvent(followList[index].followId.toString()));
                  //             //       setState(() {});
                  //             //     },
                  //             //     child: Container(
                  //             //       alignment: Alignment.center,
                  //             //       decoration:
                  //             //
                  //             //       BoxDecoration(color: MyColor.orange2,
                  //             //           boxShadow: <BoxShadow>[
                  //             //             new BoxShadow(
                  //             //               color: MyColor.liteGrey,
                  //             //               blurRadius: 2.0,
                  //             //               offset: new Offset(0.0, 3.0),
                  //             //             ),
                  //             //           ],
                  //             //           borderRadius: const BorderRadius.all(Radius.circular(20))),
                  //             //       child: Container(
                  //             //           margin: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                  //             //           child: MyString.boldMultiLine("unfollow".tr, 14, MyColor.white, TextAlign.center,1)),
                  //             //     ),
                  //             //   ),
                  //             // ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   )
                ],
              ),
            ),
          ),
        ),
        if (stackLoader) progressBar()
      ],
    );
  }
}
