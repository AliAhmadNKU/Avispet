import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/aa_common_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/my_routes/route_name.dart';
import '../../utils/shared_pref.dart';
import 'contact_us_bloc.dart';

class CreatePostBloc extends Bloc<GetCreatePostEvent, BlocStates> {
  CreatePostBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetCreatePostEvent) {
        emit(Loading());
        await Future.delayed(Duration.zero, () async {
          Map<String, String> mapData = {
            'selectedCategory': event.selectedCategory.toString(),
            'currPos': event.currPos.toString(),
            'lat': event.lat.toString(),
            'long': event.long.toString(),
            'cr1': event.cr1.toString(),
            'cr2': event.cr2.toString(),
            'cr3': event.cr3.toString(),
            'cr4': event.cr4.toString(),
            'cr5': event.cr5.toString(),
            'smallDogsAllowed': event.smallDogsAllowed.toString(),
            'bigDogsAllowed': event.bigDogsAllowed.toString(),
            'childPresence': event.childPresence.toString(),
            'allDogsAllowed': event.allDogsAllowed.toString(),
            'leashRequired': event.leashRequired.toString(),
            'greenSpacesNearby': event.greenSpacesNearby.toString(),
          };
          debugPrint("CREATE-POSTV2 MAP DATA IS : $mapData");

          var res = await AllApi.postMethodApiWithArrayImage(
              mapData,
              ApiStrings.postfeedV2,
              event.imageList,
              event.thumbnail.toString());
          var result = jsonDecode(res.toString());
          commonModel = CommonModel.fromJson(result);
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
    });
  }
}
