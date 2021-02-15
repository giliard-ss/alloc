import 'package:flutter/material.dart';

class CircleInfoWidget extends StatelessWidget {
  List colorsHex = [
    0xfff78c08,
    0xff5784a3,
    0xffb4a797,
    0xff7e0ac0,
    0xfff5b200,
    0xff0085c0
  ];
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getColor(indexColor, false),
              shape: BoxShape.circle,
              // gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [
              //       _getColor(indexColor, false),
              //       _getColor(indexColor, true)
              //     ]),
            ),
            /*  child: Center(
              child: Text(
                value + "%",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Colors.white),
              ),
            ),*/
          ),
          Positioned(
            top: 4.5,
            left: 4.5,
            child: Container(
              width: 41,
              height: 41,
              child: Center(
                  child: Text(
                value + "%",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: _getColor(indexColor, false)),
              )),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
