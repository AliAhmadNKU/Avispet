import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/reviews/get_post_reviews_by_postid_model.dart';
import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';

Future<void> showCommentBottomSheet({
  required BuildContext context,
  List<dynamic>? comments,
  int? userId,
  int? postReviewId,
  Reviews? mReviews,
  int? postId,
  required bool screenCheck
}) async {
  final ScrollController _scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();

  Future<void> sendComment(String comment, int userId, int postReviewId, Function updateUI) async {
    Map<String, dynamic> mapData = {
      "userId": userId,
      "postReviewId": postReviewId,
      "comment": comment.toString(),
    };

    print("Sending comment data: $mapData");
    var res = await AllApi.postMethodApi(ApiStrings.reviewComment, mapData);
    var result = jsonDecode(res.toString());
    print("Comment response: $result");

    if (result['status'] == 201) {
      mReviews?.tcomment.value++;
      updateUI(); // Refresh UI after adding the comment
    }
  }



  Future<void> sendCommentForPost(String comment, int postId, Function updateUI) async {
    Map<String, dynamic> mapData = {
      "postId": postId,
      "commentText": comment
    };

    print("Sending comment data: $mapData");
    var res = await AllApi.postMethodApi(ApiStrings.postComment , mapData);
    var result = jsonDecode(res.toString());
    print("Comment response: $result");

    if (result['status'] == 201) {
      mReviews?.tcomment.value++;
      updateUI(); // Refresh UI after adding the comment
    }
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows expansion with keyboard
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Prevents keyboard overlap
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Comments",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                  Divider(),

                  // Comment List
                  Expanded(
                    child: (comments != null && comments.isNotEmpty)
                        ? ListView.builder(
                      controller: _scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.person, color: Colors.black54),
                          ),
                          title: Text(comments[index]["comment"]),
                        );
                      },
                    )
                        : Center(child: Text("No comments yet.")),
                  ),

                  // Comment Input Field
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: "Write a comment...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          if (commentController.text.isNotEmpty) {


                            if(screenCheck==false){
                              setState(() {
                                comments?.add({"comment": commentController.text});
                                sendComment(commentController.text, userId ?? 0, postReviewId ?? 0, _scrollToBottom);
                              });
                              commentController.clear();

                            }
                            else{
                              setState(() {
                                comments?.add({"commentText": commentController.text});
                                sendCommentForPost(commentController.text,postId??0, _scrollToBottom);
                              });
                              commentController.clear();
                            }

                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
