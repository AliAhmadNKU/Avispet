import 'dart:async';
import 'dart:convert';

import 'package:avispets/models/GlobalModel.dart';
import 'package:avispets/models/gamification/user_badges_response_model.dart';
import 'package:avispets/models/gamification_model.dart';
import 'package:avispets/models/ranking_model.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:flutter/material.dart';
import '../../models/faqs_model.dart';
import '../../models/get_all_post_model.dart';
import '../../models/get_cat_breed.dart';
import '../../models/get_dog_breed.dart';
import '../../models/get_notification_model.dart';
import '../../models/get_profile_model.dart';
import '../../models/my_animal_model.dart';
import '../../models/point_history_model.dart';
import '../my_routes/route_name.dart';
import '../shared_pref.dart';
import 'all_api.dart';
import 'api_strings.dart';

class GetApi {
  // global-model
  static GlobalModel globalModel = GlobalModel();

  // get-profile ////HOME_PAGE
  static GetProfileModel getProfileModel = GetProfileModel();
  static Future<GetProfileModel?> getProfileApi(
      BuildContext context, String userId) async {
    var res = await AllApi.getMethodApi("user/$userId");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      getProfileModel = GetProfileModel.fromJson(result);

      if (getProfileModel.data!.id.toString() ==
          sharedPref.getString(SharedKey.userId)) {
        sharedPref.setString(SharedKey.userprofilePic,
            '${ApiStrings.mediaURl}${getProfileModel.data!.profilePicture.toString()}');
      }

      return getProfileModel;
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    return null;
  }

  //get-all-post
  static GetAllPostModel _allPostModel = GetAllPostModel();
  static GetAllPostModel _allPostModel1 = GetAllPostModel();
  static List<GetAllPostModelBody> getPost = [];
  static List<GetAllPostModelBody> getPost1 = [];
  static getAllPost(
      BuildContext context,
      int type,
      int loadPage,
      String searchItem,
      int showFollowerFeed,
      int showFollowingFeed,
      int pillClicked,
      String catRaces,
      String dogRaces,
      String subCategoryIds,
      String userId) async {
    int x = type;
    if (x == 1) {
      x = 2;
    }

    var res = await AllApi.getMethodApi(
        "${ApiStrings.feeds}?page=$loadPage&limit=20&search=$searchItem&userId=$userId&type=${x.toString()}&showFollowerFeed=$showFollowerFeed&showFollowingFeed=$showFollowingFeed&pillClicked=${pillClicked.toString()}&catRaces=$catRaces&dogRaces=$dogRaces&subCategoryIds=$subCategoryIds");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      if (loadPage == 1) {
        getPost.clear();
      }
      _allPostModel = GetAllPostModel.fromJson(result);

      for (int i = 0; i < _allPostModel.data!.length; i++) {
        getPost.add(_allPostModel.data![i]);
      }
      for (int i = 0; i < getPost.length; i++) {
        if (getPost[i].isLiked == 1) {
          getPost[i].likeEnable = true;
        } else {
          getPost[i].likeEnable = false;
        }
        if (getPost[i].isFav == 1) {
          getPost[i].bookmarkEnable = true;
        } else {
          getPost[i].bookmarkEnable = false;
        }
        getPost[i].localCommentStore =
            int.parse(getPost[i].totalComments.toString());
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['message'].toString());
    }
  }

  static getAllPostHome(
      BuildContext context,
      int type,
      int loadPage,
      String searchItem,
      int showFollowerFeed,
      int showFollowingFeed,
      String pillClicked,
      String catRaces,
      String dogRaces,
      String subCategoryIds,
      String min,
      String max) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.feeds}?page=$loadPage&limit=10&search=$searchItem&userId=${sharedPref.getString(SharedKey.userId).toString()}&type=${type.toString()}&showFollowerFeed=$showFollowerFeed&showFollowingFeed=$showFollowingFeed&pillClicked=$pillClicked&catRaces=$catRaces&dogRaces=$dogRaces&subCategoryIds=$subCategoryIds&minPrice=$min&maxPrice=$max");

    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      if (loadPage == 1) {
        getPost1.clear();
      }
      _allPostModel1 = GetAllPostModel.fromJson(result);
      for (int i = 0; i < _allPostModel1.data!.length; i++) {
        getPost1.add(_allPostModel1.data![i]);

        if (getPost1[i].isLiked == 1) {
          getPost1[i].likeEnable = true;
        } else {
          getPost1[i].likeEnable = false;
        }

        if (getPost1[i].isFav == 1) {
          getPost1[i].bookmarkEnable = true;
        } else {
          getPost1[i].bookmarkEnable = false;
        }
        getPost1[i].localCommentStore =
            int.parse(_allPostModel1.data![i].totalComments.toString());
      }

      debugPrint('TOTAL LENGTH ${getPost1.length}');
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['message'].toString());
    }
  }

  //get-notification
  static GetNotification getNotification = GetNotification();
  static getNotify(BuildContext context, String search) async {
    var res =
        await AllApi.getNotify('${ApiStrings.notifications}?search=$search');
    var result = jsonDecode(res.toString());
    debugPrint(result['status'].toString());
    if (result['status'] == 200) {
      getNotification = GetNotification.fromJson(result);
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
  }

  //my-animals
  static MyAnimalModel animalModel = MyAnimalModel();
  static MyAnimalModel animalModelOther = MyAnimalModel();
  static List<MyAnimalModelBody> getAnimal = [];
  static List<MyAnimalModelBody> getAnimalOther = [];
  static List<String> breedList = [];
  static GetDogBreed _getDogBreed = GetDogBreed();
  static GetCatBreed _getCatBreed = GetCatBreed();

  static getMyAnimal(
    BuildContext context,
  ) async {
    var res = await AllApi.getMethodApi(ApiStrings.myAnimals);

    var result = jsonDecode(res.toString());
    print(result);
    if (result['status'] == 200) {
      animalModel = MyAnimalModel.fromJson(result);
      for (int i = 0; i < animalModel.data!.length; i++) {
        getAnimal.add(animalModel.data![i]);
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
  }

  static getMyAnimalNew(
      BuildContext context,
      ) async {
    getAnimal.clear();
    var res = await AllApi.getMethodApi(ApiStrings.myAnimalsNew);

    var result = jsonDecode(res.toString());
    print(result);
    if (result['status'] == 200) {
      animalModel = MyAnimalModel.fromJson(result);
      getAnimal.addAll(animalModel.data!);
      // for (int i = 0; i < animalModel.data!.length; i++) {
      //   getAnimal.add(animalModel.data![i]);
      // }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      // toaster(context, result['status'].toString());
    }
  }

  static getMyAnimalId(BuildContext context, int loaderPage, String id) async {
    var res = await AllApi.getMethodApi("${ApiStrings.animalById}/$id");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      if (loaderPage == 1) {
        getAnimalOther.clear();
      }
      animalModelOther = MyAnimalModel.fromJson(result);
      for (int i = 0; i < animalModelOther.data!.length; i++) {
        getAnimalOther.add(animalModelOther.data![i]);
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
  }

  static getBreed(BuildContext context, int type, int loadPage) async {
    debugPrint('TYPE :${type.toString()}');
    var res = await AllApi.getMethodApi(type == 1
        ? '${ApiStrings.dogBreeds}?page=${loadPage.toString()}&limit=500'
        : '${ApiStrings.catBreeds}?page=${loadPage.toString()}&limit=500');
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      // breedLoader = false;
      if (loadPage == 1) {
        breedList.clear();
      }
      if (type == 1) {
        _getDogBreed = GetDogBreed.fromJson(result);
        for (int i = 0; i < _getDogBreed.data!.length; i++) {
          breedList.add(_getDogBreed.data![i].name.toString());
        }
        debugPrint('BREED LIST (DOG):${breedList.toString()}');
      }
      if (type == 2) {
        _getCatBreed = GetCatBreed.fromJson(result);
        for (int i = 0; i < _getCatBreed.data!.length; i++) {
          breedList.add(_getCatBreed.data![i].name.toString());
        }
        debugPrint('BREED LIST (CAT):${breedList.toString()}');
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
  }

  //faqs
  static FaqsModel _faqsModel = FaqsModel();
  static List<FaqsModelBody> FaqsList = [];
  static getFaqs(BuildContext context, int loaderPage) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.faqs}?page=$loaderPage&limit=20");
    var result = jsonDecode(res.toString());
    if (result['status'] == 200) {
      if (loaderPage == 1) {
        FaqsList.clear();
      }
      _faqsModel = FaqsModel.fromJson(result);
      for (int i = 0; i < _faqsModel.data!.length; i++) {
        FaqsList.add(_faqsModel.data![i]);
      }
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
  }

  //Gamification
  static Gamification gamification = Gamification();
  static UserBadgesResponseModel userBadgesResponseModel = UserBadgesResponseModel();
  static Future<Gamification?> getGamificationApi(
      BuildContext context, String userId) async {
    var res = await AllApi.getMethodApi("${ApiStrings.gamificationBadges}?page=1&limit=1000");
    var result = jsonDecode(res.toString());
    debugPrint("dfdsfdfd f   ${result}");
    if (result['status'] == 200) {
      gamification = Gamification.fromJson(result);

      for (var i = 0; i < gamification.data!.length; i++) {
        if (gamification.data![i].isEarned == 1) {
          gamification.totalBadgesEarn++;
        }
      }

      return gamification;
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    return null;
  }

  static Future getGamificationApiNew(
      BuildContext context, String userId) async {
    var res = await AllApi.getMethodApi("${ApiStrings.gamificationBadges}/${userId}");
    // var res = await AllApi.getMethodApi("${ApiStrings.gamificationBadges}?page=1&limit=1000");
    var result = jsonDecode(res.toString());
    debugPrint("dfdsfdfd f   ${result}");
    if (result['status'] == 200) {
      userBadgesResponseModel = UserBadgesResponseModel.fromJson(result);
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
  }

  int totalBadges = 0;

  //Ranking
  static RankingModel rankingModel = RankingModel();
  static Future<RankingModel?> getRankingApi(
      BuildContext context, String userId) async {
    var res = await AllApi.getMethodApi("${ApiStrings.ranking}");
    var result = jsonDecode(res.toString());
    debugPrint("dfdsfdfd f   ${result}");
    if (result['status'] == 200) {
      rankingModel = RankingModel.fromJson(result);
      return rankingModel;
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    return null;
  }

  ////BADGES
  static PointHistoryModel pointHistoryModel = PointHistoryModel();
  static Future<PointHistoryModel?> getPointsHistoryApi(
      BuildContext context, String userId) async {
    var res = await AllApi.getMethodApi(
        "${ApiStrings.pointHistory}?page=1&limit=1000");
    var result = jsonDecode(res.toString());
    debugPrint("${result}");
    if (result['status'] == 200) {
      pointHistoryModel = PointHistoryModel.fromJson(result);
      return pointHistoryModel;
    } else if (result['status'] == 401) {
      sharedPref.clear();
      sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      toaster(context, result['status'].toString());
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.loginScreen, (route) => false);
    } else {
      toaster(context, result['status'].toString());
    }
    return null;
  }
}
