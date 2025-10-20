import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();

  var songs = <SongModel>[].obs;
  var currentIndex = 0.obs;
  var isPlaying = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    _initPlayer();
    player.positionStream.listen((p) => position.value = p);
    player.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });
    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  Future<void> _initPlayer() async {
    await _handlePermission();
    await loadSongs();
  }

  Future<void> _handlePermission() async {
    if (await Permission.audio.isGranted ||
        await Permission.storage.isGranted) {
      return;
    }

    if (await Permission.audio.isDenied) {
      await Permission.audio.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    if (!(await Permission.audio.isGranted) &&
        !(await Permission.storage.isGranted)) {
      Get.snackbar(
        "Permission Required",
        "Please allow storage/audio access to load songs.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadSongs() async {
    try {
      songs.value = await audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      if (songs.isEmpty) {
        print("⚠️ No songs found on this device.");
      } else {
        print("✅ Loaded ${songs.length} songs.");
      }
    } catch (e) {
      print("❌ Error loading songs: $e");
    }
  }

  Future<void> playSong(String uri, int index) async {
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      await player.play();
      isPlaying(true);
      currentIndex(index);
    } catch (e) {
      print("❌ Error playing song: $e");
    }
  }

  void pause() {
    player.pause();
    isPlaying(false);
  }

  void resume() {
    player.play();
    isPlaying(true);
  }

  void next() {
    if (currentIndex.value + 1 < songs.length) {
      playSong(songs[currentIndex.value + 1].uri!, currentIndex.value + 1);
    }
  }

  void previous() {
    if (currentIndex.value - 1 >= 0) {
      playSong(songs[currentIndex.value - 1].uri!, currentIndex.value - 1);
    }
  }

  // 🕹️ Seek control for slider
  void seekTo(Duration newPosition) {
    player.seek(newPosition);
  }

  // 🕒 Duration formatter for UI
  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
