import 'dart:io';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class ImageUploadExample extends StatefulWidget {
  @override
  _ImageUploadExampleState createState() => _ImageUploadExampleState();
}

class _ImageUploadExampleState extends State<ImageUploadExample> {
  List<String> imageUrlList = [];
  File? fileImage;
  final picker = ImagePicker();
  final String uploadUrl =
      "${ApiStrings.serverURl}api/v1/upload/post-animal-image";
  Future<File?> pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imageFile.path),
      });

      Dio dio = Dio();
      Response response = await dio.post(uploadUrl, data: formData);

      if (response.statusCode == 200 && response.data["error"] == false) {
        return response.data["data"]["imageUrl"];
      } else {
        throw Exception("Image upload failed: ${response.data['message']}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
