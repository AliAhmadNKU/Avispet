import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/apis/api_strings.dart';
import '../../../utils/apis/get_api.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class Ranking extends StatefulWidget {
  const Ranking({super.key});

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {

  var isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   getData();
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
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(20, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Image.asset('assets/images/icons/back_icon.png', color: MyColor.white),
          ),
        ),
        title: MyString.bold('ranking'.tr.toUpperCase(), 18, MyColor.white, TextAlign.center),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          setState(() {
            isLoading = true;
          });
          getData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: MyColor.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
            child: (isLoading)?Center(child: CircularProgressIndicator(color: MyColor.newBackgroundColor,))
                :Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      MyString.bold("${'leaderboard'.tr} ● ${'weekly'.tr}", 15, MyColor.black, TextAlign.center),
                      SizedBox(height: 5,),
                      MyString.med("rankingDec".tr, 12, MyColor.black, TextAlign.center)
                    ],
                  ),
                ),

                ///TOP 3
                if(GetApi.rankingModel.data != null)SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ///Second
                      Column(
                        children: [
                          SizedBox(height: 30,),
                          InkWell(
                            onTap: (){
                              Map<String, dynamic> mapData = {
                                'userID': GetApi.rankingModel.data![1].userId.toString()
                              };
                              Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                            },
                            child: SizedBox(
                              height: 120,
                              width: 80,
                              child: (GetApi.rankingModel.data!.length >= 2)?Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 42),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: MyColor.red,
                                        border: Border.all(color: MyColor.red,width: 2.5)
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child:  (GetApi.rankingModel.data![1].user!.profilePicture == null)
                                          ?Image.asset(
                                        'assets/images/onboard/new_logo.png',
                                        fit: BoxFit.cover,
                                        width: 65,
                                        height: 65,)
                                          :Image.network(
                                        ApiStrings.mediaURl+GetApi.rankingModel.data![1].user!.profilePicture,
                                        fit: BoxFit.cover,
                                        width: 65,
                                        height: 65,),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset("assets/images/icons/rank_two_badge.png",height: 25))
                                ],
                              ):SizedBox(),
                            ),
                          ),
                          SizedBox(height: 5,),
                          if(GetApi.rankingModel.data!.length >= 2)SizedBox(width:100,child: MyString.boldMultiLine(GetApi.rankingModel.data![1].user!.name!.capitalize.toString(), 13, MyColor.black, TextAlign.center,1)),
                          if(GetApi.rankingModel.data!.length >= 2)MyString.med("${GetApi.rankingModel.data![1].totalPoints} pts", 11, MyColor.textFieldBorder, TextAlign.center),
                        ],
                      ),

                      ///First
                      Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Map<String, dynamic> mapData = {
                                'userID': GetApi.rankingModel.data![0].userId.toString()
                              };
                              Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                            },
                            child: SizedBox(
                              height: 120,
                              width: 80,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 42),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: MyColor.newBackgroundColor,
                                        border: Border.all(color: MyColor.newBackgroundColor,width: 2.5)
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (GetApi.rankingModel.data![0].user!.profilePicture == null)
                                          ?Image.asset(
                                        'assets/images/onboard/new_logo.png',
                                        fit: BoxFit.cover,
                                        width: 65,
                                        height: 65,)
                                          :Image.network(
                                        ApiStrings.mediaURl+GetApi.rankingModel.data![0].user!.profilePicture,
                                        fit: BoxFit.cover,
                                        width: 65,
                                        height: 65,),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                      child: Image.asset("assets/images/icons/crown_first.png",height: 45,)),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                      child: Image.asset("assets/images/icons/rank_one_badge.png",height: 25))
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 5,),
                          SizedBox(width:100,child: MyString.boldMultiLine(GetApi.rankingModel.data![0].user!.name!.capitalize.toString(), 13, MyColor.black, TextAlign.center,1)),
                          MyString.med("${GetApi.rankingModel.data![0].totalPoints} pts", 11, MyColor.textFieldBorder, TextAlign.center),
                        ],
                      ),

                      ///Third
                      Column(
                        children: [
                          SizedBox(height: 30,),
                          InkWell(
                            onTap: (){
                              Map<String, dynamic> mapData = {
                                'userID': GetApi.rankingModel.data![2].userId.toString()
                              };
                              Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                            },
                            child: SizedBox(
                              height: 120,
                              width: 80,
                              child: (GetApi.rankingModel.data!.length >= 3)?Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 42),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: MyColor.textFieldBorder,
                                        border: Border.all(color: MyColor.textFieldBorder,width: 2.5)
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (GetApi.rankingModel.data![2].user!.profilePicture == null)
                                          ?Image.asset(
                                        'assets/images/onboard/new_logo.png',
                                        fit: BoxFit.cover,
                                        width: 65,
                                        height: 65,)
                                          :Image.network(
                                        ApiStrings.mediaURl+GetApi.rankingModel.data![2].user!.profilePicture,
                                        fit: BoxFit.cover,
                                        width: 65,
                                        height: 65,),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset("assets/images/icons/rank_three_badge.png",height: 25))
                                ],
                              ):SizedBox(),
                            ),
                          ),
                          SizedBox(height: 5,),
                          if(GetApi.rankingModel.data!.length >= 3)SizedBox(width:100,child: MyString.boldMultiLine(GetApi.rankingModel.data![2].user!.name!.capitalize.toString(), 13, MyColor.black, TextAlign.center,1)),
                          if(GetApi.rankingModel.data!.length >= 3)MyString.med("${GetApi.rankingModel.data![2].totalPoints} pts", 11, MyColor.textFieldBorder, TextAlign.center),
                        ],
                      ),

                    ],
                  ),
                ),

                ///Others List
                if(GetApi.rankingModel.data != null)SizedBox(height: 30,),
                (GetApi.rankingModel.data != null)
                    ?(GetApi.rankingModel.data!.length > 3)?Expanded(child: ListView.builder(
                  shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: GetApi.rankingModel.data!.length,
                    itemBuilder: (context,index){
                      return  (index == 0 || index == 1 || index == 2)?SizedBox():Padding(
                        padding: const EdgeInsets.only(right: 4,left: 4,bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            GestureDetector(
                              onTap: (){
                                Map<String, dynamic> mapData = {
                                  'userID': GetApi.rankingModel.data![index].userId.toString()
                                };
                                Navigator.pushNamed(context, RoutesName.myProfile, arguments: mapData);
                              },
                              child: Row(
                                children: [
                                  (GetApi.rankingModel.data![index].user!.profilePicture == null)
                                      ? ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    child: Image.asset(
                                      'assets/images/onboard/new_logo.png',
                                      fit: BoxFit.cover,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ):ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      ApiStrings.mediaURl+GetApi.rankingModel.data![index].user!.profilePicture,
                                      fit: BoxFit.cover,
                                      width: 30,
                                      height: 30,),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                      width: MediaQuery.of(context).size.width * .43,
                                      child: MyString.medMultiLine(GetApi.rankingModel.data![index].user!.name!.capitalize.toString(), 16, MyColor.textBlack2, TextAlign.start,1)),
                                ],
                              ),
                            ),

                            MyString.med("${GetApi.rankingModel.data![index].totalPoints} pts", 13, MyColor.black, TextAlign.end)
                          ],
                        ),
                      );
                    })):SizedBox()
                    :SizedBox(
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
                          child: MyString.bold('noDataFound'.tr, 16, MyColor.textFieldBorder, TextAlign.center)),
                                    ],
                                  ),
                    ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {

    await GetApi.getRankingApi(context, sharedPref.getString(SharedKey.userId).toString());
    setState(() {
      isLoading = false;
    });

  }
}
