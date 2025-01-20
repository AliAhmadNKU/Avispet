import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  bool loader = true;
  int page = 1;
  var searchBar = TextEditingController();

  @override
  void initState() {
    super.initState();
    GetApi.getNotify(context, '');
    page = 1;
    Future.delayed(Duration.zero, () async {
      await GetApi.getFaqs(context, page);
      setState(() {
        loader = false;
      });
    });
  }

  void _loadMoreData(int loaderPage) async {
    await GetApi.getFaqs(context, loaderPage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          page++;
          _loadMoreData(page);
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: MyColor.white,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 HeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: MyString.bold(
                        '${'faqs'.tr}', 24, MyColor.title, TextAlign.center),
                  ),
                  //!@search-bar
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffEBEBEB)),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(13),
                                    topRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(13),
                                    bottomRight: Radius.circular(50))),
                            child: TextField(
                              controller: searchBar,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style:
                                  TextStyle(color: MyColor.black, fontSize: 14),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/icons/search.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
                                suffixIcon: (searchBar.text
                                        .trim()
                                        .toString()
                                        .isNotEmpty)
                                    ? GestureDetector(
                                        onTap: () async {},
                                        child: Icon(
                                          Icons.cancel,
                                          color: MyColor.orange,
                                        ))
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Color(0xff4F2020),
                                            borderRadius:
                                                BorderRadius.circular(150)),
                                        child: Image.asset(
                                            'assets/images/icons/filter.png')),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'search'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textBlack0, fontSize: 14),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  loader
                      ? Container(
                          child: progressBar(),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: GetApi.FaqsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MyColor.stroke),
                                            color: GetApi
                                                    .FaqsList[index].isExpanded
                                                ? MyColor.orange2
                                                : MyColor.card,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: ExpansionTile(
                                          title: MyString.reg(
                                              (sharedPref
                                                          .getString(SharedKey
                                                              .languageValue)
                                                          .toString() ==
                                                      'en')
                                                  ? GetApi
                                                      .FaqsList[index].question
                                                      .toString()
                                                  : GetApi.FaqsList[index]
                                                      .questionFr
                                                      .toString(),
                                              14,
                                              GetApi.FaqsList[index].isExpanded
                                                  ? MyColor.white
                                                  : MyColor.redd,
                                              TextAlign.start),
                                          shape: const Border(),
                                          trailing:
                                              GetApi.FaqsList[index].isExpanded
                                                  ? Image.asset(
                                                      'assets/images/logos/drop_up.png',
                                                      width: 20,
                                                      height: 20,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/logos/drop_down.png',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                          onExpansionChanged: (bool expanded) {
                                            setState(() => GetApi
                                                .FaqsList[index]
                                                .isExpanded = expanded);
                                          },
                                          children: [
                                            Html(
                                              data: (sharedPref
                                                          .getString(SharedKey
                                                              .languageValue)
                                                          .toString() ==
                                                      'en')
                                                  ? GetApi
                                                      .FaqsList[index].answer
                                                      .toString()
                                                  : GetApi
                                                      .FaqsList[index].answerFr
                                                      .toString(),
                                              style: {
                                                "body": Style(
                                                    color: Colors.white,
                                                    fontSize: FontSize(12)),
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                ],
              ),
            ),
          )),
    );
  }
}
