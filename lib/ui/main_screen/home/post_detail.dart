import 'dart:convert';
import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:avispets/models/get_all_post_modle.dart';
import 'package:avispets/models/get_feed_comment_model.dart';
import 'package:avispets/models/reviews/get_post_reviews_by_postid_model.dart';
import 'package:avispets/ui/main_screen/addPost/add_post_details.dart';
import 'package:avispets/ui/main_screen/home/like_screen.dart';
import 'package:avispets/ui/widgets/cached_image.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/base_date_utils.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:readmore/readmore.dart';
import '../../../models/get_single_post_model.dart';
import '../../../models/send_feed_comment_model.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/dialogs/dialog_success.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';
import '../profile/profile_screen.dart';

class PostDetail extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const PostDetail({super.key, this.mapData});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

//THIS CODE IS PUSHED IN PRODUCTION
class _PostDetailState extends State<PostDetail> {
  bool showReviewsList = false;
  var searchBar = TextEditingController();
  bool isShowEmoji = false;
  GetSinglePostModel _singlePostModel = GetSinglePostModel();
  bool loader = true;
  bool blockScroll = false;
  bool commentSending = true;
  final _focusNode = FocusNode();
  int page = 1;
  GetFeedCommentModel commentModel = GetFeedCommentModel();
  SendFeedCommentModel sendFeedCommentModel = SendFeedCommentModel();
  List<GetFeedCommentModelBody> getComment = [];
  String? totalComment;
  bool errorCode = false;
  var msgField = TextEditingController();

  bool endScroll = false;

  String video = '';
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  late Post post;
  late Map<String, dynamic> args;
  List<Reviews> mReviews = [];

  List<String> items = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  // List<review> reviews = [
  //   review(
  //       date: '10/27/2024',
  //       rate: 4,
  //       reviewer: 'reviewer',
  //       place: 'place',
  //       description:
  //           'Super lovely product. I love this product because the software is brilliantly helpful Can’t get enough!'),
  //   review(
  //       date: 'date',
  //       rate: 3,
  //       reviewer: 'reviewer',
  //       place: 'place',
  //       description:
  //           'Super lovely product. I love this product because the software is brilliantly helpful Can’t get enough!'),
  //   review(
  //       date: 'date',
  //       rate: 5,
  //       reviewer: 'reviewer',
  //       place: 'place',
  //       description:
  //           'Super lovely product. I love this product because the software is brilliantly helpful Can’t get enough!'),
  // ];
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
  List<bool> item2Bool = List.generate(5, (index) => false);

  double average = 0.0;

  var brand = '';

  List<sortingItem> sortingList = [
    sortingItem(title: 'Place definitely closed', conditionCheck: false),
    sortingItem(title: 'Opening hours', conditionCheck: false),
    sortingItem(title: 'Photos', conditionCheck: false),
    sortingItem(title: 'Address or position on the map', conditionCheck: false),
    sortingItem(title: 'Place name', conditionCheck: false),
    sortingItem(
        title: 'Contacts (website or phone number)', conditionCheck: false),
    sortingItem(title: 'Other', conditionCheck: false),
  ];

  @override
  void initState() {
    super.initState();
    print('Received arguments: ${widget.mapData}');
    post = widget.mapData!['post'];
    getPostReviewsById();

    setState(() {
      showReviewsList = false;
    });
  }

  @override
  void dispose() async {
    if (video.isNotEmpty) {
      videoPlayerController.dispose();
      _customVideoPlayerController.dispose();
      debugPrint('Dispose method call');
    }
    super.dispose();
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
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          backgroundColor: MyColor.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.only(right: 25, left: 25, top: 10, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(),
                    MyString.bold(post.category, 18,
                        MyColor.title, TextAlign.start),
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                          hintText: 'search'.tr,
                          hintStyle: TextStyle(
                              color: MyColor.textBlack0, fontSize: 14),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedImage(
                          url: post.images[0],
                          width: double.infinity,
                          height: 147,
                          fit: BoxFit.cover,
                          ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyString.bold(post.category, 18, MyColor.title,
                              TextAlign.start),
                          Row(
                            children: [
                              Image.asset('assets/images/icons/close.png'),
                              SizedBox(
                                width: 5,
                              ),
                              MyString.reg('Closed', 12, MyColor.textBlack0,
                                  TextAlign.start),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MyString.reg('Distance :', 12, MyColor.redd,
                                  TextAlign.start),
                              SizedBox(
                                width: 5,
                              ),
                              MyString.reg('1.2 KM', 12, MyColor.textBlack0,
                                  TextAlign.start),
                            ],
                          ),
                          Row(
                            children: [
                              MyString.reg('Rating :', 12, MyColor.redd,
                                  TextAlign.start),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              MyString.reg('(563)', 12, MyColor.textBlack0,
                                  TextAlign.start),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () async {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  AddPostDetails(
                                    id:post.id,
                                  )),
                                );

                                // await Navigator.pushNamed(
                                //     context, RoutesName.addReview,
                                //     arguments: {});
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: MyColor.orange2,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: MyString.med('Add A Review', 16,
                                      MyColor.white, TextAlign.start))),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: MyColor.card,
                                      borderRadius: BorderRadius.circular(22),
                                      border:
                                          Border.all(color: MyColor.orange2)),
                                  child: Image.asset(
                                    'assets/images/icons/go.png',
                                  )),
                              MyString.reg(
                                  'Go', 12, MyColor.textBlack0, TextAlign.start)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: MyColor.card,
                                      borderRadius: BorderRadius.circular(22),
                                      border:
                                          Border.all(color: MyColor.orange2)),
                                  child: Image.asset(
                                    'assets/images/icons/web.png',
                                  )),
                              MyString.reg('Website', 12, MyColor.textBlack0,
                                  TextAlign.start)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: MyColor.card,
                                      borderRadius: BorderRadius.circular(22),
                                      border:
                                          Border.all(color: MyColor.orange2)),
                                  child: Image.asset(
                                    'assets/images/icons/ph.png',
                                  )),
                              MyString.reg('Call', 12, MyColor.textBlack0,
                                  TextAlign.start)
                            ],
                          ),
                          SizedBox(
                            width: 5,
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
                    MyString.bold('Infos', 16, MyColor.redd, TextAlign.start),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.card,
                            border: Border.all(color: MyColor.orange2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: ExpansionTile(
                          backgroundColor: MyColor.card,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedBackgroundColor: MyColor.card,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: MyString.bold('Opening Hours', 14,
                              MyColor.redd, TextAlign.start),
                          trailing: Image.asset(
                            'assets/images/icons/addpic.png',
                            width: 20,
                            height: 20,
                          ),
                          onExpansionChanged: (bool expanded) {
                            setState(() {});
                          },
                          children: [
                            MyString.bold(
                                '[]', 14, MyColor.redd, TextAlign.start),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset('assets/images/icons/routing.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        suggEditSheet(context);
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
                          child: MyString.bold('Suggest an edit  ? ', 14,
                              MyColor.redd, TextAlign.center)),
                    ),
                    Divider(
                      color: Color(0xffEBEBEB), // Color of the divider
                      thickness: 1, // Thickness of the line
                      indent: 16, // Start padding
                      endIndent: 16, // End padding
                    ),
                    MyString.bold(
                        'Leave a review', 16, MyColor.redd, TextAlign.start),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MyColor.card,
                            border: Border.all(color: MyColor.orange2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MyString.bold('Add a review', 14, MyColor.redd,
                              TextAlign.center)),
                    ),
                    Divider(
                      color: Color(0xffEBEBEB), // Color of the divider
                      thickness: 1, // Thickness of the line
                      indent: 16, // Start padding
                      endIndent: 16, // End padding
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: MyString.reg('Recommended reviews', 16,
                          MyColor.redd, TextAlign.start),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  MyString.bold('5', 14, MyColor.textBlack0,
                                      TextAlign.start),
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
                                          thumbShape:
                                              SliderComponentShape.noThumb,
                                          trackShape: CustomTrackShape()),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyString.bold('4', 14, MyColor.textBlack0,
                                      TextAlign.start),
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
                                          thumbShape:
                                              SliderComponentShape.noThumb,
                                          trackShape: CustomTrackShape()),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyString.bold('3', 14, MyColor.textBlack0,
                                      TextAlign.start),
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
                                          thumbShape:
                                              SliderComponentShape.noThumb,
                                          trackShape: CustomTrackShape()),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyString.bold('2', 14, MyColor.textBlack0,
                                      TextAlign.start),
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
                                          thumbShape:
                                              SliderComponentShape.noThumb,
                                          trackShape: CustomTrackShape()),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyString.bold('1', 14, MyColor.textBlack0,
                                      TextAlign.start),
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
                                          thumbShape:
                                              SliderComponentShape.noThumb,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MyString.reg('4.5', 20,
                                            MyColor.textBlack, TextAlign.start),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MyString.reg('88%', 20,
                                            MyColor.textBlack, TextAlign.start),
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
                    showReviewsList
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.filterReviews);
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: MyColor.card,
                                      border:
                                          Border.all(color: MyColor.orange2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                height: 480,
                                width: double.infinity,
                                child: ListView.builder(
                                    itemCount: mReviews.length,
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 30),
                                    itemBuilder: (context, index) {
                                      var rev = mReviews[index];
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              // Handle tap here
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 25, horizontal: 20),
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
                                                      rev.overallRating!.toInt(),
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

                                                  if(rev.placeName != null) MyString.bold(
                                                    '${rev.placeName}',
                                                    14,
                                                    MyColor.black,
                                                    TextAlign.start,
                                                  ),
                                                  SizedBox(height: 10), //
                                                  if(rev.description != null) MyString.regMultiLine(
                                                      '${rev.description}',
                                                      12,
                                                      MyColor.black,
                                                      TextAlign.start,
                                                      3),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (index != mReviews.length - 1)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Divider(
                                                color: Color(
                                                    0xffEBEBEB), // Color of the divider
                                                thickness:
                                                    1, // Thickness of the line
                                                indent: 16, // Start padding
                                                endIndent: 16, // End padding
                                              ),
                                            ),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: MyString.reg(
                                    'Customer ratings (${mReviews.length} reviews)',
                                    16,
                                    MyColor.redd,
                                    TextAlign.start),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                      context, RoutesName.addReview,
                                      arguments: {});
                                  // setState(() {
                                  //   showReviewsList = true;
                                  // });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Row(
                                    children: [
                                      MyString.reg('Show all reviews', 12,
                                          MyColor.redd, TextAlign.start),
                                      SizedBox(width: 5),
                                      Image.asset(
                                          'assets/images/icons/noun_arr_right.png')
                                    ],
                                  ),
                                ),
                              ),
                              if(mReviews.isNotEmpty) Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyString.reg('${mReviews.first.overallRating}', 20, MyColor.textBlack,
                                      TextAlign.start),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 26),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 220,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: mReviews.length,
                                  itemBuilder: (context, index) {
                                    var rev = mReviews[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        // Handle tap here
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 20),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        width: 280,
                                        decoration: BoxDecoration(
                                          color: MyColor.card,
                                          border:
                                              Border.all(color: MyColor.stroke),
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
                                                rev.overallRating!.toInt(),
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

                                            if(rev.placeName != null) MyString.bold(
                                              '${rev.placeName}',
                                              14,
                                              MyColor.black,
                                              TextAlign.start,
                                            ),
                                            SizedBox(height: 10), //
                                            if(rev.description != null) MyString.regMultiLine(
                                                '${rev.description}',
                                                12,
                                                MyColor.black,
                                                TextAlign.start,
                                                3),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  suggEditSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColor.orange2),
                  color: MyColor.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(18))),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                            width: 300,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 5),
                            child: MyString.bold(
                                'What’s your relationship to this business'.tr,
                                18,
                                MyColor.redd,
                                TextAlign.center)),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            child: Image.asset(
                              'assets/images/icons/cl.png',
                              height: 28,
                              width: 28,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: MyString.reg(
                          'Your feedback is important to us, if you notice something that is incorrect, lets us know and we’ill make sure it’s updated. ',
                          12,
                          MyColor.title,
                          TextAlign.center),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: MyString.bold('Reason(s) for reporting', 12,
                          MyColor.title, TextAlign.center),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      constraints: new BoxConstraints(
                        minHeight: 100,
                        maxHeight: MediaQuery.of(context).size.height / 1.5,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: ListView.builder(
                          itemCount: sortingList.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = sortingList[index];
                            return Padding(
                              padding: const EdgeInsets.all(7),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: MyString.reg(item.title, 12,
                                              MyColor.title, TextAlign.start),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Toggle the conditionCheck value for the tapped item
                                          item.conditionCheck =
                                              !item.conditionCheck;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColor.orange2),
                                          color: MyColor.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: item.conditionCheck
                                              ? MyColor.orange2
                                              : MyColor.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Center(
                      child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: 128,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: MyColor.orange2,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: MyString.med(
                                    'Send', 16, MyColor.white, TextAlign.start),
                              ))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  getPostReviewsById() async {
    try {
      var res = await AllApi.getMethodApi("${ApiStrings.getPostReviewsByPostId}${post.id}");
      var result = jsonDecode(res.toString());
      print(result);
      if (result['status'] == 200) {
        mReviews = (result['data'] as List).map((reviewItem) => Reviews.fromJson(reviewItem)).toList();
        if(this.mounted){
          setState(() {

          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      toaster(context, "An error occurred while fetching categories.");
    }
  }
}

class sortingItem {
  String title;
  bool conditionCheck;

  sortingItem({
    required this.title,
    this.conditionCheck = false,
  });
}

class review {
  String? date;
  int? rate;
  String? reviewer;
  String? place;
  String? description;

  review({
    required this.date,
    required this.rate,
    required this.reviewer,
    required this.place,
    required this.description,
  });
}
