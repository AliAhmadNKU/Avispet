import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import '../../../utils/common_function/my_string.dart';

class CommentDialog extends StatefulWidget {
  String comment;
  CommentDialog({super.key, required this.comment});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadiusDirectional.circular(40)),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyString.bold(widget.comment.toString(), 14,
                            MyColor.black, TextAlign.start),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 30),
                                    decoration: BoxDecoration(
                                        color: MyColor.orange2,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: MyString.med(
                                        'close'.tr.toUpperCase(),
                                        12,
                                        MyColor.white,
                                        TextAlign.center),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
