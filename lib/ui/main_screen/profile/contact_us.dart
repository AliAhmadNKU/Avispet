import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/contact_us_bloc.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/toaster.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late ContactUsBloc _contactUsBloc;

  var name =TextEditingController();
  var lastName =TextEditingController();
  var email =TextEditingController();
  var message =TextEditingController();

  @override
  void initState() {
    super.initState();
    _contactUsBloc = ContactUsBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _contactUsBloc,
      child: BlocListener<ContactUsBloc, BlocStates>(
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
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            backgroundColor: MyColor.newBackgroundColor,
                      appBar: AppBar(
              surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: MyColor.newBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(20, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Image.asset('assets/images/icons/back_icon.png', color: MyColor.white),
            ),
          ),
          title: MyString.bold('contactUs'.tr.toUpperCase(), 18, MyColor.white, TextAlign.center),
                      ),
                      body: SafeArea(
                        child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                            color: MyColor.grey,
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40))
                                        ),
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(40))),
                            child: TextField(
                              controller: name,
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
                                        'assets/images/icons/person.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                hintText: 'firstName'.tr,
                                hintStyle: TextStyle(color: MyColor.textFieldBorder, fontSize: 14),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(40))),
                            child: TextField(
                              controller: lastName,
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
                                        'assets/images/icons/person.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                hintText: 'lastName'.tr,
                                hintStyle: TextStyle(color: MyColor.textFieldBorder, fontSize: 14),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(40))),
                            child: TextField(
                              controller: email,
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
                                        'assets/images/icons/email.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                hintText: 'email'.tr,
                                hintStyle: TextStyle(color: MyColor.textFieldBorder, fontSize: 14),
                              ),
                            ),
                          ),
                                  
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: MyColor.liteGrey,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 3.0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: TextField(
                              controller: message,
                              maxLines: 3,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                hintText: 'message'.tr,
                                hintStyle: TextStyle(color: MyColor.textFieldBorder, fontSize: 14),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:  () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              _contactUsBloc.add(GetContactUsEvent(name.text.trim().toString(), email.text.trim().toString() , message.text.trim().toString()));
                              setState(() { });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 25,right: 30,left: 30),
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(color: MyColor.orange, borderRadius: const BorderRadius.all(Radius.circular(50))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 50,),
                                  MyString.med('submit'.tr.toUpperCase(), 15, MyColor.white, TextAlign.center),
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Image.asset("assets/images/onboard/intro_button_icon.png"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                                            ),
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
    );
  }
}
