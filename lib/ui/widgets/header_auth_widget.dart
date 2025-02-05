import 'package:avispets/utils/common_function/dialogs/bottom_language.dart';
import 'package:flutter/material.dart';

class HeaderAuthWidget extends StatelessWidget {
  const HeaderAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () async {
          await changeLanguage(context);
        },
        child: Image.asset(
          'assets/images/icons/translation.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
