import 'dart:convert';

import 'package:avispets/bloc/bloc_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/apis/all_api.dart';
import '../utils/apis/api_strings.dart';
import '../utils/my_routes/route_name.dart';
import '../utils/shared_pref.dart';
import 'bloc_events.dart';

class CreateForumTopicBloc extends Bloc<GetCreateForumTopicEvent, BlocStates> {
  CreateForumTopicBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetCreateForumTopicEvent) {
        String? value = checkValidation(event);

        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {
              'forumId': event.forumId.toString(),
              'title': event.title.toString(),
              'description': event.desc.toString(),
              'forumCategoryId': event.forumCategoryCode.toString(),
              'sendEmail': event.isEmailSend.toString(),
            };

            debugPrint("FORUM TOPIC CREATE MAP DATA IS : $mapData");

            var res =
                await AllApi.postMethodApi(ApiStrings.addForumTopic, mapData);
            var result = jsonDecode(res.toString());
            debugPrint("CHANGE-PASSWORD CODE : ${result['status']}");
            emit(Loaded());
            if (result['status'] == 200) {
              emit(ValidationCheck(result['message'].toString()));
              emit(NextScreen());
            } else if (result['status'] == 401) {
              sharedPref.clear();
              sharedPref.setString(SharedKey.onboardScreen, 'OFF');
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.loginScreen, (route) => false);
            } else {
              emit(ValidationCheck(result['message'].toString()));
            }
          }).onError((error, stackTrace) {
            emit(Error(error.toString()));
          });
        }
      }
    });
  }

  String? checkValidation(GetCreateForumTopicEvent data) {
    if (data.title.toString().trim().isEmpty) {
      return StringKey.enterTitle;
    }
    if (data.forumCategoryCode.toString().trim().isEmpty) {
      return StringKey.selectCategory;
    }
    if (data.desc.toString().trim().isEmpty) {
      return StringKey.enterDescription;
    }

    return '';
  }
}
