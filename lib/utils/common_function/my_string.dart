import 'package:flutter/material.dart';

class MyString {
  // bold
  static Widget bold(
      String value, double size, Color textColor, TextAlign align,
  {int maxLines = 30}

      ) {
    return Text(value,
        textAlign: align,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: textColor,
            fontSize: size,
            fontFamily: 'poppins_bold',
            fontWeight: FontWeight.w700

        ));
  }




  static Widget boldRich(String firstPart, String secondPart, double size,
      Color textColor, TextAlign align) {
    return RichText(
      textAlign: align,
      text: TextSpan(
        style: TextStyle(
          fontSize: size,
          fontFamily: 'poppins_bold',
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: firstPart,
            style: TextStyle(color: textColor),
          ),
          TextSpan(
            text: secondPart,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }

  static Widget boldMultiLine(String value, double size, Color textColor,
      TextAlign align, int maxLine) {
    return Text(value,
        style: TextStyle(
          fontSize: size,
          color: textColor,
          fontFamily: 'poppins_bold',
          fontWeight: FontWeight.w700,
          overflow: TextOverflow.ellipsis,
        ),
        textAlign: align,
        maxLines: maxLine);
  }

  // med
  static Widget med(
      String value, double size, Color textColor, TextAlign align) {
    return Text(value,
        style: TextStyle(
          fontSize: size,
          color: textColor,
          fontFamily: 'poppins_medium',
        ),
        textAlign: align);
  }

  static Widget medMultiLine(String value, double size, Color textColor,
      TextAlign align, int maxLine) {
    return Text(value,
        style: TextStyle(
          fontSize: size,
          color: textColor,
          overflow: TextOverflow.ellipsis,
          fontFamily: 'poppins_medium',
        ),
        textAlign: align,
        maxLines: maxLine);
  }

  // reg
  static Widget reg(
      String value, double size, Color textColor, TextAlign align, {maxLines = 100}) {
    return Text(value,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: size,
          color: textColor,
          fontFamily: 'poppins_regular',
        ),
        textAlign: align);
  }

  static Widget regMultiLine(String value, double size, Color textColor,
      TextAlign align, int maxLine) {
    return Text(
      value,
      style: TextStyle(
        fontSize: size,
        color: textColor,
        fontFamily: 'poppins_regular',
      ),
      textAlign: align,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }

  // italic
  static Widget italic(
      String value, double size, Color textColor, TextAlign align) {
    return Text(value,
        style: TextStyle(
          fontSize: size,
          color: textColor,
          fontFamily: 'poppins_italic',
        ),
        textAlign: align);
  }

  static Widget italicMultiLine(String value, double size, Color textColor,
      TextAlign align, int maxLine) {
    return Text(value,
        style: TextStyle(
          fontSize: size,
          color: textColor,
          fontFamily: 'poppins_italic',
        ),
        textAlign: align,
        maxLines: maxLine);
  }
}
