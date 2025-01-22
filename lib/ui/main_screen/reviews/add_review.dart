import 'package:avispets/ui/main_screen/home/post_detail.dart';
import 'package:avispets/ui/main_screen/profile/profile_screen.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool showReviewsList = false;
  var searchBar = TextEditingController();
  List<String> items = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  List<review> reviews = [
    review(
        date: '10/27/2024',
        rate: 4,
        reviewer: 'reviewer',
        place: 'place',
        description:
            'Super lovely product. I love this product because the software is brilliantly helpful Can’t get enough!'),
    review(
        date: 'date',
        rate: 3,
        reviewer: 'reviewer',
        place: 'place',
        description:
            'Super lovely product. I love this product because the software is brilliantly helpful Can’t get enough!'),
    review(
        date: 'date',
        rate: 5,
        reviewer: 'reviewer',
        place: 'place',
        description:
            'Super lovely product. I love this product because the software is brilliantly helpful Can’t get enough!'),
  ];
  List<bool> itemBool = List.generate(5, (index) => false);

  List<String> items1 = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  List<bool> item1Bool = List.generate(5, (index) => false);

  List<String> items2 = [
    'star1'.tr,
    'star2'.tr,
    'star3'.tr,
    'star4'.tr,
    'star5'.tr
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                ),
                child: HeaderWidget(),
              ),
              MyString.bold('Restaurant - Backers & brothers', 20,
                  MyColor.title, TextAlign.start),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffEBEBEB)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                        bottomLeft: Radius.circular(13),
                        bottomRight: Radius.circular(13))),
                child: TextField(
                  controller: searchBar,
                  scrollPadding: const EdgeInsets.only(bottom: 50),
                  style: TextStyle(color: MyColor.black, fontSize: 14),
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    hintText: 'search'.tr,
                    hintStyle:
                        TextStyle(color: MyColor.textBlack0, fontSize: 14),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: MyString.reg(
                    'Recommended reviews', 16, MyColor.redd, TextAlign.start),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            MyString.bold(
                                '5', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 5,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '4', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 4,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '3', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 3,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '2', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 2,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyString.bold(
                                '1', 14, MyColor.textBlack0, TextAlign.start),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: SliderTheme(
                                child: Slider(
                                  value: 1,
                                  max: 5,
                                  min: 0,
                                  activeColor: Color(0xffFFB400),
                                  inactiveColor: MyColor.grey,
                                  onChanged: (double value) {},
                                ),
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 11,
                                    thumbColor: Color(0xffFFB400),
                                    thumbShape: SliderComponentShape.noThumb,
                                    trackShape: CustomTrackShape()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyString.reg('4.5', 20, MyColor.textBlack,
                                      TextAlign.start),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 26),
                                ],
                              ),
                              MyString.reg('563 Reviews', 10,
                                  MyColor.textBlack0, TextAlign.start),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyString.reg('88%', 20, MyColor.textBlack,
                                      TextAlign.start),
                                ],
                              ),
                              MyString.reg('Recommended', 10,
                                  MyColor.textBlack0, TextAlign.start),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Color(0xffEBEBEB), // Color of the divider
                thickness: 1, // Thickness of the line
                indent: 16, // Start padding
                endIndent: 16, // End padding
              ),
              showReviewsList
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesName.filterReviews);
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColor.card,
                                border: Border.all(color: MyColor.orange2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyString.bold('Filter reviews ', 14,
                                      MyColor.redd, TextAlign.center),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/filtres.png',
                                    width: 25,
                                    height: 25,
                                  )
                                ],
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 480,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: reviews.length,
                              padding: EdgeInsets.only(top: 20, bottom: 30),
                              itemBuilder: (context, index) {
                                var rev = reviews[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        // Handle tap here
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 25, horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: MyColor.card,
                                          border:
                                              Border.all(color: MyColor.stroke),
                                          borderRadius: BorderRadius.circular(
                                              8), // Optional: adds rounded corners
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Review header text
                                            MyString.reg(
                                              'Review filed on ${rev.date}',
                                              12,
                                              MyColor.textBlack0,
                                              TextAlign.start,
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Spacing between elements
                                            // Stars
                                            Row(
                                              children: List.generate(
                                                rev.rate!,
                                                (index) => Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      right:
                                                          4.0), // Space between stars
                                                  child: Image.asset(
                                                    'assets/images/icons/star.png',
                                                    height: 16,
                                                    width: 16,
                                                    semanticLabel:
                                                        'Star rating',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Spacing between elements

                                            MyString.bold(
                                              '${rev.reviewer} reviews ${rev.place}',
                                              14,
                                              MyColor.black,
                                              TextAlign.start,
                                            ),
                                            SizedBox(height: 10), //
                                            SizedBox(height: 10),
                                            MyString.regMultiLine(
                                                '${rev.description}',
                                                12,
                                                MyColor.black,
                                                TextAlign.start,
                                                3),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index != reviews.length - 1)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Divider(
                                          color: Color(
                                              0xffEBEBEB), // Color of the divider
                                          thickness: 1, // Thickness of the line
                                          indent: 16, // Start padding
                                          endIndent: 16, // End padding
                                        ),
                                      ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: MyString.reg('Customer ratings (8 reviews)',
                              16, MyColor.redd, TextAlign.start),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showReviewsList = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                MyString.reg('Show all reviews', 12,
                                    MyColor.redd, TextAlign.start),
                                SizedBox(width: 5),
                                Image.asset(
                                    'assets/images/icons/noun_arr_right.png')
                              ],
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyString.reg(
                                '4.5', 20, MyColor.textBlack, TextAlign.start),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.star, color: Colors.amber, size: 26),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 220,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              var rev = reviews[index];
                              return GestureDetector(
                                onTap: () async {
                                  // Handle tap here
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  width: 280,
                                  decoration: BoxDecoration(
                                    color: MyColor.card,
                                    border: Border.all(color: MyColor.stroke),
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: adds rounded corners
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Review header text
                                      MyString.reg(
                                        'Review filed on ${rev.date}',
                                        12,
                                        MyColor.textBlack0,
                                        TextAlign.start,
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Spacing between elements
                                      // Stars
                                      Row(
                                        children: List.generate(
                                          rev.rate!,
                                          (index) => Padding(
                                            padding: const EdgeInsets.only(
                                                right:
                                                    4.0), // Space between stars
                                            child: Image.asset(
                                              'assets/images/icons/star.png',
                                              height: 16,
                                              width: 16,
                                              semanticLabel: 'Star rating',
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Spacing between elements

                                      MyString.bold(
                                        '${rev.reviewer} reviews ${rev.place}',
                                        14,
                                        MyColor.black,
                                        TextAlign.start,
                                      ),
                                      SizedBox(height: 10), //
                                      SizedBox(height: 10),
                                      MyString.regMultiLine(
                                          '${rev.description}',
                                          12,
                                          MyColor.black,
                                          TextAlign.start,
                                          3),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
