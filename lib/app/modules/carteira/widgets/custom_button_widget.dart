import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  Function onPressed;
  IconData icon;
  String text;

  CustomButtonWidget({
    @required this.icon,
    @required this.text,
    @required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // decoration: BoxDecoration(
        //   color: color,
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        // ),
        width: 120,
        height: 70,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.grey,
                size: 30,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
