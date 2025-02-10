import 'package:avispets/utils/my_color.dart';
import 'package:avispets/utils/common_function/my_string.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/common_function/dialogs/bottom_language.dart';
import '../../utils/my_routes/route_name.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selectedPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    initSharedPref();
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    super.initState();
  }

  initSharedPref() async {
    await iniSharePreference();
    sharedPref.setString(SharedKey.onboardScreen, "NO");
  }

  @override
  void dispose() {
    selectedPage = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pageCount = 3;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.50,
              padding: EdgeInsets.symmetric(horizontal: 35),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  (selectedPage == 0)
                      ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'poppins_bold',
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: 'Avispets',
                            style: TextStyle(color: Color(0xff800000)),
                          ),
                          TextSpan(
                            text: 'GiveYourPetTheBest'.tr,
                            style: TextStyle(color: Color(0xff1F3143)),
                          ),
                        ],
                      ),
                    ),
                  )
                      : (selectedPage == 1)
                      ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'poppins_bold',
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: 'Discover'.tr,
                            style: TextStyle(color: Color(0xff1F3143)),
                          ),
                          TextSpan(
                            text: 'Personalized'.tr,
                            style: TextStyle(color: Color(0xff800000)),
                          ),
                          TextSpan(
                            text: 'Forums'.tr,
                            style: TextStyle(color: Color(0xff1F3143)),
                          ),
                        ],
                      ),
                    ),
                  )
                      : (selectedPage == 2)
                      ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'poppins_bold',
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: 'Share&Consult'.tr,
                            style:
                            TextStyle(color: Color(0xff1F3143)),
                          ),
                          TextSpan(
                            text: 'Authentic'.tr,
                            style:
                            TextStyle(color: Color(0xff800000)),
                          ),
                          TextSpan(
                            text: 'Reviews'.tr,
                            style:
                            TextStyle(color: Color(0xff1F3143)),
                          ),
                        ],
                      ),
                    ),
                  ):
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'poppins_bold',
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: 'Avispets',
                            style: TextStyle(color: Color(0xff800000)),
                          ),
                          TextSpan(
                            text: 'GiveYourPetTheBest'.tr,
                            style: TextStyle(color: Color(0xff1F3143)),
                          ),
                        ],
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 0 ),
                  MyString.reg(
                      (selectedPage == 0)
                          ? 'FindTheBestsHotelsRestaurantsParksToVisitWithYourFurryLovedOnes'.tr
                          : (selectedPage == 1)
                          ? 'DiscussCommonTopicsWithPetParentsDependingOnTheBreedOfYourPet'.tr
                          : (selectedPage == 2)
                          ? 'EvaluateTheServicesYouBuyForYourDogsAndCats'.tr
                          : 'FindTheBestsHotelsRestaurantsParksToVisitWithYourFurryLovedones'.tr,
                      14,
                      MyColor.textBlack0,
                      TextAlign.center),
        
                  const SizedBox(height: 20),
                  SizedBox(height: 20,),
                  // PageViewDotIndicator(
                  //   currentItem: selectedPage,
                  //   count: 3,
                  //   size: const Size(16, 10),
                  //   unselectedSize: const Size(10, 10),
                  //   margin: const EdgeInsets.only(right: 1, left: 2),
                  //   duration: const Duration(milliseconds: 200),
                  //   boxShape: BoxShape.rectangle,
                  //   onItemClicked: (index) {},
                  //   unselectedColor: MyColor.liteGrey,
                  //   selectedColor: MyColor.orange,
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (selectedPage == 0)
                          ? Image.asset(
                        "assets/images/onboard/selected_indicator.png",
                        height: 4,
                        width: 26,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        "assets/images/onboard/unselect_indicator.png",
                        height: 4,
                        width: 13,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      (selectedPage == 1)
                          ? Image.asset(
                        "assets/images/onboard/selected_indicator.png",
                        height: 4,
                        width: 26,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        "assets/images/onboard/unselect_indicator.png",
                        height: 4,
                        width: 13,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      (selectedPage == 2)
                          ? Image.asset(
                        "assets/images/onboard/selected_indicator.png",
                        height: 4,
                        width: 26,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        "assets/images/onboard/unselect_indicator.png",
                        height: 4,
                        width: 13,
                        fit: BoxFit.cover,
                      ), ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      Future.delayed(Duration.zero, () {
                        debugPrint('next working');
                        nextPage();
                      });
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 59,
                      width: 151,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(color: MyColor.orange2, borderRadius: const BorderRadius.all(Radius.circular(25))),
                      child:
                          MyString.med('Explore'.tr, 15, MyColor.white, TextAlign.center),
        
        
                    ),
                  ),
                  SizedBox(height: 15,),
                 /* GestureDetector(
                        onTap: () {
                          sharedPref.setString(SharedKey.onboardScreen, "OFF");
                          Navigator.pushNamedAndRemoveUntil(context, RoutesName.loginScreen, (route) => false);
                          debugPrint('Skip working');
                        },
                        child: Container( child: MyString.med('Skip', 16, MyColor.orange2, TextAlign.center)),
                      )*/
                ],
              ),
            ),
        
            Container(
              margin:  EdgeInsets.only(bottom: 200),
              height: double.infinity,
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      selectedPage = page;
                      debugPrint("page no is $page");
                    });
                  },
                  children: List.generate(pageCount, (index) {
                    return Container(
                        alignment: Alignment.topCenter,
                        child: (selectedPage == 0)
                            ? Stack(
                          children: [
                            // Existing images
                            Positioned(
                              top: 60,
                              left: 60,
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.50,
                                alignment: Alignment.topLeft,
                                child: Image.asset(
                                  "assets/images/onboard/onboarding11.png",
                                  width: 190,
                                  height: 190,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -30,
                              left: 90,
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.50,
                                alignment: Alignment.bottomLeft,
                                child: Image.asset(
                                  "assets/images/onboard/onboarding12.png",
                                  width: 132,
                                  height: 132,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 60,
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.50,
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  "assets/images/onboard/onboarding13.png",
                                  width: 89,
                                  height: 89,
                                ),
                              ),
                            ),
        
                            // Empty colorful circles
                            Positioned(
                              top: 30,
                              left: 25,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Color(0xff40E53B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 156,
                                height: 156,
                                decoration: BoxDecoration(
                                  color: Color(0xffFFEDED),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 280,
                              left: -20,
                              child: Container(
                                width: 69,
                                height: 69,
                                decoration: BoxDecoration(
                                  color: MyColor.orange2,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 160,
                              right: 60,
                              child: Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: Color(0xff800000),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 370,
                              right: 130,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xff55A9FC),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        )
        
                            : (selectedPage == 1)
                            ? Stack(
                          children: [
                            // Existing images
                            Positioned(
                              top: 60,
                              left: 60,
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.50,
                                alignment: Alignment.topLeft,
                                child: Image.asset(
                                  "assets/images/onboard/onboarding23.png",
                                  width: 190,
                                  height: 190,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -30,
                              left: 90,
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.50,
                                alignment: Alignment.bottomLeft,
                                child: Image.asset(
                                  "assets/images/onboard/onboarding22.png",
                                  width: 132,
                                  height: 132,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 60,
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.50,
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  "assets/images/onboard/onboarding21.png",
                                  width: 89,
                                  height: 89,
                                ),
                              ),
                            ),
        
                            // Empty colorful circles
                            Positioned(
                              top: 30,
                              left: 25,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Color(0xff40E53B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 156,
                                height: 156,
                                decoration: BoxDecoration(
                                  color: Color(0xffFFEDED),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 280,
                              left: -20,
                              child: Container(
                                width: 69,
                                height: 69,
                                decoration: BoxDecoration(
                                  color: MyColor.orange2,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 160,
                              right: 60,
                              child: Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: Color(0xff800000),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 370,
                              right: 130,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xff55A9FC),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        )
        
                            : (selectedPage == 2)
                            ? Stack(
                          children: [
                          // Existing images
                          Positioned(
                          top: 60,
                          left: 60,
                          child: Container(
                            height: MediaQuery.of(context)
                                .size
                                .height *
                                0.50,
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              "assets/images/onboard/onboarding31.png",
                              width: 190,
                              height: 190,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -30,
                          left: 90,
                          child: Container(
                            height: MediaQuery.of(context)
                                .size
                                .height *
                                0.50,
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(
                              "assets/images/onboard/onboarding32.png",
                              width: 132,
                              height: 132,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 60,
                          child: Container(
                            height: MediaQuery.of(context)
                                .size
                                .height *
                                0.50,
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              "assets/images/onboard/onboarding33.png",
                              width: 89,
                              height: 89,
                            ),
                          ),
                        ),
        
                        // Empty colorful circles
                        Positioned(
                          top: 30,
                          left: 25,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Color(0xff40E53B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Container(
                            width: 156,
                            height: 156,
                            decoration: BoxDecoration(
                              color: Color(0xffFFEDED),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 280,
                          left: -20,
                          child: Container(
                            width: 69,
                            height: 69,
                            decoration: BoxDecoration(
                              color: MyColor.orange2,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 160,
                          right: 60,
                          child: Container(
                            width: 23,
                            height: 23,
                            decoration: BoxDecoration(
                              color: Color(0xff800000),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 370,
                          right: 130,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xff55A9FC),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),])
        
                        : const SizedBox());
                  })),
            ),
            /// translation
            Positioned(
              top: 10,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () async {
                    await changeLanguage(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'assets/images/icons/translation.png',
                      // 'assets/images/icons/translation_login.png',
                      color: const Color(0xff4F2020),
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

  nextPage() async {
    if (selectedPage == 2) {
      sharedPref.setString(SharedKey.onboardScreen, "OFF");
    }
    return (selectedPage != 2)
        ? _pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)
        : Navigator.pushNamedAndRemoveUntil(context, RoutesName.loginScreen, (route) => false);
  }
}
