import 'dart:convert';
import 'dart:typed_data';

import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:flutter/material.dart';

class ImageBase64Widget extends StatelessWidget {
  final String base64Image;
  final Widget widgetError;
  const ImageBase64Widget(
      {this.base64Image, this.widgetError = const Icon(Icons.error)});

  @override
  Widget build(BuildContext context) {
    try {
      if (StringUtil.isEmpty(base64Image)) return widgetError;

      Uint8List _image = base64Decode(base64Image);
      Image image = Image.memory(_image); //
      return image;
    } catch (e) {
      return widgetError;
    }
  }
}
