import 'package:app/controller/playerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          'Now Playing',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        final song = controller.songs[controller.currentIndex.value];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 120, color: Colors.orange),
            const SizedBox(height: 20),
            Text(song.title, style: const TextStyle(fontSize: 20)),
            Text(song.artist ?? "Unknown",
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            // --- Song Progress Slider ---
            Obx(() {
              final position = controller.position.value.inSeconds.toDouble();
              final duration =
                  controller.duration.value.inSeconds.toDouble();

              return Column(
                children: [
                  Slider(
                    activeColor: Colors.orange,
                    inactiveColor: Colors.grey.shade400,
                    value: position.clamp(0.0, duration),
                    min: 0.0,
                    max: duration > 0 ? duration : 1,
                    onChanged: (value) {
                      controller.seekTo(Duration(seconds: value.toInt()));
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.formatDuration(controller.position.value),
                            style: const TextStyle(color: Colors.grey)),
                        Text(controller.formatDuration(controller.duration.value),
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),

            // --- Player Controls ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      size: 40, color: Colors.orange),
                  onPressed: controller.previous,
                ),
                IconButton(
                  icon: Icon(
                    controller.isPlaying.value
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    size: 60,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    controller.isPlaying.value
                        ? controller.pause()
                        : controller.resume();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next,
                      size: 40, color: Colors.orange),
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
