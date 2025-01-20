import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_color.dart';
import '../../../utils/shared_pref.dart';

class GameInfo extends StatefulWidget {
  const GameInfo({super.key});

  @override
  State<GameInfo> createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: MyColor.newBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(20, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Image.asset('assets/images/icons/back_icon.png', color: MyColor.white),
          ),
        ),
        title: MyString.bold('earnMore'.tr.toUpperCase(), 18, MyColor.white, TextAlign.center),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, MyColor.newBackgroundColorTr],
              ),
            ),
            child: Column(
              children: [
                MyString.bold("gameInfoTitle".tr, 14, MyColor.black, TextAlign.center),
                SizedBox(height: 5,),
                MyString.medMultiLine("gameInfoDec".tr, 14, MyColor.black, TextAlign.center,10),
              ],
            ),
          ),
          SizedBox(height: 10,),
          MyString.bold("earnWithPerform".tr, 18, MyColor.black, TextAlign.center),
          SizedBox(height: 10,),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColor.textFieldBorder)
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyString.med("Action".toUpperCase(), 12, MyColor.textFieldBorder, TextAlign.start),
                      MyString.med("pts".toUpperCase(), 12, MyColor.textFieldBorder, TextAlign.start),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: GetApi.gamification.mMetadata!.rulesToEarn!.length,
                        itemBuilder: (context,index){
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: MyColor.textFieldBorder)
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/1.6,
                                        child: MyString.med((sharedPref.getString(SharedKey.languageValue).toString() == 'en')
                                            ?GetApi.gamification.mMetadata!.rulesToEarn![index].name.toString():GetApi.gamification.mMetadata!.rulesToEarn![index].nameFr.toString(), 12, MyColor.textFieldBorder, TextAlign.start),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: MyString.med(GetApi.gamification.mMetadata!.rulesToEarn![index].points.toString(), 12, MyColor.textFieldBorder, TextAlign.start),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }))
              ],
            ),
          )
        ],
      ),
    );
  }
}
