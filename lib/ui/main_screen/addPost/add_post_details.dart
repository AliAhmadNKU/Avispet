import 'dart:convert';

import 'package:avispets/models/add_post_model.dart';
import 'package:avispets/ui/widgets/cached_image.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../bloc/bloc_events.dart';
import '../../../utils/apis/all_api.dart';
import '../../../utils/apis/api_strings.dart';
import '../../../utils/common_function/toaster.dart';
import '../../../utils/shared_pref.dart';
import '../home/home_screen.dart';
import '../home/post_detail.dart';
import 'add_post.dart';

class AddPostDetails extends StatefulWidget {

  int id ;
   AddPostDetails({super.key,required this.id});

  @override
  State<AddPostDetails> createState() => _AddPostDetailsState();
}

class _AddPostDetailsState extends State<AddPostDetails> {
  late AddPost addPost;

  List<bool> isSelected = [];
  TextEditingController additionalInfo = TextEditingController();

  int cr1 = 1;
  int cr2 = 1;
  int cr3 = 1;
  int cr4 = 1;
  int cr5 = 1;
  final post = Postssss(
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
  bool isLoading = false;
  List<CriteriaModel> CriteriasList = [
    CriteriaModel(
      title: 'Atmosphere and environment',
      subtitle: '(score from 1 to 5)',
      data: [
        CriteriaModelBody(l1: '1: Very unpleasant (noisy, dirty, unsafe).'),
        CriteriaModelBody(
            l2: '2: Not very pleasant, several notable problems.'),
        CriteriaModelBody(l3: '3: Acceptable, some areas for improvement.'),
        CriteriaModelBody(l4: '4: Nice and clean, good environment.'),
        CriteriaModelBody(l5: '5: Excellent, very pet friendly.')
      ],
    ),
    CriteriaModel(
      title: 'Safety for animals',
      subtitle: '(score from 1 to 5)',
      data: [
        CriteriaModelBody(l1: '1: Very dangerous for animals (high risks).'),
        CriteriaModelBody(l2: '2: Risks present but manageable.'),
        CriteriaModelBody(l3: '3: Acceptable, some concerns.'),
        CriteriaModelBody(l4: '4: Generally safe for animals.'),
        CriteriaModelBody(l5: '5: Very safe, excellent security measures.')
      ],
    ),
    CriteriaModel(
        title: 'Accessibility and infrastructure',
        subtitle: '(score from 1 to 5)',
        data: [
          CriteriaModelBody(
              l1: '1: Very difficult to access with an animal (no ramps, stairs).'),
          CriteriaModelBody(
              l2: '2: Difficult to access, little suitable infrastructure.'),
          CriteriaModelBody(l3: '3: Acceptable, some easy access.'),
          CriteriaModelBody(l4: '4: Well accessible with good infrastructure.'),
          CriteriaModelBody(l5: '5: Perfectly accessible, excellent layout.')
        ]),
    CriteriaModel(
        title: 'Social interactions',
        subtitle: '(score from 1 to 5)',
        data: [
          CriteriaModelBody(
              l1: '1: No opportunities to socialize (pets or owners).'),
          CriteriaModelBody(
              l2: '2: Few interactions possible, closed atmosphere.'),
          CriteriaModelBody(l3: '3: Casual interactions, neutral atmosphere.'),
          CriteriaModelBody(
              l4: '4: Good socializing opportunities, friendly atmosphere.'),
          CriteriaModelBody(
              l5: '5: Excellent interactions, very welcoming to animals and their owners.')
        ]),
    CriteriaModel(
        title: 'Value for money',
        subtitle: '(score from 1 to 5)',
        data: [
          CriteriaModelBody(
              l1: '1: Very poor value for money (too expensive for what is offered).'),
          CriteriaModelBody(l2: '2: Bad ratio, limited options for the price.'),
          CriteriaModelBody(l3: '3: Acceptable, good value for money.'),
          CriteriaModelBody(l4: '4: Good value for money, satisfactory.'),
          CriteriaModelBody(
              l5: '5: Excellent value for money, high quality services.')
        ])
  ];
  @override
  void initState() {


    getPostByID();
    // TODO: implement initState
    super.initState();
  }


  getPostByID() async {
    try {
       isLoading = true;
      var res = await AllApi.getMethodApi("${ApiStrings.getPostById}/${widget.id}");
      var result = jsonDecode(res.toString());

       print("asdadsadasdsad ${result}");

      if (result['status'] == 200) {

        addPost = AddPost.fromJson(result);

        print("asdadsadasdsad ${addPost.data.placeId}");

        setState(() {
          isSelected = [addPost.data.greenSpaces,addPost.data.child,addPost.data.dogLeash,addPost.data.allDogs,addPost.data.bigDogs,
            addPost.data.smallDogs
          ];
          isLoading = false;
        });
      } else if (result['status'] == 401) {
        isLoading = false;

      } else {
        isLoading = false;
        toaster(context, result['message'].toString());
      }
    } catch (e) {
      debugPrint("Error: $e");
      toaster(context, "An error occurred while fetching post.");
    }
  }






  final List<String> options = [
    'Green spaces nearby',
    'Presence of child',
    'Dog leash obligatory',
    'All dogs allowed',
    'Suitable for big dogs',
    'Suitable for small dogs',
  ];



  Future<void> credentialCheck() async {




    List<String> imageArray = [];
    List<String> criteriaTitles = [
      'Atmosphere and environment',
      'Safety for animals',
      'Accessibility and infrastructure',
      'Social interactions',
      'Value for money'
    ];

// Map the ratings to the criteria titles
    List<int> ratings = [cr1, cr2, cr3, cr4, cr5];

// Create the postRatings list dynamically
    List<PostRatingX> postRatings = [];

    for (int i = 0; i < ratings.length; i++) {
      if (ratings[i] != 0 || ratings[i] != 1) {
        postRatings.add(PostRatingX(
          category: criteriaTitles[i],
          rating: ratings[i],
        ));
      }
    }


    Map<String, dynamic> mapData = {
      "postId": addPost.data.id,
      'userId': int.parse(sharedPref.getString(SharedKey.userId)!),
      'placeId': addPost.data.placeId,
      'images': addPost.data.images,
      'place_name': addPost.data.placeName,
      'description': additionalInfo.text,
      'postRatings': postRatings.map((post) => post.toJson()).toList(),
    };

    debugPrint("CREATE-POSTV2 MAP DATA IS : $mapData");

    try {
      var res = await AllApi.postMethodApi(
        ApiStrings.createReview,
        mapData,
      );
      print('===================+$res=====================');
      var result = jsonDecode(res.toString());

      if (result['status'] == 201) {

        print("idhr aya hai");
        Get.back(result: true);
         toaster(context, "review Submitted Successfully");

      } else if (result['status'] == 401) {


      } else {

        toaster(context, result['message'].toString());
      }
    } catch (e) {
      debugPrint("Error: $e");
      toaster(context, "An error occurred while submitted review.");
    }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: isLoading==true?
      progressBar():
      SingleChildScrollView(
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
                    '${'addReviewTitle'.tr}', 27, MyColor.title, TextAlign.center),
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
                        child: CachedImage(
                            width: 130,
                            height: 110,
                            fit: BoxFit.cover,
                            url:
                            addPost.data.images[0]

                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          addPost.data.placeName=="No Name"?
                          MyString.reg(
                              'No place name', 14, MyColor.orange2, TextAlign.start):
                          Container(
                            width: 160,
                            child: Text(
                              "${addPost.data.placeName}"??"",
                              overflow: TextOverflow.ellipsis,
                              textAlign:  TextAlign.start,
                              style: TextStyle(
                                fontSize: 18,
                                color: MyColor.orange2,
                                fontFamily: 'poppins_regular',
                              ),
                            ),
                          ),
                          Container(
                            width: 160,
                            child: Text(
                              "${addPost.data.address}"??"",
                              overflow: TextOverflow.ellipsis,
                              textAlign:  TextAlign.start,
                              style: TextStyle(
                                fontSize: 12,
                                color: MyColor.textBlack0,
                                fontFamily: 'poppins_regular',
                              ),
                            ),
                          ),
                          MyString.reg(addPost.data.category, 12, MyColor.textBlack0,
                              TextAlign.start),
                          MyString.reg("${addPost.data.locationDistance.toString() + addPost.data.locationDistanceUnit}", 12, MyColor.textBlack0,
                              TextAlign.start),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              MyString.reg('${addPost.data.locationRating} (${addPost.data.userRatingCount})',
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
              Container(
                margin: EdgeInsets.only(bottom: 20),
                // height: MediaQuery.of(context)
                //         .size
                //         .height *
                //     0.54,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: CriteriasList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets
                                .symmetric(
                                vertical: 3,
                                horizontal: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius.circular(
                                          10))),
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                    MyColor.card,
                                    border: Border.all(
                                        color: MyColor
                                            .orange2),
                                    borderRadius:
                                    const BorderRadius
                                        .all(
                                        Radius.circular(
                                            10))),
                                child: ExpansionTile(
                                  backgroundColor:
                                  MyColor.orange2,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        10),
                                  ),
                                  collapsedBackgroundColor:
                                  MyColor.card,
                                  collapsedShape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        10),
                                  ),
                                  title: MyString.bold(
                                      '${CriteriasList[index].title}',
                                      14,
                                      CriteriasList[
                                      index]
                                          .isExpanded
                                          ? MyColor
                                          .white
                                          : MyColor
                                          .redd,
                                      TextAlign
                                          .start),
                                  subtitle: MyString.reg(
                                      '${CriteriasList[index].subtitle}',
                                      12,
                                      CriteriasList[
                                      index]
                                          .isExpanded
                                          ? MyColor
                                          .white
                                          : MyColor
                                          .redd,
                                      TextAlign
                                          .start),
                                  trailing:
                                  Image.asset(
                                    CriteriasList[
                                    index]
                                        .isExpanded
                                        ? 'assets/images/icons/minus.png'
                                        : 'assets/images/icons/addpic.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  onExpansionChanged:
                                      (bool
                                  expanded) {
                                    setState(() {
                                      CriteriasList[
                                      index]
                                          .isExpanded =
                                          expanded;
                                    });
                                  },
                                  children: [
                                    ...?CriteriasList[
                                    index]
                                        .data
                                        ?.map(
                                            (criteriaBody) {
                                          return Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                18.0,
                                                vertical:
                                                2),
                                            color: MyColor
                                                .card,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              children: [
                                                SizedBox(
                                                  height:
                                                  2,
                                                ),
                                                if (criteriaBody
                                                    .l1 !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: MyString.reg(criteriaBody.l1!, 12, MyColor.textBlack0, TextAlign.start),
                                                      ),
                                                    ],
                                                  ),
                                                if (criteriaBody
                                                    .l2 !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: MyString.reg(criteriaBody.l2!, 12, MyColor.textBlack0, TextAlign.start),
                                                      ),
                                                    ],
                                                  ),
                                                if (criteriaBody
                                                    .l3 !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: MyString.reg(criteriaBody.l3!, 12, MyColor.textBlack0, TextAlign.start),
                                                      ),
                                                    ],
                                                  ),
                                                if (criteriaBody
                                                    .l4 !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: MyString.reg(criteriaBody.l4!, 12, MyColor.textBlack0, TextAlign.start),
                                                      ),
                                                    ],
                                                  ),
                                                if (criteriaBody
                                                    .l5 !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: MyString.reg(criteriaBody.l5!, 12, MyColor.textBlack0, TextAlign.start),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                    Container(
                                      color: MyColor
                                          .card,
                                      padding: EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          18,
                                          vertical:
                                          10),
                                      child: Row(
                                        children: [
                                          MyString.reg(
                                              'Rating: ',
                                              12,
                                              MyColor
                                                  .red,
                                              TextAlign
                                                  .start),
                                          RatingBar
                                              .builder(
                                            unratedColor:
                                            Color(
                                                0xffBEBEBE),
                                            itemSize:
                                            30,
                                            initialRating:
                                            1,
                                            minRating:
                                            1,
                                            direction:
                                            Axis.horizontal,
                                            allowHalfRating:
                                            true,
                                            itemCount:
                                            5,
                                            itemBuilder:
                                                (context, _) =>
                                                Icon(
                                                  Icons
                                                      .star,
                                                  color: Colors
                                                      .amber,
                                                ),
                                            onRatingUpdate:
                                                (rating) {
                                              setState(
                                                      () {
                                                    index == 0
                                                        ? cr1 = rating.toInt()
                                                        : index == 1
                                                        ? cr2 = rating.toInt()
                                                        : index == 2
                                                        ? cr3 = rating.toInt()
                                                        : index == 3
                                                        ? cr4 = rating.toInt()
                                                        : cr5 = rating.toInt();
                                                    ;
                                                  });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),

              MyString.bold(
                  '${'Additional information to share & specify : '.tr}',
                  12,
                  MyColor.title,
                  TextAlign.start),
              TextField(
                maxLength: 300,
                controller: additionalInfo,
                style: TextStyle(
                    color: MyColor.black),
                decoration: InputDecoration(
                  border:
                  const OutlineInputBorder(
                    borderSide:
                    BorderSide.none,
                  ),
                  hintText:
                  'Add description',
                  hintStyle: TextStyle(
                      color:
                      Color(0xffBEBEBE),
                      fontSize: 14),
                  contentPadding:
                  const EdgeInsets
                      .symmetric(
                      vertical: 0,
                      horizontal: 10),
                ),
              ),
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child: CachedImage(
                  url:
                  addPost.data.images[0],
                  fit: BoxFit.cover,
                  width: 120,
                  height:120,
                ),
              ),
              // Container(
              //   height:  110,
              //   width: double.infinity,
              //   child: GridView.builder(
              //     itemCount: addPost.data.images.length,
              //     gridDelegate:
              //     SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount:
              //       3, // Number of items per row
              //       crossAxisSpacing: 8,
              //       mainAxisSpacing: 8,
              //     ),
              //     itemBuilder: (context, index) {
              //
              //         // Display selected images
              //         return Stack(
              //           children: [
              //             ClipRRect(
              //               borderRadius:
              //               BorderRadius.circular(
              //                   10),
              //               child: CachedImage(
              //                 url:
              //                 addPost.data.images[index],
              //                 fit: BoxFit.cover,
              //                 width: double.infinity,
              //                 height: double.infinity,
              //               ),
              //             ),
              //
              //           ],
              //         );
              //
              //     },
              //   ),
              // ),

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
                                // setState(() {
                                //   isSelected[index] = value;
                                // });
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
                  MyString.reg(addPost.data.email, 14, MyColor.textBlack0,
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
                      addPost.data.phone, 14, MyColor.textBlack0, TextAlign.start),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  credentialCheck();
                },
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
              ),
              SizedBox(
                height: 20,
              ),
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
