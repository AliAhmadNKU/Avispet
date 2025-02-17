import 'dart:convert';

import 'package:avispets/ui/main_screen/home/filter_screen.dart';
import 'package:avispets/ui/main_screen/home/post_detail.dart';
import 'package:avispets/ui/main_screen/profile/profile_screen.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../models/get_all_post_modle.dart';
import '../../../models/reviews/get_post_reviews_by_postid_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/base_date_utils.dart';
import '../../../utils/shared_pref.dart';
import '../../widgets/comment_screen.dart';
import '../filter_reviews.dart';

class AddReview extends StatefulWidget {
  List<Reviews> mReviews = [];
  int postID;
  Post ?post;
   int userRecommendedPercentage;

  AddReview({super.key, required this.mReviews, required this.postID,required this.userRecommendedPercentage,required this.post});

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
  Future<void> sendLikes( int userId, int postReviewId,   Reviews? mReviews,) async {
    Map<String, dynamic> mapData = {
      "userId": userId,
      "postReviewId": postReviewId,
    };

    print("Sending comment data: $mapData");
    var res = await AllApi.postMethodApi(ApiStrings.reviewLikes, mapData);
    var result = jsonDecode(res.toString());
    print("like response: $result");

    if (result['status'] == 201) {


      mReviews?.tLikes.value++;

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: HeaderWidget(),
              ),
              MyString.bold('Review', 20, MyColor.title, TextAlign.start),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: MyString.reg('Recommended reviews', 16, MyColor.redd,
                        TextAlign.start),
                  ),
                ],
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
                                  MyString.reg(widget.post!.locationRating.toString(), 20, MyColor.textBlack,
                                      TextAlign.start),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 26),
                                ],
                              ),
                              MyString.reg('${widget.post?.userRatingCount.toString()} Reviews', 10,
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
                                  MyString.reg('${widget.userRecommendedPercentage}%', 20, MyColor.textBlack,
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
              GestureDetector(
                onTap: () async {
                  print("widget.postID ${widget.postID}");
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterReviews(
                              postId: widget.postID,
                            )),
                  );

                  if (result != null) {
                    widget.mReviews.clear();
                    setState(() {
                      widget.mReviews = result;
                    });
                  }
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
                        MyString.bold('Filter reviews ', 14, MyColor.redd,
                            TextAlign.center),
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
              //   Reviews List
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  // Ensures ListView takes only needed space
                  physics: NeverScrollableScrollPhysics(),
                  // Disables ListView scrolling
                  padding: EdgeInsets.zero,
                  itemCount: widget.mReviews.length,
                  itemBuilder: (context, index) {
                    var rev = widget.mReviews[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () async {
                          // Handle tap here
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          width: 280,
                          height: 219,
                          decoration: BoxDecoration(
                            color: MyColor.card,
                            border: Border.all(color: MyColor.stroke),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                MyString.reg(
                                  'Review filed on ${BaseDateUtils.formatToMMddyyyy(rev.createdAt!)}',
                                  12,
                                  MyColor.textBlack0,
                                  TextAlign.start,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: List.generate(
                                    rev.overallRating!.toInt(),
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(right: 4.0),
                                      child: Image.asset(
                                        'assets/images/icons/star.png',
                                        height: 16,
                                        width: 16,
                                        semanticLabel: 'Star rating',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (rev.placeName != null)
                                  MyString.bold(
                                    '${rev.placeName}',
                                    14,
                                    MyColor.black,
                                    TextAlign.start,
                                  ),
                                SizedBox(height: 10),
                                if (rev.description != null)
                                  MyString.regMultiLine(
                                    '${rev.description}',
                                    12,
                                    MyColor.black,
                                    TextAlign.start,
                                    3,
                                  ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// comments
                                    GestureDetector(
                                      onTap: () async {
                                        String? userid = sharedPref
                                            .getString(SharedKey.userId);
                                        await showCommentBottomSheet(
                                          screenCheck: false,
                                            context: context,
                                            comments: widget. mReviews[index].comments,
                                            userId: int.parse(userid!),
                                            postReviewId: widget.mReviews[index].id
                                                ?.toInt(),
                                            mReviews: rev
                                        );
                                      },
                                      child: Row(

                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/icons/comment_icon.svg',
                                              width: 14,
                                              height: 15),
                                          SizedBox(width: 5,),
                                          Obx(() {
                                            return MyString.reg(
                                              '${ rev.tcomment.value
                                                  .toString()}',
                                              12,
                                              MyColor.commentCountColor,
                                              TextAlign.start,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),


                                    Spacer(),

                                    /// likes
                                    GestureDetector(
                                      onTap: () {
                                        String? userid = sharedPref
                                            .getString(SharedKey.userId);
                                        sendLikes(int.parse(userid!),widget.mReviews[index].id!.toInt(), rev);
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/icons/heart_solid_icon.svg',
                                              width: 14, height: 15),
                                          SizedBox(width: 5,),
                                          Obx(() {
                                            return MyString.reg(
                                              '${rev.tLikes.value.toString()
                                                  .toString()}',
                                              12,
                                              MyColor.commentCountColor,
                                              TextAlign.start,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),

                                    Spacer(),



                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
