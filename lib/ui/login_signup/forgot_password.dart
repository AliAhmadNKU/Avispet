import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../bloc/forgot_bloc.dart';
import '../../utils/common_function/loader_screen.dart';
import '../../utils/common_function/toaster.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late ForgotBloc _forgotBloc;
  var email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _forgotBloc = ForgotBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _forgotBloc,
      child: BlocListener<ForgotBloc, BlocStates>(
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
            Navigator.pop(context);
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 5),
                            child: HeaderWidget2(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: EdgeInsets.only(right: 5, left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: MyString.bold(
                                          '${"forgotPassword".tr} ${"forgotPassword2".tr}',
                                          27,
                                          MyColor.title,
                                          TextAlign.center)),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: MyString.reg(
                                          'forgotPasswordDesc'.tr,
                                          12,
                                          MyColor.textBlack0,
                                          TextAlign.start)),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    child: TextField(
                                      controller: email,
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
                                                  const EdgeInsets.all(12.0),
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
                                            color: MyColor.textBlack0,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Color(0xffEBEBEB),
                                    thickness: 1,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();
                                      _forgotBloc.add(GetForgotEvent(
                                          email.text.trim().toString()));
                                      setState(() {});
                                    },
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 59,
                                        width: 151,
                                        decoration: BoxDecoration(
                                            color: MyColor.orange2,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(22))),
                                        child: MyString.med('submit'.tr, 15,
                                            MyColor.white, TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 120)
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
            )),
      ),
    );
  }
}
