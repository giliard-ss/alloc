import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'extrato_controller.dart';

class ExtratoPage extends StatefulWidget {
  final String title;
  const ExtratoPage({Key key, this.title = "Extrato"}) : super(key: key);

  @override
  _ExtratoPageState createState() => _ExtratoPageState();
}

class _ExtratoPageState extends ModularState<ExtratoPage, ExtratoController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WidgetUtil.futureBuild(controller.init, _body),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: Observer(
              builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.events.length,
                  itemBuilder: (context, index) {
                    AbstractEvent event = controller.events[index];

                    return Text(event.getTipoEvento());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
