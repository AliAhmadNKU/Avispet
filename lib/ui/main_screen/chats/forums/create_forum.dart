import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../bloc/create_forum_topic.dart';
import '../../../../models/forum/forum_category.dart';
import '../../../../models/my_animal_model.dart';
import '../../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../../utils/common_function/loader_screen.dart';
import '../../../../utils/common_function/my_string.dart';
import '../../../../utils/common_function/toaster.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/my_routes/route_name.dart';
import '../../../../utils/shared_pref.dart';

class CreateForum extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  const CreateForum({super.key, this.mapData});

  @override
  State<CreateForum> createState() => _CreateForumState();
}

class _CreateForumState extends State<CreateForum> {
  String htmlString = '';
  String animalCode = '';
  var selectSpecies = TextEditingController();
  var title = TextEditingController();
  var desc = TextEditingController();
  late CreateForumTopicBloc forumTopicBloc;
  bool conditionCheck = false;
  String forumCategoryCode = '';
  MyAnimalModel _myAnimalModel = MyAnimalModel();
  ForumCategory forumCategory = ForumCategory();
  List<String> myCategoryStringList = [];
  List<String> myAnimalList = [];

  @override
  void initState() {
    forumTopicBloc = CreateForumTopicBloc(context);
    _myAnimal();
    getForumCategory();
    super.initState();
  }

  _myAnimal() async {
    var res =
        await AllApi.getMethodApi("${ApiStrings.myAnimals}?page=1&limit=20");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      myAnimalList.clear();
      _myAnimalModel = MyAnimalModel.fromJson(result);

      for (int i = 0; i < _myAnimalModel.data!.length; i++) {
        myAnimalList.add(_myAnimalModel.data![i].name.toString());
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => forumTopicBloc,
      child: BlocListener<CreateForumTopicBloc, BlocStates>(
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
            backgroundColor: MyColor.white,
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderWidget2(),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyString.bold('postQuestion'.tr, 27,
                                  MyColor.title, TextAlign.center),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: widget.mapData!['image']
                                        .toString()
                                        .isNotEmpty
                                    ? Image.network(
                                        '${widget.mapData!['image'].toString()}',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/onboard/placeholder_image.png',
                                        fit: BoxFit.cover,
                                        height: 50),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyColor
                                            .orange2, // Orange shadow color
                                        blurRadius: 10.0, // Blur intensity
                                        offset: Offset(5, 5), // Shadow position
                                      ),
                                    ],
                                    color: MyColor.card,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyString.med('${'title'.tr}', 12,
                                        MyColor.black, TextAlign.center),
                                    TextField(
                                      controller: title,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 50),
                                      style: TextStyle(color: MyColor.black),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0),
                                        hintText: '${'title'.tr}',
                                        hintStyle: TextStyle(
                                            color: MyColor.textBlack0,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              /* const SizedBox(height: 12),
                                          MyString.med('${'headingSelectAnimal'.tr}*', 18, MyColor.black, TextAlign.center),
                                          if(myAnimalList.isEmpty)
                                            MyString.med('Note: ${'noAnimalCreate'.tr}', 12, MyColor.red, TextAlign.center),
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                          border: Border.all(color: MyColor.textFieldBorder), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                            child: DropdownButton<String>(
                        underline: Container(),
                        isExpanded: true,
                        value: selectSpecies.text.isEmpty ? null : selectSpecies.text,
                        icon: Container(margin: EdgeInsets.only(right: 10), child: const Icon(Icons.keyboard_arrow_down)),
                        items: myAnimalList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Container(margin: EdgeInsets.only(left: 10), child: Text(items)),
                          );
                        }).toList(),



                        onChanged: (String? newValue) {
                          setState(() {
                            selectSpecies.text = newValue!;
                            for (int i = 0; i < _myAnimalModel.data!.length; i++) {
                              if (selectSpecies.text.toString() == _myAnimalModel.data![i].name.toString()) {
                                animalCode = _myAnimalModel.data![i].id.toString();
                              }
                            }
                          });
                          print(animalCode);
                        },
                                            ),
                                          ),*/

                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 0),
                                decoration: BoxDecoration(
                                    color: MyColor.card,
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyColor
                                            .orange2, // Orange shadow color
                                        blurRadius: 10.0, // Blur intensity
                                        offset: Offset(5, 5), // Shadow position
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyString.med('${'selectCategory'.tr}', 12,
                                        MyColor.black, TextAlign.center),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: MyColor.card,
                                      ),
                                      child: DropdownButton<String>(
                                        underline: Container(),
                                        isExpanded: true,
                                        value: selectSpecies.text.isEmpty
                                            ? null
                                            : selectSpecies.text,
                                        icon: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: const Icon(
                                                Icons.keyboard_arrow_down)),
                                        items: myCategoryStringList
                                            .map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(items)),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectSpecies.text = newValue!;
                                            for (int i = 0;
                                                i < forumCategory.data!.length;
                                                i++) {
                                              if (sharedPref
                                                      .getString(SharedKey
                                                          .languageValue)
                                                      .toString() ==
                                                  'en') {
                                                if (selectSpecies.text
                                                        .toString() ==
                                                    forumCategory.data![i].name
                                                        .toString()) {
                                                  forumCategoryCode =
                                                      forumCategory.data![i].id
                                                          .toString();
                                                }
                                              } else {
                                                if (selectSpecies.text
                                                        .toString() ==
                                                    forumCategory
                                                        .data![i].nameFr
                                                        .toString()) {
                                                  forumCategoryCode =
                                                      forumCategory.data![i].id
                                                          .toString();
                                                }
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyColor
                                            .orange2, // Orange shadow color
                                        blurRadius: 10.0, // Blur intensity
                                        offset: Offset(5, 5), // Shadow position
                                      ),
                                    ],
                                    color: MyColor.card,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyString.med('${'yourMessage'.tr}', 12,
                                        MyColor.black, TextAlign.start),
                                    TextField(
                                      controller: desc,
                                      maxLines: 3,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 50),
                                      style: TextStyle(color: MyColor.black),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: '${'yourMessage'.tr}',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0),
                                        hintStyle: TextStyle(
                                            color: MyColor.textBlack0,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  conditionCheck = !conditionCheck;
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, top: 15),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: conditionCheck
                                                ? MyColor.orange2
                                                : MyColor.grey,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: conditionCheck
                                            ? Icon(
                                                Icons.check,
                                                color: MyColor.white,
                                                size: 15,
                                              )
                                            : Container(),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: MyString.med(
                                              'receiveNotification'.tr,
                                              14,
                                              MyColor.textBlack0,
                                              TextAlign.start),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  setState(() {
                                    /*        htmlString ='';
                          final json = jsonEncode(_controller.document.toDelta().toJson());
                          print(' 1111 $_controller');
                          print(' $json');
                          List<dynamic> jsonList = jsonDecode(json);
                          for (var item in jsonList) {
                            if (item.containsKey('insert')) {
                              htmlString += '<span';
                              if (item.containsKey('attributes')) {
                                var attributes = item['attributes'];
                                if (attributes.containsKey('bold') && attributes['bold']) {
                                  htmlString += ' style="font-weight: bold;"';
                                }
                                if (attributes.containsKey('italic') && attributes['italic']) {
                                  htmlString += ' style="font-style: italic;"';
                                }
                                if (attributes.containsKey('underline') && attributes['underline']) {
                                  htmlString += ' style="text-decoration: underline;"';
                                }
                                if (attributes.containsKey('strike') && attributes['strike']) {
                                  htmlString += ' style="text-decoration: line-through;"';
                                }
                              }
                              htmlString += '>';
                              htmlString += item['insert'];
                              htmlString += '</span>';
                            }
                          }
                          print(' $htmlString');
                                  */

                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    forumTopicBloc.add(GetCreateForumTopicEvent(
                                        widget.mapData!['forumId'],
                                        title.text.toString().trim(),
                                        desc.text.toString().trim(),
                                        forumCategoryCode,
                                        conditionCheck ? '1' : '0'));
                                  });
                                },
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 59,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: MyColor.orange2,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(22))),
                                    child: MyString.med('submit'.tr, 16,
                                        MyColor.white, TextAlign.center),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                        //!@title
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getForumCategory() async {
    var res = await AllApi.getMethodApi(
        '${ApiStrings.forumCategories}?page=1&limit=50');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      setState(() {
        myCategoryStringList.clear();
        forumCategory = ForumCategory.fromJson(result);
        for (int i = 0; i < forumCategory.data!.length; i++) {
          if (sharedPref.getString(SharedKey.languageValue).toString() ==
              'en') {
            myCategoryStringList.add(forumCategory.data![i].name.toString());
          } else {
            myCategoryStringList.add(forumCategory.data![i].nameFr.toString());
          }
        }
      });
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
