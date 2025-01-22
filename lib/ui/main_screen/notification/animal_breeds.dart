import 'dart:convert';

import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/get_cat_breed.dart';
import '../../../models/get_dog_breed.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';

class AnimalBreeds extends StatefulWidget {
  final Map<String, dynamic>? mapData;
  AnimalBreeds({super.key, this.mapData});

  @override
  State<AnimalBreeds> createState() => _AnimalBreedsState();
}

class _AnimalBreedsState extends State<AnimalBreeds> {
  int breedingPaging = 1;
  bool breedLoader = true;
  List<String> breedList = [];
  List<String> breedListEn = [];
  GetDogBreed _getDogBreed = GetDogBreed();
  GetCatBreed _getCatBreed = GetCatBreed();

  String value = '';

  @override
  void initState() {
    super.initState();
    value = widget.mapData!['field'].toString();
    getBreed(widget.mapData!['type'], 1);
  }

  void _loadMoreData(int loaderPage) {
    setState(() {
      getBreed(widget.mapData!['type'], loaderPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, value);
      },
      child: Scaffold(
        backgroundColor: MyColor.white,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: MyColor.white,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () => Navigator.pop(context, value),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(20, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Image.asset('assets/images/icons/prev.png'),
            ),
          ),
          title: MyString.bold(
              'race'.tr.toUpperCase(), 27, MyColor.title, TextAlign.center),
        ),
        body: SafeArea(
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter == 0) {
                breedingPaging++;
                _loadMoreData(breedingPaging);
              }
              return false;
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: MyColor.card,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: breedLoader
                  ? Container(child: progressBar())
                  : Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            scrollPadding: const EdgeInsets.only(bottom: 150),
                            style:
                                TextStyle(color: MyColor.black, fontSize: 14),
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
                                      'assets/images/icons/search.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              hintText: 'search'.tr,
                              hintStyle: TextStyle(
                                  color: MyColor.textFieldBorder, fontSize: 14),
                            ),
                            onChanged: (value) {
                              onSearchTextChanged(value.toString());
                              setState(() {});
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: 8),
                            itemCount: breedList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: MyString.med(breedList[index].toString(),
                                    14, MyColor.textBlack, TextAlign.start),
                                onTap: () {
                                  Map<String, String> data = {
                                    "nameShow": breedList[index].toString(),
                                    "nameSend": breedListEn[index].toString(),
                                  };
                                  value = breedList[index].toString();
                                  Navigator.pop(context, data);
                                  setState(() {});
                                },
                              );
                            },
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

  getBreed(int type, int loadPage) async {
    debugPrint('TYPE :${type.toString()}');
    var res = await AllApi.getMethodApi(type == 1
        ? '${ApiStrings.dogBreeds}?page=${loadPage.toString()}&limit=10'
        : '${ApiStrings.catBreeds}?page=${loadPage.toString()}&limit=10');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      breedLoader = false;
      if (loadPage == 1) {
        breedList.clear();
      }
      if (type == 1) {
        _getDogBreed = GetDogBreed.fromJson(result);
        for (int i = 0; i < _getDogBreed.data!.length; i++) {
          if (sharedPref.getString(SharedKey.languageValue).toString() ==
              'en') {
            breedList.add(_getDogBreed.data![i].name.toString());
            breedListEn.add(_getDogBreed.data![i].name.toString());
          } else {
            breedList.add(_getDogBreed.data![i].nameFr.toString());
            breedListEn.add(_getDogBreed.data![i].name.toString());
          }
        }
        debugPrint('BREED LIST (DOG):${breedList.toString()}');
      }
      if (type == 2) {
        _getCatBreed = GetCatBreed.fromJson(result);
        for (int i = 0; i < _getCatBreed.data!.length; i++) {
          if (sharedPref.getString(SharedKey.languageValue).toString() ==
              'en') {
            breedList.add(_getCatBreed.data![i].name.toString());
            breedListEn.add(_getCatBreed.data![i].name.toString());
          } else {
            breedList.add(_getCatBreed.data![i].nameFr.toString());
            breedListEn.add(_getCatBreed.data![i].name.toString());
          }
        }
        debugPrint('BREED LIST (CAT):${breedList.toString()}');
      }
      setState(() {});
    } else if (result['status'] == 401) {
    } else {}
  }

  onSearchTextChanged(String text) async {
    breedList.clear();
    breedListEn.clear();
    if (text.isEmpty) {
      setState(() {
        getBreed(widget.mapData!['type'], 1);
      });
      return;
    }

    if (widget.mapData!['type'] != 1) {
      for (var userDetail in _getCatBreed.data!) {
        if (userDetail.name.toString().toLowerCase().contains(text))
          breedList.add(
              (sharedPref.getString(SharedKey.languageValue).toString() == 'en')
                  ? userDetail.name.toString()
                  : userDetail.nameFr.toString());
        if (userDetail.name.toString().toLowerCase().contains(text))
          breedListEn.add(userDetail.name.toString());
      }
    } else {
      for (var userDetail in _getDogBreed.data!) {
        if (userDetail.name.toString().toLowerCase().contains(text))
          breedList.add(
              (sharedPref.getString(SharedKey.languageValue).toString() == 'en')
                  ? userDetail.name.toString()
                  : userDetail.nameFr.toString());
        if (userDetail.name.toString().toLowerCase().contains(text))
          breedListEn.add(userDetail.name.toString());
      }
    }
    setState(() {});
  }
}
