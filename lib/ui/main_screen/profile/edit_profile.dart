import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../bloc/edit_profile_bloc.dart';
import '../../../models/department_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late EditProfileBloc _editProfileBloc;

  var department = TextEditingController();
  String departmentEng = '';
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var pseudo = TextEditingController();
  var phone = TextEditingController();
  var city = TextEditingController();
  var address = TextEditingController();
  TextEditingController bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _getDepartment();
    Future.delayed(Duration.zero, () async {
      await GetApi.getProfileApi(
          context, sharedPref.getString(SharedKey.userId).toString());
      fillFields();
      setState(() {});
    });
    _editProfileBloc = EditProfileBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _editProfileBloc,
      child: BlocListener<EditProfileBloc, BlocStates>(
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: HeaderWidget2(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, bottom: 20),
                            child: MyString.bold('editProfile'.tr, 27,
                                MyColor.title, TextAlign.start),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: firstName,
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
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            color: MyColor.orange2,
                                            'assets/images/icons/user.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintText: 'firstName'.tr,
                                    hintStyle: TextStyle(
                                        color: MyColor.textFieldBorder,
                                        fontSize: 14),
                                  ),
                                )),
                                SizedBox(
                                    width:
                                        5), // Optional spacing between fields
                                Expanded(
                                  child: TextField(
                                    controller: lastName,
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
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                              color: MyColor.orange2,
                                              'assets/images/icons/user.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          )),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                      hintText: 'lastName'.tr,
                                      hintStyle: TextStyle(
                                          color: MyColor.textFieldBorder,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
                            thickness: 1, // Thickness of the line
                            indent: 16, // Start padding
                            endIndent: 16, // End padding
                          ),

                          /* Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: MyColor.white,

                                  borderRadius: const BorderRadius.all(Radius.circular(50))),
                              child: DropdownButton<String>(
                                underline: Container(),
                                isExpanded: true,
                                value: department.text.isEmpty || !departmentList.contains(department.text)
                                    ? null
                                    : department.text,
                                hint: Text('    Department of residence'),
                                icon: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: const Icon(Icons.keyboard_arrow_down),
                                ),
                                items: departmentList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        items,
                                        style: TextStyle(color: MyColor.black, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    department.text = newValue ?? '';
                                    for (int i = 0; i < departmentModel.data!.length; i++) {
                                      if (newValue != null &&
                                          (newValue.contains(departmentModel.data![i].name.toString()) ||
                                              newValue.contains(departmentModel.data![i].nameFr.toString()))) {
                                        departmentEng = departmentModel.data![i].name.toString();
                                        debugPrint('SELECTED DEPARTMENT :: $departmentEng');
                                      }
                                    }
                                  });
                                },
                              ),

                            ),
                            Divider(
                              color: Color(
                                  0xffEBEBEB), // Color of the divider
                              thickness: 1, // Thickness of the line
                              indent: 16, // Start padding
                              endIndent: 16, // End padding
                            ),*/
                          Container(
                            child: TextField(
                              controller: email,
                              enabled: false, // This fully disables the field
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
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                hintText: 'email'.tr,
                                hintStyle: TextStyle(
                                  color: MyColor.textFieldBorder,
                                  fontSize: 14,
                                ),
                                filled: true, // Helps visually show it's disabled
                                fillColor: Colors.grey[200], // Light grey background to indicate disabled
                              ),
                            ),
                          ),
                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
                            thickness: 1, // Thickness of the line
                            indent: 16, // Start padding
                            endIndent: 16, // End padding
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: phone,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            child: Image.asset(
                                              'assets/images/icons/phone.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          )),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                      hintText: 'phone'.tr,
                                      hintStyle: TextStyle(
                                          color: MyColor.textFieldBorder,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: pseudo,
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
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                              color: MyColor.orange2,
                                              'assets/images/icons/user.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          )),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                      hintText: 'pseudo'.tr,
                                      hintStyle: TextStyle(
                                          color: MyColor.textFieldBorder,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            child: Image.asset(
                                              'assets/images/icons/map.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          )),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                      hintText: 'city'.tr,
                                      hintStyle: TextStyle(
                                          color: MyColor.textFieldBorder,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: address,
                                    scrollPadding:
                                        const EdgeInsets.only(bottom: 50),
                                    style: TextStyle(color: MyColor.black),
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                      hintText: 'address'.tr,
                                      hintStyle: TextStyle(
                                          color: MyColor.textFieldBorder,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
                            thickness: 1, // Thickness of the line
                            indent: 16, // Start padding
                            endIndent: 16, // End padding
                          ),
                          //!@bio-bar
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(40))),
                            child: TextField(
                              controller: bio,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              maxLength: 250,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style:
                                  TextStyle(color: MyColor.black, fontSize: 14),
                              decoration: InputDecoration(
                                counterText: '',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/icons/t.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'enterBio'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          Divider(
                            color: Color(0xffEBEBEB), // Color of the divider
                            thickness: 1, // Thickness of the line
                            indent: 16, // Start padding
                            endIndent: 16, // End padding
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              _editProfileBloc.add(GetEditProfileEvent(
                                  firstName.text.trim().toString(),
                                  lastName.text.trim().toString(),
                                  email.text.trim().toString(),
                                  pseudo.text.trim().toString(),
                                  phone.text.trim().toString(),
                                  city.text.trim().toString(),
                                  address.text.trim().toString(),
                                  bio.text.trim().toString(),
                                  'editProfile'
                                  //departmentEng.trim().toString()
                                  ));

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
                                child: MyString.med('save'.tr, 16,
                                    MyColor.white, TextAlign.center),
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

  List<String> departmentList = [];
  DepartmentModel departmentModel = DepartmentModel();
  _getDepartment() async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.departments}?page=1&limit=2000");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      departmentList.clear();
      departmentModel = DepartmentModel.fromJson(result);

      for (int i = 0; i < departmentModel.data!.length; i++) {
        if (sharedPref.getString(SharedKey.languageValue).toString() == 'en') {
          departmentList.add(departmentModel.data![i].name.toString());
        } else {
          departmentList.add(departmentModel.data![i].nameFr.toString());
        }
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    setState(() {});
  }

  fillFields() {
    firstName.text = GetApi.getProfileModel.data!.firstName.toString();
    lastName.text = GetApi.getProfileModel.data!.lastName.toString();
    email.text = GetApi.getProfileModel.data!.email.toString();
    pseudo.text = GetApi.getProfileModel.data!.pseudo != null
        ? GetApi.getProfileModel.data!.pseudo.toString()
        : '';
    phone.text = GetApi.getProfileModel.data!.phoneNumber != null
        ? GetApi.getProfileModel.data!.phoneNumber.toString()
        : '';
    city.text = GetApi.getProfileModel.data!.city != null
        ? GetApi.getProfileModel.data!.city.toString()
        : '';

    bio.text = GetApi.getProfileModel.data!.biography != null
        ? GetApi.getProfileModel.data!.biography.toString()
        : '';

    address.text = GetApi.getProfileModel.data!.area != null
        ? GetApi.getProfileModel.data!.area.toString()
        : '';

    // address.text = GetApi.getProfileModel.data!.address != null
    //     ? GetApi.getProfileModel.data!.address.toString()
    //     : '';
    // bio.text = GetApi.getProfileModel.data!.biography != null
    //     ? GetApi.getProfileModel.data!.biography.toString()
    //     : '';
    department.text = GetApi.getProfileModel.data!.city != null
        ? GetApi.getProfileModel.data!.city.toString()
        : '';
    setState(() {});
  }
}
