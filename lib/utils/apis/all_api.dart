import 'dart:convert';
import 'dart:io';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
//import 'package:permission_handler/permission_handler.dart';
import '../../models/aa_common_model.dart';
import '../common_function/loader_screen.dart';
import '../common_function/toaster.dart';
import '../shared_pref.dart';

class AllApi {
  static CommonModel commonModel = CommonModel();
  static String otp = '';

  static Future<Object> getMethodApi(String endPoint) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (getApi => $endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');

    print(sharedPref.getString(SharedKey.auth).toString());
    var url = Uri.parse("${ApiStrings.baseURl}$endPoint");
    print(url);

    var response = await http.get(url, headers: {
      'Authorization':
          "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
      'Content-Type': 'application/json',
      "x-access-token": sharedPref.getString(SharedKey.auth).toString(),
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString()
    });

    return response.body;
  }

  static Future<Object> getEvents(Map<String, String> queryParams) async {
    final Uri uri = Uri.parse(ApiStrings.events).replace(queryParameters: queryParams);
    // Make the GET request
    final response = await http.get(
        uri,
        headers: {
          'Authorization':
          "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
          'Content-Type': 'application/json',
          "x-access-token": sharedPref.getString(SharedKey.auth).toString(),
          'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString()
        }
    );
    return response.body;
  }

  static Future<Object> deleteMethodApi(
      String endPoint, Map<String, dynamic> mapData) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (deleteApi => $endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');
    var url = Uri.parse("${ApiStrings.baseURl}$endPoint");
    var response = await http.delete(url,
        headers: {
          // ApiStrings.headerKey: ApiStrings.headerValue,
          'Authorization':
          "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString(),
          "x-access-token": sharedPref.getString(SharedKey.auth).toString()
        },);
    return response.body;
  }

  static Future<Object> deleteMethodApiQuery(String endPoint) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (getApi1 => $endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');
    var url = Uri.parse("${ApiStrings.baseURl}$endPoint");
    var response = await http.delete(url, headers: {
      'Authorization':
          "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });
    return response.body;
  }

  static Future<Object> postMethodApi(
      String endPoint, Map<String, dynamic> mapData) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (postApi => ${ApiStrings.baseURl}$endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');

    debugPrint('Payload => ${jsonEncode(mapData)}');
    var url = Uri.parse("${ApiStrings.baseURl}$endPoint");

    try{
      var response = await http.post(url,
          headers: {
            'Authorization':
            "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
            'Content-Type': 'application/json',
            'Accept-Language':
            sharedPref.getString(SharedKey.languageValue).toString(),
            "x-access-token": sharedPref.getString(SharedKey.auth).toString()
          },
          body: jsonEncode(mapData)
      );



      return response.body;
    }
    catch(e){
      debugPrint(
          'Exception response (postApi => ${e}');
      throw e;
    }
  }

  static Future<Object> postMethodApii(String endPoint, Map data) async {
    try {
      Dio dio = Dio();

      dio.options.headers["Authorization"] =
          "Bearer ${sharedPref.getString(SharedKey.auth).toString()}";
      final response = await dio.post(
        "${ApiStrings.baseURl}$endPoint",
        data: data,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      debugPrint(
          'SHARED-PREF SAVE LANGUAGE (postApi => ${ApiStrings.baseURl}$endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');

      // Add custom headers

      // Make the POST request

      print('${response.statusCode} ${response.data}');
      return response.data; // Return the parsed response
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()}; // Return an error response
    }
  }

  static Future<Object> patchtMethodApi(
      String endPoint, Map<String, dynamic> mapData) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (postApi => ${ApiStrings.baseURl}$endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()} ${mapData}');
    var url = Uri.parse("${ApiStrings.baseURl}$endPoint");
    var response = await http.patch(url,
        headers: {
          'Authorization':
              "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
          'Content-Type': 'application/json',
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString(),
          "x-access-token": sharedPref.getString(SharedKey.auth).toString()
        },
        body: jsonEncode(mapData));

    print("change password ${response.body}");

    return response.body;
  }

  static Future<String> postMethodApiWithImage(
      Map<String, String> mapEditProfile, String endPoint, String image) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (postImageApi => $endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });
    request.fields.addAll(mapEditProfile);
    if (image != "null") {
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    var response = await request.send();
    var responded = await http.Response.fromStream(response);
    return responded.body;
  }

  static Future<String> postMethodApiOnlyImage(
      String endPoint, String image) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (postImageOnlyApi => $endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });
    if (image != "null") {
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    var response = await request.send();
    var responded = await http.Response.fromStream(response);
    return responded.body;
  }

  static Future<Object> putMethodApi(
      String endPoint, Map<String, dynamic> mapData) async {
    debugPrint(
        'SHARED-PREF SAVE LANGUAGE (putApi => $endPoint) ${sharedPref.getString(SharedKey.languageValue).toString()}');
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var response = await http.put(url,
        headers: {
          ApiStrings.headerKey: ApiStrings.headerValue,
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString(),
          "x-access-token": sharedPref.getString(SharedKey.auth).toString()
        },
        body: mapData);
    return response.body;
  }

  static Future<String> putMethodApiWithImage(
      String endPoint, Map<String, String> mapEditProfile, String image) async {
    print('Uploading to: ${ApiStrings.baseURl + endPoint}');
    print('Headers: ${{
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    }}');

    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var request = http.MultipartRequest("PUT", url);
    request.headers.addAll({
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });

    request.fields.addAll(mapEditProfile);

    if (File(image).existsSync()) {
      print("File exists at path: $image");
      request.files
          .add(await http.MultipartFile.fromPath('profilePicture', image));
    } else {
      print("File not found at path: $image");
      return "File not found";
    }

    var response = await request.send();
    print("Response status code: ${response.statusCode}");

    var responded = await http.Response.fromStream(response);
    print("Response body: ${responded.body}");
    return responded.body;
  }

  static Future<String> postMethodApiWithArrayImage(
      Map<String, String> mapEditProfile,
      String endPoint,
      List<String> image,
      String thumbnail) async {
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });
    request.fields.addAll(mapEditProfile);
    for (int i = 0; i < image.length; i++) {
      if (image != "null") {
        request.files
            .add(await http.MultipartFile.fromPath('images', image[i]));
      }
    }
    if (thumbnail != "null") {
      request.files
          .add(await http.MultipartFile.fromPath('videoThumbnail', thumbnail));
    }
    var response = await request.send();
    var responded = await http.Response.fromStream(response);
    return responded.body;
  }

  static Future<Object> signupApi(var signValues) async {
    var url = Uri.parse(ApiStrings.baseURl + ApiStrings.signup);
    var response = await http.post(url,
        headers: {
          ApiStrings.headerKey: "Bearer ${ApiStrings.headerValue}",
          'Content-Type': 'application/json',
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString(),
        },
        body: signValues);
    return response.body;
  }

  static Future<Object> otpApi(Map<String, String> signValues) async {
    var url = Uri.parse(ApiStrings.baseURl + ApiStrings.emailOtp);
    var response = await http.post(url,
        headers: {
          // ApiStrings.headerKey: ApiStrings.headerValue,
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString()
        },
        body: signValues);
    return response.body;
  }

  static Future<Object> resendOTP(Map<String, String> signValues) async {
    var url = Uri.parse(ApiStrings.baseURl + ApiStrings.resendOTP);
    var response = await http.post(url,
        headers: {
          // ApiStrings.headerKey: ApiStrings.headerValue,
          'Content-Type': 'application/json',
          'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString()
        },
        body: jsonEncode(signValues)
    );
    return response.body;
  }

  static Future<Object> forgotApi(Map<String, String> signValues) async {
    var url = Uri.parse(ApiStrings.baseURl + ApiStrings.forgotPassword);
    var response = await http.post(url,
        headers: {
          ApiStrings.headerKey: ApiStrings.headerValue,
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString(),
        },
        body: signValues);
    return response.body;
  }

  static Future<Object> logout(String endPoint) async {
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var response = await http.post(url, headers: {
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });
    return response.body;
  }

  static Future<Object> deactivate(String endPoint) async {

    debugPrint(" deactivate account ${sharedPref.getString(SharedKey.auth).toString()}");
    debugPrint(" deactivate account ${sharedPref.getString(SharedKey.auth).toString()}");
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var response = await http.post(url,

        headers: {
          'Authorization':
          "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
          'Content-Type': 'application/json',
          'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
          "x-access-token": sharedPref.getString(SharedKey.auth).toString()
        },
    //     headers: {
    //   ApiStrings.headerKey: "Bearer ${ApiStrings.headerValue}",
    //   'Accept-Language': sharedPref.getString(SharedKey.languageValue).toString(),
    //   "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    // }


    );

    debugPrint(" deactivate account ${response.body}");

    return response.body;
  }

  static Future<Object> delete(String endPoint) async {

    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var response = await http.delete(url,
      headers: {
        'Authorization':
        "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
        'Content-Type': 'application/json',
        'Accept-Language':
        sharedPref.getString(SharedKey.languageValue).toString(),
        "x-access-token": sharedPref.getString(SharedKey.auth).toString()
      },
    );
    debugPrint(" delete account ${response.body}");
    return response.body;
  }




  static Future<Object> getNotify(String endPoint) async {
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var response = await http.get(url, headers: {
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });
    return response.body;
  }

  static Future<String> onlyImage(String image) async {
    var url = Uri.parse(ApiStrings.baseURl + ApiStrings.uploadImage);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
          sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString()
    });
    if (image != "null") {
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }
    var response = await request.send();
    var responded = await http.Response.fromStream(response);
    return responded.body;
  }

  static Future<String> uploadChatImage(String image) async {
    var url = Uri.parse(ApiStrings.baseURl + ApiStrings.postChatImage);
    print(url);
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      // ApiStrings.headerKey: ApiStrings.headerValue,
      'Accept-Language':
      sharedPref.getString(SharedKey.languageValue).toString(),
      "x-access-token": sharedPref.getString(SharedKey.auth).toString(),
      "Authorization": "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
    });
    request.files.add(await http.MultipartFile.fromPath('chat_image', image));
    var response = await request.send();
    var responded = await http.Response.fromStream(response);
    return responded.body;
  }

  /*static Future<bool> checkAndRequestStoragePermission() async {
    // Check if permission is already granted
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      print("Storage permission already granted");
      return true; // Permission granted
    } else if (status.isDenied) {
      // Request permission
      PermissionStatus newStatus = await Permission.storage.request();
      if (newStatus.isGranted) {
        print("Storage permission granted after request");
        return true;
      } else {
        print("Storage permission denied");
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permanently denied
      print("Storage permission permanently denied. Redirecting to app settings.");
      openAppSettings();
      return false;
    }

    // Handle other statuses (e.g., restricted, limited)
    return false;
  }*/

  static Future<void> uploadImage(BuildContext context, File? image) async {
    /* bool hasPermission = await checkAndRequestStoragePermission();
    if (!hasPermission) {
      print("Cannot proceed without storage permission.");
      return;
    }*/

    Map<String, String> mapData = {'type ': "1"};
    var res = await AllApi.putMethodApiWithImage(
        ApiStrings.updateProfilePicture, mapData, image!.path);
    var result = jsonDecode(res.toString());
    LoadingDialog.hide(context);
    if (result['status'] == 200) {
      commonModel = CommonModel.fromJson(result);
    } else if (result['status'] == 401) {
      toaster(context, result['message'].toString());
    } else {
      toaster(context, result['message'].toString());
    }
  }

  static verifyOtpApiForgotPassword(Map<String, String> data, endPoint) async {
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var response = await http.post(url,
        headers: {
          ApiStrings.headerKey: ApiStrings.headerValue,
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString(),
          "x-access-token": sharedPref.getString(SharedKey.auth).toString()
        },
        body: data);
    return response.body;
  }

  static resetPasswordPostMethod(Map<String, String> data, endPoint) async {
    var url = Uri.parse(ApiStrings.baseURl + endPoint);
    var response = await http.post(url,
        headers: {
          ApiStrings.headerKey: ApiStrings.headerValue,
          'Accept-Language':
              sharedPref.getString(SharedKey.languageValue).toString(),
          "x-access-token": sharedPref.getString(SharedKey.auth).toString()
        },
        body: data);
    return response.body;
  }

  Future<String?> uploadImages(File imageFile) async {
    try {
      // Replace with your actual token

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://16.171.146.189:8001/api/v1/upload/post-animal-image"),
      );

      // Add headers
      request.headers.addAll({
        'Authorization':
            "Bearer  ${sharedPref.getString(SharedKey.auth).toString()}",
        'Accept': 'application/json',
      });

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'animal_image',
        imageFile.path,
      ));

      // Send the request
      var response = await request.send();

      print(response);

      // Parse the response
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseBody = json.decode(responseData.body);

        if (responseBody["error"] == false) {
          return responseBody["data"]["imageUrl"];
        } else {
          throw Exception("Image upload failed: ${responseBody['message']}");
        }
      } else {
        throw Exception(
            "Failed to upload image. HTTP Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
