import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../my_color.dart';
import 'my_string.dart';

XFile? _pickedFile;
CroppedFile? _croppedFile;

cameraPhoto(BuildContext context, String from) async {
  return showModalBottomSheet<String>(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 1,
    isDismissible: true,
    enableDrag: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, myState) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: MyColor.white,
                border: Border.all(color: MyColor.orange2),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: MyString.bold(
                        (from == "edit")
                            ? 'editAnimalPhoto'.tr
                            : (from == "editProfile")
                                ? 'changeProfilePhoto'.tr
                                : (from == "create_group")
                                    ? 'addGroupPhoto'.tr
                                    : (from == "editGroup")
                                        ? 'editGroupPhoto'.tr
                                        : (from == "create_animal")
                                            ? 'animalPhotoCreate'.tr
                                            : 'cameraGallery1'.tr,
                        16,
                        MyColor.black,
                        TextAlign.center)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context, "1");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          height: 100,
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: MyColor.stroke),
                              color: MyColor.card),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/icons/post_library.png",
                                height: 40,
                                width: 40,
                              ),
                              MyString.med('phoneLibrary'.tr, 18, MyColor.black,
                                  TextAlign.start)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context, "0");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          height: 100,
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: MyColor.stroke),
                              color: MyColor.card),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/icons/post_camera.png",
                                height: 40,
                                width: 40,
                              ),
                              MyString.med('camera'.tr, 18, MyColor.black,
                                  TextAlign.start)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<File?> pickImage(BuildContext context, ImageSource source) async {
  final pickedFile = await ImagePicker().pickImage(source: source);
  if (pickedFile != null) {
    _pickedFile = pickedFile;
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'cropImage'.tr,
            toolbarColor: MyColor.cardColor,
            hideBottomControls: true,
            toolbarWidgetColor: MyColor.orange,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Cropper'),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.page,
            size: const CropperSize(
              width: 200,
              height: 200,
            ),
            //viewwMode: const CroppieViewPort(width: 480, height: 200, type: 'circle'),
          ),
        ],
      );
      if (croppedFile != null) {
        File? fileImage;
        _croppedFile = croppedFile;
        fileImage = File(_croppedFile!.path.toString());
        return fileImage;
      }
    }
  }
  return null;
}
