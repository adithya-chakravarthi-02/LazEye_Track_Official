import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final String broker = 'broker.hivemq.com';
  final int port = 1883;
  final String topic = 'amblyopia/glasses/status';

  late MqttServerClient client;

  String frameContact = "--";
  String eyeStatus = "--";
  String systemState = "--";

  VoidCallback? onUpdate;

  Future<void> connect() async {
    client = MqttServerClient(
      broker,
      'flutter_${DateTime.now().millisecondsSinceEpoch}',
    );

    client.port = port;
    client.keepAlivePeriod = 20;
    client.autoReconnect = true;

    client.onConnected = () => debugPrint("✅ MQTT CONNECTED");
    client.onDisconnected = () => debugPrint("❌ MQTT DISCONNECTED");

    try {
      await client.connect();
      client.subscribe(topic, MqttQos.atMostOnce);

      client.updates!.listen((events) {
        final msg = events[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(msg.payload.message);

        debugPrint("📥 MQTT DATA: $payload");

        try {
          final data = jsonDecode(payload);

          frameContact = (data['frame_contact'] ?? "--").toString();
          eyeStatus = (data['eye_status'] ?? "--").toString();
          systemState = (data['system_state'] ?? "--").toString();

          onUpdate?.call();
        } catch (e) {
          debugPrint("❌ JSON ERROR: $e");
        }
      });
    } catch (e) {
      debugPrint("❌ MQTT CONNECTION ERROR: $e");
    }
  }
}
