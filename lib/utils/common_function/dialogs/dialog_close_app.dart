
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../my_color.dart';
import '../my_string.dart';

Widget DialogCloseApp() {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(color: MyColor.white, borderRadius: BorderRadiusDirectional.circular(40)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/icons/logout.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(height: 10),
                MyString.bold('areYouSure'.tr, 20, MyColor.black, TextAlign.center),
                MyString.med('areYouSureDesc'.tr, 12, MyColor.textFieldBorder, TextAlign.center),
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
                            decoration: BoxDecoration(color: MyColor.bgColor, borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: MyString.med('no'.tr, 20, MyColor.orange, TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          exit(0);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            decoration: BoxDecoration(color: MyColor.orange, borderRadius: const BorderRadius.all(Radius.circular(10))),
                            child: MyString.med('yes'.tr, 20, MyColor.white, TextAlign.center),
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