import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/common_function/header_widget.dart';
import '../../utils/common_function/my_string.dart';

class FilterReviews extends StatefulWidget {
  const FilterReviews({super.key});

  @override
  State<FilterReviews> createState() => _FilterReviewsState();
}

class _FilterReviewsState extends State<FilterReviews> {
  bool loader = true;
  bool isExp = false;
  int page = 1;
  var searchBar = TextEditingController();
  List<refiningItem> refiningList = [
    refiningItem(title: 'Most Recent Review', conditionCheck: false),
    refiningItem(title: 'Older Review', conditionCheck: false),
    refiningItem(title: 'Ascending Note', conditionCheck: false),
    refiningItem(title: 'Decreasing Note', conditionCheck: false),
  ];
  @override
  void initState() {
    super.initState();
    GetApi.getNotify(context, '');
    page = 1;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          page++;
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: MyColor.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HeaderWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyString.bold('${'Refine'.tr}', 18, MyColor.title,
                              TextAlign.center),
                          GestureDetector(
                            onTap: () {},
                            child: MyString.reg('${'Reset Filters'.tr}', 12,
                                MyColor.orange2, TextAlign.center),
                          )
                        ],
                      ),
                    ),
                    MyString.med('Sort By', 14, MyColor.redd, TextAlign.start),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 120,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing:
                              4, // Horizontal spacing between items
                          mainAxisSpacing: 1, // Vertical spacing between items
                          childAspectRatio:
                              3, // Aspect ratio for each grid item
                        ),
                        itemCount: refiningList.length,
                        itemBuilder: (context, index) {
                          var item = refiningList[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 130,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: MyColor.card,
                                      border:
                                          Border.all(color: MyColor.orange2),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: MyString.bold('${item.title}', 12,
                                        MyColor.redd, TextAlign.center),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: Color(0xffEBEBEB), // Color of the divider
                      thickness: 1, // Thickness of the line
                      indent: 16, // Start padding
                      endIndent: 16, // End padding
                    ),
                    MyString.med('Note', 14, MyColor.redd, TextAlign.start),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: ExpansionTile(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        collapsedBackgroundColor: Colors.transparent,
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: MyString.bold(
                            '5 stars / 4 stars / 3 stars / 2 stars / 1 star',
                            12,
                            MyColor.textBlack0,
                            TextAlign.start),
                        trailing: Image.asset(
                          isExp
                              ? 'assets/images/icons/minus.png'
                              : 'assets/images/icons/addpic.png',
                          width: 20,
                          height: 20,
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            isExp = expanded;
                          });
                        },
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: MyColor.card,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: MyColor.orange2)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png')
                                      ],
                                    ),
                                    MyString.bold('5 Stars', 12, MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: MyColor.card,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: MyColor.orange2)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                      ],
                                    ),
                                    MyString.bold('4 Stars', 12, MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: MyColor.card,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: MyColor.orange2)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                      ],
                                    ),
                                    MyString.bold('3 Stars', 12, MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: MyColor.card,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: MyColor.orange2)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                      ],
                                    ),
                                    MyString.bold('2 Stars', 12, MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: MyColor.card,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: MyColor.orange2)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/icons/star.png'),
                                      ],
                                    ),
                                    MyString.bold('1 Star', 12, MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Color(0xffEBEBEB), // Color of the divider
                      thickness: 1, // Thickness of the line
                      indent: 16, // Start padding
                      endIndent: 16, // End padding
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          height: 59,
                          width: 200,
                          decoration: BoxDecoration(
                              color: MyColor.orange2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(22))),
                          child: MyString.med(
                              'Apply'.tr, 18, MyColor.white, TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class refiningItem {
  String title;
  bool conditionCheck;

  refiningItem({
    required this.title,
    this.conditionCheck = false,
  });
}
