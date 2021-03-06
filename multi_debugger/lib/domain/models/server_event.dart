import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:multi_debugger/domain/enums/server_event_type.dart';
import 'package:uuid/uuid.dart';

part 'server_event.g.dart';

abstract class ServerEvent implements Built<ServerEvent, ServerEventBuilder> {
  ServerEvent._();

  factory ServerEvent([ServerEventBuilder updates(ServerEventBuilder buider)]) = _$ServerEvent;

  static void _initializeBuilder(ServerEventBuilder b) => b
    ..serverEventId = Uuid().v4()
    ..index = 0
    ..serverEventType = ServerEventType.action
    ..datetime = DateTime.now().toUtc()
    ..favorite = false;

  String get serverEventId;

  int get index;

  String get action;

  @nullable
  JsonObject get payload;

  @nullable
  JsonObject get state;

  ServerEventType get serverEventType;

  DateTime get datetime;

  bool get favorite;

  static Serializer<ServerEvent> get serializer => _$serverEventSerializer;
}
