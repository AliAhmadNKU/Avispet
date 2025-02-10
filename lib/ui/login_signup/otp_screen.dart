import 'dart:async';
import 'dart:convert';

import 'package:avispets/ui/widgets/header_auth_widget.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../bloc/bloc_events.dart';
import '../../bloc/bloc_states.dart';
import '../../bloc/signup_bloc.dart';
import '../../models/otp_model.dart';
import '../../utils/common_function/loader_screen.dart';
import '../../utils/my_color.dart';
import '../../utils/my_routes/route_name.dart';

class OtpScreen extends StatefulWidget {
  Map<String, dynamic> data;
  bool sreenCheck = false;

  OtpScreen({super.key, required this.data,required this.sreenCheck});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late SignUpBlock _signUpBlock;

  String verificationCode = "";
  String resendOtp = "";
  bool resendOtpValid = false;
  String screen = 'signup';
  Map<String, String> payload = {};
  bool loader = false;

  int secondsRemaining = 120;
  bool enableResend = false;
  Timer? timer;
  int currentTab = 1;
  bool socialLogin = false;

  @override
  initState() {
    super.initState();

    screen = widget.data['screen']!;


    if(screen=="login")
      {
        payload = widget.data['data']!;
        _resendOTPForVerfication();

      }
    else{
      payload = widget.data['data']!;
    }

    if(payload['googleLogin'] != null){
      socialLogin = true;
    }
    _signUpBlock = SignUpBlock(context);
    _startTimer();
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
                (route) => false
            );
          }
        },
        child: Scaffold(
          backgroundColor: MyColor.white,
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: !loader ?
              _buildOTPSCreenNew() : Container(
                margin: EdgeInsets.only(top: 100),
                child: progressBar(),
              ),
              // _buildOTPSCreenOLD(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOtp() async {
    try{
      setState(() {
        loader = true;
      });
      var res = await AllApi.postMethodApi(
          "${ApiStrings.verifyOtp}",{
        'phone_number':screen=="login"?  payload["data"]: payload['phone_number'],

        'otp': verificationCode,
      });
      print(res);
      var result = jsonDecode(res.toString());
      if (result['status'] == 200) {
        toaster(context, result['data']['message']);
        if(screen == 'signup' ||screen=="login" ){
          Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.loginScreen,
              // RoutesName.selectAnimal,
              arguments: payload,
                  (route) => false
          );
        }
      }
      if(mounted){
        setState(() {
          loader = false;
        });
      }
    }
    catch(e){
        print(e);
        setState(() {
          loader = false;
        });
    }
  }

  Widget _buildOTPSCreenOLD() {
    if(currentTab == 1){
      return GestureDetector(
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
                          text: " ${payload['email']}",
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
                    verificationCode = code;
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
                  if(verificationCode.isEmpty) {
                    toaster(context, "enterOtp".tr);
                    return;
                  }
                  if(verificationCode.length < 6){
                    toaster(context, "Please enter a valid 6 digit code");
                    return;
                  }
                  verifyOtp();
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
                  // _signUpBlock.add(GetCreateProfileEvent(
                  //     widget.data["firstName"],
                  //     widget.data["lastName"],
                  //     widget.data["email"],
                  //     widget.data["password"],
                  //     "",
                  //     widget.data["timezone"],
                  //     widget.data['latitude'],
                  //     widget.data["longitude"],
                  //     widget.data["pseudo"],
                  //     widget.data["phone"],
                  //     widget.data["city"],
                  //     widget.data["address"],
                  //     widget.data["deviceType"],
                  //     true)
                  // );
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
                                    'email': payload['email']
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
      );
    }
    else{
      return GestureDetector(
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
                          text: " +${payload['phone']}",
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
                  // _signUpBlock.add(GetCreateProfileEvent(
                  //     widget.data["firstName"],
                  //     widget.data["lastName"],
                  //     widget.data["email"],
                  //     widget.data["password"],
                  //     "",
                  //     widget.data["timezone"],
                  //     widget.data['latitude'],
                  //     widget.data["longitude"],
                  //     widget.data["pseudo"],
                  //     widget.data["phone"],
                  //     widget.data["city"],
                  //     widget.data["address"],
                  //     widget.data["deviceType"],
                  //     true));
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
                                    'email': payload['email']
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
      );
    }
  }

  Widget _buildOTPSCreenNew() {
    return GestureDetector(
      onTap: () =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HeaderWidget2(),
            Row(
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5),
                  child: HeaderAuthWidget(),
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: MyString.bold('verification'.tr, 27,
                    MyColor.title, TextAlign.start)),
            Container(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                    text: "otpDec2".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "mont_Med",
                      fontWeight: FontWeight.w400,
                      color: MyColor.textBlack0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: " ${ payload["data"]}",
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
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (String value) {
                  verificationCode = value;
                  print("Changed: $value");
                },
                onCompleted: (String value) {
                  verificationCode = value;
                  print("Completed: $value");
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,
                  borderRadius: BorderRadius.circular(100),
                  borderWidth: 1,
                  fieldHeight: 46,
                  fieldWidth: 46,
                  activeFillColor: Color(0xffF6F6F6),
                  inactiveFillColor: Color(0xffF6F6F6),
                  selectedFillColor: Color(0xffF6F6F6),
                  activeColor: MyColor.orange2.withOpacity(.3),
                  inactiveColor: MyColor.textFieldBorder,
                  selectedColor: MyColor.orange2,
                ),
                keyboardType: TextInputType.number,
                enableActiveFill: false,
              )
              // OtpTextField(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   contentPadding: EdgeInsets.all(10),
              //   fieldHeight: 46,
              //   fieldWidth: 46,
              //   fillColor: Color(0xffF6F6F6),
              //   borderWidth: 1,
              //   borderRadius: BorderRadius.circular(100),
              //   inputFormatters: [
              //     FilteringTextInputFormatter.digitsOnly
              //   ],
              //   focusedBorderColor:
              //   MyColor.orange2.withOpacity(.3),
              //   disabledBorderColor: MyColor.textFieldBorder,
              //   enabledBorderColor: MyColor.orange2,
              //   numberOfFields: 6,
              //   borderColor: MyColor.orange2,
              //   showFieldAsBox: true,
              //   onCodeChanged: (String code) {
              //     debugPrint("code =  $code");
              //     verificationCode = code;
              //     // verificationCode = code;
              //     // setState(() {});
              //   },
              //   onSubmit: (String verificationCode) {
              //     this.verificationCode = verificationCode;
              //   }, // end onSubmit
              // ),
            ),

            GestureDetector(
              onTap: () {
                if(verificationCode.isEmpty) {
                  toaster(context, "enterOtp".tr);
                  return;
                }
                if(verificationCode.length < 6){
                  toaster(context, "Please enter a valid 6 digit code");
                  return;
                }
                verifyOtp();
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
                // _signUpBlock.add(GetCreateProfileEvent(
                //     widget.data["firstName"],
                //     widget.data["lastName"],
                //     widget.data["email"],
                //     widget.data["password"],
                //     "",
                //     widget.data["timezone"],
                //     widget.data['latitude'],
                //     widget.data["longitude"],
                //     widget.data["pseudo"],
                //     widget.data["phone"],
                //     widget.data["city"],
                //     widget.data["address"],
                //     widget.data["deviceType"],
                //     true)
                // );
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
                                _resendOTP();
                                // OtpModel _otpModel =
                                // OtpModel.fromJson(result);
                                //
                                // AllApi.otp = _otpModel.data!.otp
                                //     .toString();
                                // setState(() {});
                              }
                            }),
                    ]),
              ),
            ),
            //!@resend Otp

            const SizedBox(height: 50),
            // GestureDetector(
            //   onTap: () async {
            //     setState(() {
            //       currentTab = 2;
            //     });
            //   },
            //   child: Text(
            //     'otp2'.tr,
            //     style: TextStyle(
            //       fontSize: 12,
            //       fontFamily: "mont_Med",
            //       fontWeight: FontWeight.w400,
            //       color: MyColor.textBlack0,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
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

  @override
  void dispose() {
    if(timer != null){
      timer!.cancel();
    }
    super.dispose();
  }

  Future<void> _resendOTP() async {
    setState(() {
      loader = true;
    });
    Map<String, String> mapData = {
      'phone_number': payload['phone_number']
          .toString(),
    };

    var res = await AllApi.resendOTP(mapData);
    var result = jsonDecode(res.toString());
    print("result otp code $result");
    if(result['status'] == 200){
      toaster(context, result['message']);
      secondsRemaining = 120;
      enableResend = false;
      _startTimer();
    }
    setState(() {
      loader = false;
    });
  }


  Future<void> _resendOTPForVerfication( ) async {
    setState(() {
      loader = true;
    });

    String phoneNumber = widget.data['data']['data'].toString();

    print("mapData ${phoneNumber}");
    Map<String, String> mapData = {
      'phone_number': phoneNumber
          .toString(),
    };


    print("mapData ${mapData}");
    var res = await AllApi.resendOTP(mapData);
    var result = jsonDecode(res.toString());
    print("result otp code $result");
    if(result['status'] == 200){
      toaster(context, result['message']);
      secondsRemaining = 120;
      enableResend = false;
      _startTimer();
    }
    setState(() {
      loader = false;
    });
  }

}
