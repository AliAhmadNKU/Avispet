import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_function/dialogs/bottom_language.dart';
import 'common_function/my_string.dart';
import 'my_color.dart';

class Thanks extends StatefulWidget {
  const Thanks({super.key});

  @override
  State<Thanks> createState() => _ThanksState();
}

class _ThanksState extends State<Thanks> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: MyColor.white,
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
bottom: 430,
              child: Container(

                child: Image.asset(

                  'assets/images/icons/bg.png', // Replace with your image path
                  fit: BoxFit.fill, // Ensures the image covers the entire background
                ),
              ),
            ),
            Positioned(
              bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.6,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric( horizontal: 80, vertical: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.elliptical(280,150),topLeft: Radius.elliptical(280,150)),
                      color: MyColor.white
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0, top: 0),
                          child: Image.asset('assets/images/icons/flower.png'),
                        ),
                                Column(
                                  children: [
                                    MyString.bold('Thank You', 27,MyColor.redd,TextAlign.start), SizedBox(height:10),
                                    MyString.reg('hope you enjoying avispet its great if your rate our app', 13, MyColor.textBlack0, TextAlign.center), SizedBox(height:10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.star, color:Colors.amber),
                                        Icon(Icons.star, color:Colors.amber),
                                        Icon(Icons.star, color:Colors.amber),
                                        Icon(Icons.star, color:Colors.amber),
                                        Icon(Icons.star, color:Colors.amber),
                                      ],
                                    )
                                  ],
                                ),

                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                      height: 59,
                      width: 141,
                      decoration: BoxDecoration(
                          color: MyColor.orange2,
                          borderRadius:
                          const BorderRadius.all(
                              Radius.circular(22))),

                      child: Center(child: MyString.med('Home', 16, MyColor.white,TextAlign.center))
                  ),)
                              ],
                                ),
                  ),
                 ),
            // Main Content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 31,
                            height: 31,
                            child: Image.asset(
                              'assets/images/icons/whiteArr.png',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await changeLanguage(context);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            child: Image.asset(
                              'assets/images/icons/translation_login.png',
                              color: const Color(0xff4F2020),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      )

     ;
  }
}
