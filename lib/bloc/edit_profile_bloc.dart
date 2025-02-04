import 'dart:convert';
import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/get_profile_model.dart';
import '../utils/apis/get_api.dart';
import '../utils/my_routes/route_name.dart';
import '../utils/shared_pref.dart';

class EditProfileBloc extends Bloc<GetEditProfileEvent, BlocStates> {
  EditProfileBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetEditProfileEvent) {
        String? value = '';
        if (event.from == 'editProfile') {
          value = checkValidation(event);
        } else {
          value = "";
        }

        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {};

            if (event.from == 'editProfile') {
              mapData = {
                'first_name': event.firstName.toString(),
                'last_name': event.lastName.toString(),
                'pseudo': event.pseudo.toString(),
                'biography': event.bio.toString(),
                'phone_number': event.phoneNumber.toString(),
                'city': event.city.toString(),
                'area': event.address.toString(),
              };
            }




            String id= "/${sharedPref.getString(SharedKey.userId)}";
            String editProfile = "";
            editProfile = ApiStrings.updateProfile+id;

            var res = await AllApi.patchtMethodApi(editProfile, mapData);
            var result = jsonDecode(res.toString());
            if (result['status'] == 200) {
              GetApi.getProfileModel.data = Data();
              GetApi.getProfileModel = GetProfileModel.fromJson(result);
              // GetApi.getProfileModel.data!.biography =
              //     GetApi.getProfileModel.data!.biography.toString();
              emit(Loaded());
              emit(ValidationCheck(result['message'].toString()));
              emit(NextScreen());
            } else if (result['status'] == 401) {
              sharedPref.clear();
              sharedPref.setString(SharedKey.onboardScreen, 'OFF');
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.loginScreen, (route) => false);
            } else {
              emit(Loaded());
              emit(ValidationCheck(result['message'].toString()));
            }
          }).onError((error, stackTrace) {
            emit(Error(error.toString()));
          });
        }
      }
    });
  }

  String? checkValidation(GetEditProfileEvent data) {
    final bool emailValid =
        RegExp(StringKey.emailValidation).hasMatch(data.email.toString());
    if (data.firstName.toString().isEmpty) {
      return StringKey.enterFirstName;
    }
    if (data.lastName.toString().isEmpty) {
      return StringKey.enterLastName;
    }
    if (data.city.toString().isEmpty) {
      return StringKey.enterCity;
    }
    if (data.address.toString().isEmpty) {
      return StringKey.enterAddress;
    }

    if (data.email.toString().isEmpty) {
      return StringKey.enterEmail;
    }
    if (!emailValid) {
      return StringKey.validEmail;
    }
    if (data.pseudo.toString().isEmpty) {
      return StringKey.enterPseudo;
    }
    if (data.phoneNumber.toString().isEmpty) {
      return StringKey.enterPhone;
    }

    return '';
  }
}
