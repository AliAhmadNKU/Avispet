import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../my_color.dart';
import '../my_string.dart';

Widget success(String values, int type) {
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
              borderRadius: BorderRadiusDirectional.circular(15),
              border: Border.all(color: MyColor.orange2)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                //normal
                if (type == 0)
                  SizedBox(
                      width: 70,
                      height: 70,
                      child: Lottie.asset('assets/images/animations/qw.json')),
                //create an animal
                if (type == 1)
                  SizedBox(
                      width: 70,
                      height: 70,
                      child: Lottie.asset(
                          'assets/images/animations/success1.json')),

                const SizedBox(height: 10),
                MyString.bold(
                    'success'.tr, 20, MyColor.redd, TextAlign.center),
                MyString.med(
                    values, 12, MyColor.textBlack0, TextAlign.center),
                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      alignment: Alignment.center,
                      height: 59,
                      width: 141,
                      decoration: BoxDecoration(
                        color: MyColor.orange2,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: MyString.med(
                          'done'.tr, 18, MyColor.white, TextAlign.center),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    ),
  );
}
