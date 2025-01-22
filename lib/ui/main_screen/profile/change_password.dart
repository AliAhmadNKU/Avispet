import 'package:avispets/bloc/change_password_bloc.dart';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late ChangePasswordBloc _changePasswordBloc;
  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  var currentPassword = TextEditingController();
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = ChangePasswordBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _changePasswordBloc,
      child: BlocListener<ChangePasswordBloc, BlocStates>(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: HeaderWidget2(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 18),
                            child: MyString.bold('updatePassword'.tr, 27,
                                MyColor.title, TextAlign.start),
                          ),

                          //!@currentPassword
                          Container(
                            child: TextField(
                              controller: currentPassword,
                              obscureText: oldPasswordVisible ? false : true,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/icons/pwd.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
                                suffixIcon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        oldPasswordVisible =
                                            !oldPasswordVisible;
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          oldPasswordVisible
                                              ? 'assets/images/logos/visible.png'
                                              : 'assets/images/icons/invisible.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    )),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'oldPassword'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
                            thickness: 1, // Thickness of the line
                            indent: 16, // Start padding
                            endIndent: 16, // End padding
                          ),

                          //!@newPassword
                          Container(
                            child: TextField(
                              controller: newPassword,
                              obscureText: newPasswordVisible ? false : true,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/icons/pwd.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
                                suffixIcon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        newPasswordVisible =
                                            !newPasswordVisible;
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          newPasswordVisible
                                              ? 'assets/images/logos/visible.png'
                                              : 'assets/images/icons/invisible.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    )),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'newPassword'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
                            thickness: 1, // Thickness of the line
                            indent: 16, // Start padding
                            endIndent: 16, // End padding
                          ),

                          //!@confirmPassword
                          Container(
                            child: TextField(
                              controller: confirmPassword,
                              obscureText:
                                  confirmPasswordVisible ? false : true,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/icons/pwd.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
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
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          confirmPasswordVisible
                                              ? 'assets/images/logos/visible.png'
                                              : 'assets/images/icons/invisible.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    )),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'confirmPassword'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
                            thickness: 1, // Thickness of the line
                            indent: 16, // Start padding
                            endIndent: 16, // End padding
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          //!@mainButton
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              _changePasswordBloc.add(GetChangePasswordEvent(
                                  currentPassword.text.trim().toString(),
                                  newPassword.text.trim().toString(),
                                  confirmPassword.text.trim().toString()));
                              setState(() {});
                            },
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                height: 59,
                                width: 141,
                                decoration: BoxDecoration(
                                    color: MyColor.orange2,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(22))),
                                child: Flexible(
                                    child: MyString.med('save'.tr, 18,
                                        MyColor.white, TextAlign.center)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
