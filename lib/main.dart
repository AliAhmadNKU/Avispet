import 'dart:io';
import 'package:avispets/utils/langauges.dart';
import 'package:avispets/utils/my_routes/app_routes.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/statistics_callback.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'LocalNotificationService.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterBranchSdk.init(enableLogging: true, disableTracking: false);
  // if (Platform.isAndroid){
  //   await Firebase.initializeApp(
  //       options: const FirebaseOptions(
  //         apiKey: 'AIzaSyCpVIfe-MXtJh4VbtxBc4_EjhFZC1ygaWQ',
  //         appId: '1:110517972384:android:83566ef165053fa00848c5',
  //         messagingSenderId: '110517972384',
  //         projectId: 'avispetsapp',
  //       )
  //   );
  // }else{
  //   await Firebase.initializeApp();
  // }
  await LocalNotificationService.initMainFCM();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  // FlutterBranchSdk.validateSDKIntegration();

  // for SSL(api https)
  ByteData data =
      await PlatformAssetBundle().load('assets/raw/3b7739f77ed701f6.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  StatisticsCallback? statisticsCallback;
  FFmpegKitConfig.enableStatisticsCallback(statisticsCallback);
  // FlutterFFmpegConfig().enableStatisticsCallback(statisticsCallback);
  await getLocationPermission();

  String? languageKey;
  String? languageValue;
  await Future.delayed(Duration.zero, () async {
    await iniSharePreference();
    if ((sharedPref.getString(SharedKey.languageKey).toString() != 'null' &&
            sharedPref
                .getString(SharedKey.languageKey)
                .toString()
                .isNotEmpty) &&
        (sharedPref.getString(SharedKey.languageValue).toString() != 'null' &&
            sharedPref
                .getString(SharedKey.languageValue)
                .toString()
                .isNotEmpty)) {
      languageKey = sharedPref.getString(SharedKey.languageKey).toString();
      languageValue = sharedPref.getString(SharedKey.languageValue).toString();
      debugPrint('LANGUAGE KEYS IS  $languageKey');
      debugPrint('LANGUAGE VALUE IS  $languageValue');
    } else {
      sharedPref.setString(SharedKey.languageKey, 'fr');
      sharedPref.setString(SharedKey.languageValue, 'fr');
      sharedPref.setString(SharedKey.languageCount, '1');
      languageKey = 'fr';
      languageValue = "fr";
    }
  });

  runApp(MyApp(languageKey, languageValue));
}

class MyApp extends StatefulWidget {
  final String? languageKey;
  final String? languageValue;
  const MyApp(this.languageKey, this.languageValue, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissions();
    LocalNotificationService.initNotification(context);
    LocalNotificationService.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      fallbackLocale: Locale(widget.languageKey!, widget.languageValue!),
      translations: Lang(),
      locale: Locale(widget.languageKey!, widget.languageValue!),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }

  getDeviceToken() {
    Future.delayed(Duration.zero, () async {
      await iniSharePreference();
      await FirebaseMessaging.instance.getToken().then((token) {
        sharedPref.setString(SharedKey.deviceToken, token.toString());
        debugPrint(
            'THIS IS DEVICE TOKEN: ${sharedPref.getString(SharedKey.deviceToken)}');
      });
    });
  }

  getPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      getDeviceToken();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
      getDeviceToken();
    } else {
      debugPrint('User declined or has not accepted permission');
    }
    if (await Permission.notification.request().isGranted) {
      try {
        getDeviceToken();
      } catch (e) {
        debugPrint('ERROR__$e');
      }
    }
  }
}

bool serviceStatus = true;
bool hasPermission = false;
late LocationPermission permission;
late Position position;

getLocationPermission() async {
  serviceStatus = await Geolocator.isLocationServiceEnabled();
  if (serviceStatus) {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('LOCATION PERMISSION ARE DENIED.');
      } else if (permission == LocationPermission.deniedForever) {
        debugPrint("LOCATION PERMISSION ARE PERMANENTLY DENIED.");
      } else {
        hasPermission = true;
      }
    } else {
      hasPermission = true;
    }
  } else {
    debugPrint("GPS SERVICE IS NOT ENABLED, TURN ON GPS LOCATION.");
  }
}
