import 'package:flutter/material.dart';

class CircleInfoWidget extends StatelessWidget {
  List colorsHex = [0xff818099, 0xffa18799, 0xff7c8381, 0xffa9a3b2];
  List colorDarkHex = [0xff504f63, 0xff725a6b, 0xff575c5a, 0xff71687d];
  int indexColor;
  String value;
  CircleInfoWidget(this.value, [this.indexColor = 0]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getColor(indexColor, false),
                      _getColor(indexColor, true)
                    ])),
          ),
          Positioned(
            top: 2.5,
            left: 2.5,
            child: Container(
              width: 40,
              height: 40,
              child: Center(
                  child: Text(
                value + "%",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: _getColor(indexColor, true)),
              )),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xfff4f6f9)),
            ),
          )
        ],
      ),
    );
  }

  Color _getColor(int index, bool dark) {
    List colors = dark ? colorDarkHex : colorsHex;

    if (index < colors.length - 1) return Color(colors[index]);
    int value = index;
    while (true) {
      if (value > colors.length - 1)
        value = value - colors.length;
      else
        return Color(colors[value]);
    }
  }
}
