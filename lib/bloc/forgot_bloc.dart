import 'dart:convert';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/aa_common_model.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/my_routes/route_name.dart';

CommonModel commonModel = CommonModel();

class ForgotBloc extends Bloc<ForgotEvent, BlocStates> {
  ForgotBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetForgotEvent) {
        String value = checkValidation(event);
        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {
              'email': event.email.toString(),
            };
            debugPrint("FORGOT-PASSWORD MAP DATA IS : $mapData");

            var res = await AllApi.forgotApi(mapData);

            var result = jsonDecode(res.toString());

            // emit(Loaded());
            if (result['status'] == 200) {
              print('==============================');
              // emit(ValidationCheck(result['message'].toString()));
              Navigator.pushNamed(context, RoutesName.forgetPasswordOtpScreen,
                  arguments: {
                    'email': event.email!.trim(),
                  });
              // emit(NextScreen());
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

  String checkValidation(GetForgotEvent data) {
    final bool emailValid =
        RegExp(StringKey.emailValidation).hasMatch(data.email.toString());
    if (data.email.toString().trim().isEmpty) {
      return StringKey.enterEmail;
    }
    if (!emailValid) {
      return StringKey.validEmail;
    }
    return '';
  }
}
