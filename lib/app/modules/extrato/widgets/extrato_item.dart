import 'package:alloc/app/shared/utils/date_util.dart';
import 'package:flutter/material.dart';

class ExtratoItem extends StatelessWidget {
  Widget title;
  Widget subtitle;
  Function onLongPress;
  DateTime data;

  ExtratoItem({this.title, this.subtitle, this.onLongPress, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          leading: createLeading(),
          title: title,
          subtitle: subtitle,
          onLongPress: onLongPress,
        ),
        Divider(
          height: 3,
        )
      ],
    );
  }

  Widget createLeading() {
    if (data == null) return Text("");
    return createDataItem();
  }

  Widget createDataItem() {
    return Column(
      children: [
        Text(
          DateUtil.dateToString(data, mask: "dd"),
          style: TextStyle(fontSize: 24),
        ),
        Text(DateUtil.dateToString(data, mask: "MMM").toUpperCase()),
      ],
    );
  }
}
