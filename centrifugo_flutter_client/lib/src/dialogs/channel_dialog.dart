import 'package:centrifugo_flutter_client/src/models/channel.dart';
import 'package:centrifugo_flutter_client/src/utils/hive_boxes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'components/item_sliver_content.dart';

class ChannelDialogWidget extends StatefulWidget {
  const ChannelDialogWidget({
    Key key,
  }) : super(key: key);

  @override
  _ChannelDialogState createState() => _ChannelDialogState();
}

class _ChannelDialogState extends State<ChannelDialogWidget> {
  List<Widget> _sliverItems(Map<dynamic, Channel> rawMap) {
    return <Widget>[
      ...rawMap.entries.map<Widget>((MapEntry<dynamic, Channel> item) {
        return ItemSliverContent(
          name: item.value.name,
          isPermanent: false,
        );
      }).toList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ValueListenableBuilder<Box<Channel>>(
      valueListenable: Hive.box<Channel>(HiveBoxes.channel).listenable(),
      builder: (_, Box<Channel> box, __) {
        final Map<dynamic, Channel> rawMap = box.toMap();

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 0.9 * size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
            ),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('select channel'),
              ),
              body: Container(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox.expand(
                  child: CustomScrollView(
                    slivers: _sliverItems(rawMap),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
