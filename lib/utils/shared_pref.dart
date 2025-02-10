import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;

Future<void> iniSharePreference() async {
  sharedPref = await SharedPreferences.getInstance();
}

class SharedKey {
  static String onboardScreen = 'onboardScreen';
  static String auth = 'auth';
  static String deviceToken = 'deviceToken';
  static String userId = 'userId';
  static String socialLogin = 'socialLogin';
  static String userprofilePic = 'userprofilePic';
  static String userEmail = 'userEmail';
  static String languageKey = 'languageKey';
  static String languageValue = 'languageKey';
  static String languageCount = 'languageCount';
}

class StringKey {
  static String emailValidation =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static String enterEmail = 'enterEmail'.tr;
  static String enterPhone = 'enterPhone'.tr;
  static String enterAddress = 'enterAddress'.tr;
  static String enterCity = 'enterCity'.tr;

  static String validEmail = 'validEmail'.tr;
  static String enterPassword = 'enterPassword'.tr;
  static String enterPassword1 = 'enterPassword1'.tr;
  static String passwordLength = 'passwordLength'.tr;
  static String enterConfirmPassword = 'enterConfirmPassword'.tr;
  static String notMatch = 'notMatch'.tr;
  static String enterFirstName = 'enterFirstName'.tr;
  static String enterLastName = 'enterLastName'.tr;
  static String enterDepartment = 'enterDepartment'.tr;
  static String enterPseudo = 'enterPseudo'.tr;
  static String selectTermsPrivacy = 'selectTermsPrivacy'.tr;
  static String selectPetType = 'animalType1'.tr;

  static String animalName = 'animalName'.tr;
  static String animalWeight = 'animalWeight'.tr;

  static String animalType = 'animalType'.tr;
  static String animalRace = 'animalRace'.tr;
  static String animalDob = 'animalDob'.tr;
  static String animalGender = 'animalGender'.tr;
  static String animalSterilized = 'animalSterilized'.tr;
  static String animalImage = 'animalImage'.tr;
  static String animalAge = 'animalAge'.tr;


  //changePassword
  static String currentPassword = 'currentPassword'.tr;
  static String newPassword = 'enterPassword1'.tr;
  static String confirmPassword = 'enterConfirmPassword'.tr;

  //contactUs
  static String enterSubject = 'enterSubject'.tr;
  static String enterMessage = 'enterMessage'.tr;
  static String enterGroupName = 'enterGroupName'.tr;
  static String selectAnyOption = 'selectAnyOption'.tr;

  //createPost
  static String selectAnimal = 'headingSelectAnimal'.tr;
  static String selectCategory = 'selectCategory'.tr;
  static String selectSubCategory = 'selectSubCategory'.tr;
  static String enterDescription = 'enterDescription'.tr;
  static String enterTitle = 'enterTitle'.tr;

  static String enterBrand = 'enterBrand'.tr;
  static String enterProductName = 'enterProductName'.tr;
  static String enterPackage = 'enterPackage'.tr;
}
