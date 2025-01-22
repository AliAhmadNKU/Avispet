import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/aa_common_model.dart';
import '../../utils/apis/all_api.dart';
import '../../utils/apis/api_strings.dart';
import '../../utils/shared_pref.dart';
import 'bloc_states.dart';

CommonModel commonModel = CommonModel();

class ContactUsBloc extends Bloc<GetContactUsEvent, BlocStates> {
  ContactUsBloc(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetContactUsEvent) {
        String? value = checkValidation(event);
        if (value != '') {
          emit(ValidationCheck(value));
          debugPrint("CONTACT-US MAP DATA IS : 11");
        } else {
          debugPrint("CONTACT-US MAP DATA IS : 22");
          emit(Loading());
          await Future.delayed(Duration.zero, () async {
            Map<String, String> mapData = {
              'name': event.name.toString(),
              'email': event.email.toString(),
              'message': event.message.toString(),
            };
            debugPrint("CONTACT-US MAP DATA IS : $mapData");
            var res = await AllApi.postMethodApi(ApiStrings.contactUs, mapData);
            var result = jsonDecode(res.toString());
            if (result['status'] == 200) {
              commonModel = CommonModel.fromJson(result);
              emit(ValidationCheck(result['message'].toString()));
              emit(Loaded());
              emit(NextScreen());
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

  String? checkValidation(GetContactUsEvent data) {
    final bool emailValid =
        RegExp(StringKey.emailValidation).hasMatch(data.email.toString());
    if (data.name.toString().isEmpty) {
      return StringKey.enterFirstName;
    }
    if (data.email.toString().isEmpty) {
      return StringKey.enterEmail;
    }
    if (!emailValid) {
      return StringKey.validEmail;
    }
    if (data.message.toString().isEmpty) {
      return StringKey.enterMessage;
    }
    return '';
  }
}
