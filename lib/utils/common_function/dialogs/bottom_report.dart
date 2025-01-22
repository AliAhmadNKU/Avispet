import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../apis/all_api.dart';
import '../../apis/api_strings.dart';
import '../../my_color.dart';
import '../../my_routes/route_name.dart';
import '../../shared_pref.dart';
import '../my_string.dart';
import '../toaster.dart';
import 'dialog_success.dart';

reportPost(BuildContext context, String feedId) async {
  var pickOption = TextEditingController();
  var review = TextEditingController();
  List<String> reportList = [
    'doNotLike'.tr,
    'spam'.tr,
    'nudity'.tr,
    'hateSpeech'.tr,
    'falseInfo'.tr
  ];
  bool optionList = false;
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      decoration: BoxDecoration(
                          color: MyColor.grey,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: MyString.bold('reportPost'.tr.toUpperCase(), 16,
                          MyColor.black, TextAlign.start)),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          MyString.reg('pickAnOption'.tr, 15, MyColor.textBlack,
                              TextAlign.start),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
                            child: TextField(
                              controller: pickOption,
                              readOnly: true,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: MyColor.textFieldBorder),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: '--select--',
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                              onTap: () {
                                optionList = !optionList;
                                myState(() {});
                              },
                            ),
                          ),
                          if (optionList)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color: MyColor.cardColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                itemCount: reportList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ListTile(
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: MyString.med(
                                          reportList[index].toString(),
                                          16,
                                          MyColor.textBlack,
                                          TextAlign.start),
                                      onTap: () {
                                        pickOption.text =
                                            reportList[index].toString();
                                        optionList = false;
                                        myState(() {});
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 15),
                          MyString.reg('writeReview'.tr, 15, MyColor.textBlack,
                              TextAlign.start),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25))),
                            child: TextField(
                              controller: review,
                              maxLines: 4,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'help'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                              onTap: () {
                                optionList = false;
                                myState(() {});
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus!.unfocus();
                              if (pickOption.text.trim().toString().isEmpty) {
                                toaster(context, StringKey.selectAnyOption);
                              } else if (review.text
                                  .trim()
                                  .toString()
                                  .isEmpty) {
                                toaster(context, StringKey.enterMessage);
                              } else {
                                Navigator.pop(context);
                                Map<String, String> mapData = {
                                  'feedId': feedId,
                                  'subject': pickOption.text.trim().toString(),
                                  'message': review.text.trim().toString(),
                                };
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) {
                                    return success('report'.tr, 0);
                                  },
                                );
                                var res = await AllApi.postMethodApi(
                                    ApiStrings.reportfeed, mapData);
                                var result = jsonDecode(res.toString());
                                debugPrint(
                                    'REPORT API CODE ${result['status'].toString()}');
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 15, bottom: 10, left: 50, right: 50),
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: MyColor.newBackgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(40))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  MyString.med('submit'.tr.toUpperCase(), 15,
                                      MyColor.white, TextAlign.center),
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Image.asset(
                                        "assets/images/onboard/intro_button_icon.png"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

deletePost(BuildContext context, String id) {
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
                MyString.bold(
                    'dialogPostTitle'.tr, 20, MyColor.black, TextAlign.center),
                MyString.med('dialogPost'.tr, 12, MyColor.textFieldBorder,
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
                            child: MyString.med(
                                'no'.tr, 20, MyColor.orange, TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          var res = await deletePostApi(context, id);
                          await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) {
                              return success('deletePost'.tr, 0);
                            },
                          );
                          Navigator.pop(context, res);
                          setState(() {});
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
                            child: MyString.med(
                                'yes'.tr, 20, MyColor.white, TextAlign.center),
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

Future<bool> deletePostApi(BuildContext context, String id) async {
  var res =
      await AllApi.deleteMethodApiQuery("${ApiStrings.deleteFeed}?id=$id");
  var result = jsonDecode(res.toString());
  if (result['status'] == 200) {
    // page = 1;
    // getAllPost(currentTab, page, '');
    return true;
  } else if (result['status'] == 401) {
    sharedPref.clear();
    sharedPref.setString(SharedKey.onboardScreen, 'OFF');
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.loginScreen, (route) => false);
    return false;
  } else {
    toaster(context, result['message'].toString());
    return false;
  }
}
