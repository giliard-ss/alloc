import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  List<Widget> rightItems;
  bool withDivider;
  TitleWidget(
      {this.title = "Titulo", this.rightItems, this.withDivider = false}) {
    if (this.rightItems == null) this.rightItems = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: rightItems,
            )
          ],
        ),
        Visibility(
            visible: withDivider && rightItems.isEmpty,
            child: SizedBox(
              height: 15,
            )),
        Visibility(
          visible: withDivider,
          child: Divider(
            height: 10,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
