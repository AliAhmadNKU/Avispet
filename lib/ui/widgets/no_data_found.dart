import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/onboard/placeholder_image.png',
            width: 120,
            height: 90,
          ),
          Container(
              child: MyString.reg(
                  'noDataFound'.tr,
                  12,
                  MyColor.textBlack0,
                  TextAlign.center)),
        ],
      ),
    );
  }
}
