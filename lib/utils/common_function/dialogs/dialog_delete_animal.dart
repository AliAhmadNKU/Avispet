import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../apis/all_api.dart';
import '../../apis/api_strings.dart';
import '../../my_color.dart';
import '../loader_screen.dart';
import '../my_string.dart';
import '../toaster.dart';

deleteAnimalDialog(String animalId) {
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
                    'deleteAnimal'.tr, 20, MyColor.black, TextAlign.center),
                MyString.med('dialogAnimalDesc'.tr, 12, MyColor.textFieldBorder,
                    TextAlign.center),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
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
                          LoadingDialog.show(context);
                          await deleteAnimal(context, animalId);
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

deleteAnimal(BuildContext context, String animalId) async {
  var res =
      await AllApi.deleteMethodApiQuery("${ApiStrings.deleteAnimal}/$animalId");
  var result = jsonDecode(res.toString());
  LoadingDialog.hide(context);
  if (result['status'] == 200) {
    toaster(context, result['message'].toString());
    Navigator.pop(context, true);
  } else if (result['status'] == 401) {
  } else {
    toaster(context, result['message'].toString());
  }
}
