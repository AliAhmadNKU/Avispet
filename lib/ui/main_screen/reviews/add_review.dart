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
import '../../../utils/common_function/toaster.dart';
import '../../../utils/shared_pref.dart';
import '../../widgets/comment_screen.dart';
import '../filter_reviews.dart';

class AddReview extends StatefulWidget {
  int postID;
  Post? post;
  int userRecommendedPercentage;

  AddReview(
      {super.key,
      required this.postID,
      required this.userRecommendedPercentage,
      required this.post});

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

  Future<void> sendLikes(
    int userId,
    int postReviewId,
    Reviews? mReviews,
  ) async {
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
  void initState() {
    getPostReviewsById();
    // TODO: implement initState
    super.initState();
  }

  List<Reviews> mReviews = [];
  bool isLoading = true;

  getPostReviewsById() async {
    isLoading = true;
    try {
      String? userid = sharedPref.getString(SharedKey.userId);

      var res = await AllApi.getMethodApi(
          "${ApiStrings.getPostReviewsByPostId}${widget.post?.id}");
      var result = jsonDecode(res.toString());
      print("result REVIEW  ${result}");
      if (result['status'] == 200) {
        isLoading = false;
        mReviews = (result['data'] as List)
            .map((reviewItem) => Reviews.fromJson(reviewItem))
            .toList();

        // mReviews.forEach((element) {
        //
        //   if(element.likes!.isNotEmpty){
        //     element.likes?.forEach((e) {
        //       if (e.userId == int.parse(userid!)) {
        //         print("asdasdasdasda idhr aya hai");
        //         element.isLiked.value = true;
        //       }
        //     });
        //   }
        //
        // });

        if (this.mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      toaster(context, "An error occurred while fetching categories.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // You can attach a ScrollController here if you need to scroll programmatically.
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
                    mReviews.clear();
                    setState(() {
                      mReviews = result;
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

              // Other vertical content can go here.
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              mReviews.isEmpty || isLoading == true
                  ? progressBar()
                  : ListView.builder(
                      shrinkWrap: true,
                      // Makes the ListView expand to fit its content.
                      physics: NeverScrollableScrollPhysics(),
                      // Disables inner scrolling.
                      padding: EdgeInsets.zero,
                      itemCount: mReviews.length,
                      itemBuilder: (context, index) {
                        var rev = mReviews[index];
                        // Update comment and like counts.
                        rev.tcomment.value = rev.totalComments!.toInt();
                        rev.tLikes.value = rev.totalLikes!.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: GestureDetector(
                            onTap: () async {
                              // Handle tap here.
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 15),
                              width: 280,
                              decoration: BoxDecoration(
                                color: MyColor.card,
                                border: Border.all(color: MyColor.stroke),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
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
                                  Row(
                                    children: [
                                      if (rev.user?.firstName != null)
                                        Flexible(
                                          child: Text(
                                            rev.user!.firstName ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: MyColor.title,
                                              fontFamily: 'poppins_bold',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 8),
                                      MyString.bold(
                                        "reviews",
                                        14,
                                        Colors.grey.withOpacity(0.9),
                                        TextAlign.start,
                                      ),
                                      SizedBox(width: 8),
                                      if (rev.placeName != null &&
                                          rev.placeName != "No Name")
                                        Flexible(
                                          child: Text(
                                            rev.placeName ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: MyColor.title,
                                              fontFamily: 'poppins_bold',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (rev.description != null)
                                    Text(
                                      rev.description ?? "",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: MyColor.black,
                                        fontFamily: 'poppins_regular',
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          String? userid = sharedPref
                                              .getString(SharedKey.userId);
                                          await showCommentBottomSheet(
                                            screenCheck: false,
                                            context: context,
                                            comments: rev.comments,
                                            userId: int.parse(userid!),
                                            postReviewId: rev.id!.toInt(),
                                            mReviews: rev,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/icons/comment_icon.svg',
                                              width: 14,
                                              height: 15,
                                            ),
                                            SizedBox(width: 5),
                                            Obx(() {
                                              return MyString.reg(
                                                '${rev.tcomment.value}',
                                                12,
                                                MyColor.commentCountColor,
                                                TextAlign.start,
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          String? userid = sharedPref
                                              .getString(SharedKey.userId);
                                          sendLikes(int.parse(userid!),
                                              rev.id!.toInt(), rev);
                                        },
                                        child: Obx(() {
                                          return Row(
                                            children: [
                                              rev.isLiked.value == false
                                                  ? SvgPicture.asset(
                                                      'assets/images/icons/heart_solid_icon.svg',
                                                      width: 14,
                                                      height: 15,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.grey
                                                            .withOpacity(0.5),
                                                        BlendMode.srcIn,
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/images/icons/heart_solid_icon.svg',
                                                      width: 14,
                                                      height: 15,
                                                    ),
                                              SizedBox(width: 5),
                                              MyString.reg(
                                                '${rev.tLikes.value}',
                                                12,
                                                MyColor.commentCountColor,
                                                TextAlign.start,
                                              )
                                            ],
                                          );
                                        }),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

