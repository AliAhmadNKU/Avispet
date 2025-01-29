import 'dart:async';
import 'dart:convert';

import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class ForgetPasswordOtpScreen extends StatefulWidget {
  final Map<String, String> data;

  const ForgetPasswordOtpScreen({Key? key, required this.data})
      : super(key: key);

  @override
  State<ForgetPasswordOtpScreen> createState() =>
      _ForgetPasswordOtpScreenState();
}

class _ForgetPasswordOtpScreenState extends State<ForgetPasswordOtpScreen> {
  int secondsRemaining = 120;
  bool enableResend = false;
  Timer? timer;
  int currentTab = 1;
  bool loader = false;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _startTimer();
    });
    super.initState();
  }

  String getFormattedTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }



  String verification = "";
  @override
  Widget build(BuildContext context) {
    final String email = widget.data['email'] ?? '';
    final TextEditingController _otpController = TextEditingController();

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(title: Text('Verify OTP')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: !loader ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget2(),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: MyString.bold(
                      'verification'.tr, 27, MyColor.title, TextAlign.start)),
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
                          text: " ${email}",
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
              MyString.reg(
                  "rememberSpam".tr, 12, MyColor.textBlack0, TextAlign.start),
              // Text(
              //   (!enableResend)
              //       ? " ${getFormattedTime(secondsRemaining)}"
              //       : " ${'resend'.tr}",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontFamily: "mont_Med",
              //     fontWeight: FontWeight.w400,
              //     color: MyColor.orange2,
              //   ),
              // ),
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  focusedBorderColor: MyColor.orange2.withOpacity(.3),
                  disabledBorderColor: MyColor.textFieldBorder,
                  enabledBorderColor: MyColor.orange2,
                  numberOfFields: 6,
                  borderColor: MyColor.orange2,
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {
                    debugPrint("code =  $code");
                    verification = code;
                    // verificationCode = code;
                    // print(verificationCode);
                  },
                  onSubmit: (String verificationCode) {
                    verification = verificationCode;
                    print(verification);
                  }, // end onSubmit
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if(verification.isEmpty) {
                    toaster(context, "enterOtp".tr);
                    return;
                  }
                  if(verification.length < 6){
                    toaster(context, "Please enter a valid 6 digit code");
                    return;
                  }
                  verifyOtp();
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(22))),
                    child: MyString.med(
                        'verify'.tr, 15, MyColor.white, TextAlign.center),
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
                              if(enableResend){
                                _resendOTP();
                              }
                              }),
                      ]),
                ),
              ),
            ],
          ) : Container(
            margin: EdgeInsets.only(top: 100),
            child: progressBar(),
          ),
        ),
      ),
    );
  }

  Future<void> _resendOTP() async {
    setState(() {
      loader = true;
    });
    Map<String, String> mapData = {
      'email': widget.data['email']!,
    };
    debugPrint("FORGOT-PASSWORD MAP DATA IS : $mapData");

    var res = await AllApi.forgotApi(mapData);

    var result = jsonDecode(res.toString());

    // emit(Loaded());
    if (result['status'] == 200) {
      toaster(context, result['message']);
      secondsRemaining = 120;
      enableResend = false;
      _startTimer();
    }
    setState(() {
      loader = false;
    });
  }

  void _startTimer() {
    Future.delayed(Duration.zero, () {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if(mounted){
          setState(() {
            if (secondsRemaining != 0) {
              secondsRemaining--;
            } else {
              enableResend = true;
            }
          });
        }
      });
    });
  }

  Future<void> verifyOtp() async {
    try{
      setState(() {
        loader = true;
      });
      final mapData = {
        "reset_token": "$verification",
      };

      debugPrint("SIGN-UP MAP DATA: $mapData");
      var res = await AllApi.verifyOtpApiForgotPassword(
          mapData, ApiStrings.forgotPasswordOtp);
      var result = jsonDecode(res.toString());
      print(result);
      if (result['status'] == 200) {
        Navigator.pushNamed(
          context,
          RoutesName.newPassword,
          arguments: {'email': widget.data['email']!},
        );
        print(verification);
      }
      toaster(context, result['message']);
      setState(() {
        loader = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        loader = false;
      });
    }
  }

  @override
  void dispose() {
    if(timer != null){
      timer!.cancel();
    }
    super.dispose();
  }
}
