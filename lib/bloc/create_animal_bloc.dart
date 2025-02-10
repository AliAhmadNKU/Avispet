import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/aa_common_model.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:avispets/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/my_routes/route_name.dart';
import 'contact_us_bloc.dart';

class CreateAnimalBloc extends Bloc<CreateAnimalEvent, BlocStates> {
  CreateAnimalBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetCreateAnimalEvent) {


        String? value = checkValidation(event);

        if (value != '') {
          emit(ValidationCheck(value));
        } else {
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, dynamic> mapData = {
              'name': event.name.toString(),
              'specices': event.type.toString(),
              'weight': event.weight,
              'age': event.age,
              'breed': event.race.toString(),
              'images': event.image,
              "user_id": int.parse(await sharedPref.getString(SharedKey.userId)!),
              'gender': event.gender.toString(),
              'sterilized': event.sterilized.toString(),
            };
            debugPrint("CREATE-ANIMAL MAP DATA IS : $mapData");
            var res = await AllApi.postMethodApi(
              ApiStrings.addAnimal,
              mapData,
            );
            var result = jsonDecode(res.toString());
            print(result);
            if (result['status'] == 201) {
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
    });
  }

  String? checkValidation(GetCreateAnimalEvent data) {

       print("data.age.toString() ${data.image}");

    if (data.image == null || data.image!.isEmpty) {
      return StringKey.animalImage;
    }
    if (data.name.toString().trim().isEmpty) {
      return StringKey.animalName;
    }
    if (data.type.toString().trim().isEmpty) {
      return StringKey.animalType;
    }
    if (data.race.toString().trim().isEmpty) {
      return StringKey.animalRace;
    }

    if (data.gender.toString().trim().isEmpty) {
      return StringKey.animalGender;
    }
    if (data.sterilized.toString().trim().isEmpty) {
      return StringKey.animalSterilized;
    }
    if (data.age==0) {


      return StringKey.animalAge;
    }
       if (data.weight==0) {


         return StringKey.animalWeight;
       }



    return '';
  }
}
