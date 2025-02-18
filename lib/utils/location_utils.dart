import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtils {
  static Future<BitmapDescriptor> createCustomPinMarker(Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final double width = 100.0; // Width of the pin
    final double height = 150.0; // Height of the pin

    final Paint paint = Paint()..color = color;

    // Draw the pin shape (circular head and pointed bottom)
    Path path = Path();

    // Draw the circular head
    double headRadius = width * 0.4;
    canvas.drawCircle(Offset(width / 2, headRadius), headRadius, paint);

    // Draw the pointed bottom
    path.moveTo(width / 2, height); // Bottom center (pin point)
    path.lineTo(width * 0.2, headRadius * 2); // Left side
    path.lineTo(width * 0.8, headRadius * 2); // Right side
    path.close();

    canvas.drawPath(path, paint);

    // Add an inner white circle to represent the marker's inner section
    final Paint circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(width / 2, headRadius), headRadius * 0.6, circlePaint);

    // Convert the drawing to an image
    final img = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }
}