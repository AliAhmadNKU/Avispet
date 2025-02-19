import 'dart:convert';
import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:avispets/models/get_all_post_modle.dart';
import 'package:avispets/models/get_feed_comment_model.dart';
import 'package:avispets/models/reviews/get_post_reviews_by_postid_model.dart';
import 'package:avispets/ui/main_screen/addPost/add_post_details.dart';
import 'package:avispets/ui/main_screen/home/like_screen.dart';
import 'package:avispets/ui/main_screen/reviews/add_review.dart';
import 'package:avispets/ui/widgets/cached_image.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/base_date_utils.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
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
import '../../widgets/comment_screen.dart';
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

  bool isLoading = true;
  late int userRecommendedPercentage;

  @override
  @override
  void initState() {
    super.initState();

    print('Received arguments: ${widget.mapData}');
    post = widget.mapData!['post'];

    print("phone ${post.phone}");
    userRecommendedPercentage = post.userRecommendedPercentage?.toInt() ?? 0;
    print("post.id asdasdasd  ${post.id}");

    getPostReviewsById();

    setState(() {
      showReviewsList = false;
    });
  }

  Future<void> _launchURL(String? url) async {
    print("URL Data: $url");



    // Check if the URL is null or empty
    if (url == null || url.trim().isEmpty || url=="null"||url=="") {
      print("Invalid URL");
      toaster(context, "Webiste not found");
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        toaster(context, "Website not found");
      }
    } catch (e) {
      toaster(context, "Website not found");
      print('Error launching URL: $e');
    }
  }

  void makePhoneCall(BuildContext context, String ? phoneNumber) async {


    print("phoneNumber ${phoneNumber}");
    if(phoneNumber =="No phone number found" || phoneNumber==null)
      {
        toaster(context, "No phone number found");

      }
    else{


      final Uri uri = Uri.parse("tel:$phoneNumber");

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        toaster(context, "Could not launch phone dialer.");
      }
    }

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

  bool opening = false;

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
                    Row(
                      children: [
                        MyString.bold(
                            post.category, 18, MyColor.title, TextAlign.start),

                        post.placeName =="No Name" || post.placeName==null?
                        SizedBox():

                        Expanded(
                          child: Text(
                            " - ${post.placeName}"??"",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                color:MyColor.title,
                                fontFamily: 'poppins_bold',
                                fontWeight: FontWeight.w700,
                            ),
                          )
                        )





                      ],
                    ),
                    SizedBox(height: 10,),
                    // Container(
                    //   margin: const EdgeInsets.only(top: 15, bottom: 15),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(color: Color(0xffEBEBEB)),
                    //       borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(13),
                    //           topRight: Radius.circular(13),
                    //           bottomLeft: Radius.circular(13),
                    //           bottomRight: Radius.circular(13))),
                    //   child: TextField(
                    //     controller: searchBar,
                    //     scrollPadding: const EdgeInsets.only(bottom: 50),
                    //     style: TextStyle(color: MyColor.black, fontSize: 14),
                    //     decoration: InputDecoration(
                    //       border: const OutlineInputBorder(
                    //         borderSide: BorderSide.none,
                    //       ),
                    //       prefixIcon: SizedBox(
                    //           width: 20,
                    //           height: 20,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Image.asset(
                    //               'assets/images/icons/search.png',
                    //               width: 20,
                    //               height: 20,
                    //             ),
                    //           )),
                    //       contentPadding: const EdgeInsets.symmetric(
                    //           vertical: 5, horizontal: 12),
                    //       hintText: 'search'.tr,
                    //       hintStyle: TextStyle(
                    //           color: MyColor.textBlack0, fontSize: 14),
                    //     ),
                    //     onChanged: (value) {},
                    //   ),
                    // ),
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
                          post.placeName =="No Name" || post.placeName==null?
                              SizedBox():
                          Expanded(
                              child: Text(
                                "${post.placeName}"??"",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  color:MyColor.title,
                                  fontFamily: 'poppins_bold',
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                          ),
                          SizedBox(width: 20,),
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
                              MyString.reg('${post.locationDistance} ${post
                                  .locationDistanceUnit}', 12,
                                  MyColor.textBlack0,
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
                              MyString.reg(post.locationRating.toString(), 12,
                                  MyColor.textBlack0, TextAlign.start),
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
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddPostDetails(id: post.id),
                                  ),
                                );
                                if (result == true) {
                                  getPostReviewsById();
                                }
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
                              GestureDetector(
                                onTap: () {
                                  _launchURL(post.websiteName);
                                },
                                child: Container(
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
                              ),
                              MyString.reg(
                                  'Go', 12, MyColor.textBlack0, TextAlign.start)
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // _launchURL(post.websiteName.toString());
                                },
                                child: Container(
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
                              ),
                              MyString.reg('Website', 12, MyColor.textBlack0,
                                  TextAlign.start)
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {

                                  makePhoneCall(context, post.phone);
                                },
                                child: Container(
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
                              ),
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
                          trailing:
                          opening==true?
                          Container(
                            width: 20,  // Adjust size as needed
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColor.orange,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove, // Flutter’s built-in minus icon
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ):
                          Image.asset(
                            'assets/images/icons/addpic.png',
                            width: 20,
                            height: 20,
                          ),
                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              opening = !opening;
                            });
                          },
                          children: [

                            MyString.bold(
                                '[${post.openingClosingHour ?? "no data"}]', 14,
                                MyColor.redd, TextAlign.start),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset('assets/images/icons/routing.png'),
                    ),


                    /// Suggest an Edit
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
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddPostDetails(id: post.id),
                          ),
                        );
                        if (result == true) {
                          getPostReviewsById();
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
                                        MyString.reg(
                                            post.locationRating.toString(),
                                            20,
                                            MyColor.textBlack,
                                            TextAlign.start),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 26),
                                      ],
                                    ),
                                    MyString.reg('${post.locationRating
                                        .toString()} Reviews', 10,
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
                                        MyString.reg(
                                            '${userRecommendedPercentage}%', 20,
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
                                              'Review filed on ${BaseDateUtils
                                                  .formatToMMddyyyy(
                                                  rev.createdAt!)}',
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
                                                    (index) =>
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          right: 4.0),
                                                      // Space between stars
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
                                    if (index != mReviews.length - 1)
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Divider(
                                          color: Color(0xffEBEBEB),
                                          // Color of the divider
                                          thickness: 1,
                                          // Thickness of the line
                                          indent: 16,
                                          // Start padding
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
                            getPostReviewsById();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  AddReview(
                                    post: post,
                                    mReviews: mReviews, postID: post.id,
                                    userRecommendedPercentage: userRecommendedPercentage,


                                  )),
                            );
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
                        if (mReviews.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyString.reg(
                                  '${post.locationRating}',
                                  20,
                                  MyColor.textBlack,
                                  TextAlign.start),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.star,
                                  color: Colors.amber, size: 26),
                            ],
                          ),
                        mReviews.isEmpty || isLoading == true
                            ? progressBar()
                            : Container(
                          margin: EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: mReviews.map((rev) {
                                // Update your review properties
                                rev.tcomment.value = rev.totalComments!.toInt();
                                rev.tLikes.value = rev.totalLikes!.toInt();

                                return GestureDetector(
                                  onTap: () async {
                                    // Handle tap
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                                    width: 280,
                                    decoration: BoxDecoration(
                                      color: MyColor.card,
                                      border: Border.all(color: MyColor.stroke),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min, // Lets the column size itself dynamically.
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
                                            if (rev.placeName != null && rev.placeName != "No Name")
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
                                            rev.description??"",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: MyColor.black,
                                              fontFamily: 'poppins_regular',
                                            ),
                                          ),
                                        SizedBox(height: 10),
                                        // Fixed spacing instead of Spacer
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                String? userid = sharedPref.getString(SharedKey.userId);
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
                                                String? userid = sharedPref.getString(SharedKey.userId);
                                                sendLikes(int.parse(userid!), rev.id!.toInt(), rev);
                                              },
                                              child: Obx(() {
                                                return Row(
                                                  children: [
                                                    rev.isLiked.value == false
                                                        ? SvgPicture.asset(
                                                      'assets/images/icons/heart_solid_icon.svg',
                                                      width: 14,
                                                      height: 15,
                                                      colorFilter: ColorFilter.mode(
                                                        Colors.grey.withOpacity(0.5),
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
                                );
                              }).toList(),
                            ),
                          ),
                        )




                        // Container(
                        //   margin: EdgeInsets.only(top: 10),
                        //   height: 330,
                        //   child: ListView.builder(
                        //     padding: EdgeInsets.zero,
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: mReviews.length,
                        //     itemBuilder: (context, index) {
                        //       var rev = mReviews[index];
                        //       rev.tcomment.value = rev.totalComments!.toInt();
                        //       rev.tLikes.value = rev.totalLikes!.toInt();
                        //
                        //       print("review rev.id  ${rev.id}");
                        //       return GestureDetector(
                        //         onTap: () async {
                        //           // Handle tap here
                        //         },
                        //         child: Container(
                        //           margin:
                        //           EdgeInsets.only(right: 20),
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: 30, horizontal: 15),
                        //           width: 280,
                        //           decoration: BoxDecoration(
                        //             color: MyColor.card,
                        //             border: Border.all(
                        //                 color: MyColor.stroke),
                        //             borderRadius: BorderRadius.circular(
                        //                 8), // Optional: adds rounded corners
                        //           ),
                        //           child: Column(
                        //             crossAxisAlignment:
                        //             CrossAxisAlignment.start,
                        //             mainAxisAlignment:
                        //             MainAxisAlignment.center,
                        //             children: [
                        //               // Review header text
                        //               MyString.reg(
                        //                 'Review filed on ${BaseDateUtils
                        //                     .formatToMMddyyyy(rev.createdAt!)}',
                        //                 12,
                        //                 MyColor.textBlack0,
                        //                 TextAlign.start,
                        //               ),
                        //               SizedBox(
                        //                   height:
                        //                   10), // Spacing between elements
                        //               // Stars
                        //               Row(
                        //                 children: List.generate(
                        //                   rev.overallRating!
                        //                       .toInt(),
                        //                       (index) =>
                        //                       Padding(
                        //                         padding: const EdgeInsets
                        //                             .only(
                        //                             right:
                        //                             4.0), // Space between stars
                        //                         child: Image.asset(
                        //                           'assets/images/icons/star.png',
                        //                           height: 16,
                        //                           width: 16,
                        //                           semanticLabel:
                        //                           'Star rating',
                        //                         ),
                        //                       ),
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                   height:
                        //                   10), // Spacing between elements
                        //
                        //           Row(
                        //             children: [
                        //               if (rev.user?.firstName != null)
                        //                 Flexible(
                        //                   child: Text(
                        //
                        //                     rev.user!.firstName??"",
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                     style: TextStyle(
                        //                       fontSize: 14,
                        //                       color: MyColor.title,
                        //                       fontFamily: 'poppins_bold',
                        //                       fontWeight: FontWeight.w700,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               // Add spacing so "reviews" text doesn't stick to the first name
                        //               SizedBox(width: 8),
                        //               MyString.bold(
                        //                 "reviews",
                        //                 14,
                        //                 Colors.grey.withOpacity(0.9),
                        //                 TextAlign.start,
                        //               ),
                        //               // Add spacing between "reviews" and place name
                        //               SizedBox(width: 8),
                        //               if (rev.placeName != null && rev.placeName != "No Name")
                        //                 Flexible(
                        //                   child: Text(
                        //                     rev.placeName??"",
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                     style: TextStyle(
                        //                       fontSize: 14,
                        //                       color: MyColor.title,
                        //                       fontFamily: 'poppins_bold',
                        //                       fontWeight: FontWeight.w700,
                        //                     ),
                        //                   ),
                        //                 ),
                        //             ],
                        //           ),
                        //
                        //
                        //           if (rev.description != null)
                        //
                        //             Text(
                        //               "Dappled light filtered through ancient trees as the forest whispered forgotten legends. Amid rustling leaves and murmuring streams, hidden paths revealed the secrets of time. Each step carried echoes of past lives, inviting curious souls to wander deeper into nature's enchanted realm. Mystic echoes call.",
                        //               style: TextStyle(
                        //                 fontSize: 12,
                        //                 color: MyColor.black,
                        //                 fontFamily:'poppins_regular',
                        //
                        //
                        //               ),
                        //             ),
                        //
                        //
                        //
                        //
                        //
                        //
                        //               SizedBox(height: 10), //
                        //
                        //               Spacer(),
                        //
                        //
                        //               Row(
                        //                 mainAxisAlignment: MainAxisAlignment
                        //                     .spaceBetween,
                        //                 children: [
                        //
                        //                   /// comments
                        //                   GestureDetector(
                        //                     onTap: () async {
                        //                       String? userid = sharedPref
                        //                           .getString(SharedKey.userId);
                        //                       await showCommentBottomSheet(
                        //                           screenCheck: false,
                        //                           context: context,
                        //                           comments:
                        //                           mReviews[index].comments,
                        //                           userId: int.parse(userid!),
                        //                           postReviewId: mReviews[index]
                        //                               .id
                        //                               ?.toInt(),
                        //                           mReviews: rev
                        //                       );
                        //                       print("dsfsdfsdfsdfsdfsdf00");
                        //                     },
                        //                     child: Row(
                        //
                        //                       children: [
                        //                         SvgPicture.asset(
                        //                             'assets/images/icons/comment_icon.svg',
                        //                             width: 14,
                        //                             height: 15),
                        //                         SizedBox(width: 5,),
                        //                         Obx(() {
                        //                           return MyString.reg(
                        //                             '${ rev.tcomment.value
                        //                                 .toString()}',
                        //                             12,
                        //                             MyColor.commentCountColor,
                        //                             TextAlign.start,
                        //                           );
                        //                         }),
                        //                       ],
                        //                     ),
                        //                   ),
                        //
                        //
                        //                   Spacer(),
                        //
                        //                   /// likes
                        //
                        //                   GestureDetector(
                        //                     onTap: () {
                        //                       String? userid = sharedPref
                        //                           .getString(SharedKey.userId);
                        //                       sendLikes(int.parse(userid!),
                        //                           mReviews[index].id!.toInt(),
                        //                           rev);
                        //                     },
                        //                     child: Obx(() {
                        //                       return Row(
                        //                         children: [
                        //
                        //                           rev.isLiked.value == false ?
                        //                           SvgPicture.asset(
                        //                             'assets/images/icons/heart_solid_icon.svg',
                        //                             width: 14,
                        //                             height: 15,
                        //                             colorFilter: ColorFilter.mode(
                        //                                 Colors.grey.withOpacity(
                        //                                     0.5),
                        //                                 BlendMode.srcIn),
                        //                           ) :
                        //                           SvgPicture.asset(
                        //                               'assets/images/icons/heart_solid_icon.svg',
                        //                               width: 14, height: 15),
                        //                           SizedBox(width: 5,),
                        //                           MyString.reg(
                        //                             '${rev.tLikes.value
                        //                                 .toString()
                        //                                 .toString()}',
                        //                             12,
                        //                             MyColor.commentCountColor,
                        //                             TextAlign.start,
                        //                           )
                        //                         ],
                        //                       );
                        //                     }),
                        //                   ),
                        //
                        //                   Spacer(),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 20,
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
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

  Future<void> sendLikes(int userId, int postReviewId,
      Reviews? mReviews,) async {
    Map<String, dynamic> mapData = {
      "userId": userId,
      "postReviewId": postReviewId,
    };

    print("Sending comment data: $mapData");
    var res = await AllApi.postMethodApi(ApiStrings.reviewLikes, mapData);
    var result = jsonDecode(res.toString());
    print("Likes response: $result");

    if (result['status'] == 200) {
      if (result['data']['isLiked'] == false) {

        if (mReviews!.tLikes.value >= 0) {
          mReviews.isLiked.value = false;
          mReviews.tLikes.value--; // Decrease only if greater than 0
        }
      }
      else {
          mReviews?.isLiked.value = true;
          mReviews?.tLikes.value++;
      }
    }
  }

  Future<Future<String?>> suggEditSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColor.orange2),
                    color: MyColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery
                          .of(context)
                          .viewInsets
                          .bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header

                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Flexible( // ✅ Prevents overflow while allowing text to wrap
                                child: MyString.bold(
                                  'What’s your relationship to this business'
                                      .tr,
                                  18,
                                  MyColor.redd,
                                  TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 10),
                              // Adds spacing between text and button
                              TextButton(
                                onPressed: () {

                                  sortingList.forEach((element) {
                                    element.conditionCheck = false;
                                  });

                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap,
                                ),
                                child: Image.asset(
                                  'assets/images/icons/cl.png',
                                  height: 28,
                                  width: 28,
                                ),
                              ),
                            ],
                          ),
                        ),


                        SizedBox(height: 10),
                        Center(
                          child: MyString.reg(
                            'Your feedback is important to us. If you notice something incorrect, let us know, and we’ll update it.',
                            12,
                            MyColor.title,
                            TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: MyString.bold(
                            'Reason(s) for reporting',
                            12,
                            MyColor.title,
                            TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15),

                        // List of reasons (with toggle functionality)
                        Container(
                          constraints: BoxConstraints(
                            minHeight: 100,
                            maxHeight: MediaQuery
                                .of(context)
                                .size
                                .height / 1.5,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      child: MyString.reg(
                                        item.title,
                                        12,
                                        MyColor.title,
                                        TextAlign.start,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          sortingList.forEach((element) {
                                            element.conditionCheck = false;
                                          });
                                          sortingList[index].conditionCheck =
                                          true;
                                          // item.conditionCheck = !item.conditionCheck;
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
                                          color: sortingList[index]
                                              .conditionCheck ? MyColor
                                              .orange2 : MyColor.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 15),

                        // Send Button
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              int? checkedIndex = sortingList.indexWhere((
                                  item) => item.conditionCheck);
                              if (checkedIndex != -1) {
                                suggestFeedBack(
                                    sortingList[checkedIndex].title);
                                Get.back();
                                toaster(context, "Feed back send Successfully");
                              } else {
                                toaster(context,
                                    "Please select at least one option");
                              }



                              // Handle send action here
                            },
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
                                  'Send',
                                  16,
                                  MyColor.white,
                                  TextAlign.center,
                                ),
                              ),
                            ),
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

  Future<void> suggestFeedBack(String Message) async {
    Map<String, dynamic> mapData = {
      "message": Message
    };

    print("feedback: $mapData");
    var res = await AllApi.postMethodApi(ApiStrings.contactUs, mapData);
    var result = jsonDecode(res.toString());
    print("Contact US: $result");
    if (result['status'] == 201) {

    }
  }


  getPostReviewsById() async {
    isLoading = true;
    try {
      String? userid = sharedPref
          .getString(SharedKey.userId);

      var res = await AllApi.getMethodApi(
          "${ApiStrings.getPostReviewsByPostId}${post.id}");
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
