import 'dart:convert';
import 'dart:io';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/create_animal_bloc.dart';
import '../../../utils/common_function/crop_image.dart';

import '../../../utils/common_function/dialogs/dialog_success.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';

import 'package:http/http.dart' as http;

import '../../../utils/my_routes/route_name.dart';

class CreateAnimal extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  CreateAnimal({super.key, this.mapData});

  @override
  State<CreateAnimal> createState() => _CreateAnimalState();
}

class _CreateAnimalState extends State<CreateAnimal> {
  late CreateAnimalBloc _animalBloc;

  bool doNotKnowDob = false;
  bool doNotKnowBreed = false;
  bool anotherAnimal = false;
  bool secondTimeAdd = false;
  bool breedListEnable = false;

  // controllers
  var name = TextEditingController();
  var dob = TextEditingController();
  var age = TextEditingController();

  var race = TextEditingController();
  var weight = TextEditingController();
  List<File> imageList = [];

  File? fileImage;

  int type = 1;
  int gender = 1;
  int sterilized = 1;
  String sendRace = '';
  String sendDate = '';
  List<String> imageUrlList = [];
  @override
  void initState() {
    super.initState();
    _animalBloc = CreateAnimalBloc(context);
    if (widget.mapData != null) {
      type = widget.mapData?['selectedAnimal'];
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      // Replace with your actual token

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://16.171.146.189:8001/api/v1/upload/post-animal-image"),
      );

      // Add headers
      request.headers.addAll({
        'Authorization':
            "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
        'Accept': 'application/json',
      });

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'animal_image',
        imageFile.path,
      ));

      // Send the request
      var response = await request.send();

      print(response);

      // Parse the response
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseBody = json.decode(responseData.body);

        if (responseBody["error"] == false) {
          return responseBody["data"]["imageUrl"];
        } else {
          throw Exception("Image upload failed: ${responseBody['message']}");
        }
      } else {
        throw Exception(
            "Failed to upload image. HTTP Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _animalBloc,
      child: BlocListener<CreateAnimalBloc, BlocStates>(
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
            Future.delayed(Duration.zero, () async {
              print(anotherAnimal);

              if (!anotherAnimal)
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) {
                    return success('animal'.tr, 1);
                  },
                );
              print(anotherAnimal);
              if (anotherAnimal) {
                name.text = '';
                dob.text = '';
                age.text = '';
                weight.text = '';
                race.text = '';
                fileImage = null;
                imageList.clear();
                type = 1;
                gender = 1;
                sterilized = 1;
                sendRace = '';
                sendDate = '';
                imageUrlList.clear();
                secondTimeAdd = true;
                doNotKnowDob = false;
                doNotKnowBreed = false;
                anotherAnimal = false;
              } else {
                if (widget.mapData?['from'] == 0) {
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.myAnimal,
                      arguments: 0,
                      (route) => false);
                } else {
                  Navigator.pop(context);
                }
              }
              setState(() {});
            });
          }
        },
        child: Scaffold(
          backgroundColor: MyColor.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: HeaderWidget2(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: MyString.bold('addAnimal'.tr, 25,
                                MyColor.black, TextAlign.center),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //!@name

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyString.med('nameAnimal'.tr, 16,
                                        MyColor.black, TextAlign.center),
                                    TextField(
                                      controller: name,
                                      style: TextStyle(color: MyColor.black),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: 'nameAnimal'.tr,
                                        hintStyle: TextStyle(
                                            color: Color(0xffBEBEBE),
                                            fontSize: 14),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                      ),
                                    ),
                                    Divider(
                                      color: Color(
                                          0xffEBEBEB), // Color of the divider
                                      thickness: 1, // Thickness of the line
                                      indent: 16, // Start padding
                                      endIndent: 16, // End padding
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyString.med('species'.tr, 16, MyColor.black,
                                        TextAlign.center),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: type == 1 ? 'dog' : 'cat',
                                        items: [
                                          DropdownMenuItem(
                                            value: 'dog',
                                            child: Text('Dog'.tr),
                                          ),
                                          DropdownMenuItem(
                                            value: 'cat',
                                            child: Text('Cat'.tr),
                                          ),
                                        ],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            if (newValue == 'dog') {
                                              type = 1;
                                            } else if (newValue == 'cat') {
                                              type = 2;
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          //!@race
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyString.med('gender'.tr, 16, MyColor.black,
                                        TextAlign.center),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: gender == null
                                            ? null
                                            : (gender == 1 ? 'female' : 'male'),
                                        hint: Text(
                                            'Select gender'), // Placeholder text
                                        items: [
                                          DropdownMenuItem(
                                            value: 'female',
                                            child: Text('female'.tr),
                                          ),
                                          DropdownMenuItem(
                                            value: 'male',
                                            child: Text('male'.tr),
                                          ),
                                        ],
                                        onChanged: (String? newValue) {
                                          print(newValue);
                                          setState(() {
                                            if (newValue == 'female') {
                                              gender = 1;
                                            } else if (newValue == 'male') {
                                              gender = 2;
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyString.med('${'race'.tr}', 16,
                                        MyColor.black, TextAlign.center),
                                    Container(
                                      child: TextField(
                                        controller: race,
                                        readOnly: true,
                                        style: TextStyle(color: MyColor.black),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: 'race'.tr,
                                          hintStyle: TextStyle(
                                              color: Color(0xffBEBEBE),
                                              fontSize: 14),
                                        ),
                                        onTap: () async {
                                          Map<String, dynamic> mapData = {
                                            'type': type,
                                            'field': race.text.toString()
                                          };
                                          if (!doNotKnowBreed) {
                                            var value = await Navigator.pushNamed(
                                                context, RoutesName.animalBreed,
                                                arguments: mapData);
                                            if (value.toString().isNotEmpty) {
                                              Map<String, String> data =
                                                  value as Map<String, String>;
                                              race.text =
                                                  data['nameShow'].toString();
                                              sendRace =
                                                  data['nameSend'].toString();
                                            }
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Divider(
                                      color: Color(
                                          0xffEBEBEB), // Color of the divider
                                      thickness: 1, // Thickness of the line
                                      indent: 16, // Start padding
                                      endIndent: 16, // End padding
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //!@gender

                          //!@dob
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyString.med('${'Age'.tr}', 16, MyColor.black,
                                        TextAlign.center),
                                    Container(
                                      child: TextField(
                                          controller: age,
                                          readOnly: false,
                                          style: TextStyle(color: MyColor.black),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: '20 months'.tr,
                                            hintStyle: TextStyle(
                                                color: Color(0xffBEBEBE),
                                                fontSize: 14),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              age.text = value;
                                            });
                                          }),
                                    ),
                                    Divider(
                                      color: Color(
                                          0xffEBEBEB), // Color of the divider
                                      thickness: 1, // Thickness of the line
                                      indent: 16, // Start padding
                                      endIndent: 16, // End padding
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyString.med('${'weight'.tr}(Kg)', 16,
                                        MyColor.black, TextAlign.center),
                                    Container(
                                      child: TextField(
                                        controller: weight,
                                        readOnly: false,
                                        style: TextStyle(color: MyColor.black),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: 'weight'.tr,
                                          hintStyle: TextStyle(
                                              color: Color(0xffBEBEBE),
                                              fontSize: 14),
                                        ),
                                        onTap: () async {},
                                      ),
                                    ),
                                    Divider(
                                      color: Color(
                                          0xffEBEBEB), // Color of the divider
                                      thickness: 1, // Thickness of the line
                                      indent: 16, // Start padding
                                      endIndent: 16, // End padding
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),

                          //!@photo
                          MyString.med(
                              'photo'.tr, 16, MyColor.black, TextAlign.center),

                          Container(
                            height: imageList.length >= 3 ? 230 : 150,
                            width: double.infinity,
                            child: GridView.builder(
                              itemCount: imageList.length + 1,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Number of items per row
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                if (index == imageList.length) {
                                  // Add More Button
                                  return GestureDetector(
                                    onTap: () async {
                                      print('==============================');

                                      String? result =
                                          await cameraPhoto(context, "create_animal");
                                      File? returnImage;

                                      // Pick image from Camera or Gallery
                                      if (result == '0') {
                                        returnImage = await pickImage(
                                            context, ImageSource.camera);
                                      } else if (result == '1') {
                                        returnImage = await pickImage(
                                            context, ImageSource.gallery);
                                      }

                                      print(returnImage);
                                      if (returnImage != null) {
                                        fileImage = returnImage;

                                        print(returnImage);
                                        String? uploadedImageUrl =
                                            await uploadImage(fileImage!);

                                        if (uploadedImageUrl != null) {
                                          setState(() {
                                            imageList.add(File(fileImage!.path));
                                            imageUrlList.add(uploadedImageUrl);
                                          });
                                          print(
                                              "Image uploaded successfully: $uploadedImageUrl");
                                        } else {
                                          print("Image upload failed.");
                                        }
                                      }

                                      setState(() {});
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: MyColor.white,
                                        border:
                                            Border.all(color: MyColor.orange2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/icons/addpic.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                          Text('Add More',
                                              style: TextStyle(
                                                  color: MyColor.orange2)),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  // Display selected images
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          imageList[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Remove image from list
                                            setState(() {
                                              imageList.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          //radio 3
                          if (!secondTimeAdd)
                            GestureDetector(
                              onTap: () {
                                anotherAnimal = !anotherAnimal;
                                setState(() {});
                              },
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Checkbox(
                                        value: anotherAnimal,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            anotherAnimal = newValue ?? false;
                                          });
                                        },
                                        activeColor:
                                            MyColor.orange2, // Color when checked
                                        checkColor: MyColor
                                            .white, // Icon color when checked
                                        side: BorderSide(
                                            color: MyColor.orange2,
                                            width:
                                                1), // Outline color when unchecked
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        child: MyString.reg(
                                            "anotherAnimal".tr,
                                            14,
                                            MyColor.textFieldBorder,
                                            TextAlign.center)),
                                  ],
                                ),
                              ),
                            ),

                          //mainButton
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                FocusManager.instance.primaryFocus!.unfocus();
                                _animalBloc.add(GetCreateAnimalEvent(
                                    name.text.trim().toString(),
                                    type == 1 ? 'Dog' : 'Cat',
                                    doNotKnowBreed ? 'N/A' : sendRace,
                                    int.parse(weight.text),
                                    int.parse(age.text),
                                    gender == 1 ? 'Female' : 'Male',
                                    sterilized == 1 ? 'Yes' : 'No',
                                    imageUrlList));
                              });
                            },
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                alignment: Alignment.center,
                                height: 59,
                                width: 151,
                                decoration: BoxDecoration(
                                    color: MyColor.orange2,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25))),
                                child: MyString.med('add'.tr, 18, MyColor.white,
                                    TextAlign.center),
                              ),
                            ),
                          ),

                          //doItLater
                          // if (secondTimeAdd)
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pushNamed(context, RoutesName.mainPage,
                          //         arguments: 0);
                          //   },
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     child: Text('later'.tr,
                          //         style: TextStyle(
                          //           decorationThickness: 2,
                          //           color: Colors.transparent,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w500,
                          //           decorationColor: MyColor.orange2,
                          //           shadows: [
                          //             Shadow(
                          //                 color: MyColor.orange2,
                          //                 offset: const Offset(0, -2))
                          //           ],
                          //         )),
                          //   ),
                          // ),
                        ],
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
