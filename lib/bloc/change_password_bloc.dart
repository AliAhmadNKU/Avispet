import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/my_routes/route_name.dart';

class ChangePasswordBloc extends Bloc<GetChangePasswordEvent, BlocStates> {
  ChangePasswordBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetChangePasswordEvent) {
        String? value = checkValidation(event);
        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {
              'currentPassword': event.currentPassword.toString(),
              'newPassword': event.newPassword.toString(),
              'confirmPassword': event.confirmPassword.toString(),
            };
            debugPrint("CHANGE-PASSWORD MAP DATA IS : $mapData");

            var res =
                await AllApi.putMethodApi(ApiStrings.changePassword, mapData);
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

  String? checkValidation(GetChangePasswordEvent data) {
    if (data.currentPassword.toString().trim().isEmpty) {
      return StringKey.currentPassword;
    }
    if (data.newPassword.toString().trim().isEmpty) {
      return StringKey.newPassword;
    }
    if (data.newPassword.toString().length < 6) {
      return StringKey.passwordLength;
    }
    if (data.confirmPassword.toString().trim().isEmpty) {
      return StringKey.confirmPassword;
    }
    return '';
  }
}
