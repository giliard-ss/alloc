import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithIndicator extends StatefulWidget {
  List<Widget> items;
  double height;

  CarouselWithIndicator({this.items, this.height});
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.items.length == 1) {
      return widget.items.first;
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1,
              height: widget.height,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: widget.items,
        ),
        Visibility(
          visible: widget.items.length > 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.map((url) {
              int index = widget.items.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
