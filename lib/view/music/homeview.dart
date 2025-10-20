import 'package:app/controller/playerController.dart';
import 'package:app/view/music/musicScreen.dart';
import 'package:app/view/music/widget/songtiltle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerController());

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Music Player',style: TextStyle(
          color: Colors.black,fontWeight: FontWeight.bold
        ),),
      ),
      body: Obx(() {
        if (controller.songs.isEmpty) {
          return const Center(child: Text('No songs found'));
        }
        return ListView.builder(
          itemCount: controller.songs.length,
          itemBuilder: (context, index) {
            final song = controller.songs[index];
            return SongTile(
              title: song.title,
              artist: song.artist ?? "Unknown Artist",
              onTap: () {
                controller.playSong(song.uri!, index);
                Get.to(() => const PlayerView());
              },
            );
          },
        );
      }),
    );
  }
}
