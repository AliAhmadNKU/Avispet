import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool loader = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
     // GetApi.getNotify(context, '');
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HeaderWidget(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    child: MyString.bold('${'privacy1'.tr}', 24, MyColor.title,
                        TextAlign.center),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'poppins_regular',
                      ),
                      children: [
                        TextSpan(
                          text:
                              'Your privacy is important to us. It is Brainstorming\'s policy to respect your privacy regarding any information we may collect from you across our web site, and other sites we own and operate. \n \n',
                          style: TextStyle(color: MyColor.redd, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.\n\n',
                          style: TextStyle(
                              color: MyColor.textBlack0, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'We only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\n\n',
                          style: TextStyle(
                              color: MyColor.textBlack0, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'We don’t share any personally identifying information publicly or with third-parties, except when required to by law.\n\n',
                          style: TextStyle(
                              color: MyColor.textBlack0, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.',
                          style: TextStyle(color: MyColor.redd, fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
