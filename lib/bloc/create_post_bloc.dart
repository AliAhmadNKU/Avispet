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
        // emit(Loading());
        await Future.delayed(Duration.zero, () async {
          Map<String, dynamic> mapData = {
            'userId': event.userId,
            'placeId': event.placeId,
            'email': event.email,
            'phone': event.phone,
            'images': event.images,
            'category': event.category,
            'overallRating': 0.0,
            'placeName': event.placeName,
            'description': event.description,
            'smallDogs': event.smallDogs,
            'bigDogs': event.bigDogs,
            'child': event.child,
            'allDogs': event.allDogs,
            'dogLeash': event.dogLeash,
            'greenSpaces': event.greenSpaces,
            'reservationPlatform': event.reservationPlatform,
            'additionalInfo': event.description,
            'isFavourite': false,
            'postRatings': event.postRatings.map((post) => post.toJson()).toList(),
            "latitude": event.lat,
            "longitude": event.lng,
            "location_distance": event.location_distance,
            "location_distance_unit": "km",
            "location_rating": event.location_rating,
            "user_rating_count": event.user_rating_count,
            "address":event.address,

          };
          debugPrint("CREATE-POSTV2 MAP DATA IS : $mapData");

          var res = await AllApi.postMethodApi(
            ApiStrings.createPost,
            mapData,
          );
          print('===================+$res=====================');
          var result = jsonDecode(res.toString());
          // commonModel = CommonModel.fromJson(result);
          // emit(Loaded());
          if (result['status'] == 201) {
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
