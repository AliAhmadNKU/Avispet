import 'dart:convert';
import 'dart:io';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/ui/widgets/header_auth_widget.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/dialogs/bottom_language.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/loader_screen.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/common_function/my_string.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../bloc/login_bloc.dart';
import '../../models/login_model.dart';
import '../../models/social_login.dart';
import '../../utils/shared_pref.dart';
import '../main_screen/main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late OAuthCredential credential;

  late LoginBloc _loginBloc;
  var email = TextEditingController();
  var password = TextEditingController();
  bool passwordVisible = false;
  String languageFormat = 'en';
  String deviceType = "";
  String currentTimeZone = "";
  String longitude = "";
  String latitude = "";

  static const platform = MethodChannel('com.avispets.jeanne/custom');

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      appleSignInCallback();
    }

    Future.delayed(Duration.zero, () async {
      await changelang();
    });

    _loginBloc = LoginBloc(context);
    getDeviceToken();
    Future.delayed(Duration.zero, () async {
      if (Platform.isAndroid) {
        deviceType = "ANDROID";
      } else if (Platform.isIOS) {
        deviceType = "IOS";
      }
      currentTimeZone = await FlutterTimezone.getLocalTimezone();
      await _getLocation();
      debugPrint('DEVICE TYPE : $deviceType');
      debugPrint('TIME ZONE : $currentTimeZone');
      setState(() {});
    });
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    longitude = position.longitude.toString();
    latitude = position.latitude.toString();

    debugPrint("CURRENT LOCATION LONGITUDE : $longitude ");

    debugPrint("CURRENT LOCATION LATITUDE : $latitude ");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginBloc,
      child: BlocListener<LoginBloc, BlocStates>(
        listener: (context, state) {
          if (state is ValidationCheck) {
            toaster(context, state.value.toString());
          }
          if (state is Loading) {
            LoadingDialog.show(context);
          }
          if (state is Loaded) {
            LoadingDialog.hide(context);
          }
          if (state is NextScreen) {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.mainPage, arguments: 0, (route) => false);
          }
        },
        child: Scaffold(
            backgroundColor: MyColor.white,
            body: SafeArea(
              bottom: false,
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 5),
                              child: HeaderAuthWidget(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 25, left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: MyString.bold("login".tr, 27,
                                          MyColor.black, TextAlign.start)),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: TextField(
                                      controller: email,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 50),
                                      style: TextStyle(color: MyColor.black),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        prefixIcon: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Image.asset(
                                                'assets/images/icons/email.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            )),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                        hintText: "email".tr,
                                        hintStyle: TextStyle(
                                            color: MyColor.textFieldBorder,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Color(
                                        0xffEBEBEB), // Color of the divider
                                    thickness: 1, // Thickness of the line
                                    indent: 16, // Start padding
                                    endIndent: 16, // End padding
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    color: Colors.white,
                                    child: TextField(
                                      controller: password,
                                      obscureText:
                                          passwordVisible ? false : true,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 50),
                                      style: TextStyle(color: MyColor.black),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Image.asset(
                                                'assets/images/icons/password.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            )),
                                        suffixIcon: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: GestureDetector(
                                              onTap: () {
                                                passwordVisible =
                                                    !passwordVisible;
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 10),
                                                child: Image.asset(
                                                  passwordVisible
                                                      ? 'assets/images/logos/visible.png'
                                                      : 'assets/images/icons/invisible.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            )),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                        hintText: "password".tr,
                                        hintStyle: TextStyle(
                                            color: MyColor.textFieldBorder,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Color(
                                        0xffEBEBEB), // Color of the divider
                                    thickness: 1, // Thickness of the line
                                    indent: 16, // Start padding
                                    endIndent: 16, // End padding
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 15, bottom: 20),
                                      child: TextButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          Navigator.pushNamed(context,
                                              RoutesName.forgotPassword);
                                        },
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(3),
                                            minimumSize: Size(30, 30),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${"forgotPassword".tr} ',
                                              style: TextStyle(
                                                decorationThickness: 1.5,
                                                color: Colors.transparent,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                decorationColor:
                                                    MyColor.orange2,
                                                shadows: [
                                                  Shadow(
                                                      color: MyColor.textBlack0,
                                                      offset:
                                                          const Offset(0, -2))
                                                ],
                                              ),
                                            ),
                                            Text('${"forgotPassword2".tr}?',
                                                style: TextStyle(
                                                  decorationThickness: 1.5,
                                                  color: Colors.transparent,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  decorationColor:
                                                      MyColor.orange2,
                                                  shadows: [
                                                    Shadow(
                                                        color: MyColor.orange2,
                                                        offset:
                                                            const Offset(0, -2))
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();
                                      _loginBloc.add(GetLoginEvent(
                                          email.text.trim().toString(),
                                          password.text.trim().toString(),
                                          currentTimeZone,
                                          latitude,
                                          longitude,
                                          deviceType));
                                      setState(() {});
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 52,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: MyColor.orange2,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(18))),
                                      child: MyString.med("loginbtn".tr, 16,
                                          MyColor.white, TextAlign.center),
                                    ),
                                  ),


                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Flexible(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: Divider(),
                                            )),
                                        Flexible(
                                            flex: 4,
                                            child: MyString.med(
                                                "orContinueWith"
                                                    .tr
                                                    .toUpperCase(),
                                                15,
                                                MyColor.textBlack0,
                                                TextAlign.start)),
                                        const Flexible(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: Divider(),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 5, left: 8, right: 8),
                                    child: MyString.reg(
                                        'Social Account Login',
                                        12,
                                        MyColor.textBlack0,
                                        TextAlign.start),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final FirebaseAuth _auth =
                                                FirebaseAuth.instance;
                                            FacebookAuth.instance.logOut();
                                            await _auth.signOut();
                                            var result =
                                                await loginWithFacebook();
                                            print('FACEBOOK RESULT :- $result');
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            width: double.infinity,
                                            height: 52,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffBEBEBE)),
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(25))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'assets/images/logos/facebook.png',
                                                    height: 25,
                                                    width: 25),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                MyString.med(
                                                    "signinfb".tr,
                                                    12,
                                                    Color(0xff4F2020),
                                                    TextAlign.start)
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            GoogleSignIn googleSignIn =
                                                GoogleSignIn();
                                            await googleSignIn.signOut();
                                            await googleSignIn.signIn();
                                            googleSignup(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            width: double.infinity,
                                            height: 52,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffBEBEBE)),
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(25))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'assets/images/logos/google.png',
                                                    height: 25,
                                                    width: 25),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                MyString.med(
                                                    "signingg".tr,
                                                    12,
                                                    Color(0xff4F2020),
                                                    TextAlign.start)
                                              ],
                                            ),
                                          ),
                                        ),
                                        //apple
                                        if (Platform.isIOS)
                                          GestureDetector(
                                            onTap: () async {
                                              //apple login
                                              appleLogin();
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              width: double.infinity,
                                              height: 52,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xffBEBEBE)),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(25))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/icons/apple.png',
                                                      height: 25,
                                                      width: 25),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  MyString.med(
                                                      "signinapp".tr,
                                                      12,
                                                      Color(0xff4F2020),
                                                      TextAlign.start)
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              height: 75,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MyString.med(
                                      "haveAnAccount".tr,
                                      12,
                                      MyColor.textFieldBorder,
                                      TextAlign.center),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();

                                        Map<String, dynamic> mapData = {
                                          'languageFormat': languageFormat,
                                          'deepLinkingTrue': false
                                        };
                                        Navigator.pushNamed(
                                            context, RoutesName.signupScreen,
                                            arguments: mapData);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(' ${"createAccount".tr}',
                                            style: TextStyle(
                                              decorationThickness: 1.5,
                                              color: Colors.transparent,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              shadows: [
                                                Shadow(
                                                    color: MyColor.orange2,
                                                    offset: const Offset(0, -2))
                                              ],
                                            )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  getDeviceToken() {
    Future.delayed(Duration.zero, () async {
      await iniSharePreference();
      await FirebaseMessaging.instance.getToken().then((token) {
        sharedPref.setString(SharedKey.deviceToken, token.toString());
        debugPrint(
            'THIS IS DEVICE TOKEN: ${sharedPref.getString(SharedKey.deviceToken)}');
        debugPrint('THIS IS DEVICE TOKEN: ${token}');
      });
    });
  }

  _changeLanguage() async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: MyColor.white,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, myState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 8, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 50,
                          decoration: BoxDecoration(
                              color: sharedPref
                                              .getString(
                                                  SharedKey.languageCount)
                                              .toString() ==
                                          '0' ||
                                      sharedPref.getString(
                                              SharedKey.languageCount) ==
                                          null
                                  ? MyColor.yellowLite
                                  : null,
                              border: Border.all(
                                color: sharedPref
                                                .getString(
                                                    SharedKey.languageCount)
                                                .toString() ==
                                            '0' ||
                                        sharedPref.getString(
                                                SharedKey.languageCount) ==
                                            null
                                    ? MyColor.yellowLite
                                    : MyColor.textFieldBorder,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: TextField(
                            readOnly: true,
                            scrollPadding: const EdgeInsets.only(bottom: 50),
                            style: TextStyle(color: MyColor.black),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                      child: Image.asset(
                                    'assets/images/logos/uk_flag.png',
                                    width: 20,
                                    height: 20,
                                  ))),
                              suffixIcon: Icon(
                                  sharedPref
                                                  .getString(
                                                      SharedKey.languageCount)
                                                  .toString() ==
                                              '0' ||
                                          sharedPref.getString(
                                                  SharedKey.languageCount) ==
                                              null
                                      ? Icons.radio_button_on
                                      : Icons.radio_button_off,
                                  color: sharedPref
                                                  .getString(
                                                      SharedKey.languageCount)
                                                  .toString() ==
                                              '0' ||
                                          sharedPref.getString(
                                                  SharedKey.languageCount) ==
                                              null
                                      ? MyColor.orange2
                                      : MyColor.textFieldBorder),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              hintText: 'English',
                              hintStyle: TextStyle(
                                  color: MyColor.textFieldBorder1,
                                  fontSize: 16),
                            ),
                            onTap: () {
                              Get.updateLocale(const Locale('en', 'en'));
                              languageFormat = 'en';
                              sharedPref.setString(SharedKey.languageKey, 'en');
                              sharedPref.setString(
                                  SharedKey.languageValue, 'en');
                              sharedPref.setString(
                                  SharedKey.languageCount, '0');
                              Navigator.pop(context);
                              myState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          height: 50,
                          decoration: BoxDecoration(
                              color: sharedPref
                                          .getString(SharedKey.languageCount)
                                          .toString() ==
                                      '1'
                                  ? MyColor.yellowLite
                                  : null,
                              border: Border.all(
                                color: sharedPref
                                            .getString(SharedKey.languageCount)
                                            .toString() ==
                                        '1'
                                    ? MyColor.yellowLite
                                    : MyColor.textFieldBorder,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: TextField(
                            readOnly: true,
                            scrollPadding: const EdgeInsets.only(bottom: 50),
                            style: TextStyle(color: MyColor.black),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                      child: Image.asset(
                                    'assets/images/logos/france_flag.png',
                                    width: 20,
                                    height: 20,
                                  ))),
                              suffixIcon: Icon(
                                  sharedPref
                                              .getString(
                                                  SharedKey.languageCount)
                                              .toString() ==
                                          '1'
                                      ? Icons.radio_button_on
                                      : Icons.radio_button_off,
                                  color: sharedPref
                                              .getString(
                                                  SharedKey.languageCount)
                                              .toString() ==
                                          '1'
                                      ? MyColor.orange2
                                      : MyColor.textFieldBorder),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              hintText: 'French',
                              hintStyle: TextStyle(
                                  color: MyColor.textFieldBorder1,
                                  fontSize: 16),
                            ),
                            onTap: () {
                              Get.updateLocale(const Locale('fr', 'fr'));
                              languageFormat = 'fr';
                              sharedPref.setString(SharedKey.languageKey, 'fr');
                              sharedPref.setString(
                                  SharedKey.languageValue, 'fr');
                              sharedPref.setString(
                                  SharedKey.languageCount, '1');
                              Navigator.pop(context);
                              myState(() {});
                            },
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

  googleSignup(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      LoadingDialog.show(context);
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      user!.email.toString().split(" ");

      // if (kDebugMode) {
      print("Google(Email_Id)= ${user.email.toString()}");
      print("Google(Name)= ${user.displayName.toString()}");
      print("Google(Email_Verified)= ${user.emailVerified.toString()}");
      print("Google(Phone_Number)= ${user.phoneNumber.toString()}");
      print("Google(uid)= ${user.uid.toString()}");
      List<String> parts = user.displayName.toString().split(' ');
      String firstName = '';
      String lastName = '';
      if (parts.length < 1) {
        firstName = parts[0];
        lastName = parts[1];
      } else {
        firstName = parts[0];
        lastName = "";
      }

      String useremail = '';

      if (user.email == null) {
        useremail = user.providerData[0].email.toString();
      } else {
        useremail = user.email.toString();
      }

      socialAccount(
          user.uid.toString(),
          firstName.isNotEmpty ? firstName.trim() : '',
          lastName.isNotEmpty ? lastName.trim() : '',
          useremail,
          'Google');
      // }
    }
  }

  loginWithFacebook() async {
    //pankaj
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    LoadingDialog.show(context);
    UserCredential result = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    print("fb(result)= ${result.toString()}");
    print("fb(uid)= ${result.user?.uid.toString()}");
    print(
        "fb(Email_Id)= ${result.additionalUserInfo!.profile?['email'].toString()}");
    print(
        "fb(Name)= ${result.additionalUserInfo!.profile?['name'].toString()}");
    print(
        "fb(first_name)= ${result.additionalUserInfo!.profile?['first_name'].toString()}");
    print(
        "fb(last_name)= ${result.additionalUserInfo!.profile?['last_name'].toString()}");
    socialAccount(
        result.user!.uid.toString(),
        result.additionalUserInfo!.profile!['first_name'].toString().isNotEmpty
            ? result.additionalUserInfo!.profile!['first_name'].toString()
            : '',
        result.additionalUserInfo!.profile!['last_name'].toString().isNotEmpty
            ? result.additionalUserInfo!.profile!['last_name'].toString()
            : '',
        result.additionalUserInfo!.profile!['email'].toString(),
        'Facebook');
  }

  void appleLogin() {
    platform.invokeMethod('iOSAppleLogin');
  }

  Future<void> appleSignInCallback() async {
    try {
      platform.setMethodCallHandler((call) async {
        print("setMethodCallHandler_handle: ${call.arguments}");
        if (call.method == 'iOSAppleLogin') {
          debugPrint('apple login credential ${call.arguments}');
          if (call.arguments["status"] == "success") {
            socialAccount(
                call.arguments["appleId"],
                call.arguments["firstName"],
                call.arguments["lastName"],
                call.arguments["email"],
                'Apple');
          } else {
            toaster(context, call.arguments["error"]);
          }
        }
      });
    } on PlatformException catch (e) {
      debugPrint('Error $e');
    }
  }

  LoginModel _loginModel = LoginModel();
  socialAccount(String uid, String firstName, String lastName, String email,
      String type) async {
    Map<String, String> mapData = {
      'socialId': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'timezone': currentTimeZone.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'deviceToken': sharedPref.getString(SharedKey.deviceToken).toString(),
      'deviceType': deviceType.toString(),
      'socialType': type,
    };

    debugPrint('LOGIN (AUTH) : ${mapData}');
    var res = await AllApi.postMethodApi(ApiStrings.socialLogin, mapData);
    var result = jsonDecode(res.toString());

    if (result['status'] == 200) {
      SocialLogin socialLogin = SocialLogin.fromJson(result);
      setState(() {
        LoadingDialog.hide(context);
      });
      _loginModel = LoginModel.fromJson(result);

      sharedPref.setString(SharedKey.auth, _loginModel.data!.token.toString());
      sharedPref.setString(
          SharedKey.deviceToken, _loginModel.data!.deviceToken.toString());
      sharedPref.setString(SharedKey.userId, _loginModel.data!.id.toString());
      sharedPref.setString(
          SharedKey.userEmail, _loginModel.data!.email.toString());
      sharedPref.setString(SharedKey.socialLogin, '1');

      debugPrint('LOGIN (AUTH) : ${sharedPref.getString(SharedKey.auth)}');
      debugPrint(
          'LOGIN (TOKEN) : ${sharedPref.getString(SharedKey.deviceToken)}');
      debugPrint('LOGIN (USERID) : ${sharedPref.getString(SharedKey.userId)}');
      debugPrint(
          'LOGIN (USER_EMAIL) : ${sharedPref.getString(SharedKey.userEmail)}');
      debugPrint(
          'LOGIN (SOCIAL_LOGIN) : ${sharedPref.getString(SharedKey.socialLogin)}');

      if (socialLogin.metadata!.isNew == 0) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.mainPage, arguments: 0, (route) => false);
      } else {
        if (referralCode.isNotEmpty) {
          Map<String, String> mapData = {
            'referralCode': referralCode.toString(),
          };
          var res =
              await AllApi.putMethodApi(ApiStrings.updateProfile, mapData);
          var result = jsonDecode(res.toString());
          if (result['status'] == 200) {
            Map<String, dynamic> mapData = {'googleLogin': false};
            Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.otpScreen,
                arguments: {
                  'data': mapData,
                  'screen': 'login',
                },
                (route) => false);
          }
        } else {
          Map<String, dynamic> mapData = {'googleLogin': true};
          Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.selectAnimal,
              arguments: mapData,
              (route) => false);
        }
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['message'].toString());
    }
  }

  changelang() {
    setState(() {
      Get.updateLocale(const Locale('fr', 'fr'));
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
        sharedPref.getString(SharedKey.languageKey).toString();
        sharedPref.getString(SharedKey.languageValue).toString();
      } else {
        sharedPref.setString(SharedKey.languageKey, 'fr');
        sharedPref.setString(SharedKey.languageValue, 'fr');
        sharedPref.setString(SharedKey.languageCount, '1');
      }
    });
  }
}

class Resource {
  final Status status;
  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
