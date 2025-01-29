import 'dart:io';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../bloc/edit_animal.dart';
import '../../../utils/common_function/crop_image.dart';
import '../../../utils/common_function/loader_screen.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';

class EditAnimal extends StatefulWidget {
  final Map<String, dynamic>? mapData;

  EditAnimal({super.key, this.mapData});

  @override
  State<EditAnimal> createState() => _EditAnimalState();
}

class _EditAnimalState extends State<EditAnimal> {
  late EditAnimalBloc _editAnimalBloc;

  bool doNotKnowDob = false;
  bool doNotKnowBreed = false;
  bool anotherAnimal = false;

  bool breedListEnable = false;
  int breedingPaging = 1;
  bool breedLoader = true;
  List<String> imageUrlList = [];
  // controllers
  var name = TextEditingController();
  var dob = TextEditingController();
  var weight = TextEditingController();

  var race = TextEditingController();
  File? fileImage;
  String? image;
  int type = 1;
  int gender = 1;
  int sterilized = 1;
  String specices = '';

  String sendRace = '';
  String sendDate = '';

  @override
  void initState() {
    super.initState();
    _editAnimalBloc = EditAnimalBloc(context);
    if (widget.mapData != null) {
      name.text = widget.mapData!['animal'].toString();
      type = int.parse(widget.mapData!['type'].toString());
      image = widget.mapData!['image'].toString();

      if (widget.mapData!['weight'].toString().isNotEmpty) {
        weight.text = widget.mapData!['weight'].toString();
      }
      if (widget.mapData!['dob'].toString().isNotEmpty) {
        dob.text = widget.mapData!['dob'].toString();
        sendDate = widget.mapData!['dob'].toString();
      } else {
        doNotKnowDob = true;
      }
      if (widget.mapData!['breed'].toString() != 'N/A') {
        race.text = widget.mapData!['breed'].toString();
        sendRace = widget.mapData!['breed'].toString();
      } else {
        doNotKnowBreed = true;
      }
      gender = int.parse(widget.mapData!['gender'].toString());
      sterilized = int.parse(widget.mapData!['sterilized'].toString());
    }
    if (widget.mapData!['specices'].toString() != 'null') {
      specices = widget.mapData!['specices'].toString();
    }
  }

  List<File> imageList = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _editAnimalBloc,
      child: BlocListener<EditAnimalBloc, BlocStates>(
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
              Navigator.pop(context);
              setState(() {});
            });
          }
        },
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
                child: Image.asset('assets/images/icons/back_icon.png',
                    color: MyColor.white),
              ),
            ),
            title: MyString.bold(
                'edit'.tr.toUpperCase(), 18, MyColor.white, TextAlign.center),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: MyColor.grey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(right: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //!@name
                          const SizedBox(height: 10),
                          MyString.med('nameAnimal'.tr, 16, MyColor.black,
                              TextAlign.center),
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
                              controller: name,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                // prefixIcon: SizedBox(
                                //     width: 20,
                                //     height: 20,
                                //     child: Padding(
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 10, vertical: 10),
                                //       child: Image.asset(
                                //         'assets/images/icons/animal_hand.png',
                                //         width: 20,
                                //         height: 20,
                                //       ),
                                //     )),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'nameAnimal'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                            ),
                          ),

                          //!@species
                          const SizedBox(height: 15),
                          MyString.med('species'.tr, 16, MyColor.black,
                              TextAlign.center),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      type = 1;
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      height: 113,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: 10, left: 10),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                boxShadow: <BoxShadow>[
                                                  new BoxShadow(
                                                    color: MyColor.liteGrey,
                                                    blurRadius: 2.0,
                                                    offset:
                                                        new Offset(0.0, 3.0),
                                                  ),
                                                ],
                                                color: MyColor.white),
                                            child: MyString.med(
                                                "",
                                                14,
                                                type == 2
                                                    ? MyColor.textBlack3
                                                    : MyColor.orange,
                                                TextAlign.center),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                width: 95,
                                                height: 95,
                                                child: Image.asset(
                                                    "assets/images/logos/dog.png")),
                                          ),
                                          if (type == 1)
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  color: MyColor.orange,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )),
                              Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      type = 2;
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      height: 113,
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10, left: 10),
                                            height: 100,
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                boxShadow: <BoxShadow>[
                                                  new BoxShadow(
                                                    color: MyColor.liteGrey,
                                                    blurRadius: 2.0,
                                                    offset:
                                                        new Offset(0.0, 3.0),
                                                  ),
                                                ],
                                                color: MyColor.white),
                                            child: MyString.med(
                                                ''.tr,
                                                14,
                                                type == 1
                                                    ? MyColor.textBlack3
                                                    : MyColor.orange,
                                                TextAlign.center),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                width: 95,
                                                height: 95,
                                                child: Image.asset(
                                                    "assets/images/logos/cat.png")),
                                          ),
                                          if (type == 2)
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  color: MyColor.orange,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),

                          //!@dob
                          const SizedBox(height: 15),
                          MyString.med('Age in months', 16, MyColor.black,
                              TextAlign.center),
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
                              keyboardType: TextInputType.number,
                              controller: dob,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: '',
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                              onTap: () async {
                                if (!doNotKnowDob) {
                                  //   DateTime? pickedDate = await showDatePicker(
                                  //       initialEntryMode:
                                  //           DatePickerEntryMode.calendarOnly,
                                  //       context: context,
                                  //       initialDate:
                                  //           DateTime.now(), //get today's date
                                  //       firstDate: DateTime(
                                  //           2000), //DateTime.now() - not to allow to choose before today.
                                  //       lastDate: DateTime(2101));

                                  //   if (pickedDate != null) {
                                  //     debugPrint(pickedDate
                                  //         .toString()); //get the picked date in the format => 2022-07-04 00:00:00.000
                                  //     String formattedDateShow =
                                  //         DateFormat('dd/MM/yyyy').format(
                                  //             pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  //     String formattedDateSend =
                                  //         DateFormat('yyyy-MM-dd').format(
                                  //             pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  //     debugPrint(formattedDateSend);
                                  //     dob.text = formattedDateShow;
                                  //     sendDate = formattedDateSend;
                                  //     setState(() {});
                                  //   } else {
                                  //     debugPrint("Date is not selected");
                                  //   }
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          MyString.med(
                              'Weight', 16, MyColor.black, TextAlign.center),
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
                              keyboardType: TextInputType.number,
                              controller: weight,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: '',
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
                                    fontSize: 14),
                              ),
                              onTap: () async {
                                if (!doNotKnowDob) {
                                  //   DateTime? pickedDate = await showDatePicker(
                                  //       initialEntryMode:
                                  //           DatePickerEntryMode.calendarOnly,
                                  //       context: context,
                                  //       initialDate:
                                  //           DateTime.now(), //get today's date
                                  //       firstDate: DateTime(
                                  //           2000), //DateTime.now() - not to allow to choose before today.
                                  //       lastDate: DateTime(2101));

                                  //   if (pickedDate != null) {
                                  //     debugPrint(pickedDate
                                  //         .toString()); //get the picked date in the format => 2022-07-04 00:00:00.000
                                  //     String formattedDateShow =
                                  //         DateFormat('dd/MM/yyyy').format(
                                  //             pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  //     String formattedDateSend =
                                  //         DateFormat('yyyy-MM-dd').format(
                                  //             pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  //     debugPrint(formattedDateSend);
                                  //     dob.text = formattedDateShow;
                                  //     sendDate = formattedDateSend;
                                  //     setState(() {});
                                  //   } else {
                                  //     debugPrint("Date is not selected");
                                  //   }
                                }
                              },
                            ),
                          ),

                          //radio 1
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: 30,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    doNotKnowDob = !doNotKnowDob;
                                    dob.text = '';
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: doNotKnowDob
                                            ? MyColor.orange
                                            : MyColor.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Icon(
                                      Icons.check,
                                      color: MyColor.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                    child: MyString.reg(
                                        "dontKnowDOB".tr,
                                        14,
                                        MyColor.textFieldBorder,
                                        TextAlign.center)),
                              ],
                            ),
                          ),

                          //!@race
                          const SizedBox(height: 10),
                          MyString.med('${'race'.tr}*', 16, MyColor.black,
                              TextAlign.center),
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
                              controller: race,
                              readOnly: true,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style: TextStyle(color: MyColor.black),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: ' ',
                                hintStyle: TextStyle(
                                    color: MyColor.textFieldBorder,
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
                                    race.text = data['nameShow'].toString();
                                    sendRace = data['nameSend'].toString();
                                  }
                                }
                                setState(() {});
                              },
                            ),
                          ),

                          //radio 2
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: 30,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    doNotKnowBreed = !doNotKnowBreed;
                                    race.text = '';
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: doNotKnowBreed
                                            ? MyColor.orange
                                            : MyColor.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Icon(
                                      Icons.check,
                                      color: MyColor.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                    child: MyString.reg(
                                        "DonotKnowBreed".tr,
                                        14,
                                        MyColor.textFieldBorder,
                                        TextAlign.center)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),

                          //!@gender
                          MyString.med(
                              'gender'.tr, 16, MyColor.black, TextAlign.center),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      gender = 1;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40)),
                                          boxShadow: <BoxShadow>[
                                            new BoxShadow(
                                              color: MyColor.liteGrey,
                                              blurRadius: 2.0,
                                              offset: new Offset(0.0, 3.0),
                                            ),
                                          ],
                                          color: gender == 2
                                              ? MyColor.white
                                              : MyColor.newBackgroundColor),
                                      child: MyString.med(
                                          'male'.tr,
                                          14,
                                          gender == 2
                                              ? MyColor.textBlack3
                                              : MyColor.white,
                                          TextAlign.center),
                                    ),
                                  )),
                              Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      gender = 2;
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      height: 40,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40)),
                                          boxShadow: <BoxShadow>[
                                            new BoxShadow(
                                              color: MyColor.liteGrey,
                                              blurRadius: 2.0,
                                              offset: new Offset(0.0, 3.0),
                                            ),
                                          ],
                                          color: gender == 1
                                              ? MyColor.white
                                              : MyColor.newBackgroundColor),
                                      child: MyString.med(
                                          'female'.tr,
                                          14,
                                          gender == 1
                                              ? MyColor.textBlack3
                                              : MyColor.white,
                                          TextAlign.center),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 15),

                          //!@sterilized
                          MyString.med('sterilized'.tr, 16, MyColor.black,
                              TextAlign.center),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      sterilized = 1;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40)),
                                          boxShadow: <BoxShadow>[
                                            new BoxShadow(
                                              color: MyColor.liteGrey,
                                              blurRadius: 2.0,
                                              offset: new Offset(0.0, 3.0),
                                            ),
                                          ],
                                          color: sterilized == 2
                                              ? MyColor.white
                                              : MyColor.newBackgroundColor),
                                      child: MyString.med(
                                          'yes'.tr,
                                          14,
                                          sterilized == 2
                                              ? MyColor.textBlack3
                                              : MyColor.white,
                                          TextAlign.center),
                                    ),
                                  )),
                              Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      sterilized = 2;
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      height: 40,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40)),
                                          boxShadow: <BoxShadow>[
                                            new BoxShadow(
                                              color: MyColor.liteGrey,
                                              blurRadius: 2.0,
                                              offset: new Offset(0.0, 3.0),
                                            ),
                                          ],
                                          color: sterilized == 1
                                              ? MyColor.white
                                              : MyColor.newBackgroundColor),
                                      child: MyString.med(
                                          'no'.tr,
                                          14,
                                          sterilized == 1
                                              ? MyColor.textBlack3
                                              : MyColor.white,
                                          TextAlign.center),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 10),

                          //!@photo
                          const SizedBox(height: 10),
                          MyString.med(
                              'photo'.tr, 16, MyColor.black, TextAlign.center),
                          GestureDetector(
                            onTap: () async {
                              String? result =
                                  await cameraPhoto(context, "edit");
                              var returnImage;
                              if (result == '0') {
                                returnImage = await pickImage(
                                    context, ImageSource.camera);
                              } else if (result == '1') {
                                returnImage = await pickImage(
                                    context, ImageSource.gallery);
                              }
                              if (returnImage != null) {
                                fileImage = returnImage;
                                String? uploadedImageUrl =
                                    await AllApi().uploadImages(fileImage!);
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
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: MyColor.liteGrey,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: fileImage != null
                                      ? Image.file(
                                          fileImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : image != null
                                          ? Image.network(
                                              image.toString(),
                                              fit: BoxFit.cover,
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: Image.asset(
                                                'assets/images/icons/camera_animal.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                            )),
                            ),
                          ),

                          //mainButton
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                FocusManager.instance.primaryFocus!.unfocus();
                                _editAnimalBloc.add(
                                  GetEditAnimalEvent(
                                    widget.mapData!['id'].toString(),
                                    name.text.trim().toString(),
                                    type == 1 ? 'Dog' : 'Cat',
                                    doNotKnowBreed
                                        ? 'N/A'
                                        : sendRace.toString(),
                                    dob.text,
                                    gender == 1 ? 'Male' : 'Female',
                                    weight.text.isEmpty ? int.parse(widget.mapData!['weight'].toString()) : int.parse(weight.text.trim()),
                                    sterilized.toString(),
                                    fileImage == null && imageUrlList.isEmpty
                                        ? [image.toString()]
                                        : imageUrlList,
                                  ),
                                );
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 25),
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: MyColor.orange,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  MyString.med('updateAnimal'.tr, 18,
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
