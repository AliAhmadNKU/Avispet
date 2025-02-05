import 'dart:convert';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/login_model.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/apis/all_api.dart';
import '../utils/my_routes/route_name.dart';

LoginModel _loginModel = LoginModel();

class LoginBloc extends Bloc<LoginEvent, BlocStates> {
  LoginBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetLoginEvent) {
        String? value = checkValidation(event);
        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {
              'email': event.email.toString(),
              'password': event.password.toString(),
              'timezone': event.currentTimeZone.toString(),
              'latitude': event.latitude.toString(),
              'longitude': event.longitude.toString(),
              'deviceToken':
                  sharedPref.getString(SharedKey.deviceToken).toString(),
              'deviceType': event.deviceType.toString(),
            };

            debugPrint("LOGIN MAP DATA IS : $mapData");

            var res = await AllApi.postMethodApi(ApiStrings.login, mapData);

            var result = jsonDecode(res.toString());
            if (result['status'] == 200) {
              _loginModel = LoginModel.fromJson(result);
              emit(ValidationCheck(result['message'].toString()));

              sharedPref.setString(
                  SharedKey.auth, _loginModel.data!.token.toString());
              sharedPref.setString(SharedKey.deviceToken,
                  _loginModel.data!.deviceToken.toString());
              sharedPref.setString(SharedKey.userId, _loginModel.data!.id.toString());
              sharedPref.setString(SharedKey.userEmail, _loginModel.data!.email.toString());

              debugPrint(
                  'LOGIN (AUTH) : ${sharedPref.getString(SharedKey.auth)}');
              debugPrint(
                  'LOGIN (TOKEN) : ${sharedPref.getString(SharedKey.deviceToken)}');
              debugPrint(
                  'LOGIN (USERID) : ${sharedPref.getString(SharedKey.userId)}');
              debugPrint(
                  'LOGIN (USER_EMAIL) : ${sharedPref.getString(SharedKey.userEmail)}');

              emit(Loaded());
              emit(NextScreen());
            } else if (result['status'] == 401) {
              sharedPref.clear();
              sharedPref.setString(SharedKey.onboardScreen, 'OFF');
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.loginScreen, (route) => false);
            } else {
              emit(ValidationCheck(result['message'].toString()));
              emit(Loaded());
            }
          }).onError((error, stackTrace) {
            emit(Error(error.toString()));
          });
        }
      }
    });
  }

  String checkValidation(GetLoginEvent data) {
    final bool emailValid =
        RegExp(StringKey.emailValidation).hasMatch(data.email.toString());
    if (data.email.toString().trim().isEmpty) {
      return StringKey.enterEmail;
    }
    if (!emailValid) {
      return StringKey.validEmail;
    }
    if (data.password.toString().trim().isEmpty) {
      return StringKey.enterPassword;
    }
    return '';
  }
}
