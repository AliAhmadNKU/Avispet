import 'package:avispets/ui/main_screen/profile/profile_screen.dart';
import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class Badges extends StatefulWidget {
  const Badges({super.key});

  @override
  State<Badges> createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    GetApi.getNotify(context, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: (isLoading)
            ? Center(
                child: CircularProgressIndicator(
                  color: MyColor.orange2,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: MyString.bold(
                        "allBadges".tr, 27, Color(0xff1F3143), TextAlign.start),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyString.reg(
                        "${"totalBadges".tr} ${GetApi.gamification.totalBadgesEarn} ${'badge'.tr.toLowerCase()}${(GetApi.gamification.totalBadgesEarn > 1) ? "s" : ""}${'badges'.tr.toLowerCase()}",
                        12,
                        Color(0xff5B6170),
                        TextAlign.center),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: GetApi.getProfileModel.data!.profilePicture != null
                                    ? Image.network('${ApiStrings.mediaURl}${GetApi.getProfileModel.data!.profilePicture.toString()}',
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                                            ? child
                                            : Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        50),
                                                    color: MyColor.cardColor),
                                                width: 75,
                                                height: 75,
                                                child: Center(
                                                    child: Image.asset('assets/images/onboard/placeholder_image.png',
                                                        width: 60,
                                                        height: 60))))
                                    : Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: MyColor.cardColor),
                                        width: 75,
                                        height: 75,
                                        child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 60, height: 60))),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyString.boldMultiLine(
                                            '${GetApi.getProfileModel.data!.name.toString()}',
                                            14,
                                            MyColor.title,
                                            TextAlign.start,
                                            1),
                                        // MyString.reg(
                                        // (sharedPref
                                        //     .getString(SharedKey
                                        //     .languageValue)
                                        //     .toString() ==
                                        //     'en')
                                        //     ? GetApi.getProfileModel.data!
                                        //     .userLevel!.name
                                        //     .toString()
                                        //     : GetApi.getProfileModel.data!
                                        //     .userLevel!.nameFr
                                        //     .toString(),
                                        // 12,
                                        // MyColor.textBlack0,
                                        // TextAlign.start),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        isLoading = true;
                      });
                      getData();
                    },
                    child: ListView.builder(
                        itemCount: GetApi.gamification.data!.length,
                        itemBuilder: (context, index) {
                          int remaining = int.parse(GetApi
                                  .gamification.data![index].totalPoint
                                  .toString()) -
                              int.parse(GetApi
                                  .gamification.data![index].currentPoint
                                  .toString());
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xffFFF9F5),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 10,
                                          right: 25,
                                          left: 25,
                                          top: 10),
                                      child: Row(
                                        children: [
                                          (GetApi.gamification.data![index].icon == null)
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          50),
                                                      color: MyColor.cardColor),
                                                  width: 40,
                                                  height: 40,
                                                  child: Center(
                                                      child: Image.asset(
                                                          'assets/images/onboard/placeholder_image.png',
                                                          width: 40,
                                                          height: 40)))
                                              : Image.network(ApiStrings.mediaURl + GetApi.gamification.data![index].icon.toString(),
                                                  height: 40,
                                                  loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) =>
                                                      (loadingProgress == null)
                                                          ? child
                                                          : Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(50),
                                                                  color: MyColor.cardColor),
                                                              width: 75,
                                                              height: 75,
                                                              child: Center(child: Image.asset('assets/images/onboard/placeholder_image.png', width: 40, height: 40)))),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        MyString.boldMultiLine(
                                                            (sharedPref
                                                                        .getString(SharedKey
                                                                            .languageValue)
                                                                        .toString() ==
                                                                    'en')
                                                                ? GetApi
                                                                    .gamification
                                                                    .data![
                                                                        index]
                                                                    .name
                                                                    .toString()
                                                                : GetApi
                                                                    .gamification
                                                                    .data![
                                                                        index]
                                                                    .nameFr
                                                                    .toString(),
                                                            14,
                                                            Color(0xff4F2020),
                                                            TextAlign.start,
                                                            1),
                                                        MyString.medMultiLine(
                                                            (sharedPref
                                                                        .getString(SharedKey
                                                                            .languageValue)
                                                                        .toString() ==
                                                                    'en')
                                                                ? GetApi
                                                                    .gamification
                                                                    .data![
                                                                        index]
                                                                    .mission
                                                                    .toString()
                                                                : GetApi
                                                                    .gamification
                                                                    .data![
                                                                        index]
                                                                    .missionFr
                                                                    .toString(),
                                                            8,
                                                            Color(0xff5B6170),
                                                            TextAlign.start,
                                                            2),
                                                        if (GetApi
                                                                    .gamification
                                                                    .data![
                                                                        index]
                                                                    .showProgressBar ==
                                                                1 &&
                                                            GetApi
                                                                    .gamification
                                                                    .data![
                                                                        index]
                                                                    .isEarned ==
                                                                0)
                                                          Row()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if (GetApi
                                                        .gamification
                                                        .data![index]
                                                        .isEarned ==
                                                    1)
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                    child: Image.asset(
                                                      "assets/images/icons/badge_check.png",
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (GetApi.gamification.data![index]
                                            .isEarned ==
                                        1)
                                      Container(
                                        height: 75,
                                        width: double.infinity,
                                        color:
                                            MyColor.liteGrey.withOpacity(0.4),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ))
                ],
              ),
      ),
    );
  }

  Future<void> getData() async {
    await GetApi.getGamificationApi(
        context, sharedPref.getString(SharedKey.userId).toString());
    setState(() {
      isLoading = false;
    });
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = MyColor.textFieldBorder
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
