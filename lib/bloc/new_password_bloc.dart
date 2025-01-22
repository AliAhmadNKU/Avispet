import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPasswordBloc extends Bloc<GetNewPasswordEvent, BlocStates> {
  NewPasswordBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetNewPasswordEvent) {
        String? value = checkValidation(event);
        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {
              'email': event.email.toString(),
              'password': event.newPassword.toString(),
              'confirm_password': event.confirmPassword.toString(),
            };
            debugPrint("CHANGE-PASSWORD MAP DATA IS : $mapData");

            final res = await AllApi.resetPasswordPostMethod(
              mapData,
              ApiStrings.resetPassword,
            );

            var result = jsonDecode(res.toString());
            debugPrint("CHANGE-PASSWORD CODE : ${result['status']}");
            emit(Loaded());
            if (result['status'] == 200) {
              print(
                  'Password is successfully changed ==========================');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(
                  context,
                  RoutesName.loginScreen,
                );
              });
              emit(ValidationCheck(result['message'].toString()));
            } else if (result['status'] == 401) {
              // sharedPref.clear();
              // sharedPref.setString(SharedKey.onboardScreen, 'OFF');
              // Navigator.pushNamedAndRemoveUntil(
              //     context, RoutesName.loginScreen, (route) => false);
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

  String? checkValidation(GetNewPasswordEvent data) {
    if (data.newPassword.toString().length < 6) {
      return StringKey.passwordLength;
    }
    if (data.confirmPassword.toString().trim().isEmpty) {
      return StringKey.confirmPassword;
    }
    return '';
  }
}
