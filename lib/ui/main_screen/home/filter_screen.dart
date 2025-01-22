import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/brand_model.dart';
import '../../../models/get_cat_breed.dart';
import '../../../models/get_category_model.dart';
import '../../../models/get_dog_breed.dart';
import '../../../models/get_subcategory_model.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class ModelClass {
  int? id;
  String? name;

  ModelClass(this.id, this.name);
}

class FilterScreen extends StatefulWidget {
  final Map<String, String> mapData;

  FilterScreen({super.key, required this.mapData});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

String category_1 = '0';
String category_2 = '0';

class _FilterScreenState extends State<FilterScreen> {
  List<ModelClass> mainTags = [];
  List<bool> mainTagsSelect = List.generate(3, (index) => false);

  var searchBar = TextEditingController();

  bool breedLoader = true;
  bool loader = true;

  // 0:dog, 1:cat, 2:category
  int categoryPosition = 0;

  int filterCount = 0;

  int selectTag = 0;

  //finals array
  List<String> catRaces = [];
  List<String> dogRaces = [];
  List<String> brands = [];
  List<String> subCategories = [];

  List<GetDogBreedBody> breedList = [];
  List<GetCatBreedBody> breedList1 = [];
  List<GetSubCategoryBody> subCategoryList = [];

  GetCategoryModel _categoryModel = GetCategoryModel();
  GetSubCategoryModel _subCategoryModel = GetSubCategoryModel();

  GetDogBreed _getDogBreed = GetDogBreed();
  GetCatBreed _getCatBreed = GetCatBreed();
  double start = 0.0;
  double end = 100.0;
  bool showRange = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      mainTags.add(ModelClass(0, 'dog'.tr));
      mainTags.add(ModelClass(1, 'cat'.tr));
      mainTags.add(ModelClass(2, 'brand'.tr));

      if (widget.mapData['dogList'].toString().isNotEmpty &&
          widget.mapData['dogList'] != null) {
        debugPrint(
            'NEXT DATA FROM(dog) : ${widget.mapData['dogList'].toString()}');
        dogRaces = widget.mapData['dogList'].toString().split(',');
      }

      if (widget.mapData['catList'].toString().isNotEmpty &&
          widget.mapData['catList'] != null) {
        debugPrint(
            'NEXT DATA FROM(cat) : ${widget.mapData['catList'].toString()}');
        catRaces = widget.mapData['catList'].toString().split(',');
      }

      if (widget.mapData['subCategories'].toString().isNotEmpty &&
          widget.mapData['subCategories'] != null) {
        debugPrint(
            'NEXT DATA FROM(sub-categories) : ${widget.mapData['subCategories'].toString()}');
        subCategories = widget.mapData['subCategories'].toString().split(',');
      }

      if (widget.mapData['brands'].toString().isNotEmpty &&
          widget.mapData['brands'] != null) {
        debugPrint(
            'NEXT DATA FROM(brands) : ${widget.mapData['brands'].toString()}');
        brands = widget.mapData['brands'].toString().split(',');
      }

      await getDogBreed();
      getCatBreed();
      _getBrands('');
      _getCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'filter'.tr.toUpperCase(), 18, MyColor.white, TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                breedList.clear();
                dogRaces.clear();

                breedList1.clear();
                catRaces.clear();

                brands.clear();
                brandList.clear();

                subCategories.clear();

                filterCount = 0;

                debugPrint('TOTAL COUNT $filterCount');
                Map<String, String> backHit = {
                  'dogList': dogRaces.join(','),
                  'catList': catRaces.join(','),
                  'subCategories': subCategories.join(','),
                  'filterCount': filterCount.toString()
                };

                debugPrint('FINAL MAP RETURN VALUES (MAP) :: $backHit');
                toaster(context, 'clear');
                Navigator.pop(context, backHit);
              });
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(8),
                minimumSize: Size(40, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: MyString.med('clearFilter'.tr, 14,
                    MyColor.textFieldBorder, TextAlign.center)),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            color: MyColor.grey,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                new BoxShadow(
                                  color: MyColor.liteGrey,
                                  blurRadius: 2.0,
                                  offset: new Offset(0.0, 3.0),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40))),
                          child: TextField(
                            controller: searchBar,
                            scrollPadding: const EdgeInsets.only(bottom: 50),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/icons/search.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  )),
                              suffixIcon: (searchBar.text
                                      .trim()
                                      .toString()
                                      .isNotEmpty)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          searchBar.text = '';

                                          if (categoryPosition == 0) {
                                            onSearchDog(
                                                searchBar.text.toString());
                                          } else if (categoryPosition == 1) {
                                            onSearchCat(
                                                searchBar.text.toString());
                                          } else if (categoryPosition == 2) {
                                            onSearchBrand(
                                                searchBar.text.toString());
                                          } else {
                                            onSearchSubCategories(
                                                searchBar.text.toString());
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: MyColor.orange,
                                      ))
                                  : Container(width: 10),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              hintText: 'search'.tr,
                              hintStyle: TextStyle(
                                  color: MyColor.textFieldBorder, fontSize: 14),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (categoryPosition == 0) {
                                  onSearchDog(value.toString());
                                } else if (categoryPosition == 1) {
                                  onSearchCat(value.toString());
                                } else if (categoryPosition == 2) {
                                  onSearchBrand(searchBar.text.toString());
                                } else {
                                  onSearchSubCategories(value.toString());
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          showRange = !showRange;
                          setState(() {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: MyColor.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Image.asset(
                              "assets/images/icons/euro_coin.png",
                              height: 25,
                              width: 25,
                            )),
                      ),
                    ],
                  ),
                  if (showRange)
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyString.med("€" + start.toStringAsFixed(2), 15,
                                MyColor.black, TextAlign.start),
                            MyString.med("€" + end.toStringAsFixed(2), 15,
                                MyColor.black, TextAlign.start),
                          ],
                        ),
                        RangeSlider(
                          values: RangeValues(start, end),
                          labels: RangeLabels(start.toString(), end.toString()),
                          onChanged: (value) {
                            setState(() {
                              start = value.start;
                              end = value.end;
                            });
                          },
                          min: 0.0,
                          max: 500.0,
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  loader
                      ? Container(
                          child: progressBar(),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 4,
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: (showRange)
                                        ? MediaQuery.of(context).size.height *
                                            0.50
                                        : MediaQuery.of(context).size.height *
                                            0.60,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: mainTags.length,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              selectTag = index;
                                              FocusManager
                                                  .instance.primaryFocus!
                                                  .unfocus();
                                              searchBar.text = '';
                                              getDogBreed();
                                              getCatBreed();
                                              categoryPosition = index;
                                              breedLoader = true;
                                              subCategoryList.clear();
                                            });

                                            // if (mainTags[index].id! > 2) {
                                            if (categoryPosition > 2) {
                                              await _getSubCategory(
                                                  mainTags[index].id.toString(),
                                                  loader: false);
                                            }
                                            mainTagsSelect = List.generate(
                                                mainTags.length,
                                                (index) => false);
                                            mainTagsSelect[index] = true;
                                            Timer(
                                              const Duration(seconds: 2),
                                              () {
                                                breedLoader = false;
                                              },
                                            );
                                            setState(() {});
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: selectTag == index
                                                  ? MyColor.newBackgroundColor
                                                  : MyColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: <BoxShadow>[
                                                new BoxShadow(
                                                  color: MyColor.liteGrey,
                                                  blurRadius: 2.0,
                                                  offset: new Offset(0.0, 3.0),
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.only(bottom: 10),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: MyString.med(
                                                mainTags[index].name.toString(),
                                                14,
                                                selectTag == index
                                                    ? MyColor.white
                                                    : MyColor.textFieldBorder,
                                                TextAlign.center),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                flex: 6,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: (showRange)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.50
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.60,
                                        child: breedLoader
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .60,
                                                child: progressBar())
                                            : Container(
                                                child: SingleChildScrollView(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.only(
                                                        bottom: 15),
                                                    itemCount: categoryPosition ==
                                                            2
                                                        ? brandList.length
                                                        : categoryPosition == 0
                                                            ? breedList.length
                                                            : categoryPosition ==
                                                                    1
                                                                ? breedList1
                                                                    .length
                                                                : subCategoryList
                                                                    .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (categoryPosition ==
                                                          2) {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              brandList[index]
                                                                      .isSelect =
                                                                  !brandList[
                                                                          index]
                                                                      .isSelect;
                                                              if (brandList[
                                                                      index]
                                                                  .isSelect) {
                                                                brands.add(brandList[
                                                                        index]
                                                                    .name
                                                                    .toString());
                                                              } else {
                                                                brands.remove(
                                                                    brandList[
                                                                            index]
                                                                        .name
                                                                        .toString());
                                                              }
                                                            });

                                                            debugPrint(
                                                                'BRAND LIST : ${brands.toString()}');
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: brandList[index].isSelect
                                                                          ? MyColor
                                                                              .orange
                                                                          : MyColor
                                                                              .white,
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              20))),
                                                                  child: brandList[
                                                                              index]
                                                                          .isSelect
                                                                      ? Icon(
                                                                          Icons
                                                                              .check,
                                                                          color:
                                                                              MyColor.white,
                                                                          size:
                                                                              15,
                                                                        )
                                                                      : Container(),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: MyString.med(
                                                                      sharedPref.getString(SharedKey.languageValue).toString() == 'en'
                                                                          ? brandList[index]
                                                                              .name
                                                                              .toString()
                                                                          : brandList[index]
                                                                              .nameFr
                                                                              .toString(),
                                                                      14,
                                                                      MyColor
                                                                          .textBlack,
                                                                      TextAlign
                                                                          .start),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } else if (categoryPosition ==
                                                          0) {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              breedList[index]
                                                                      .isSelect =
                                                                  !breedList[
                                                                          index]
                                                                      .isSelect;
                                                              if (breedList[
                                                                      index]
                                                                  .isSelect) {
                                                                dogRaces.add(
                                                                    breedList[
                                                                            index]
                                                                        .name
                                                                        .toString());
                                                              } else {
                                                                dogRaces.remove(
                                                                    breedList[
                                                                            index]
                                                                        .name
                                                                        .toString());
                                                              }
                                                            });

                                                            debugPrint(
                                                                'DOG LIST : ${dogRaces.toString()}');
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: breedList[index].isSelect
                                                                          ? MyColor
                                                                              .orange
                                                                          : MyColor
                                                                              .white,
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              20))),
                                                                  child: breedList[
                                                                              index]
                                                                          .isSelect
                                                                      ? Icon(
                                                                          Icons
                                                                              .check,
                                                                          color:
                                                                              MyColor.white,
                                                                          size:
                                                                              15,
                                                                        )
                                                                      : Container(),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: MyString.med(
                                                                      sharedPref.getString(SharedKey.languageValue).toString() == 'en'
                                                                          ? breedList[index]
                                                                              .name
                                                                              .toString()
                                                                          : breedList[index]
                                                                              .nameFr
                                                                              .toString(),
                                                                      14,
                                                                      MyColor
                                                                          .textBlack,
                                                                      TextAlign
                                                                          .start),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } else if (categoryPosition ==
                                                          1) {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              breedList1[index]
                                                                      .isSelect =
                                                                  !breedList1[
                                                                          index]
                                                                      .isSelect;
                                                              if (breedList1[
                                                                      index]
                                                                  .isSelect) {
                                                                catRaces.add(
                                                                    breedList1[
                                                                            index]
                                                                        .name
                                                                        .toString());
                                                              } else {
                                                                catRaces.remove(
                                                                    breedList1[
                                                                            index]
                                                                        .name
                                                                        .toString());
                                                              }
                                                            });
                                                            debugPrint(
                                                                'CAT LIST : ${catRaces.toString()}');
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: breedList1[index].isSelect
                                                                          ? MyColor
                                                                              .orange
                                                                          : MyColor
                                                                              .white,
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              20))),
                                                                  child: breedList1[
                                                                              index]
                                                                          .isSelect
                                                                      ? Icon(
                                                                          Icons
                                                                              .check,
                                                                          color:
                                                                              MyColor.white,
                                                                          size:
                                                                              15,
                                                                        )
                                                                      : Container(),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: MyString.med(
                                                                      sharedPref.getString(SharedKey.languageValue).toString() == 'en'
                                                                          ? breedList1[index]
                                                                              .name
                                                                              .toString()
                                                                          : breedList1[index]
                                                                              .nameFr
                                                                              .toString(),
                                                                      14,
                                                                      MyColor
                                                                          .textBlack,
                                                                      TextAlign
                                                                          .start),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              subCategoryList[
                                                                          index]
                                                                      .isSelect =
                                                                  !subCategoryList[
                                                                          index]
                                                                      .isSelect;

                                                              if (subCategoryList[
                                                                      index]
                                                                  .isSelect) {
                                                                subCategories.add(
                                                                    subCategoryList[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                              } else {
                                                                subCategories.remove(
                                                                    subCategoryList[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                              }

                                                              if (subCategories
                                                                      .join(',')
                                                                      .isNotEmpty &&
                                                                  idSave ==
                                                                      '1') {
                                                                category_1 = subCategoryList[
                                                                        index]
                                                                    .categoryId
                                                                    .toString();
                                                              } else if (subCategories
                                                                      .join(',')
                                                                      .isNotEmpty &&
                                                                  idSave ==
                                                                      '2') {
                                                                category_2 = subCategoryList[
                                                                        index]
                                                                    .categoryId
                                                                    .toString();
                                                              } else {
                                                                category_1 =
                                                                    '0';
                                                                category_2 =
                                                                    '0';
                                                              }
                                                            });
                                                            debugPrint(
                                                                'SUB-CATEGORY LIST : ${subCategories.toString()}');
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                      color: subCategoryList[index].isSelect
                                                                          ? MyColor
                                                                              .orange
                                                                          : MyColor
                                                                              .white,
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              20))),
                                                                  child: subCategoryList[
                                                                              index]
                                                                          .isSelect
                                                                      ? Icon(
                                                                          Icons
                                                                              .check,
                                                                          color:
                                                                              MyColor.white,
                                                                          size:
                                                                              15,
                                                                        )
                                                                      : Container(),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 100,
                                                                  child: MyString.med(
                                                                      sharedPref.getString(SharedKey.languageValue).toString() == 'en'
                                                                          ? subCategoryList[index]
                                                                              .name
                                                                              .toString()
                                                                          : subCategoryList[index]
                                                                              .nameFr
                                                                              .toString(),
                                                                      14,
                                                                      MyColor
                                                                          .textBlack,
                                                                      TextAlign
                                                                          .start),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                    debugPrint('FINAL DOG_LIST :: $dogRaces');
                    debugPrint('FINAL CAT_LIST :: $catRaces');
                    debugPrint('FINAL BRAND_LIST :: $brands');
                    debugPrint('FINAL SUB-CATEGORIES_LIST :: $subCategories');

                    debugPrint('FINAL DOG_LIST :: ${start.toString()}');
                    debugPrint('FINAL CAT_LIST :: ${end.toString()}');

                    filterCount = dogRaces.length +
                        catRaces.length +
                        subCategories.length +
                        brands.length;

                    debugPrint('TOTAL COUNT $filterCount');
                    Map<String, String> backHit = {
                      'dogList': dogRaces.join(','),
                      'catList': catRaces.join(','),
                      'brands': brands.join(','),
                      'subCategories': subCategories.join(','),
                      'filterCount': filterCount.toString(),
                      'minPrice': start.toString(),
                      'maxPrice': end.toString()
                    };

                    debugPrint('FINAL MAP RETURN VALUES (MAP) :: $backHit');
                    Navigator.pop(context, backHit);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        color: MyColor.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        MyString.med('filter'.tr.toUpperCase(), 15,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDogBreed() async {
    var res =
        await AllApi.getMethodApi('${ApiStrings.dogBreeds}?page=1&limit=500');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      breedList.clear();
      breedLoader = false;
      _getDogBreed = GetDogBreed.fromJson(result);
      for (int i = 0; i < _getDogBreed.data!.length; i++) {
        breedList.add(_getDogBreed.data![i]);

        if (dogRaces.contains(_getDogBreed.data![i].name.toString())) {
          breedList[i].isSelect = true;
        }
      }
      debugPrint('BREED LIST (DOG):${breedList.toString()}');

      setState(() {});
    } else if (result['status'] == 401) {
    } else {}
  }

  getCatBreed() async {
    var res =
        await AllApi.getMethodApi('${ApiStrings.catBreeds}?page=1&limit=500');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      breedLoader = false;
      breedList1.clear();
      _getCatBreed = GetCatBreed.fromJson(result);
      for (int i = 0; i < _getCatBreed.data!.length; i++) {
        breedList1.add(_getCatBreed.data![i]);

        if (catRaces.contains(_getCatBreed.data![i].name.toString())) {
          breedList1[i].isSelect = true;
        }
      }
      debugPrint('BREED LIST (CAT):${breedList1.toString()}');
      setState(() {});
    } else if (result['status'] == 401) {
    } else {}
  }

  _getCategory() async {
    var res =
        await AllApi.getMethodApi('${ApiStrings.categories}?page=1&limit=100');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      breedLoader = false;
      _categoryModel = GetCategoryModel.fromJson(result);
      for (int i = 0; i < _categoryModel.data!.length; i++) {
        (sharedPref.getString(SharedKey.languageValue).toString() == 'en')
            ? mainTags.add(ModelClass(_categoryModel.data![i].id,
                _categoryModel.data![i].name.toString()))
            : mainTags.add(ModelClass(_categoryModel.data![i].id,
                _categoryModel.data![i].nameFr.toString()));
      }
      mainTagsSelect = List.generate(mainTags.length, (index) => false);
      mainTagsSelect[0] = true;
      loader = false;
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

  String idSave = '';

  _getSubCategory(String categoryId, {required bool loader}) async {
    debugPrint('CATEGORY-ID IS : $categoryId');
    idSave = categoryId;
    var res = await AllApi.getMethodApi(
        '${ApiStrings.subCategories}?categoryId=$categoryId&page=1&limit=122');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      subCategoryList.clear();
      _subCategoryModel = GetSubCategoryModel.fromJson(result);

      for (int i = 0; i < _subCategoryModel.data!.length; i++) {
        subCategoryList.add(_subCategoryModel.data![i]);

        if (subCategories.contains(_subCategoryModel.data![i].id.toString())) {
          subCategoryList[i].isSelect = true;
        }
      }
      if (loader) {
        breedLoader = false;
      }

      setState(() {});
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

  BrandModel _brandModel = BrandModel();
  List<BrandModelBody> brandList = [];

  _getBrands(String search) async {
    var res = await AllApi.getMethodApi(
        '${ApiStrings.product_brands}?page=1&limit=100&search=$search');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      brandList.clear();
      _brandModel = BrandModel.fromJson(result);
      for (int i = 0; i < _brandModel.data!.length; i++) {
        brandList.add(_brandModel.data![i]);

        if (brands.contains(_brandModel.data![i].name.toString())) {
          brandList[i].isSelect = true;
        }
      }
      breedLoader = false;
      setState(() {});
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

  onSearchDog(String text) async {
    breedList.clear();
    if (text.isEmpty) {
      setState(() {
        breedLoader = true;
        getDogBreed();
      });
      return;
    }
    for (var userDetail in _getDogBreed.data!) {
      if (userDetail.name.toString().toLowerCase().contains(text))
        breedList.add(userDetail);
    }
    setState(() {});
  }

  onSearchCat(String text) async {
    breedList1.clear();
    if (text.isEmpty) {
      setState(() {
        breedLoader = true;
        getCatBreed();
      });
      return;
    }
    for (var userDetails in _getCatBreed.data!) {
      if (userDetails.name.toString().toLowerCase().contains(text))
        breedList1.add(userDetails);
    }
  }

  onSearchBrand(String text) async {
    brandList.clear();
    if (text.isEmpty) {
      setState(() {
        breedLoader = true;
        _getBrands('');
      });
      return;
    }
    for (var userDetail in _brandModel.data!) {
      if (userDetail.name.toString().toLowerCase().contains(text))
        brandList.add(userDetail);
    }
    setState(() {});
  }

  onSearchSubCategories(String text) async {
    subCategoryList.clear();
    if (text.isEmpty) {
      setState(() {
        breedLoader = true;
        _getSubCategory(idSave, loader: true);
      });
      return;
    }
    for (var userDetail in _subCategoryModel.data!) {
      if (userDetail.name.toString().toLowerCase().contains(text))
        subCategoryList.add(userDetail);
    }
    setState(() {});
  }
}
