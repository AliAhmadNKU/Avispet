import 'package:avispets/ui/main_screen/map/map_page.dart';
import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool loader = true;
  int page = 1;
  var searchBar = TextEditingController();
  String selectedCategory = '';

  List<FilterModel> dataList=  [
    FilterModel('assets/images/markers/Animalerie.png', 'Animalerie'.tr, 'petstore'),
    FilterModel('assets/images/markers/Bars.png', 'Bars'.tr, 'bar'),
    FilterModel('assets/images/markers/coffee.png', 'coffee'.tr, 'coffee'),
    FilterModel('assets/images/markers/Evenement.png', 'Evenement'.tr, 'event'),
    FilterModel('assets/images/markers/Exposition.png', 'Exposition'.tr, 'expo'),
    FilterModel('assets/images/markers/Hotel.png', 'Hotel'.tr, 'hotel'),
    FilterModel('assets/images/markers/localisation.png', 'localisation'.tr, 'loc'),
    FilterModel('assets/images/markers/Parks.png', 'Parks'.tr, 'park'),
    FilterModel('assets/images/markers/Restaurants.png', 'Restaurants'.tr, 'resto'),
    FilterModel('assets/images/markers/supermarket.png', 'supermarket'.tr, 'market'),
    FilterModel('assets/images/markers/Toilettage.png', 'Toilettage'.tr, 'toilet'),
    FilterModel('assets/images/markers/Veterinaire.png', 'Veterinaire'.tr, 'vet'),
  ];

  @override
  void initState() {
    super.initState();
    GetApi.getNotify(context, '');
    page = 1;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          page++;
        }
        return false;
      },
      child: Scaffold(


          backgroundColor: MyColor.white,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  HeaderWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: MyString.bold(
                        '${'filter'.tr}', 27, MyColor.title, TextAlign.center),
                  ),
                  //!@search-bar
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffEBEBEB)),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(13),
                                    topRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(13),
                                    bottomRight: Radius.circular(50))),
                            child: TextField(
                              controller: searchBar,
                              scrollPadding: const EdgeInsets.only(bottom: 50),
                              style:
                                  TextStyle(color: MyColor.black, fontSize: 14),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: GestureDetector(
                                  onTap: () async {
                                    Navigator.pushNamed(
                                        context, RoutesName.filterScreen);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: MyColor.textBlack0,
                                  ),
                                ),
                                suffixIcon: (searchBar.text
                                        .trim()
                                        .toString()
                                        .isNotEmpty)
                                    ? GestureDetector(
                                        onTap: () async {},
                                        child: Icon(
                                          Icons.cancel,
                                          color: MyColor.orange,
                                        ))
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Color(0xff4F2020),
                                            borderRadius:
                                                BorderRadius.circular(150)),
                                        child: Image.asset(
                                            'assets/images/icons/filter.png')),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintText: 'filter'.tr,
                                hintStyle: TextStyle(
                                    color: MyColor.textBlack0, fontSize: 14),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                    child: MyString.bold('Pet Friendly place',18,MyColor.title,TextAlign.start),
                  ),

                  Container(
                    height: 100,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              selectedCategory = dataList[index].name;
                              //fetchAndAddPlaces();
                            },
                            child: Container(
                              width: 70,
                              child: Column(
                                children: [
                                  Image.asset(
                                    '${dataList[index].image}',
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(height: 6,),
                                  MyString.bold('${dataList[index].name}', 12, MyColor.title,
                                      TextAlign.center)
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20, bottom: 0),
                    child: MyString.bold('Overall rating',18,MyColor.title,TextAlign.start),
                  ),

                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 40),
                            height: 17,
                            padding: EdgeInsets.zero,
                            color: Colors.transparent,
                            child: SliderTheme(
                              child: Slider(
                                value: 3,
                                max: 5,
                                min: 1,
                                divisions: 5,
                                activeColor:
                                Color(0xffED8631),
                                inactiveColor: MyColor.stroke,
                                onChanged:
                                    (double value) {},
                              ),
                              data: SliderTheme.of(context)
                                  .copyWith(
                                  trackHeight: 17,
                                  thumbColor: Colors
                                      .transparent,
                                  thumbShape:
                                  SliderComponentShape
                                      .noThumb,
                                 ),
                            )),
                      ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        height: 59,
                        width: 200,
                        decoration: BoxDecoration(
                            color: MyColor.orange2,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(22))),
                        child: MyString.med('applyfilters'.tr, 18,
                            MyColor.white, TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
