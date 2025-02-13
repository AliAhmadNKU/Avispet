import 'package:avispets/ui/main_screen/home/filter_screen.dart';
import 'package:avispets/ui/main_screen/home/post_detail.dart';
import 'package:avispets/ui/main_screen/profile/profile_screen.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/reviews/get_post_reviews_by_postid_model.dart';
import '../../../utils/base_date_utils.dart';
import '../filter_reviews.dart';

class AddReview extends StatefulWidget {
  List<Reviews> mReviews = [];
  int postID;
   AddReview({super.key,required this.mReviews,required this.postID});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool showReviewsList = false;
  var searchBar = TextEditingController();
  List<String> items = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];

  List<bool> itemBool = List.generate(5, (index) => false);

  List<String> items1 = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  List<bool> item1Bool = List.generate(5, (index) => false);

  List<String> items2 = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                ),
                child: HeaderWidget(),
              ),
              MyString.bold('Review', 20,
                  MyColor.title, TextAlign.start),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffEBEBEB)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13))),
                child: TextField(
                  controller: searchBar,
                  scrollPadding: const EdgeInsets.only(bottom: 50),
                  style: TextStyle(color: MyColor.black, fontSize: 14),
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    hintText: 'search'.tr,
                    hintStyle:
                        TextStyle(color: MyColor.textBlack0, fontSize: 14),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: MyString.reg(
                    'Recommended reviews', 16, MyColor.redd, TextAlign.start),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            MyString.bold(
                                '5', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 5,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '4', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 4,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '3', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 3,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '2', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 2,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '1', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 1,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyString.reg('4.5', 20, MyColor.textBlack,
                                      TextAlign.start),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 26),
                                ],
                              ),
                              MyString.reg('563 Reviews', 10,
                                  MyColor.textBlack0, TextAlign.start),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyString.reg('88%', 20, MyColor.textBlack,
                                      TextAlign.start),
                                ],
                              ),
                              MyString.reg('Recommended', 10,
                                  MyColor.textBlack0, TextAlign.start),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Color(0xffEBEBEB), // Color of the divider
                thickness: 1, // Thickness of the line
                indent: 16, // Start padding
                endIndent: 16, // End padding
              ),


              // showReviewsList
              //     ?

              Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FilterReviews(postId: widget.postID,)),
                            );

                            Navigator.pushNamed(
                                context, RoutesName.filterReviews);
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColor.card,
                                border: Border.all(color: MyColor.orange2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyString.bold('Filter reviews ', 14,
                                      MyColor.redd, TextAlign.center),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/filtres.png',
                                    width: 25,
                                    height: 25,
                                  )
                                ],
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 220,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: widget.mReviews.length,
                            itemBuilder: (context, index) {
                              var rev =  widget.mReviews[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: GestureDetector(
                                  onTap: () async {
                                    // Handle tap here
                                  },
                                  child: Container(
                                    margin:
                                    EdgeInsets.only(right: 20),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    width: 280,
                                    decoration: BoxDecoration(
                                      color: MyColor.card,
                                      border: Border.all(
                                          color: MyColor.stroke),
                                      borderRadius: BorderRadius.circular(
                                          8), // Optional: adds rounded corners
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        // Review header text
                                        MyString.reg(
                                          'Review filed on ${BaseDateUtils.formatToMMddyyyy(rev.createdAt!)}',
                                          12,
                                          MyColor.textBlack0,
                                          TextAlign.start,
                                        ),
                                        SizedBox(
                                            height:
                                            10), // Spacing between elements
                                        // Stars
                                        Row(
                                          children: List.generate(
                                            rev.overallRating!
                                                .toInt(),
                                                (index) => Padding(
                                              padding: const EdgeInsets
                                                  .only(
                                                  right:
                                                  4.0), // Space between stars
                                              child: Image.asset(
                                                'assets/images/icons/star.png',
                                                height: 16,
                                                width: 16,
                                                semanticLabel:
                                                'Star rating',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                            10), // Spacing between elements

                                        if (rev.placeName != null)
                                          MyString.bold(
                                            '${rev.placeName}',
                                            14,
                                            MyColor.black,
                                            TextAlign.start,
                                          ),
                                        SizedBox(height: 10), //
                                        if (rev.description != null)
                                          MyString.regMultiLine(
                                              '${rev.description}',
                                              12,
                                              MyColor.black,
                                              TextAlign.start,
                                              3),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
              //     :
              //
              //
              // Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(bottom: 3.0),
              //             child: MyString.reg('Customer ratings (8 reviews)',
              //                 16, MyColor.redd, TextAlign.start),
              //           ),
              //           GestureDetector(
              //             onTap: () {
              //               setState(() {
              //                 showReviewsList = true;
              //               });
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.only(bottom: 20.0),
              //               child: Row(
              //                 children: [
              //                   MyString.reg('Show all reviews', 12,
              //                       MyColor.redd, TextAlign.start),
              //                   SizedBox(width: 5),
              //                   Image.asset(
              //                       'assets/images/icons/noun_arr_right.png')
              //                 ],
              //               ),
              //             ),
              //           ),
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               MyString.reg(
              //                   '4.5', 20, MyColor.textBlack, TextAlign.start),
              //               SizedBox(
              //                 width: 5,
              //               ),
              //               Icon(Icons.star, color: Colors.amber, size: 26),
              //             ],
              //           ),
              //           Container(
              //             margin: EdgeInsets.only(top: 10),
              //             height: 220,
              //             child: ListView.builder(
              //               padding: EdgeInsets.zero,
              //               scrollDirection: Axis.horizontal,
              //               itemCount: reviews.length,
              //               itemBuilder: (context, index) {
              //                 var rev = reviews[index];
              //                 return GestureDetector(
              //                   onTap: () async {
              //                     // Handle tap here
              //                   },
              //                   child: Container(
              //                     margin: EdgeInsets.only(right: 20),
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: 5, horizontal: 15),
              //                     width: 280,
              //                     decoration: BoxDecoration(
              //                       color: MyColor.card,
              //                       border: Border.all(color: MyColor.stroke),
              //                       borderRadius: BorderRadius.circular(
              //                           8), // Optional: adds rounded corners
              //                     ),
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         // Review header text
              //                         MyString.reg(
              //                           'Review filed on ${rev.date}',
              //                           12,
              //                           MyColor.textBlack0,
              //                           TextAlign.start,
              //                         ),
              //                         SizedBox(
              //                             height:
              //                                 10), // Spacing between elements
              //                         // Stars
              //                         Row(
              //                           children: List.generate(
              //                             rev.rate!,
              //                             (index) => Padding(
              //                               padding: const EdgeInsets.only(
              //                                   right:
              //                                       4.0), // Space between stars
              //                               child: Image.asset(
              //                                 'assets/images/icons/star.png',
              //                                 height: 16,
              //                                 width: 16,
              //                                 semanticLabel: 'Star rating',
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                         SizedBox(
              //                             height:
              //                                 10), // Spacing between elements
              //
              //                         MyString.bold(
              //                           '${rev.reviewer} reviews ${rev.place}',
              //                           14,
              //                           MyColor.black,
              //                           TextAlign.start,
              //                         ),
              //                         SizedBox(height: 10), //
              //                         SizedBox(height: 10),
              //                         MyString.regMultiLine(
              //                             '${rev.description}',
              //                             12,
              //                             MyColor.black,
              //                             TextAlign.start,
              //                             3),
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               },
              //             ),
              //           ),
              //         ],
              //       )
            ],
          ),
        ),
      ),
    );
  }
}
