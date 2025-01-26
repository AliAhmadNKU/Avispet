import 'package:flutter/material.dart';

class BaseSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF47E2E),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(8.0),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}