import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/otp_model.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/my_routes/route_name.dart';
import '../utils/shared_pref.dart';

OtpModel _otpModel = OtpModel();

class CreateProfileBloc extends Bloc<CreateProfileEvent, BlocStates> {
  CreateProfileBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetCreateProfileEvent) {
        String value = checkValidation(event);
        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {
              'phone_number': event.phoneNumber.toString(),
            };
            debugPrint("SIGN-UP MAP DATA IS : $mapData");
            var res = await AllApi.otpApi(mapData);
            var result = jsonDecode(res.toString());
            _otpModel = OtpModel.fromJson(result);
            emit(Loaded());
            if (result['status'] == 201) {
              emit(ValidationCheck(result['message'].toString()));

              AllApi.otp = _otpModel.data!.otp.toString();

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

  String checkValidation(GetCreateProfileEvent data) {
    final bool emailValid =
        RegExp(StringKey.emailValidation).hasMatch(data.email.toString());
    if (data.firstName.toString().trim().isEmpty) {
      return StringKey.enterFirstName;
    }
    if (data.lastName.toString().trim().isEmpty) {
      return StringKey.enterLastName;
    }
    if (data.email.toString().isEmpty) {
      return StringKey.enterEmail;
    }
    if (!emailValid) {
      return StringKey.validEmail;
    }
    if (data.password.toString().isEmpty) {
      return StringKey.enterPassword1;
    }
    if (data.password.toString().length < 6) {
      return StringKey.passwordLength;
    }
    if (data.confirmPassword.toString().isEmpty) {
      return StringKey.enterConfirmPassword;
    }
    if (data.password.toString() != data.confirmPassword.toString()) {
      return StringKey.notMatch;
    }
    if (data.pseudo.toString().isEmpty) {
      return StringKey.enterPseudo;
    }
    if (data.phoneNumber.toString().isEmpty) {
      return StringKey.enterPhone;
    }
    if (data.address.toString().isEmpty) {
      return StringKey.enterAddress;
    }
    if (data.city.toString().isEmpty) {
      return StringKey.enterCity;
    }
    if (data.termsCondition == false) {
      return StringKey.selectTermsPrivacy;
    }
    return '';
  }
}
