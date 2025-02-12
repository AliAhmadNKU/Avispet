import 'dart:convert';

import 'package:avispets/ui/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../bloc/bloc_events.dart';
import '../../bloc/follow_bloc.dart';
import '../../models/get_all_post_modle.dart';
import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/apis/get_api.dart';
import '../../utils/common_function/my_string.dart';
import '../../utils/my_color.dart';




class PostCard extends StatefulWidget {

  Post post;

  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}


class _PostCardState extends State<PostCard> {
  bool isFollowing = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future<void> follow() async {

    Map<String, dynamic> mapData = {'followingId': widget.post.userId};
    var res = await AllApi.postMethodApi(
        ApiStrings.followUser, mapData);
    var result = jsonDecode(res.toString());
    print(result);
    if (result['status'] == 200) {


    }
    if (result['status'] == 401) {
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(0),
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)
      ),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Container
              Column(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Makes the container circular
                      border: Border.all(
                        color: Colors.black,
                        // Change this to your preferred border color
                        width: 2.0, // Adjust the width as needed
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.post.images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star,
                          color: Colors.amber,
                          size: 16),
                      MyString.reg(
                          '${widget.post.overallRating}  ',
                          12,
                          MyColor.textBlack0,
                          TextAlign.start),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 10),
              // Adds spacing between image and text content

              // Expanded Column for Full Width
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Aligns items to the left
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          MyString.bold('Mariane',
                              16,
                              MyColor.black,
                              TextAlign.center),

                          /// Follow Following

                            SizedBox(
                      width: 102,
                      height: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isFollowing = !isFollowing;
                          });
                          follow();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child:
                        isFollowing==true?
                        MyString.reg("following".tr,
                            12,
                            MyColor.white,

                            TextAlign.center):
                        MyString.reg("follow".tr,
                            12,
                            MyColor.white,

                            TextAlign.center),

                      ),
                    ),

                        ],
                      ),
                      SizedBox(height: 5), // Adds spacing
                      Container(
                        height: 40,
                        width: double.infinity, // Allows full width usage
                        child: MyString.reg(
                            widget.post.description,
                            14,
                            MyColor.black,
                            TextAlign.start
                        ),
                      ),
                      SizedBox(height: 5), // Adds spacing
                      ClipRRect(
                        child: CachedImage(
                          height: 152,
                          width: double.infinity, // Allows full width usage
                          url: widget.post.images[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10), // Adds spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                              'assets/images/icons/comment_icon.svg', width: 14,
                              height: 15),
                          SvgPicture.asset(
                              'assets/images/icons/heart_solid_icon.svg',
                              width: 14, height: 15),
                          SvgPicture.asset(
                              'assets/images/icons/share_stroke_icon.svg',
                              width: 14, height: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )

      ),
    );
  }
}
