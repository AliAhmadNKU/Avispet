import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/bloc/new_password_bloc.dart';
import 'package:avispets/ui/widgets/header_auth_widget.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/my_color.dart';

class NewPassword extends StatefulWidget {
  final Map<String, String> data;
  const NewPassword({super.key, required this.data});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  late NewPasswordBloc _newPasswordBloc;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newPasswordBloc = NewPasswordBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    final String email = widget.data['email'] ?? '';
    return BlocProvider(
      create: (context) => _newPasswordBloc,
      child: BlocListener<NewPasswordBloc, BlocStates>(
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
        child: PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: MyColor.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                                child: Text(
                                  'updatePassword'.tr,
                                  style: TextStyle(
                                      fontSize: 27, color: MyColor.title),
                                ),
                              ),
                              Divider(
                                color: Color(0xffEBEBEB),
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                              Container(
                                child: TextField(
                                  controller: newPassword,
                                  obscureText: !newPasswordVisible,
                                  style: TextStyle(color: MyColor.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/icons/pwd.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          newPasswordVisible =
                                          !newPasswordVisible;
                                        });
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
                                    ),
                                    hintText: 'newPassword'.tr,
                                    hintStyle: TextStyle(
                                        color: MyColor.textFieldBorder,
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
                              Container(
                                child: TextField(
                                  controller: confirmPassword,
                                  obscureText: !confirmPasswordVisible,
                                  style: TextStyle(color: MyColor.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/icons/pwd.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          confirmPasswordVisible =
                                          !confirmPasswordVisible;
                                        });
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
                                    ),
                                    hintText: 'confirmPassword'.tr,
                                    hintStyle: TextStyle(
                                        color: MyColor.textFieldBorder,
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
                              SizedBox(height: 100),
                              GestureDetector(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  _newPasswordBloc.add(GetNewPasswordEvent(
                                      email.trim(),
                                      newPassword.text.trim(),
                                      confirmPassword.text.trim()));
                                },
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 59,
                                    width: 141,
                                    decoration: BoxDecoration(
                                        color: MyColor.orange2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22))),
                                    child: Text(
                                      'save'.tr,
                                      style: TextStyle(
                                          fontSize: 18, color: MyColor.white),
                                    ),
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
        ),
      ),
    );
  }
}
