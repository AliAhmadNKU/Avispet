import 'dart:convert';

import 'package:avispets/utils/apis/connect_socket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//pankaj
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../models/aa_common_model.dart';
import '../../../ui/main_screen/main_page.dart';
import '../../apis/all_api.dart';
import '../../apis/api_strings.dart';
import '../../my_color.dart';
import '../../my_routes/route_name.dart';
import '../../shared_pref.dart';
import '../loader_screen.dart';
import '../my_string.dart';
import '../toaster.dart';

Widget logout() {
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
              borderRadius: BorderRadiusDirectional.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icons/logout1.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 10),
                MyString.bold('logout'.tr, 20, MyColor.black, TextAlign.center),
                MyString.med('logoutDesc'.tr, 12, MyColor.textFieldBorder,
                    TextAlign.center),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            Navigator.pop(context);
                          });
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
                          // _oldFlow(context);
                          LoadingDialog.show(context);
                          disconnectSocket();
                          // try{
                          //   await FirebaseMessaging.instance.deleteToken();
                          // }
                          // catch(e){
                          //
                          // }
                          if (sharedPref
                              .getString(ApiStrings.socialLogin)
                              .toString() ==
                              "1") {
                            debugPrint(
                                'LANGUAGE KEYS IS  ${sharedPref.getString(ApiStrings.socialLogin).toString()}');
                            GoogleSignIn googleSignIn = GoogleSignIn();
                            await googleSignIn.signOut();
                            await FirebaseAuth.instance.signOut();
                          }

                          if (sharedPref
                              .getString(ApiStrings.socialLogin)
                              .toString() ==
                              "2") {
                            debugPrint(
                                'LANGUAGE KEYS IS  ${sharedPref.getString(ApiStrings.socialLogin).toString()}');
                            //pankaj
                            final FirebaseAuth _auth =
                                FirebaseAuth.instance;
                            // FacebookAuth.instance.logOut();
                            await _auth.signOut();
                          }

                          sharedPref.clear();
                          sharedPref.setString(
                              SharedKey.onboardScreen, 'OFF');
                          referralCode = '';
                          LoadingDialog.hide(context);
                          Navigator.pushNamedAndRemoveUntil(context,
                              RoutesName.loginScreen, (route) => false);
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

void _oldFlow(BuildContext context) {
  CommonModel? _commonModel;
  LoadingDialog.show(context);
  Future.delayed(Duration.zero, () async {
    var res = await AllApi.logout(ApiStrings.logout);
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      disconnectSocket();
      _commonModel = CommonModel.fromJson(result);
      await FirebaseMessaging.instance.deleteToken();
      if (sharedPref
          .getString(ApiStrings.socialLogin)
          .toString() ==
          "1") {
        debugPrint(
            'LANGUAGE KEYS IS  ${sharedPref.getString(ApiStrings.socialLogin).toString()}');
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      }

      if (sharedPref
          .getString(ApiStrings.socialLogin)
          .toString() ==
          "2") {
        debugPrint(
            'LANGUAGE KEYS IS  ${sharedPref.getString(ApiStrings.socialLogin).toString()}');
        //pankaj
        final FirebaseAuth _auth =
            FirebaseAuth.instance;
        // FacebookAuth.instance.logOut();
        await _auth.signOut();
      }

      sharedPref.clear();
      sharedPref.setString(
          SharedKey.onboardScreen, 'OFF');
      toaster(context, _commonModel!.message.toString());
      referralCode = '';
      LoadingDialog.hide(context);
      Navigator.pushNamedAndRemoveUntil(context,
          RoutesName.loginScreen, (route) => false);
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(
          SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(context,
          RoutesName.loginScreen, (route) => false);
    } else {
      LoadingDialog.hide(context);
      toaster(context, _commonModel!.message.toString());
    }
  });
}
