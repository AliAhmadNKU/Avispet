import 'dart:async';
import 'dart:io';
import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/dialogs/dialog_deactivate.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/profile_list.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/crop_image.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/dialogs/dialog_delete_account.dart';
import '../../../utils/common_function/dialogs/dialog_logout.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/shared_pref.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileListModel> dataList = [
    ProfileListModel('assets/images/icons/user.png', 'badgesTitle'.tr, 12),
    ProfileListModel(
        'assets/images/icons/myactivities.png', 'myActivities'.tr, 0),
    ProfileListModel('assets/images/icons/myanimals.png', 'myAnimals'.tr, 11),
    ProfileListModel(
        'assets/images/icons/edit_account.png', 'editProfile'.tr, 1),
    ProfileListModel(
        'assets/images/icons/lock_account.png', 'changePassword'.tr, 2),
    ProfileListModel(
        'assets/images/icons/privacy_account.png', 'privacy1'.tr, 3),
    ProfileListModel(
        'assets/images/logos/privacy_account.png', 'termsAndConditions1'.tr, 4),
    ProfileListModel('assets/images/icons/faqs.png', 'faqs'.tr, 5),
    ProfileListModel('assets/images/icons/number.png', 'contactUs'.tr, 6),
    ProfileListModel(
        'assets/images/icons/translation.png', 'changeLanguage'.tr, 7),
    ProfileListModel('assets/images/icons/deactivate_account.png',
        'deactivateAccount'.tr, 8),
    ProfileListModel(
        'assets/images/logos/delete_account.png', 'deleteAccount'.tr, 9),
    ProfileListModel('assets/images/icons/logout.png', 'logout'.tr, 10),
    ProfileListModel(
        'assets/images/icons/invite_user.png', 'inviteFriends'.tr, 100),
    ProfileListModel('assets/images/icons/logout.png', 'passcode'.tr, 99),
  ];

  bool loader = true;
  File? fileImage;
  double needPoints = 0.0;
  TextEditingController bio = TextEditingController();

  Future<void> requestStoragePermission() async {
    // Request permission for photos (images, videos)
    var status = await Permission.photos.request();

    if (status.isGranted) {
      print("Permission granted");
    } else if (status.isDenied) {
      print("Permission denied");
    } else if (status.isPermanentlyDenied) {
      print("Permission permanently denied, opening settings...");
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    GetApi.getNotify(context, '');
    Future.delayed(Duration.zero, () async {
      await GetApi.getProfileApi(
          context, sharedPref.getString(SharedKey.userId).toString());

      // double maxPoints = double.parse(
      //     GetApi.getProfileModel.data!.userLevel!.maxPoints.toString());
      double currentPoints =
          double.parse(GetApi.getProfileModel.data!.gamePoints.toString());

      // needPoints = maxPoints - currentPoints;
      loader = false;
      // bio.text = GetApi.getProfileModel.data!.biography != null
      //     ? (GetApi.getProfileModel.data!.biography!.length > 20
      //         ? GetApi.getProfileModel.data!.biography!.substring(0, 20)
      //         : GetApi.getProfileModel.data!.biography!)
      //     : '';
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: HeaderWidget(),
                  ),
                  (GetApi.getProfileModel.data == null && loader)
                      ? Container(
                          child: progressBar(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        // Image picking logic
                                        String? result = await cameraPhoto(
                                            context, "editProfile");
                                        var returnImage;
                                        if (result == '0') {
                                          returnImage = await pickImage(
                                              context, ImageSource.camera);
                                        } else if (result == '1') {
                                          returnImage = await pickImage(
                                              context, ImageSource.gallery);
                                        }

                                        if (returnImage != null) {
                                          fileImage = returnImage;
                                          LoadingDialog.show(context);

                                          // Ensure API call has a timeout
                                          await AllApi.uploadImage(
                                                  context, fileImage)
                                              .timeout(Duration(seconds: 5));
                                        }
                                      } catch (e) {
                                        toaster(
                                            context, "An error occurred: $e");
                                      } finally {
                                        LoadingDialog.hide(context);
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          child: fileImage != null
                                              ? Image.file(fileImage!,
                                                  width: 75,
                                                  height: 75,
                                                  fit: BoxFit.cover)
                                              : GetApi.getProfileModel.data!
                                                          .profilePicture !=
                                                      null
                                                  ? Image.network(
                                                      '${ApiStrings.mediaURl}${GetApi.getProfileModel.data!.profilePicture.toString()}',
                                                      width: 75,
                                                      height: 75,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) =>
                                                          (loadingProgress == null)
                                                              ? child
                                                              : Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      color:
                                                                          MyColor.cardColor),
                                                                  width: 75,
                                                                  height: 75,
                                                                  child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 60, height: 60))))
                                                  : Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: MyColor.cardColor), width: 75, height: 75, child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 60, height: 60))),
                                        ),
                                        Image.asset(
                                          'assets/images/icons/editpic.png',
                                          width: 19,
                                          height: 19,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              MyString.boldMultiLine(
                                                  loader
                                                      ? 'USERNAME'
                                                      : GetApi.getProfileModel
                                                          .data!.name
                                                          .toString(),
                                                  14,
                                                  MyColor.title,
                                                  TextAlign.start,
                                                  1),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image.asset(
                                                'assets/images/icons/hand.png',
                                                width: 15,
                                                height: 15,
                                              )
                                            ],
                                          ),
                                          // if (GetApi.getProfileModel.data!
                                          //         .biography
                                          //         .toString() !=
                                          //     "null")
                                          GestureDetector(
                                            onTap: () async {
                                              await Navigator.pushNamed(context,
                                                  RoutesName.editProfile);
                                              await GetApi.getProfileApi(
                                                  context,
                                                  sharedPref
                                                      .getString(
                                                          SharedKey.userId)
                                                      .toString());
                                              // double maxPoints = double.parse(
                                              //     GetApi.getProfileModel.data!
                                              //         .userLevel!.maxPoints
                                              //         .toString());
                                              // double currentPoints =
                                              //     double.parse(GetApi
                                              //         .getProfileModel
                                              //         .data!
                                              //         .gamePoints
                                              //         .toString());

                                              // needPoints =
                                              //     maxPoints - currentPoints;
                                              // bio.text = GetApi.getProfileModel
                                              //             .data!.biography !=
                                              //         null
                                              //     ? (GetApi
                                              //                 .getProfileModel
                                              //                 .data!
                                              //                 .biography!
                                              //                 .length >
                                              //             20
                                              //         ? GetApi.getProfileModel
                                              //             .data!.biography!
                                              //             .substring(0, 20)
                                              //         : GetApi.getProfileModel
                                              //             .data!.biography!)
                                              //     : '';
                                              setState(() {});
                                            },
                                            child: Row(
                                              children: [
                                                // SizedBox(
                                                //   width: MediaQuery.of(context)
                                                //           .size
                                                //           .width /
                                                //       2,
                                                //   child: MyString.medMultiLine(
                                                //       loader
                                                //           ? 'Bio'
                                                //           : GetApi
                                                //               .getProfileModel
                                                //               .data!
                                                //               .biography
                                                //               .toString(),
                                                //       12,
                                                //       MyColor.textBlack0,
                                                //       TextAlign.start,
                                                //       2),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyString.bold("statistics".tr, 27,
                                      Color(0xff1F3143), TextAlign.start),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutesName.statistics);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: MyColor.orange2),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Row(
                                        children: [
                                          MyString.med("viewAll".tr, 11,
                                              MyColor.white, TextAlign.start),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName.statistics);
                              },
                              child: Center(
                                child: Container(
                                  width: 317,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: Color(0xffFFEDED)),
                                      color: Colors.white),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // MyString.bold(
                                        //     (sharedPref
                                        //                 .getString(SharedKey
                                        //                     .languageValue)
                                        //                 .toString() ==
                                        //             'en')
                                        //         ? GetApi.getProfileModel.data!
                                        //             .userLevel!.name
                                        //             .toString()
                                        //         : GetApi.getProfileModel.data!
                                        //             .userLevel!.nameFr
                                        //             .toString(),
                                        //     15,
                                        //     Color(0xff800000),
                                        //     TextAlign.start),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            // MyString.med(
                                            //     GetApi.getProfileModel.data!
                                            //         .userLevel!.minPoints
                                            //         .toString(),
                                            //     12,
                                            //     MyColor.textBlack0,
                                            //     TextAlign.start),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            // Container(
                                            //     width: MediaQuery.of(context)
                                            //             .size
                                            //             .width *
                                            //         0.50,
                                            //     height: 11,
                                            //     padding: EdgeInsets.zero,
                                            //     child: SliderTheme(
                                            //       child: Slider(
                                            //         value: double.parse(GetApi
                                            //             .getProfileModel
                                            //             .data!
                                            //             .gamePoints
                                            //             .toString()),
                                            //         max: double.parse(GetApi
                                            //             .getProfileModel
                                            //             .data!
                                            //             .userLevel!
                                            //             .maxPoints
                                            //             .toString()),
                                            //         min: double.parse(GetApi
                                            //             .getProfileModel
                                            //             .data!
                                            //             .userLevel!
                                            //             .minPoints
                                            //             .toString()),
                                            //         activeColor:
                                            //             Color(0xffED8631),
                                            //         inactiveColor: MyColor.grey,
                                            //         onChanged:
                                            //             (double value) {},
                                            //       ),
                                            //       data: SliderTheme.of(context)
                                            //           .copyWith(
                                            //               trackHeight: 11,
                                            //               thumbColor: Colors
                                            //                   .transparent,
                                            //               thumbShape:
                                            //                   SliderComponentShape
                                            //                       .noThumb,
                                            //               trackShape:
                                            //                   CustomTrackShape()),
                                            //     )),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            // MyString.med(
                                            //     GetApi.getProfileModel.data!
                                            //         .userLevel!.maxPoints
                                            //         .toString(),
                                            //     12,
                                            //     MyColor.textBlack0,
                                            //     TextAlign.start),
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            )
                          ],
                        ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFFF9F5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                      ),
                      child: ListView.builder(
                          itemCount: dataList.length,
                          padding: EdgeInsets.only(top: 20, bottom: 30),
                          itemBuilder: (context, index) {
                            return
                                // (dataList[index].count == 99)
                                // ? Container(
                                //     width: MediaQuery.of(context).size.width,
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 30, vertical: 10),
                                //     child: MyString.med(
                                //         '${dataList[index].name.toString()}: ${GetApi.getProfileModel.data!.deletePasscode}',
                                //         15,
                                //         MyColor.textBlack3,
                                //         TextAlign.center),
                                //   )
                                // :

                                Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (dataList[index].count == 0) {
                                      /* Map<String, dynamic> mapData = {
                                        'userID': sharedPref
                                            .getString(SharedKey.userId)
                                            .toString()
                                      };
                                      await Navigator.pushNamed(
                                          context, RoutesName.myProfile,
                                          arguments: mapData);
                                      await GetApi.getProfileApi(
                                          context,
                                          sharedPref
                                              .getString(SharedKey.userId)
                                              .toString());

                                      double maxPoints = double.parse(GetApi.getProfileModel.data!.userLevel!.maxPoints.toString());
                                      double currentPoints = double.parse(GetApi.getProfileModel.data!.gamePoints.toString());

                                      needPoints = maxPoints - currentPoints;

                                      bio.text = GetApi.getProfileModel.data!.biography != null
                                          ? (GetApi.getProfileModel.data!.biography!.length > 20
                                          ? GetApi.getProfileModel.data!.biography!.substring(0, 20)
                                          : GetApi.getProfileModel.data!.biography!)
                                          : '';
                                      setState(() {

                                      });*/
                                      Navigator.pushNamed(
                                          context, RoutesName.statistics);
                                    } else if (dataList[index].count == 1) {
                                      await Navigator.pushNamed(
                                          context, RoutesName.editProfile);
                                      await GetApi.getProfileApi(
                                          context,
                                          sharedPref
                                              .getString(SharedKey.userId)
                                              .toString());

                                      // double maxPoints = double.parse(GetApi
                                      //     .getProfileModel
                                      //     .data!
                                      //     .userLevel!
                                      //     .maxPoints
                                      //     .toString());
                                      // double currentPoints = double.parse(GetApi
                                      //     .getProfileModel.data!.gamePoints
                                      //     .toString());

                                      // needPoints = maxPoints - currentPoints;

                                      // bio.text = GetApi.getProfileModel.data!
                                      //             .biography !=
                                      //         null
                                      //     ? (GetApi.getProfileModel.data!
                                      //                 .biography!.length >
                                      //             20
                                      //         ? GetApi.getProfileModel.data!
                                      //             .biography!
                                      //             .substring(0, 20)
                                      //         : GetApi.getProfileModel.data!
                                      //             .biography!)
                                      //     : '';
                                      setState(() {});
                                    } else if (dataList[index].count == 2) {
                                      Navigator.pushNamed(
                                          context, RoutesName.changePassword);
                                    } else if (dataList[index].count == 3) {
                                      /* if (!await launchUrl(Uri.parse(
                                                ApiStrings.privacy
                                                    .toString()))) {
                                              throw Exception(
                                                  'Could not launch ${Uri.parse(ApiStrings.privacy.toString())}');
                                            }*/
                                      Navigator.pushNamed(
                                          context, RoutesName.privacy);
                                    } else if (dataList[index].count == 4) {
                                      /* if (!await launchUrl(Uri.parse(
                                                ApiStrings.terms.toString()))) {
                                              throw Exception(
                                                  'Could not launch ${Uri.parse(ApiStrings.terms.toString())}');
                                            }*/
                                      Navigator.pushNamed(
                                          context, RoutesName.terms);
                                    } else if (dataList[index].count == 5) {
                                      Navigator.pushNamed(
                                          context, RoutesName.faqs);
                                    } else if (dataList[index].count == 6) {
                                      Navigator.pushNamed(
                                          context, RoutesName.contactUs);
                                    } else if (dataList[index].count == 7) {
                                      await changeLanguage(context);
                                    } else if (dataList[index].count == 8) {
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) {
                                          return deactivateAccount();
                                        },
                                      );
                                    } else if (dataList[index].count == 9) {
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) {
                                          return deleteAccount();
                                        },
                                      );
                                    } else if (dataList[index].count == 10) {
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) {
                                          return logout();
                                        },
                                      );
                                    } else if (dataList[index].count == 11) {
                                      Navigator.pushNamed(
                                          context, RoutesName.myAnimal,
                                          arguments: 1);
                                    } else if (dataList[index].count == 12) {
                                      Navigator.pushNamed(
                                          context, RoutesName.badges);
                                    } else if (dataList[index].count == 100) {
                                      inviteCode(context);
                                    }
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(7),
                                                  height: 35.0,
                                                  width: 35.0,
                                                  // fixed width and height
                                                  decoration: BoxDecoration(
                                                      color: MyColor.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Image.asset(
                                                    dataList[index]
                                                        .image
                                                        .toString(),
                                                    color: MyColor.orange2,
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              MyString.med(
                                                  dataList[index]
                                                      .name
                                                      .toString(),
                                                  13,
                                                  Color(0xff4F2020),
                                                  TextAlign.start)
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/icons/back_icon.png',
                                          width: 25,
                                          height: 25,
                                          color: MyColor.orange2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color:
                                      Color(0xffFFEDED), // Color of the divider
                                  thickness: 1, // Thickness of the line
                                  indent: 16, // Start padding
                                  endIndent: 16, // End padding
                                ),
                                // Divider(color: MyColor.divideLine)
                              ],
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  inviteCode(BuildContext context) async {
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
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: MyColor.grey,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Image.asset(
                              'assets/images/onboard/invite_bg.png',
                              width: 200,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(
                                    'assets/images/icons/back_icon.png',
                                    color: MyColor.black,
                                    height: 30,
                                    width: 30,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // MyString.bold(
                                    //     (sharedPref
                                    //                 .getString(
                                    //                     SharedKey.languageValue)
                                    //                 .toString() ==
                                    //             'en')
                                    //         ? GetApi.getProfileModel.metadata!
                                    //             .referralText![0].name
                                    //             .toString()
                                    //         : GetApi.getProfileModel.metadata!
                                    //             .referralText![0].nameFr
                                    //             .toString(),
                                    //     15,
                                    //     MyColor.black,
                                    //     TextAlign.start),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // MyString.med(
                                    //     (sharedPref
                                    //                 .getString(
                                    //                     SharedKey.languageValue)
                                    //                 .toString() ==
                                    //             'en')
                                    //         ? GetApi.getProfileModel.metadata!
                                    //             .referralText![0].description
                                    //             .toString()
                                    //         : GetApi.getProfileModel.metadata!
                                    //             .referralText![0].descriptionFr
                                    //             .toString(),
                                    //     12,
                                    //     MyColor.textFieldBorder,
                                    //     TextAlign.start),
                                    SizedBox(height: 20),
                                    MyString.med(
                                        '${"copyYourCode".tr} :',
                                        12,
                                        MyColor.textFieldBorder,
                                        TextAlign.start),
                                    SizedBox(height: 10),
                                    InkWell(
                                      child: Row(
                                        children: [
                                          // MyString.med(
                                          //     ' ${GetApi.getProfileModel.data!.referralCode.toString()} ',
                                          //     12,
                                          //     MyColor.black,
                                          //     TextAlign.start),
                                          // Icon(Icons.copy,
                                          //     color: MyColor.black, size: 15),
                                        ],
                                      ),
                                      onTap: () {
                                        // Clipboard.setData(ClipboardData(
                                        //     text: GetApi.getProfileModel.data!
                                        //         .referralCode
                                        //         .toString()));
                                        toaster(context, 'copy');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.pop(context);
                                        // initDeepLinkData(GetApi
                                        //     .getProfileModel.data!.referralCode
                                        //     .toString());
                                        // generateLink(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 30, bottom: 50),
                                        decoration: BoxDecoration(
                                            color: MyColor.orange2,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 20,
                                                left: 20,
                                                top: 5,
                                                bottom: 5),
                                            child: MyString.bold(
                                                "invite".tr,
                                                14,
                                                MyColor.white,
                                                TextAlign.center)),
                                      ),
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
                ),
              ],
            );
          },
        );
      },
    );
  }

  // deepLinking..
  StreamController<String> controllerUri = StreamController<String>();
  BranchContentMetaData metadata = BranchContentMetaData();
  BranchUniversalObject? buo;
  BranchLinkProperties lp = BranchLinkProperties();
  BranchEvent? eventStandard;
  BranchEvent? eventCustom;
  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();

  generateLink(BuildContext context) async {
    debugPrint("~~~generateLink~~~~");
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
    if (response.success) {
      Share.share(response.result);

      debugPrint("deeplink result ${response.result}");
      debugPrint("deeplink success ${response.success}");
      controllerUri.sink.add('${response.result}');
    } else {
      debugPrint("deeplink success ${response.success}");
      controllerUri.sink
          .add('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

  initDeepLinkData(String code) {
    metadata = BranchContentMetaData()
      ..addCustomMetadata('referCode', code.toString())
      ..addCustomMetadata('page', 'signup')
      ..addCustomMetadata('custom_bool', true)
      ..addCustomMetadata('from', 'deepLinking')
      ..addCustomMetadata('userId', '')
      ..addCustomMetadata('feedId', '');

    buo = BranchUniversalObject(
        canonicalIdentifier: 'Avispets',
        canonicalUrl: '',
        // canonicalUrl: 'https://avispets-app.com/',
        title: 'Avispets',
        imageUrl: '',
        contentDescription:
            'Hey there! Check out this fantastic post just uploaded on the Avispets App. To view the post, simply click on the following deep link',
        contentMetadata: metadata,
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec: DateTime.now()
            .add(const Duration(days: 365))
            .millisecondsSinceEpoch);

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        campaign: 'campaign',
        tags: ['one', 'two', 'three'])
      ..addControlParam('\$uri_redirect_mode', '1')
      ..addControlParam('\$ios_nativelink', true)
      ..addControlParam('\$match_duration', 7200)
      ..addControlParam('\$always_deeplink', true)
      ..addControlParam('\$android_redirect_timeout', 750)
      ..addControlParam('referring_user_id', 'user_id');

    eventStandard = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART)
      ..transactionID = '12344555'
      ..currency = BranchCurrencyType.BRL
      ..revenue = 1.5
      ..shipping = 10.2
      ..tax = 12.3
      ..coupon = 'test_coupon'
      ..affiliation = 'test_affiliation'
      ..eventDescription = 'Event_description'
      ..searchQuery = 'item 123'
      ..adType = BranchEventAdType.BANNER
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
    eventCustom = BranchEvent.customEvent('Custom_event')
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
