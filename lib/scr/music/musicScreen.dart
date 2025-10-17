import 'package:app/controller/playerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: Obx(() {
        final song = controller.songs[controller.currentIndex.value];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 120),
            const SizedBox(height: 20),
            Text(song.title, style: const TextStyle(fontSize: 20)),
            Text(song.artist ?? "Unknown", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: controller.previous,
                ),
                IconButton(
                  icon: Icon(
                    controller.isPlaying.value ? Icons.pause_circle : Icons.play_circle,
                    size: 60,
                  ),
                  onPressed: () {
                    controller.isPlaying.value
                        ? controller.pause()
                        : controller.resume();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: controller.next,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}