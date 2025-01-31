import 'dart:async';
import 'dart:convert';

import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../bloc/bloc_events.dart';
import '../../bloc/bloc_states.dart';
import '../../bloc/signup_bloc.dart';
import '../../models/otp_model.dart';
import '../../utils/common_function/loader_screen.dart';
import '../../utils/my_color.dart';
import '../../utils/my_routes/route_name.dart';

class OtpScreen extends StatefulWidget {
  Map<String, String> data;

  OtpScreen({super.key, required this.data});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late SignUpBlock _signUpBlock;

  String verificationCode = "";
  String resendOtp = "";
  bool resendOtpValid = false;

  int secondsRemaining = 120;
  bool enableResend = false;
  Timer? timer;
  int currentTab = 1;

  @override
  initState() {
    super.initState();
    _signUpBlock = SignUpBlock(context);
    Future.delayed(Duration.zero, () {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (secondsRemaining != 0) {
            secondsRemaining--;
          } else {
            enableResend = true;
          }
        });
      });
    });
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 120;
      enableResend = false;
    });
  }

  String getFormattedTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _signUpBlock,
      child: BlocListener<SignUpBlock, BlocStates>(
        listener: (context, state) {
          if (state is Loading) {
            LoadingDialog.show(context);
          }
          if (state is Loaded) {
            LoadingDialog.hide(context);
          }
          if (state is NextScreen) {
            Map<String, dynamic> mapData = {'googleLogin': false};
            Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.selectAnimal,
                arguments: mapData,
                (route) => false);
          }
        },
        child: Scaffold(
          backgroundColor: MyColor.white,
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: currentTab == 1
                  ? GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderWidget2(),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: MyString.bold('verification'.tr, 27,
                                    MyColor.title, TextAlign.start)),
                            Container(
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: "otpDec".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "mont_Med",
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.textBlack0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " ${widget.data['email']}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "mont_Med",
                                          fontWeight: FontWeight.w400,
                                          color: MyColor.orange2,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyString.reg("rememberSpam".tr, 12,
                                MyColor.textBlack0, TextAlign.start),

                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: OtpTextField(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                contentPadding: EdgeInsets.all(10),
                                fieldHeight: 46,
                                fieldWidth: 46,
                                fillColor: Color(0xffF6F6F6),
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(100),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                focusedBorderColor:
                                    MyColor.orange2.withOpacity(.3),
                                disabledBorderColor: MyColor.textFieldBorder,
                                enabledBorderColor: MyColor.orange2,
                                numberOfFields: 6,
                                borderColor: MyColor.orange2,
                                showFieldAsBox: true,
                                onCodeChanged: (String code) {
                                  debugPrint("code =  $code");
                                  // verificationCode = code;
                                  // setState(() {});
                                },
                                onSubmit: (String verificationCode) {
                                  this.verificationCode = verificationCode;
                                }, // end onSubmit
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                /* if (verificationCode.isEmpty) {
                            toaster(context, "enterOtp".tr);
                          } else if (verificationCode != AllApi.otp) {
                            toaster(context, "otpInvalid".tr);
                          } else {
                            _signUpBlock.add(GetCreateProfileEvent(
                                widget.data["firstName"],
                                widget.data["lastName"],
                                widget.data["email"],
                                widget.data["password"],
                                "",
                                widget.data["timezone"],
                                widget.data['latitude'],
                                widget.data["longitude"],
                                widget.data["pseudo"],
                                widget.data["phone"],
                                widget.data["city"],
                                widget.data["address"],
                                widget.data["deviceType"]
                            ));
                          }

                          print("Otp ---------- ${AllApi.otp}");*/
                                _signUpBlock.add(GetCreateProfileEvent(
                                    widget.data["firstName"],
                                    widget.data["lastName"],
                                    widget.data["email"],
                                    widget.data["password"],
                                    "",
                                    widget.data["timezone"],
                                    widget.data['latitude'],
                                    widget.data["longitude"],
                                    widget.data["pseudo"],
                                    widget.data["phone"],
                                    widget.data["city"],
                                    widget.data["address"],
                                    widget.data["deviceType"],
                                    true));
                              },
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 30, bottom: 30, right: 25, left: 25),
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 151,
                                  decoration: BoxDecoration(
                                      color: MyColor.orange2,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(22))),
                                  child: MyString.med('verify'.tr, 15,
                                      MyColor.white, TextAlign.center),
                                ),
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: "notReceived".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "mont_Med",
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.textBlack0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: (!enableResend)
                                              ? " ${getFormattedTime(secondsRemaining)}"
                                              : " ${'resend'.tr}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "mont_Med",
                                            fontWeight: FontWeight.w400,
                                            color: MyColor.orange2,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (enableResend) {
                                                Map<String, String> mapData = {
                                                  'email': widget.data['email']
                                                      .toString(),
                                                };

                                                var res = await AllApi.otpApi(
                                                    mapData);
                                                var result =
                                                    jsonDecode(res.toString());
                                                OtpModel _otpModel =
                                                    OtpModel.fromJson(result);

                                                AllApi.otp = _otpModel.data!.otp
                                                    .toString();
                                                _resendCode();
                                                setState(() {});
                                              }
                                            }),
                                    ]),
                              ),
                            ),
                            //!@resend Otp

                            const SizedBox(height: 50),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  currentTab = 2;
                                });
                              },
                              child: Text(
                                'otp2'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "mont_Med",
                                  fontWeight: FontWeight.w400,
                                  color: MyColor.textBlack0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderWidget2(),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: MyString.bold('verification'.tr, 27,
                                    MyColor.title, TextAlign.start)),
                            Container(
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: "otp2Dec".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "mont_Med",
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.textBlack0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " +${widget.data['phone']}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "mont_Med",
                                          fontWeight: FontWeight.w700,
                                          color: MyColor.textBlack0,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyString.reg("rememberSpam".tr, 12,
                                MyColor.textBlack0, TextAlign.start),

                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: OtpTextField(
                                fieldHeight: 46,
                                fieldWidth: 46,
                                fillColor: Color(0xffF6F6F6),
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(100),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                focusedBorderColor:
                                    MyColor.orange2.withOpacity(.3),
                                disabledBorderColor: MyColor.textFieldBorder,
                                enabledBorderColor: MyColor.orange2,
                                numberOfFields: 6,
                                borderColor: MyColor.orange2,
                                showFieldAsBox: true,
                                onCodeChanged: (String code) {
                                  debugPrint("code =  $code");
                                  // verificationCode = code;
                                  // setState(() {});
                                },
                                onSubmit: (String verificationCode) {
                                  this.verificationCode = verificationCode;
                                }, // end onSubmit
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                /* if (verificationCode.isEmpty) {
                            toaster(context, "enterOtp".tr);
                          } else if (verificationCode != AllApi.otp) {
                            toaster(context, "otpInvalid".tr);
                          } else {
                            _signUpBlock.add(GetCreateProfileEvent(
                                widget.data["firstName"],
                                widget.data["lastName"],
                                widget.data["email"],
                                widget.data["password"],
                                "",
                                widget.data["timezone"],
                                widget.data['latitude'],
                                widget.data["longitude"],
                                widget.data["pseudo"],
                                widget.data["phone"],
                                widget.data["city"],
                                widget.data["address"],
                                widget.data["deviceType"]
                            ));
                          }

                          print("Otp ---------- ${AllApi.otp}");*/
                                _signUpBlock.add(GetCreateProfileEvent(
                                    widget.data["firstName"],
                                    widget.data["lastName"],
                                    widget.data["email"],
                                    widget.data["password"],
                                    "",
                                    widget.data["timezone"],
                                    widget.data['latitude'],
                                    widget.data["longitude"],
                                    widget.data["pseudo"],
                                    widget.data["phone"],
                                    widget.data["city"],
                                    widget.data["address"],
                                    widget.data["deviceType"],
                                    true));
                              },
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 30, bottom: 30, right: 25, left: 25),
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 151,
                                  decoration: BoxDecoration(
                                      color: MyColor.orange2,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(22))),
                                  child: MyString.med('verify'.tr, 15,
                                      MyColor.white, TextAlign.center),
                                ),
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: "notReceived".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "mont_Med",
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.textBlack0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: (!enableResend)
                                              ? " ${getFormattedTime(secondsRemaining)}"
                                              : " ${'resend'.tr}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "mont_Med",
                                            fontWeight: FontWeight.w400,
                                            color: MyColor.orange2,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (enableResend) {
                                                Map<String, String> mapData = {
                                                  'email': widget.data['email']
                                                      .toString(),
                                                };

                                                var res = await AllApi.otpApi(
                                                    mapData);
                                                var result =
                                                    jsonDecode(res.toString());
                                                OtpModel _otpModel =
                                                    OtpModel.fromJson(result);

                                                AllApi.otp = _otpModel.data!.otp
                                                    .toString();
                                                _resendCode();
                                                setState(() {});
                                              }
                                            }),
                                    ]),
                              ),
                            ),
                            //!@resend Otp

                            const SizedBox(height: 50),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  currentTab = 1;
                                });
                              },
                              child: Text(
                                'otp3'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "mont_Med",
                                  fontWeight: FontWeight.w400,
                                  color: MyColor.textBlack0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
