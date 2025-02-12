import 'dart:convert';
import 'dart:io';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/bloc/signup_bloc.dart';
import 'package:avispets/ui/widgets/header_auth_widget.dart';
import 'package:avispets/utils/common_function/dialogs/bottom_language.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/create_profile_bloc.dart';
import '../../models/login_model.dart';
import '../../models/social_login.dart';
import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/common_function/loader_screen.dart';
import '../../utils/common_function/my_string.dart';
import '../../utils/common_function/toaster.dart';
import '../../utils/shared_pref.dart';
import '../main_screen/main_page.dart';

class SignupScreen extends StatefulWidget {
  Map<String, dynamic> languageFormat;

  SignupScreen({super.key, required this.languageFormat});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late CreateProfileBloc _createProfileBloc;
  late SignUpBlock _signUpBlock;

  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var pseudo = TextEditingController();
  var referCode = TextEditingController();
  var phoneNumber = TextEditingController();
  var city = TextEditingController();
  var address = TextEditingController();

  String languageFormat = 'en';

  bool confirmPasswordVisible = false;
  bool passwordVisible = false;
  bool conditionCheck = false;

  String deviceType = "";
  String currentTimeZone = "";
  String longitude = "";
  String latitude = "";

  // List of country codes
  final List<String> countryCodes = ["+1", "+44", "+91", "+33", "+49"];
  // Selected country code
  String selectedCountryCode = "+1";
  static const platform = MethodChannel('com.avispets.jeanne/custom');

  @override
  void initState() {
    super.initState();
    _signUpBlock = SignUpBlock(context);
    _createProfileBloc = CreateProfileBloc(context);
    debugPrint(
        'LANGUAGE FORMAT : ${widget.languageFormat['languageFormat'].toString()}');
    debugPrint('LANGUAGE FORMAT : ${widget.languageFormat}');

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createProfileBloc,
      child: BlocListener<CreateProfileBloc, BlocStates>(
        listener: (context, state) {
          print('BlocListener => $state');
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
            // Map<String, String> mapData2 = {
            //   'firstName': firstName.text.toString(),
            //   'lastName': lastName.text.toString(),
            //   'email': email.text.toString(),
            //   'password': password.text.toString(),
            //   'timezone': currentTimeZone.toString(),
            //   'latitude': latitude.toString(),
            //   'longitude': longitude.toString(),
            //   'deviceToken':
            //       sharedPref.getString(SharedKey.deviceToken).toString(),
            //   'deviceType': deviceType.toString(),
            //   'pseudo': pseudo.text.toString(),
            //   'phoneNumber': phoneNumber.text.toString(),
            //   'city': city.text.toString(),
            //   'address': address.text.toString(),
            // };
            //
            // Navigator.pushNamed(context, RoutesName.otpScreen,
            //     arguments: mapData2);
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      width: 31,
                                      height: 31,
                                      child: Image.asset(
                                        'assets/images/icons/prev.png',
                                      ),
                                    ),
                                  ),
                                  HeaderAuthWidget()
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 25, left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: MyString.bold('accountCreate'.tr,
                                          25, MyColor.black, TextAlign.center)),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(50), // Restrict to 50 characters
                                            ],
                                            controller: firstName,
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 50),
                                            style:
                                                TextStyle(color: MyColor.black),
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 10),
                                                  child: Image.asset(
                                                    color: MyColor.orange2,
                                                    'assets/images/icons/user.png',
                                                    width: 10,
                                                    height: 10,
                                                  ),
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 12),
                                              hintText: 'firstName'.tr,
                                              hintStyle: TextStyle(
                                                color: MyColor.textFieldBorder,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                5), // Optional spacing between fields
                                        Expanded(
                                          child: TextField(
                                            controller: lastName,
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 50),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(50), // Restrict to 50 characters
                                            ],
                                            style:
                                                TextStyle(color: MyColor.black),
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 12),
                                              hintText: 'lastName'.tr,
                                              hintStyle: TextStyle(
                                                color: MyColor.textFieldBorder,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                    child: TextField(

                                      controller: email,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 50),
                                      style: TextStyle(color: MyColor.black),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50), // Restrict to 50 characters
                                      ],
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
                                                      horizontal: 12,
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
                                        hintText: 'email'.tr,
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(50), // Restrict to 50 characters
                                            ],
                                            controller: password,
                                            obscureText:
                                                passwordVisible ? false : true,
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 50),
                                            style:
                                                TextStyle(color: MyColor.black),
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
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
                                                      vertical: 5,
                                                      horizontal: 12),
                                              hintText: 'password2'.tr,
                                              hintStyle: TextStyle(
                                                  color:
                                                      MyColor.textFieldBorder,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(50), // Restrict to 50 characters
                                            ],
                                            controller: confirmPassword,
                                            obscureText: confirmPasswordVisible
                                                ? false
                                                : true,
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 50),
                                            style:
                                                TextStyle(color: MyColor.black),
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              suffixIcon: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      confirmPasswordVisible =
                                                          !confirmPasswordVisible;
                                                      setState(() {});
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 10),
                                                      child: Image.asset(
                                                        confirmPasswordVisible
                                                            ? 'assets/images/logos/visible.png'
                                                            : 'assets/images/icons/invisible.png',
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ),
                                                  )),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 12),
                                              hintText: 'confirmPassword'.tr,
                                              hintStyle: TextStyle(
                                                  color:
                                                      MyColor.textFieldBorder,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              CountryCodePicker(
                                                onChanged: (code){
                                                  print(code);
                                                  setState(() {
                                                    selectedCountryCode = code.toString();
                                                  });
                                                },
                                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                initialSelection: 'US',
                                                showFlag: false,
                                                // optional. Shows only country name and flag
                                                showCountryOnly: false,
                                                // optional. Shows only country name and flag when popup is closed.
                                                showOnlyCountryWhenClosed: false,
                                                // optional. aligns the flag and the Text left
                                                alignLeft: false,
                                              ),
                                              // Container(
                                              //   width: 50, // Adjust width as needed
                                              //   padding: const EdgeInsets.symmetric(horizontal: 1),
                                              //
                                              //   child: DropdownButton<String>(
                                              //     isExpanded: true,
                                              //     value: selectedCountryCode,
                                              //     icon: const Icon(Icons.arrow_drop_down),
                                              //     underline: SizedBox(), // Removes default underline
                                              //     items: countryCodes.map<DropdownMenuItem<String>>((String code) {
                                              //       return DropdownMenuItem<String>(
                                              //         value: code,
                                              //         child: Text(
                                              //           code,
                                              //           style: TextStyle(color: MyColor.black, fontSize: 12),
                                              //         ),
                                              //       );
                                              //     }).toList(),
                                              //     onChanged: (String? newValue) {
                                              //       setState(() {
                                              //         selectedCountryCode = newValue!;
                                              //       });
                                              //     },
                                              //   ),
                                              // ),
                                              // Phone Number Input Field
                                              Expanded(
                                                child: TextField(
                                                  controller: phoneNumber,
                                                  scrollPadding:
                                                      const EdgeInsets.only(
                                                          bottom: 50),
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  style: TextStyle(
                                                      color: MyColor.black),
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    // prefixIcon: SizedBox(
                                                    //   width: 20,
                                                    //   height: 20,
                                                    //   child: Padding(
                                                    //     padding:
                                                    //         const EdgeInsets
                                                    //             .symmetric(
                                                    //             horizontal: 12,
                                                    //             vertical: 10),
                                                    //     child: Image.asset(
                                                    //       'assets/images/icons/phone.png',
                                                    //       width: 20,
                                                    //       height: 20,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5,
                                                            horizontal: 0),
                                                    hintText: 'phone'.tr,
                                                    hintStyle: TextStyle(
                                                      color: MyColor
                                                          .textFieldBorder,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: pseudo,
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 50),
                                            style:
                                                TextStyle(color: MyColor.black),
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 12),
                                              hintText: 'pseudo'.tr,
                                              hintStyle: TextStyle(
                                                  color:
                                                      MyColor.textFieldBorder,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: city,
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 50),
                                            style:
                                                TextStyle(color: MyColor.black),
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 10),
                                                    child: Image.asset(
                                                      'assets/images/icons/map.png',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  )),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 12),
                                              hintText: 'city'.tr,
                                              hintStyle: TextStyle(
                                                  color:
                                                      MyColor.textFieldBorder,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: address,
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 50),
                                            style:
                                                TextStyle(color: MyColor.black),
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 12),
                                              hintText: 'address'.tr,
                                              hintStyle: TextStyle(
                                                  color:
                                                      MyColor.textFieldBorder,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Color(
                                        0xffEBEBEB), // Color of the divider
                                    thickness: 1, // Thickness of the line
                                    indent: 16, // Start padding
                                    endIndent: 16, // End padding
                                  ),
                                  if (widget.languageFormat['languageFormat']
                                          .toString() ==
                                      'en')
                                    Container(
                                      margin: const EdgeInsets.all(15),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              conditionCheck = !conditionCheck;
                                              setState(() {});
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: MyColor.orange2),
                                                    color: MyColor.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: Icon(
                                                  Icons.check,
                                                  color: conditionCheck
                                                      ? MyColor.orange2
                                                      : MyColor.white,
                                                  size: 12,
                                                )),
                                          ),
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: '${"iAgreeTo".tr} ',
                                                      style: TextStyle(
                                                        decorationThickness: 1,
                                                        color:
                                                            Colors.transparent,
                                                        fontSize: 12,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            MyColor.white,
                                                        shadows: [
                                                          Shadow(
                                                              color: Color(
                                                                  0xff5B6170),
                                                              offset:
                                                                  const Offset(
                                                                      0, -2))
                                                        ],
                                                      ),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            'termsAndConditions'
                                                                .tr,
                                                        style: TextStyle(
                                                          decorationThickness:
                                                              3,
                                                          color: Colors
                                                              .transparent,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decorationColor:
                                                              MyColor.orange2,
                                                          shadows: [
                                                            Shadow(
                                                                color: MyColor
                                                                    .orange2,
                                                                offset:
                                                                    const Offset(
                                                                        0, -2))
                                                          ],
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                if (!await launchUrl(
                                                                    Uri.parse(ApiStrings
                                                                        .terms
                                                                        .toString()))) {
                                                                  throw Exception(
                                                                      'Could not launch ${Uri.parse(ApiStrings.privacy.toString())}');
                                                                }
                                                              }),
                                                    TextSpan(
                                                        text: ' & ',
                                                        style: TextStyle(
                                                          decorationThickness:
                                                              1,
                                                          color: Colors
                                                              .transparent,
                                                          fontSize: 14,
                                                          decorationColor:
                                                              MyColor.white,
                                                          shadows: [
                                                            Shadow(
                                                                color: Color(
                                                                    0xff5B6170),
                                                                offset:
                                                                    const Offset(
                                                                        0, -2))
                                                          ],
                                                        )),
                                                    TextSpan(
                                                        text: 'privacy'.tr,
                                                        style: TextStyle(
                                                          decorationThickness:
                                                              3,
                                                          color: Colors
                                                              .transparent,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decorationColor:
                                                              MyColor.orange2,
                                                          shadows: [
                                                            Shadow(
                                                                color: MyColor
                                                                    .orange2,
                                                                offset:
                                                                    const Offset(
                                                                        0, -2))
                                                          ],
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                if (!await launchUrl(
                                                                    Uri.parse(ApiStrings
                                                                        .privacy
                                                                        .toString()))) {
                                                                  throw Exception(
                                                                      'Could not launch ${Uri.parse(ApiStrings.privacy.toString())}');
                                                                }
                                                              }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (widget.languageFormat['languageFormat']
                                          .toString() ==
                                      'fr')
                                    Container(
                                      margin: const EdgeInsets.all(15),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              conditionCheck = !conditionCheck;
                                              setState(() {});
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: MyColor.orange2),
                                                    color: MyColor.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: Icon(
                                                  Icons.check,
                                                  color: conditionCheck
                                                      ? MyColor.orange2
                                                      : MyColor.white,
                                                  size: 12,
                                                )),
                                          ),
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: '${"iAgreeTo".tr} ',
                                                      style: TextStyle(
                                                        decorationThickness: 1,
                                                        color:
                                                            Colors.transparent,
                                                        fontSize: 12,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            MyColor.grey,
                                                        shadows: [
                                                          Shadow(
                                                              color: MyColor
                                                                  .textFieldBorder,
                                                              offset:
                                                                  const Offset(
                                                                      0, -2))
                                                        ],
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'termsAndConditions'
                                                          .tr
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        decorationThickness: 1,
                                                        color:
                                                            Colors.transparent,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            MyColor.orange2,
                                                        shadows: [
                                                          Shadow(
                                                              color: MyColor
                                                                  .orange2,
                                                              offset:
                                                                  const Offset(
                                                                      0, -2))
                                                        ],
                                                      ),
                                                    ),
                                                    TextSpan(
                                                        text: ' & ',
                                                        style: TextStyle(
                                                          decorationThickness:
                                                              1,
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              MyColor.white,
                                                          shadows: [
                                                            Shadow(
                                                                color: MyColor
                                                                    .textFieldBorder,
                                                                offset:
                                                                    const Offset(
                                                                        0, -2))
                                                          ],
                                                        )),
                                                    TextSpan(
                                                        text: 'privacy'
                                                            .tr
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          decorationThickness:
                                                              1,
                                                          color: Colors
                                                              .transparent,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              MyColor.orange2,
                                                          shadows: [
                                                            Shadow(
                                                                color: MyColor
                                                                    .orange2,
                                                                offset:
                                                                    const Offset(
                                                                        0, -2))
                                                          ],
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                if (!await launchUrl(
                                                                    Uri.parse(ApiStrings
                                                                        .privacy
                                                                        .toString()))) {
                                                                  throw Exception(
                                                                      'Could not launch ${Uri.parse(ApiStrings.privacy.toString())}');
                                                                }
                                                              }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
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

                                  //fb
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
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(25))),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10,),
                                            Image.asset(
                                              'assets/images/logos/google.png',
                                              height: 25,
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: MyString.bold(
                                                  "signingg".tr,
                                                  12,
                                                  Color(0xff4F2020),
                                                  TextAlign.center, // Ensure text is centered
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final FirebaseAuth _auth =
                                          FirebaseAuth.instance;
                                      FacebookAuth.instance.logOut();
                                      await _auth.signOut();
                                      var result = await loginWithFacebook();
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(25))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10,),
                                          Image.asset(
                                            'assets/images/logos/facebook.png',
                                            height: 25,
                                            width: 25,
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: MyString.bold(
                                                "signinfb".tr,
                                                12,
                                                Color(0xff4F2020),
                                                TextAlign.center, // Ensure text is centered
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
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
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.symmetric(
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

                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();

                                      // _createProfileBloc.add(
                                      //     GetCreateProfileEvent(
                                      //         firstName.text.trim().toString(),
                                      //         lastName.text.trim().toString(),
                                      //         email.text.trim().toString(),
                                      //         password.text.trim().toString(),
                                      //         confirmPassword.text
                                      //             .trim()
                                      //             .toString(),
                                      //         currentTimeZone,
                                      //         latitude,
                                      //         longitude,
                                      //         pseudo.text.trim().toString(),
                                      //         phoneNumber.text
                                      //             .trim()
                                      //             .toString(),
                                      //         city.text.trim().toString(),
                                      //         address.text.trim().toString(),
                                      //         deviceType,
                                      //         conditionCheck));

                                      // Call the signup function

                                      print(" conditionCheck ${ conditionCheck}");

                                      String phone ="";
                                        if(selectedCountryCode.isNotEmpty && phoneNumber.text.trim().isNotEmpty)
                                          {
                                            phone= selectedCountryCode + phoneNumber.text.trim().toString();
                                          }
                                          else{
                                            phone = "";
                                        }



                                      _signUpBlock.add(
                                        GetCreateProfileEvent(
                                          firstName.text.trim().toString(),
                                          lastName.text.trim().toString(),
                                          email.text.trim().toString(),
                                          password.text.trim().toString(),
                                          confirmPassword.text
                                              .trim()
                                              .toString(),
                                          currentTimeZone,
                                          latitude,
                                          longitude,
                                          pseudo.text.trim().toString(),
                                            phone,
                                          city.text.trim().toString(),
                                          address.text.trim().toString(),
                                          deviceType,
                                          conditionCheck,
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 59,
                                        width: 141,
                                        decoration: BoxDecoration(
                                            color: MyColor.orange2,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(22))),
                                        child: MyString.med('next'.tr, 15,
                                            MyColor.white, TextAlign.center),
                                      ),
                                    ),
                                  ),
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
                Container(
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: MyColor.orange2,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: MyString.bold('chooseYourLanguage'.tr.toUpperCase(),
                        20, MyColor.white, TextAlign.center)),
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

  void appleLogin() {
    platform.invokeMethod('iOSAppleLogin');
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    longitude = position.longitude.toString();
    latitude = position.latitude.toString();

    debugPrint("CURRENT LOCATION LONGITUDE : $longitude ");
    debugPrint("CURRENT LOCATION LATITUDE : $latitude ");
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
          'Google'
      );
      // }
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
    print(
        '================================$res================================');
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
                  'screen': 'signup',
                },
                (route) => false);
          }
        } else {
          Map<String, dynamic> mapData = {'googleLogin': true};
          Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.selectAnimal,
              arguments: mapData,
              (route) => false
          );
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
}
