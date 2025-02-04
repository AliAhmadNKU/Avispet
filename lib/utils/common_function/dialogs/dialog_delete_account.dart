import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
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

Widget deleteAccount() {
  CommonModel _commonModel = CommonModel();
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
                  'assets/images/icons/deactivate.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 10),
                MyString.bold(
                    'deleteAccount'.tr, 20, MyColor.black, TextAlign.center),
                MyString.med('deleteAccountDesc'.tr, 12,
                    MyColor.textFieldBorder, TextAlign.center),
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
                        onTap: () {
                          LoadingDialog.show(context);
                          Future.delayed(Duration.zero, () async {
                             String id= "/${sharedPref.getString(SharedKey.userId)}";
                             String deleteAccount = "";
                             deleteAccount = ApiStrings.deleteAccount+id;

                            var res = await AllApi.delete(deleteAccount);
                            var result = jsonDecode(res.toString());



                            if (result['status'] == 200) {
                              _commonModel = CommonModel.fromJson(result);
                              sharedPref.clear();
                              referralCode = '';
                              sharedPref.setString(
                                  SharedKey.onboardScreen, 'OFF');
                              toaster(context, _commonModel.message.toString());
                              LoadingDialog.hide(context);
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RoutesName.loginScreen, (route) => false);
                            } else {
                              LoadingDialog.hide(context);
                              toaster(context, _commonModel.message.toString());
                            }
                          });
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
