import 'dart:async';
import 'package:avispets/ui/main_screen/home/post_detail.dart';
import 'package:avispets/ui/main_screen/main_page.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<Map>? streamSubscriptionDeepLink;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await listenDeepLinkData(context);
    });
    initSharedPref();
  }

  initSharedPref() async {
    await iniSharePreference();
    Future.delayed(Duration.zero, () async {
      String result = sharedPref.getString(SharedKey.onboardScreen).toString();
      String auth = sharedPref.getString(SharedKey.auth).toString();
      String token = sharedPref.getString(SharedKey.deviceToken).toString();
      debugPrint('X-ACCESS-TOKEN : $auth');
      debugPrint('DEVICE-TOKEN : ${token}');
      debugPrint('ONBOARDING SCREEN IS WORKING OFF/NO : $result');
      if (result == "NO" || result == 'null') {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.onboarding, (route) => false));
      }
      // else if (auth.toString() == 'null') {
      //   Timer(
      //       const Duration(seconds: 3),
      //       () => Navigator.pushNamedAndRemoveUntil(
      //           context, RoutesName.mainPage, arguments: 0, (route) => false));
      // }
      else if (auth.toString() != 'null' && token.isNotEmpty) {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.mainPage, arguments: 0, (route) => false));
      } else {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.loginScreen, (route) => false));
      }
    });
  }

  listenDeepLinkData(BuildContext context) async {
    streamSubscriptionDeepLink = FlutterBranchSdk.listSession().listen((data) {
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        debugPrint('data: deeplinking $data');

        Map<String, dynamic> mapData = {
          'from': data['from'].toString(),
          'feedId': data['feedId'].toString(),
          'userId': data['userId'].toString(),
        };

        if (data['page'] == 'home') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetail(mapData: mapData)));
        } else if (data['page'] == 'signup') {
          debugPrint('data: decode  111   ${data['referCode'].toString()}');
          referralCode = data['referCode'].toString();
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.mainPage, arguments: 3, (route) => false);
        }

        debugPrint('qwqwqw  ${data['+clicked_branch_link']}');
        return data['+clicked_branch_link'];
      }
      debugPrint('qwqwqw 11111  ${data['+clicked_branch_link']}');
      return data['+clicked_branch_link'];
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      debugPrint('exception: $platformException');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.newBackgroundColor2,
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.50,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/onboard/logo_without_bg.png",
                  width: 250,
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/images/onboard/splash_person.png",
                  width: MediaQuery.of(context).size.width * 1.2,
                  height: MediaQuery.of(context).size.height * 0.50,
                  fit: BoxFit.cover),
            )
          ],
        ));
  }
}
