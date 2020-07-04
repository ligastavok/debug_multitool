import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:centrifuge/centrifuge.dart' as centrifuge;

import 'centrifugo_connect_status.dart';
import 'utils/util.dart';

class CentrifugoConnectBloc {
  CentrifugoConnectBloc() {
    _centrifugoStatusSubject = BehaviorSubject<CentrifugoConnectStatus>.seeded(CentrifugoConnectStatus.disconnected);
  }

  centrifuge.Client client;
  centrifuge.Subscription subscription;
  StreamSubscription<centrifuge.ConnectEvent> _connectSub;
  StreamSubscription<centrifuge.DisconnectEvent> _disconnectSub;
  StreamSubscription<centrifuge.PublishEvent> _publishSub;

  TextEditingController centrifugoUrlTextController = TextEditingController(text: '');
  TextEditingController centrifugoChannelTextController = TextEditingController(text: '');

  // status
  BehaviorSubject<CentrifugoConnectStatus> _centrifugoStatusSubject;
  StreamSubscription<CentrifugoConnectStatus> _centrifugoStatusSubscription;
  Stream<CentrifugoConnectStatus> get centrifugoStatusSubject => _centrifugoStatusSubject.stream;
  CentrifugoConnectStatus get currentConnectStatus => _centrifugoStatusSubject.value;

  // publish
  BehaviorSubject<String> _publishSubject;

  /// init bloc
  Future<void> init({
    @required String url,
    @required String channel,
  }) async {
    centrifugoUrlTextController.text = url;
    centrifugoChannelTextController.text = channel;
  }

  /// send data to centrifugo server
  /// example:
  /// ```json
  /// action: action1
  /// payload: {
  ///   "name1":"name1",
  ///   "name1":"name1"
  /// },
  /// state: state
  /// ```
  Future<void> sendData({String action, Object payload, Object state}) async {
    if (currentConnectStatus != CentrifugoConnectStatus.connected) {
      return;
    }

    try {
      final String output = jsonEncode(<String, dynamic>{
        'action': action,
        'payload': payload.toString(),
        'state': state.toString(),
      });

      final List<int> data = utf8.encode(output);

      await subscription?.publish(data);
    } catch (exc) {
      debugPrint('[centrifugo] send data exc: $exc');
    }
  }

  Future<void> _connect() async {
    _centrifugoStatusSubject.add(CentrifugoConnectStatus.connecting);

    // url
    final String url = centrifugoUrlTextController.text;
    await setStringToLocalStorage(kUrlKey, url);

    // channel
    final String channel = centrifugoChannelTextController.text;
    await setStringToLocalStorage(kChannelKey, channel);

    // connect
    client = centrifuge.createClient(url);
    subscription = client.getSubscription(channel);

    // subscriptions
    _connectSub = client.connectStream.listen((centrifuge.ConnectEvent event) {
      _centrifugoStatusSubject.add(CentrifugoConnectStatus.connected);
    });
    // disconnect sub
    _disconnectSub = client.disconnectStream.listen((centrifuge.DisconnectEvent event) {
      _centrifugoStatusSubject.add(CentrifugoConnectStatus.disconnected);
    });
    // publish sub
    _publishSub = subscription.publishStream.listen((centrifuge.PublishEvent event) {
      final dynamic message = json.decode(utf8.decode(event.data));
      _publishSubject.add(message.toString());
    });

    subscription.subscribe();
    client.connect();
  }

  Future<void> _disconnect() async {
    _centrifugoStatusSubject.add(CentrifugoConnectStatus.disconnected);

    client?.disconnect();

    Future<void>.delayed(const Duration(milliseconds: 200), () {
      _connectSub?.cancel();
      _disconnectSub?.cancel();
      // _publishSub?.cancel();
    });

    subscription?.unsubscribe();
    client = null;
  }

  /// ws connect
  final List<CentrifugoConnectStatus> _disconnectStatuses = <CentrifugoConnectStatus>[
    CentrifugoConnectStatus.disconnected,
    CentrifugoConnectStatus.connecting,
  ];

  Future<void> connect() async {
    if (_disconnectStatuses.contains(currentConnectStatus)) {
      await _connect();
      return;
    }

    await _disconnect();
  }

  /// dont close subscriptions in dispose
  /// need for transmitting data in background
  void unsubscribe() {
    _connectSub?.cancel();
    _disconnectSub?.cancel();
    _publishSub?.cancel();
    _centrifugoStatusSubscription?.cancel();
    _centrifugoStatusSubject.close();
    _publishSubject.close();
  }

  void dispose() {
    centrifugoUrlTextController.dispose();
    centrifugoChannelTextController.dispose();
  }
}
