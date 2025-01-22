import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../bloc/bloc_events.dart';
import '../../bloc/bloc_states.dart';
import '../../bloc/edit_profile_bloc.dart';
import '../../models/profile_list.dart';
import '../../utils/common_function/dialogs/bottom_language.dart';
import '../../utils/common_function/loader_screen.dart';

class SelectAnimal extends StatefulWidget {
  Map<String, dynamic> mapData;

  SelectAnimal({super.key, required this.mapData});

  @override
  State<SelectAnimal> createState() => _SelectAnimalState();
}

class _SelectAnimalState extends State<SelectAnimal> {
  List<Model> list = [];
  int selectedAnimal = -1;
  late EditProfileBloc _editProfileBloc;
  var referCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editProfileBloc = EditProfileBloc(context);

    print('asdasd ${widget.mapData['googleLogin']}');

    // Open BottomSheet after the widget tree is built
    if (widget.mapData['googleLogin'] == true) {
      widget.mapData['googleLogin'] = false;
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          referBottomSheet(context);
        });
      });
    }

    _listSet();
  }

  _listSet() {
    list.clear();
    list.add(Model('dog'.tr, 'assets/images/logos/dog.png', false));
    list.add(Model('cat'.tr, 'assets/images/logos/cat.png', false));
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
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                        child: HeaderWidget2(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 75,
                              child: Center(
                                  child: MyString.bold('desc1'.tr, 25,
                                      MyColor.black, TextAlign.center)),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 75,
                                child: Center(
                                  child: MyString.reg('desc2'.tr, 14,
                                      MyColor.textBlack0, TextAlign.center),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 250,
                              child: ListView.builder(
                                scrollDirection:
                                    Axis.horizontal, // Set to horizontal
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemExtent: 120,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _listSet();
                                        list[index].isSelect = true;
                                        selectedAnimal = index;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Stack(children: [
                                          Container(
                                            child: Image.asset(
                                                list[index].image.toString()),
                                          ),
                                          if (list[index].isSelect)
                                            Positioned(
                                              top: 50,
                                              right: 30,
                                              child: Container(
                                                child: Image.asset(
                                                  'assets/images/icons/check.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                        ]),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        (index == 2) ? 35 : 0),
                                                child: MyString.bold(
                                                  list[index].name.toString(),
                                                  12,
                                                  MyColor.textBlack0,
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Future.delayed(Duration.zero, () async {
                                      if (selectedAnimal + 1 == 0) {
                                        toaster(
                                            context, StringKey.selectPetType);
                                      } else {
                                        if (selectedAnimal == 2) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              RoutesName.mainPage,
                                              arguments: 0,
                                              (route) => false);
                                        } else {
                                          // selectedAnimal : 1 for dog , 2 for cat
                                          Map<String, dynamic> mapData = {
                                            'from': 0,
                                            'selectedAnimal': selectedAnimal + 1
                                          };
                                          Navigator.pushNamed(
                                              context, RoutesName.createAnimal,
                                              arguments: mapData);
                                        }
                                      }
                                    });
                                    setState(() {});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 59,
                                    width: 141,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    decoration: BoxDecoration(
                                        color: MyColor.orange2,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40))),
                                    child: MyString.med('next'.tr, 15,
                                        MyColor.white, TextAlign.center),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RoutesName.mainPage,
                                        arguments: 0,
                                        (route) => false);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                        top: 25, bottom: 20),
                                    child: Text('later'.tr,
                                        style: TextStyle(
                                          decorationThickness: 2,
                                          color: Colors.transparent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          decorationColor: MyColor.orange2,
                                          shadows: [
                                            Shadow(
                                                color: MyColor.orange2,
                                                offset: const Offset(0, -2))
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  referBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: MyColor.grey,
      elevation: 1,
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context1, myState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: MyColor.grey,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: MyString.med('skip'.tr.toUpperCase(), 15,
                                MyColor.black, TextAlign.center)),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              MyString.med("referCode".tr, 15, MyColor.black,
                                  TextAlign.center),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      new BoxShadow(
                                        color: MyColor.liteGrey,
                                        blurRadius: 2.0,
                                        offset: new Offset(0.0, 3.0),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40))),
                                child: TextField(
                                  controller: referCode,
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
                                            'assets/images/icons/person.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        )),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintText: 'referCode'.tr,
                                    hintStyle: TextStyle(
                                        color: MyColor.textFieldBorder,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            if (referCode.text.trim().toString().isEmpty) {
                              toaster(context, "enterReferral".tr);
                            } else {
                              _editProfileBloc.add(GetEditProfileEvent('', '',
                                  '', '', '', '', '', '', 'signup'));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 30, bottom: 20, right: 25, left: 25),
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: MyColor.orange2,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 50,
                                ),
                                MyString.med('next'.tr.toUpperCase(), 15,
                                    MyColor.white, TextAlign.center),
                                Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Image.asset(
                                      "assets/images/onboard/intro_button_icon.png"),
                                )
                              ],
                            ),
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
}
