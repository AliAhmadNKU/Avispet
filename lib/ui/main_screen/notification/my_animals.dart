import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/header_widget2.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/apis/api_strings.dart';

import '../../../utils/common_function/dialogs/dialog_delete_animal.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_routes/route_name.dart';

class MyAnimals extends StatefulWidget {
  int from;

  MyAnimals({super.key, required this.from});

  @override
  State<MyAnimals> createState() => _MyAnimalsState();
}

enum SampleItem { report, delete }

class _MyAnimalsState extends State<MyAnimals> {
  SampleItem? selectedItem;
  bool loader = true;
  int page = 1;
  var searchBar = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await GetApi.getMyAnimalNew(
        context,
      );
      // await GetApi.getMyAnimal(
      //   context,
      // );
      setState(() {
        loader = false;
      });
    });
  }

  // _loadMoreData(int loaderPage) async {
  //   await GetApi.getMyAnimal(
  //     context,
  //   );
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: SafeArea(
        child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter == 0) {
                page++;
                // _loadMoreData(page);
              }
              return false;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: HeaderWidget2(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyString.bold(
                          'myAnimals'.tr, 27, MyColor.title, TextAlign.center),
                      Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: MyColor.orange2,
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: MyColor.white,
                          ),
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, RoutesName.createAnimal
                            );
                            page = 1;
                            setState(() {
                              loader = true;
                            });
                            await GetApi.getMyAnimalNew(
                              context,
                            );
                            setState(() {
                              loader = false;
                            });
                            // await GetApi.getMyAnimal(context, page);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                //card_Design
                loader
                    ? Container(
                        child: progressBar(),
                      )
                    : GetApi.getAnimal.isNotEmpty
                        ? Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                // await GetApi.getMyAnimal(context, page);
                                setState(() {});
                              },
                              child: ListView.builder(
                                itemCount: GetApi.getAnimal.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: MyColor.card,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          //header
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 56,
                                                    height: 56,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  50)),
                                                      child: Image.network(
                                                          '${GetApi.getAnimal[index].images![0].toString()}',
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                                  child,
                                                                  loadingProgress) =>
                                                              (loadingProgress ==
                                                                      null)
                                                                  ? child
                                                                  : customProgressBar()),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    children: [
                                                      const SizedBox(height: 5),
                                                      MyString.bold(
                                                          GetApi
                                                              .getAnimal[index]
                                                              .name
                                                              .toString(),
                                                          11,
                                                          MyColor.textBlack0,
                                                          TextAlign.start),
                                                      const SizedBox(height: 5),
                                                      MyString.bold(
                                                          GetApi
                                                              .getAnimal[index]
                                                              .breed
                                                              .toString(),
                                                          11,
                                                          MyColor.textBlack0,
                                                          TextAlign.start),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              PopupMenuButton<SampleItem>(
                                                color: MyColor.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                18.0))),
                                                icon: Icon(
                                                  Icons
                                                      .more_vert, // Change the icon here
                                                  color: MyColor
                                                      .redd, // Change the color here
                                                ),
                                                initialValue: selectedItem,
                                                onSelected: (SampleItem item) {
                                                  setState(() {
                                                    selectedItem = item;
                                                  });
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry<
                                                            SampleItem>>[
                                                  PopupMenuItem<SampleItem>(
                                                    value: null,
                                                    onTap: () async {
                                                      Map<String, String>
                                                          mapData = {
                                                        'id': GetApi
                                                            .getAnimal[index].id
                                                            .toString(),
                                                        'animal': GetApi
                                                            .getAnimal[index]
                                                            .name
                                                            .toString(),
                                                        'type': GetApi
                                                                    .getAnimal[
                                                                        index]
                                                                    .type
                                                                    .toString() ==
                                                                'Dog'
                                                            ? 1.toString()
                                                            : 2.toString(),
                                                        'dob': GetApi
                                                            .getAnimal[index]
                                                            .age
                                                            .toString(),
                                                        'weight': GetApi
                                                            .getAnimal[index]
                                                            .weight
                                                            .toString(),
                                                        'breed': GetApi
                                                            .getAnimal[index]
                                                            .breed
                                                            .toString(),
                                                        'gender': GetApi
                                                                    .getAnimal[
                                                                        index]
                                                                    .gender
                                                                    .toString() ==
                                                                'Male'
                                                            ? 1.toString()
                                                            : 2.toString(),
                                                        'sterilized': GetApi
                                                                    .getAnimal[
                                                                        index]
                                                                    .sterilized
                                                                    .toString() ==
                                                                'Yes'
                                                            ? 1.toString()
                                                            : 2.toString(),
                                                        'specices':
                                                            '${ApiStrings.mediaURl}${GetApi.getAnimal[index].specices.toString()}',
                                                        'image':
                                                            '${GetApi.getAnimal[index].images![0].toString()}',
                                                      };

                                                      debugPrint(
                                                          'MY-ANIMAL MAP-DATA IS : ${GetApi.getAnimal[index].sterilized.toString()}');
                                                      debugPrint(
                                                          'MY-ANIMAL MAP-DATA IS : $mapData');
                                                      await Navigator.pushNamed(
                                                          context,
                                                          RoutesName.editAnimal,
                                                          arguments: mapData);
                                                      page = 1;
                                                      setState(() {
                                                        loader = true;
                                                      });
                                                      await GetApi.getMyAnimalNew(
                                                        context,
                                                      );
                                                      // await GetApi.getMyAnimal(
                                                      //   context,
                                                      // );
                                                      if(this.mounted){
                                                        setState(() {
                                                          loader = false;
                                                        });
                                                      }
                                                    },
                                                    child: MyString.reg(
                                                        'edit'.tr,
                                                        18,
                                                        MyColor.redd,
                                                        TextAlign.center),
                                                  ),
                                                  PopupMenuItem<SampleItem>(
                                                    value: null,
                                                    onTap: () async {
                                                      await showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (_) {
                                                          return deleteAnimalDialog(
                                                              GetApi
                                                                  .getAnimal[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                        },
                                                      );
                                                      // await GetApi.getMyAnimal(
                                                      //   context,
                                                      // );
                                                      await GetApi.getMyAnimalNew(
                                                        context,
                                                      );
                                                      setState(() {
                                                        // LoadingDialog.hide(context);
                                                      });
                                                    },
                                                    child: MyString.reg(
                                                        'deleteAnimal'.tr,
                                                        18,
                                                        MyColor.redd,
                                                        TextAlign.center),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 60,
                                                      child:
                                                          MyString.medMultiLine(
                                                              'type'.tr,
                                                              13,
                                                              MyColor
                                                                  .textBlack2,
                                                              TextAlign.start,
                                                              1)),
                                                  SizedBox(
                                                      width: 60,
                                                      child:
                                                          MyString.medMultiLine(
                                                              GetApi
                                                                  .getAnimal[
                                                                      index]
                                                                  .specices
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .tr,
                                                              15,
                                                              MyColor.black,
                                                              TextAlign.start,
                                                              1)),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 60,
                                                      child:
                                                          MyString.medMultiLine(
                                                              'species1'.tr,
                                                              13,
                                                              MyColor
                                                                  .textBlack2,
                                                              TextAlign.start,
                                                              1)),
                                                  SizedBox(
                                                      width: 60,
                                                      child:
                                                          MyString.medMultiLine(
                                                              GetApi
                                                                  .getAnimal[
                                                                      index]
                                                                  .breed
                                                                  .toString(),
                                                              15,
                                                              MyColor.black,
                                                              TextAlign.start,
                                                              1)),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 75,
                                                      child:
                                                          MyString.medMultiLine(
                                                              'Age (mo)',
                                                              13,
                                                              MyColor
                                                                  .textBlack2,
                                                              TextAlign.start,
                                                              1)),
                                                  SizedBox(
                                                      width: 60,
                                                      child: MyString.medMultiLine(
                                                          GetApi.getAnimal[index]
                                                                      .age ==
                                                                  null
                                                              ? 'N/A'
                                                              : '${GetApi.getAnimal[index].age.toString()}',
                                                          15,
                                                          MyColor.black,
                                                          TextAlign.start,
                                                          1)),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 60,
                                                      child:
                                                          MyString.medMultiLine(
                                                              'gender'.tr,
                                                              13,
                                                              MyColor
                                                                  .textBlack2,
                                                              TextAlign.start,
                                                              1)),
                                                  SizedBox(
                                                      width: 60,
                                                      child:
                                                          MyString.medMultiLine(
                                                              GetApi
                                                                  .getAnimal[
                                                                      index]
                                                                  .gender
                                                                  .toString(),
                                                              15,
                                                              MyColor.black,
                                                              TextAlign.start,
                                                              1)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/onboard/placeholder_image.png',
                                  width: 120,
                                  height: 90,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: MyString.reg('noAnimal'.tr, 11,
                                        MyColor.textBlack0, TextAlign.center)),
                              ],
                            ),
                          ),
              ],
            )),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    GetApi.getAnimal.clear();
    if (text.isEmpty) {
      page = 1;
      // await GetApi.getMyAnimal(
      //   context,
      // );
      await GetApi.getMyAnimalNew(
        context,
      );
      setState(() {
        loader = false;
      });
      return;
    }
    for (var userDetail in GetApi.animalModel.data!) {
      if (userDetail.name.toString().toLowerCase().contains(text))
        GetApi.getAnimal.add(userDetail);
    }
    setState(() {});
  }
}
//