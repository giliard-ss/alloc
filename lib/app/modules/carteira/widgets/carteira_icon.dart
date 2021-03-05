import 'package:flutter/material.dart';

class CarteiraIcon extends StatelessWidget {
  String title;
  CarteiraIcon(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[800],
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
                title.characters.first.toUpperCase() +
                    title.characters.toList()[1].toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue[600]),
              )),
              decoration:
                  BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
