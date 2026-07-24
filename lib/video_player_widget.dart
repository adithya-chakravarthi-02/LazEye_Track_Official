import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TherapyVideo extends StatefulWidget {
  final bool play;
  final String assetPath;

  const TherapyVideo({
    super.key,
    required this.play,
    required this.assetPath,
  });

  @override
  State<TherapyVideo> createState() => _TherapyVideoState();
}

class _TherapyVideoState extends State<TherapyVideo> {
  late VideoPlayerController controller;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(widget.assetPath)
      ..setLooping(true)
      ..initialize().then((_) {
        initialized = true;
        if (widget.play) controller.play();
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant TherapyVideo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!initialized) return;

    if (widget.play && !controller.value.isPlaying) {
      controller.play();
    } else if (!widget.play && controller.value.isPlaying) {
      controller.pause();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}
