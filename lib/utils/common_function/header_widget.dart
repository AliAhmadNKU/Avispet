import 'package:flutter/material.dart';

import '../apis/get_api.dart';
import '../my_routes/route_name.dart';
import 'dialogs/bottom_language.dart';

class HeaderWidget extends StatelessWidget {
  final bool backIcon;
  const HeaderWidget({
    Key? key,
    this.backIcon = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: backIcon ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
        children: [
          if(backIcon) GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 31,
              height: 31,
              child: Image.asset(
                'assets/images/icons/prev.png',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pushNamed(
                      context, RoutesName.friends);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    'assets/images/icons/addfr.png',
                    color: Color(0xff5B6170),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      FocusManager.instance.primaryFocus
                          ?.unfocus();
                      Navigator.pushNamed(
                        context,
                        RoutesName.notification,
                        arguments: 1,
                      );
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        'assets/images/icons/notif.png',
                        color: const Color(0xff5B6170),
                      ),
                    ),
                  ),
                  if (GetApi.getNotification.data != null &&
                      GetApi.getNotification.data!.length > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                          color: Color(0xff00C03A),
                          borderRadius: BorderRadius.all(
                              Radius.circular(100)),
                        ),
                        child: Text(
                          '${GetApi.getNotification.data!.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),

              /// translation
              GestureDetector(
                onTap: () async {
                  await changeLanguage(context);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/icons/translation.png',
                    // 'assets/images/icons/translation_login.png',
                    color: const Color(0xff4F2020),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
