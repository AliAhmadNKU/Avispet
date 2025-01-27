// import 'dart:convert';

// import 'package:avispets/bloc/bloc_events.dart';
// import 'package:avispets/bloc/bloc_states.dart';
// import 'package:avispets/models/signup_model.dart';
// import 'package:avispets/utils/apis/all_api.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../utils/my_routes/route_name.dart';
// import '../../utils/shared_pref.dart';

// SignUpModel _signUpModel = SignUpModel();

// class SignUpBlock extends Bloc<CreateProfileEvent, BlocStates> {
//   SignUpBlock(BuildContext context) : super(Initial()) {
//     on((event, emit) async {
//       if (event is GetCreateProfileEvent) {
//         emit(Loading());
//         await Future.delayed(Duration.zero, () async {
//           Map<String, String> mapData = {
//             'firstName': event.firstName.toString(),
//             'lastName': event.lastName.toString(),
//             'email': event.email.toString(),
//             'password': event.password.toString(),
//             'timezone': event.timeZone.toString(),
//             'latitude': event.latitude.toString(),
//             'longitude': event.longitude.toString(),
//             'deviceToken':
//                 sharedPref.getString(SharedKey.deviceToken).toString(),
//             'deviceType': event.deviceType.toString(),
//             'pseudo': event.pseudo.toString(),
//             'phoneNumber': event.phoneNumber.toString(),
//             'city': event.city.toString(),
//             'address': event.address.toString(),
//           };
//           debugPrint("SIGN-UP MAP DATA IS : $mapData");
//           var res = await AllApi.signupApi(mapData);
//           var result = jsonDestatus(res.toString());
//           _signUpModel = SignUpModel.fromJson(result);
//           emit(Loaded());
//           if (result['status'] == 200) {
//             sharedPref.setString(
//                 SharedKey.auth, _signUpModel.data!.token.toString());
//             sharedPref.setString(SharedKey.deviceToken,
//                 _signUpModel.data!.deviceToken.toString());
//             sharedPref.setString(
//                 SharedKey.userId, _signUpModel.data!.id.toString());
//             sharedPref.setString(
//                 SharedKey.userEmail, _signUpModel.data!.email.toString());

//             debugPrint(
//                 'SIGNUP (AUTH) : ${sharedPref.getString(SharedKey.auth)}');
//             debugPrint(
//                 'SIGNUP (TOKEN) : ${sharedPref.getString(SharedKey.deviceToken)}');
//             debugPrint(
//                 'LOGIN (USERID) : ${sharedPref.getString(SharedKey.userId)}');
//             debugPrint(
//                 'LOGIN (USER_EMAIL) : ${sharedPref.getString(SharedKey.userEmail)}');

//             emit(ValidationCheck(result['message'].toString()));
//             emit(NextScreen());
//           } else if (result['status'] == 401) {
//             sharedPref.clear();
//             sharedPref.setString(SharedKey.onboardScreen, 'OFF');
//             Navigator.pushNamedAndRemoveUntil(
//                 context, RoutesName.loginScreen, (route) => false);
//           } else {
//             emit(ValidationCheck(result['message'].toString()));
//           }
//         }).onError((error, stackTrace) {
//           emit(Error(error.toString()));
//         });
//       }
//     });
//   }

//   String checkValidation(GetCreateProfileEvent data) {
//     final bool emailValid =
//         RegExp(StringKey.emailValidation).hasMatch(data.email.toString());
//     if (data.firstName.toString().trim().isEmpty) {
//       return StringKey.enterFirstName;
//     }
//     if (data.lastName.toString().trim().isEmpty) {
//       return StringKey.enterLastName;
//     }
//     if (data.email.toString().isEmpty) {
//       return StringKey.enterEmail;
//     }
//     if (!emailValid) {
//       return StringKey.validEmail;
//     }
//     if (data.password.toString().isEmpty) {
//       return StringKey.enterPassword1;
//     }
//     if (data.password.toString().length < 6) {
//       return StringKey.passwordLength;
//     }
//     if (data.confirmPassword.toString().isEmpty) {
//       return StringKey.enterConfirmPassword;
//     }
//     if (data.password.toString() != data.confirmPassword.toString()) {
//       return StringKey.notMatch;
//     }
//     if (data.pseudo.toString().isEmpty) {
//       return StringKey.enterPseudo;
//     }
//     return '';
//   }
// }
import 'dart:convert';

import 'package:avispets/bloc/bloc_events.dart';
import 'package:avispets/bloc/bloc_states.dart';
import 'package:avispets/models/signup_model.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/my_routes/route_name.dart';
import '../../utils/shared_pref.dart';

SignUpModel _signUpModel = SignUpModel();

class SignUpBlock extends Bloc<CreateProfileEvent, BlocStates> {
  SignUpBlock(BuildContext context) : super(Initial()) {
    on((event, emit) async {
      if (event is GetCreateProfileEvent) {
        emit(Loading());
        await Future.delayed(Duration.zero, () async {
          try {
            final mapData = {
              'name': event.firstName!.trim() + ' ' + event.lastName!.trim(),
              'first_name': event.firstName!.trim(),
              'last_name': event.lastName!.trim(),
              'email': event.email!.trim(),
              'password': event.password!.trim(),
              'timezone': event.timeZone!,
              'latitude': event.latitude.toString(),
              'longitude': event.longitude.toString(),
              // 'deviceToken':
              //     sharedPref.getString(SharedKey.deviceToken).toString(),
              // 'deviceType': event.deviceType!,
              'pseudo': event.pseudo!.trim(),
              'phone_number': event.phoneNumber!.trim(),
              'city': event.city!.trim(),
              'area': event.address!.trim(),
            };
            debugPrint("SIGN-UP MAP DATA: $mapData");

            var res = await AllApi.signupApi(json.encode(mapData));

            debugPrint("Response: $res");

            print(jsonEncode(res));
            var result = jsonDecode(res.toString());
            // Deserialize response
            _signUpModel = SignUpModel.fromJson(result);
            emit(Loaded());

            if (result['status'] == 201) {
              // sharedPref.setString(
              //     SharedKey.auth, _signUpModel.data!.token.toString());
              sharedPref.setString(SharedKey.deviceToken,
                  _signUpModel.data!.deviceToken.toString());
              sharedPref.setString(
                  SharedKey.userId, _signUpModel.data!.id.toString());
              sharedPref.setString(
                  SharedKey.userEmail, _signUpModel.data!.email.toString());

              debugPrint(
                  'SIGNUP SUCCESS - TOKEN: ${sharedPref.getString(SharedKey.auth)}');
              debugPrint(
                  'SIGNUP SUCCESS - DEVICE TOKEN: ${sharedPref.getString(SharedKey.deviceToken)}');

              emit(ValidationCheck(result['message'].toString()));
              Navigator.pushNamed(context, RoutesName.otpScreen, arguments: mapData);

              // Navigate to OTP screen
              // Navigator.pushNamed(context, RoutesName.otpScreen, arguments: {
              //   'phoneNumber': event.phoneNumber!.trim(),
              // });

              // emit(NextScreen());
            } else if (result['status'] == 401) {
              // Clear shared preferences and navigate to login
              sharedPref.clear();
              sharedPref.setString(SharedKey.onboardScreen, 'OFF');
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.loginScreen, (route) => false);
            } else {
              emit(ValidationCheck(result['message'].toString()));
            }
          } catch (error) {
            print(error);
            emit(Error(error.toString()));
          }
        });
      }
    });
  }

  // Validation method
  String checkValidation(GetCreateProfileEvent data) {
    final bool emailValid =
        RegExp(StringKey.emailValidation).hasMatch(data.email!.trim());
    if (data.firstName!.trim().isEmpty) {
      return StringKey.enterFirstName;
    }
    if (data.lastName!.trim().isEmpty) {
      return StringKey.enterLastName;
    }
    if (data.email!.trim().isEmpty) {
      return StringKey.enterEmail;
    }
    if (!emailValid) {
      return StringKey.validEmail;
    }
    if (data.password!.trim().isEmpty) {
      return StringKey.enterPassword1;
    }
    if (data.password!.trim().length < 6) {
      return StringKey.passwordLength;
    }
    if (data.confirmPassword!.trim().isEmpty) {
      return StringKey.enterConfirmPassword;
    }
    if (data.password!.trim() != data.confirmPassword!.trim()) {
      return StringKey.notMatch;
    }
    if (data.pseudo!.trim().isEmpty) {
      return StringKey.enterPseudo;
    }
    return '';
  }
}
