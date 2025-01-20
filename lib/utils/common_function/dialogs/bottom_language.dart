

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../my_color.dart';
import '../../shared_pref.dart';
import '../my_string.dart';

changeLanguage(BuildContext context) async {
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: MyColor.orange, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                  child: MyString.bold('chooseYourLanguage'.tr.toUpperCase(), 20, MyColor.white, TextAlign.center)),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 50,
                        decoration: BoxDecoration(
                            color: sharedPref.getString(SharedKey.languageCount).toString() == '0' ||
                                sharedPref.getString(SharedKey.languageCount) == null
                                ? MyColor.yellowLite
                                : null,
                            border: Border.all(
                              color: sharedPref.getString(SharedKey.languageCount).toString() == '0' ||
                                  sharedPref.getString(SharedKey.languageCount) == null
                                  ? MyColor.yellowLite
                                  : MyColor.textFieldBorder,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: TextField(
                          readOnly: true,
                          scrollPadding: const EdgeInsets.only(bottom: 50),
                          style: TextStyle(color: MyColor.black),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                    child: Image.asset(
                                      'assets/images/logos/uk_flag.png',
                                      width: 20,
                                      height: 20,
                                    ))),
                            suffixIcon: Icon(
                                sharedPref.getString(SharedKey.languageCount).toString() == '0' ||
                                    sharedPref.getString(SharedKey.languageCount) == null
                                    ? Icons.radio_button_on
                                    : Icons.radio_button_off,
                                color: sharedPref.getString(SharedKey.languageCount).toString() == '0' ||
                                    sharedPref.getString(SharedKey.languageCount) == null
                                    ? MyColor.orange
                                    : MyColor.textFieldBorder),
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            hintText: 'English',
                            hintStyle: TextStyle(color: MyColor.textFieldBorder1, fontSize: 16),
                          ),
                          onTap: () {
                            Get.updateLocale(const Locale('en', 'en'));
                            sharedPref.setString(SharedKey.languageKey, 'en');
                            sharedPref.setString(SharedKey.languageValue, 'en');
                            sharedPref.setString(SharedKey.languageCount, '0');
                            Navigator.pop(context);
                            myState(() {});
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 8),
                        height: 50,
                        decoration: BoxDecoration(
                            color: sharedPref.getString(SharedKey.languageCount).toString() == '1' ? MyColor.yellowLite : null,
                            border: Border.all(
                              color: sharedPref.getString(SharedKey.languageCount).toString() == '1' ? MyColor.yellowLite : MyColor.textFieldBorder,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: TextField(
                          readOnly: true,
                          scrollPadding: const EdgeInsets.only(bottom: 50),
                          style: TextStyle(color: MyColor.black),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                    child: Image.asset(
                                      'assets/images/logos/france_flag.png',
                                      width: 20,
                                      height: 20,
                                    ))),
                            suffixIcon: Icon(
                                sharedPref.getString(SharedKey.languageCount).toString() == '1' ? Icons.radio_button_on : Icons.radio_button_off,
                                color: sharedPref.getString(SharedKey.languageCount).toString() == '1' ? MyColor.orange : MyColor.textFieldBorder),
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            hintText: 'French',
                            hintStyle: TextStyle(color: MyColor.textFieldBorder1, fontSize: 16),
                          ),
                          onTap: () {
                            Get.updateLocale(const Locale('fr', 'fr'));
                            sharedPref.setString(SharedKey.languageKey, 'fr');
                            sharedPref.setString(SharedKey.languageValue, 'fr');
                            sharedPref.setString(SharedKey.languageCount, '1');
                            Navigator.pop(context);
                            myState(() {});
                          },
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