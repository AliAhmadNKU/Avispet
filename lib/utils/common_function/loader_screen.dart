import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {

  static void show(BuildContext context) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => const LoadingDialog(),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked : (didPop){ },
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: MyColor.white,
          backgroundColor: MyColor.orange,
        ),
      ),
    );
  }
}