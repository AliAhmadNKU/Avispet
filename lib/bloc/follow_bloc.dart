import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/common_function/loader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/my_routes/route_name.dart';
import '../../utils/shared_pref.dart';
import '../ui/widgets/post_card.dart';

class FollowUnfollowBloc extends Bloc<GetFollowUnfollowEvent, BlocStates> {
  FollowUnfollowBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetFollowUnfollowEvent) {
        await Future.delayed(Duration.zero, () async {
          emit(Loading());
          Map<String, dynamic> mapData = {'followingId': int.parse(event.followId!)};
          var res = await AllApi.postMethodApi(
              ApiStrings.followUser, mapData);
          var result = jsonDecode(res.toString());
          print(result);

          if (result['status'] == 200) {


            // sharedPref.clear();
            // sharedPref.setString(SharedKey.onboardScreen, 'OFF');
            // Navigator.pushNamedAndRemoveUntil(
            //     context, RoutesName.loginScreen, (route) => false);
          }
          if (result['status'] == 401) {
            // sharedPref.clear();
            // sharedPref.setString(SharedKey.onboardScreen, 'OFF');
            // Navigator.pushNamedAndRemoveUntil(
            //     context, RoutesName.loginScreen, (route) => false);
          }
          emit(Loaded());
        }).onError((error, stackTrace) {
          emit(Error(error.toString()));
        });
      }
      // if (event is GetFollowUnfollowEvent) {
      //   emit(Loading());
      //   await Future.delayed(Duration.zero, () async {
      //     Map<String, String> mapData = {'followId': event.followId.toString()};
      //     var res = await AllApi.postMethodApi(
      //         ApiStrings.followUnfollowUser, mapData);
      //     var result = jsonDecode(res.toString());
      //     emit(Loaded());
      //     if (result['status'] == 401) {
      //       sharedPref.clear();
      //       sharedPref.setString(SharedKey.onboardScreen, 'OFF');
      //       Navigator.pushNamedAndRemoveUntil(
      //           context, RoutesName.loginScreen, (route) => false);
      //     }
      //   }).onError((error, stackTrace) {
      //     emit(Error(error.toString()));
      //   });
      // }
    });
  }
}
