import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/my_routes/route_name.dart';
import '../../utils/shared_pref.dart';

class FollowUnfollowBloc extends Bloc<GetFollowUnfollowEvent, BlocStates> {
  FollowUnfollowBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetFollowUnfollowEvent) {
        emit(Loading());
        await Future.delayed(Duration.zero, () async {
          Map<String, String> mapData = {'followId': event.followId.toString()};
          var res = await AllApi.postMethodApi(
              ApiStrings.followUnfollowUser, mapData);
          var result = jsonDecode(res.toString());
          emit(Loaded());
          if (result['status'] == 401) {
            sharedPref.clear();
            sharedPref.setString(SharedKey.onboardScreen, 'OFF');
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.loginScreen, (route) => false);
          }
        }).onError((error, stackTrace) {
          emit(Error(error.toString()));
        });
      }
    });
  }
}
