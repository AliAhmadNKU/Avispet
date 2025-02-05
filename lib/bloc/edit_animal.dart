import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/bloc/contact_us_bloc.dart';
import 'package:avispets/models/aa_common_model.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/my_routes/route_name.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/apis/all_api.dart';

class EditAnimalBloc extends Bloc<EditAnimalEvent, BlocStates> {
  EditAnimalBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      try {
        if (event is GetEditAnimalEvent) {
          String? value = checkValidation(event);
          print('=================1==================');

          if (value != '') {
            emit(ValidationCheck(value));
          } else {
            // emit(Loading());
            print('==================2=================');

            await Future.delayed(Duration.zero, () async {
              Map<String, dynamic> mapData = {
                // 'id': event.id.toString(),
                'name': event.name.toString(),
                'specices': event.specices.toString(),
                'gender': event.gender.toString(),
                'weight': event.weight!,
                'breed': event.race.toString(),
                'age': int.parse(event.dob.toString()),
                'sterilized': event.sterilized == "1" ? "Yes" : "No",
                'images': event.image
              };
              debugPrint("EDIT-ANIMAL MAP DATA IS : $mapData");

              var res = await AllApi.patchtMethodApi(
                '${ApiStrings.updateAnimal}/${event.id}',
                mapData,
              );
              var result = jsonDecode(res.toString());
              print('==================$result=================');
              if (result['status'] == 200) {
                commonModel = CommonModel.fromJson(result);
                emit(ValidationCheck(result['message'].toString()));
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
      } catch (e) {
        print(e);
      }
    });
  }

  String? checkValidation(GetEditAnimalEvent data) {
    if (data.name.toString().trim().isEmpty) {
      return StringKey.animalName;
    }
    if (data.specices.toString().trim().isEmpty) {
      return StringKey.animalType;
    }
    if (data.race.toString().trim().isEmpty) {
      return StringKey.animalRace;
    }
    if (data.dob.toString().trim().isEmpty) {
      return StringKey.animalDob;
    }
    if (data.gender.toString().trim().isEmpty) {
      return StringKey.animalGender;
    }
    if (data.sterilized.toString().trim().isEmpty) {
      return StringKey.animalSterilized;
    }
    return '';
  }
}
