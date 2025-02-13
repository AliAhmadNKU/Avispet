import 'dart:convert';

import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/common_function/header_widget.dart';
import '../../utils/common_function/my_string.dart';

class FilterReviews extends StatefulWidget {

  int postId;
   FilterReviews({super.key,required this.postId});

  @override
  State<FilterReviews> createState() => _FilterReviewsState();
}

class _FilterReviewsState extends State<FilterReviews> {
  bool loader = true;
  bool isExp = false;
  int page = 1;
  var searchBar = TextEditingController();
  List<RefiningItem> refiningList = [
    RefiningItem(title: 'Most Recent Review', conditionCheck: false,value: "recent"),
    RefiningItem(title: 'Older Review', conditionCheck: false,value: "oldest"),
    RefiningItem(title: 'Ascending Note', conditionCheck: false,value:"asc"),
    RefiningItem(title: 'Decreasing Note', conditionCheck: false,value:"desc"),
  ];

   RefiningItem  refItem = RefiningItem(title: '', conditionCheck: false,value: "");
  List<bool> isActive = [false, false, false, false,false];

  @override
  void initState() {
    super.initState();
    // GetApi.getNotify(context, '');
    // page = 1;
  }


  filterReview(int postId,int rating,String sort) async {
    try {
      var res = await AllApi.getMethodApi("${ApiStrings.filterReview}?postId=$postId&rating=$rating&sortBy=$sort");
      var result = jsonDecode(res.toString());

       print("Filter result ${result}");
      if (result['status'] == 200) {



      } else if (result['status'] == 401) {


      } else {
        toaster(context, result['message'].toString());
      }
    } catch (e) {
      debugPrint("Error: $e");
      toaster(context, "An error occurred while fetching post.");
    }
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
                            onTap: () {
                              setState(() {
                                refItem = RefiningItem(title: "", value: "");
                                refiningList.forEach((element) {
                                  element.selectedColor=false;
                                });
                                isActive.fillRange(0, isActive.length, false);
                              });



                            },
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
                                onTap: () async {
                                      setState(() {
                                        refItem = item;
                                        refiningList.forEach((element) {
                                          element.selectedColor=false;
                                        });
                                        refiningList[index].selectedColor=true;
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 130,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: refiningList[index].selectedColor==true?MyColor.orange: MyColor.white,
                                      border: Border.all(color: refiningList[index].selectedColor==true?MyColor.white:MyColor.orange),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: MyString.bold('${item.title}', 12,
                                        refiningList[index].selectedColor==true?MyColor.white:MyColor.redd,
                                        TextAlign.center),
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
                            onTap: () {
                              setState(() {
                                isActive.fillRange(0, isActive.length, false);
                                isActive[0] = true;
                              });

                              refItem.ratingValue = 5;
                            },
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color:  isActive[0]== true? MyColor.orange: MyColor.card,
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
                                    MyString.bold('5 Stars', 12,isActive[0]== true?MyColor.white: MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isActive.fillRange(0, isActive.length, false);
                                isActive[1] = true;
                              });

                              refItem.ratingValue = 4;
                            },
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: isActive[1]== true? MyColor.orange: MyColor.card,
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
                                    MyString.bold('4 Stars', 12, isActive[1]== true?MyColor.white: MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isActive.fillRange(0, isActive.length, false);
                                isActive[2] = true;
                              });

                              refItem.ratingValue = 3;

                            },
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: isActive[2]== true? MyColor.orange: MyColor.card,
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
                                    MyString.bold('3 Stars', 12, isActive[2]== true?MyColor.white: MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isActive.fillRange(0, isActive.length, false);
                                isActive[3] = true;
                              });

                              refItem.ratingValue = 2;
                            },
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: isActive[3]== true? MyColor.orange: MyColor.card,
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
                                    MyString.bold('2 Stars', 12, isActive[3]== true?MyColor.white: MyColor.redd,
                                        TextAlign.start)
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isActive.fillRange(0, isActive.length, false);
                                isActive[4] = true;
                              });

                              refItem.ratingValue = 1;
                            },
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: isActive[4]== true? MyColor.orange: MyColor.card,
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
                                    MyString.bold('1 Star', 12, isActive[4]== true?MyColor.white: MyColor.redd,
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
                          if (isActive.indexWhere((element) => element == true) == -1) {
                            toaster(context, "Please select a Rating");
                          }
                          if (refItem.selectedColor== false) {
                            toaster(context, "Please selected the Sort");
                          }

                          if( isActive.indexWhere((element) => element == true) != -1 && refItem.selectedColor== true)
                            {
                              filterReview( widget.postId, refItem.ratingValue??1 ,refItem.value);

                            }

                        //  Navigator.pop(context);
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

class RefiningItem {
  String title;
  bool conditionCheck;
  String value;
  int? ratingValue;
  bool? selectedColor;

  RefiningItem({
    required this.title,
    this.ratingValue,
    required this.value,
    this. selectedColor = false,
    this.conditionCheck = false,
  });

}
