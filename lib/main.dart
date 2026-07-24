import 'dart:async';
import 'package:flutter/material.dart';
import 'mqtt_service.dart';
import 'video_player_widget.dart';

void main() {
  runApp(const SmartGlassesApp());
}

class SmartGlassesApp extends StatelessWidget {
  const SmartGlassesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final mqtt = MqttService();

  Timer? _timer;
  int _sessionSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    mqtt.onUpdate = _onMqttUpdate;
    mqtt.connect();
  }

  void _onMqttUpdate() {
    _handleTiming();
    if (mounted) setState(() {});
  }

  // ---------------- LOGIC (IMPORTANT) ----------------

  bool get isFrameWorn {
    final v = mqtt.frameContact.toLowerCase();
    return v.contains("contact") ||
        v.contains("worn") ||
        v == "1" ||
        v == "true";
  }

  bool get isEyeOpen {
    final v = mqtt.eyeStatus.toLowerCase();
    return v.contains("open") ||
        v.contains("detected") ||
        v.contains("present") ||
        v == "1" ||
        v == "true";
  }

  bool get isTherapyActive => isFrameWorn && isEyeOpen;

  // ---------------- TIMER CONTROL ----------------

  void _handleTiming() {
    if (isTherapyActive) {
      if (_timer == null) {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            _sessionSeconds++;
            _totalSeconds++;
          });
        });
      }
    } else {
      _timer?.cancel();
      _timer = null;
      _sessionSeconds = 0;
    }
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LazEye Track")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TherapyVideo(
              play: isTherapyActive,
              assetPath: "assets/videos/therapy.mp4",
            ),
            const SizedBox(height: 20),
            info("Frame Contact", mqtt.frameContact),
            info("Eye Status", mqtt.eyeStatus),
            info("System State", mqtt.systemState),
            info("Therapy Active", isTherapyActive ? "YES" : "NO"),
            const Divider(),
            info("Session Time", formatTime(_sessionSeconds)),
            info("Total Therapy Time", formatTime(_totalSeconds)),
          ],
        ),
      ),
    );
  }

  Widget info(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
