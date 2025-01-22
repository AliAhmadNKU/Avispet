import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class LocalNotificationService {
///////////////////////////////// init firebase ////////////////////////////////

  ///Receive message when app is in background solution for on message
  static Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint("LocalNotificationService_backgroundHandler: ${message.data}");
    if (Platform.isAndroid) {
      // LocalNotificationService.display(message);
    }
  }

  static initMainFCM() async {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
        apiKey: 'AIzaSyCpVIfe-MXtJh4VbtxBc4_EjhFZC1ygaWQ',
        appId: '1:110517972384:android:83566ef165053fa00848c5',
        messagingSenderId: '110517972384',
        projectId: 'avispetsapp',
      ));
    } else {
      Firebase.initializeApp().then((value) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      });
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      await Firebase.initializeApp().catchError((e) {
        log(e.toString());
        return e;
      });
    }
  }

///////////////////////////////// close firebase ///////////////////////////////

//////////////////////// init Local Notification Service ///////////////////////

  static void initNotification(BuildContext contextGlobal) async {
    ///gives you the message on which user taps and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint("notification_getInitialMessage: ${message.data}");
        redirectScreen("getInitialMessage", message.data, contextGlobal);
      }
    });

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          "LocalNotificationService_onMessage_foreground: ${message.data}");
      if (Platform.isAndroid) {
        LocalNotificationService.display(message);
      }
    });

    ///When the app is in background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("notification_onMessageOpenedApp: ${message.data.toString()}");

      LocalNotificationService.redirectScreen(
          "onMessageOpenedApp.listen", message.data, contextGlobal);
    });
  }

/////////////////////// close Local Notification Service ///////////////////////

//////////////////////// init Notification Code ///////////////////////

  static const channelId = 'avispets_channelId';
  static const channelName = 'avispets_channelName';

  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext contextGlobal) async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: const AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: initializationSettingsIOS,
    );

    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint(
            "LocalNotificationService_onDidReceiveNotificationResponse: ${response.payload}");
        if (response.payload != null) {
          redirectScreen(
              "initialize", jsonDecode(response.payload!), contextGlobal);
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: "this is connect channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      debugPrint("notification_show_error: $e");
    }
  }

  static void redirectScreen(String from, Map<String, dynamic> data,
      BuildContext contextGlobal) async {
    //code ===>
    debugPrint(
        "LocalNotificationService_redirectScreen_from: $from, Data: $data");

    Map<String, dynamic> mapDataBody = jsonDecode(data['body']);

    ///message
    if (data['status'] == "1") {
      Map<String, dynamic> mapData = {
        'userId': mapDataBody['senderId'].toString(),
        'userName': mapDataBody['senderName'],
        'userImage': (mapDataBody['senderImage'] == null)
            ? ''
            : ApiStrings.mediaURl + mapDataBody['senderImage'],
        'myId': mapDataBody['receiverId'].toString(),
        'myImage':
            sharedPref.getString(SharedKey.userprofilePic).toString().isEmpty
                ? ""
                : sharedPref.getString(SharedKey.userprofilePic).toString(),
        'blockBy': '0',
        'isBlock': 0,
        'online': 0,
        'groupId': 0,
        'totalMember': '',
        'from': 'notification'
      };

      FocusManager.instance.primaryFocus!.unfocus();

      Future.delayed(Duration(milliseconds: 100), () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.mainPage,
          arguments: 2,
          (route) => false,
        );
      });
    }

    ///follow
    else if (data['status'] == "999") {
      Map<String, dynamic> mapData = {
        'from': "notification",
        'userID': mapDataBody['id'].toString(),
      };
      Future.delayed(Duration(milliseconds: 100), () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.myProfile,
          arguments: mapData,
          (route) => false,
        );
      });
    }

    ///Forum Reply
    else if (data['status'] == "988") {
      Map<String, dynamic> mapping = {
        'from': "notification",
        'topicTitle': mapDataBody['title'].toString(),
        'forumId': int.parse(mapDataBody['forumId'].toString()),
        'forumTopicId': int.parse(mapDataBody['id'].toString()),
      };
      Future.delayed(Duration(milliseconds: 100), () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.forumReply,
          arguments: mapping,
          (route) => false,
        );
      });
    }

    /// Like Forum Reply
    else if (data['status'] == "989") {
      Map<String, dynamic> mapping = {
        'from': "notification",
        'topicTitle': mapDataBody['title'].toString(),
        'forumId': int.parse(mapDataBody['forumId'].toString()),
        'forumTopicId': int.parse(mapDataBody['id'].toString()),
      };
      Future.delayed(Duration(milliseconds: 100), () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.forumReply,
          arguments: mapping,
          (route) => false,
        );
      });
    }

    /// Feed Comment
    else if (data['status'] == "780") {
      Map<String, dynamic> mapData = {
        'from': 'notification',
        'feedId': mapDataBody['feedId'].toString()
      };
      Future.delayed(Duration(milliseconds: 100), () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.postDetail,
          arguments: mapData,
          (route) => false,
        );
      });
    }

    /// Feed Comment Reply
    else if (data['status'] == "781") {
      Map<String, dynamic> mapData = {
        'popUsed': false,
        'feedId': mapDataBody['feedId'].toString(),
        'parentId': mapDataBody['replyId'].toString(),
        'userImage': mapDataBody['user']['profile_picture'],
        'userId': mapDataBody['user']['id'].toString(),
        'userName': mapDataBody['user']['name'].toString(),
      };
      Future.delayed(Duration(milliseconds: 100), () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.replyScreen,
          arguments: mapData,
          (route) => false,
        );
      });
    }

    /// Like Feed
    else if (data['status'] == "987") {
      Map<String, dynamic> mapData = {
        'from': 'notification',
        'feedId': mapDataBody['id'].toString()
      };
      Future.delayed(Duration(milliseconds: 100), () async {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RoutesName.postDetail,
          arguments: mapData,
          (route) => false,
        );
      });
    }

    // Navigator.pushNamedAndRemoveUntil(contextGlobal, RoutesName.mainPage, arguments: 2, (route) => false);
  }
}
