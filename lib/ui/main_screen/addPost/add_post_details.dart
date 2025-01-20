import 'package:avispets/ui/main_screen/home/home_screen.dart';
import 'package:avispets/ui/main_screen/home/post_detail.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/my_color.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPostDetails extends StatefulWidget {
  const AddPostDetails({super.key});

  @override
  State<AddPostDetails> createState() => _AddPostDetailsState();
}

class _AddPostDetailsState extends State<AddPostDetails> {
  final post = Post(
    title: 'Hotel1',
    location: 'Berlin, Germany',
    category: 'hotel',
    distance: '2 KM',
    lat: 36,
    long: -122,
    rating: 4.5,
    reviews: 563,
    likes: 100,
    comments: 50,
    timeAgo: '5 min ago',
    imageUrl: 'assets/images/place.png',
  );
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Atmosphere And Environment',
      'description': '1: Very unpleasant (noisy, dirty, unsafe).\n'
          '2: Not very pleasant, several notable problems.\n'
          '3: Acceptable, some areas for improvement.\n'
          '4: Nice and clean, good environment.\n'
          '5: Excellent, very pet friendly.',
      'rating': 4,
    },
    {
      'title': 'Safety For Animals',
      'description': '',
      'rating': null,
    },
    {
      'title': 'Accessibility And Infrastructure',
      'description': '',
      'rating': null,
    },
    {
      'title': 'Social Interactions',
      'description': '',
      'rating': null,
    },
  ];

  final List<String> options = [
    'Green spaces nearby',
    'Presence of child',
    'Dog leash obligatory',
    'All dogs allowed',
    'Suitable for big dogs',
    'Suitable for small dogs',
  ];
  List<bool> isSelected = List.generate(6, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              HeaderWidget(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: MyString.bold(
                    '${'addPost'.tr}', 27, MyColor.title, TextAlign.center),
              ),
              GestureDetector(
                onTap: () async {
                  // Map<String, dynamic> mapData = {
                  //   'postId': '',
                  // };
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: MyColor.card,
                      borderRadius: BorderRadius.circular(22)),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                            width: 130,
                            height: 110,
                            fit: BoxFit.cover,
                            post.imageUrl),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyString.reg(
                              post.title, 14, MyColor.orange2, TextAlign.start),
                          MyString.reg(post.location, 12, MyColor.textBlack0,
                              TextAlign.start),
                          MyString.reg(post.category, 12, MyColor.textBlack0,
                              TextAlign.start),
                          MyString.reg(post.distance, 12, MyColor.textBlack0,
                              TextAlign.start),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              MyString.reg('${post.rating} (${post.reviews})',
                                  12, MyColor.textBlack0, TextAlign.start),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MyString.reg('${'evaluateService'.tr}', 14, MyColor.textBlack0,
                  TextAlign.start),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      bool isExpanded = false;

                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ExpansionTile(
                          shape: Border.all(color: MyColor.orange2),
                          collapsedShape: const ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          backgroundColor: Colors.orange[50],
                          collapsedBackgroundColor: MyColor.card,
                          title: Text(
                            items[index]['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: MyColor.black),
                          ),
                          subtitle: Text(
                            '(score from 1 to 5)',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColor.orange2,
                            ),
                            child: Icon(
                              isExpanded ? Icons.remove : Icons.add,
                              color: MyColor.white,
                            ),
                          ),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isExpanded = expanded;
                            });
                          },
                          children: items[index]['description'].isNotEmpty
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          items[index]['description'],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 8),
                                        if (items[index]['rating'] != null)
                                          Row(
                                            children:
                                                List.generate(5, (starIndex) {
                                              return Icon(
                                                starIndex <
                                                        items[index]['rating']
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.orange,
                                              );
                                            }),
                                          ),
                                      ],
                                    ),
                                  ),
                                ]
                              : [],
                        ),
                      );
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildImageCard(post.imageUrl),
                  _buildImageCard(post.imageUrl),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(width: 1.4, color: MyColor.orange2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColor.orange2,
                          ),
                          child: Icon(
                            Icons.add,
                            color: MyColor.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MyString.reg('addAnother'.tr, 14, MyColor.textBlack0,
                            TextAlign.start)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: List.generate(3, (rowIndex) {
                    // Create rows with 2 switches each
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(2, (switchIndex) {
                        int index = rowIndex * 2 +
                            switchIndex; // Calculate the actual index
                        return Row(
                          children: [
                            Switch(
                              value: isSelected[index],
                              onChanged: (bool value) {
                                setState(() {
                                  isSelected[index] = value;
                                });
                              },
                              activeColor: MyColor.orange2,
                              thumbColor:
                                  WidgetStateProperty.all(MyColor.white),
                              activeTrackColor: MyColor.orange2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: SizedBox(
                                width: 90,
                                child: Text(
                                  '${options[index]}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.email,
                    color: MyColor.orange2,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MyString.reg('name@gmail.com', 14, MyColor.textBlack0,
                      TextAlign.start),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.phone,
                    color: MyColor.orange2,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MyString.reg(
                      '123 456 789', 14, MyColor.textBlack0, TextAlign.start),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {},
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    decoration: BoxDecoration(
                        color: MyColor.orange2,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(22))),
                    child: MyString.med(
                        'publish'.tr, 18, MyColor.white, TextAlign.center),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget _buildCheckboxRow(
      String label, bool value, ValueChanged<bool?>? onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}
