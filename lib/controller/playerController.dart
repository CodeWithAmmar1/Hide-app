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

  @override
  void onInit() {
    super.onInit();
    _initPlayer();
  }

  /// 🔹 Initialize and handle permissions properly
  Future<void> _initPlayer() async {
    await _handlePermission();
    await loadSongs();
  }

  /// 🔹 Request proper permissions based on Android version
  Future<void> _handlePermission() async {
    // Android 13 (SDK 33) aur upar ke liye READ_MEDIA_AUDIO ka use hota hai
    if (await Permission.audio.isGranted || await Permission.storage.isGranted) {
      return;
    }

    // Request permission
    if (await Permission.audio.isDenied) {
      await Permission.audio.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    // Agar permission fir bhi nahi mili
    if (!(await Permission.audio.isGranted) &&
        !(await Permission.storage.isGranted)) {
      Get.snackbar(
        "Permission Required",
        "Please allow storage/audio access to load songs.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 🔹 Load all songs from device
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

  /// 🔹 Play selected song
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

  /// 🔹 Pause current song
  void pause() {
    player.pause();
    isPlaying(false);
  }

  /// 🔹 Resume playback
  void resume() {
    player.play();
    isPlaying(true);
  }

  /// 🔹 Play next song
  void next() {
    if (currentIndex.value + 1 < songs.length) {
      playSong(songs[currentIndex.value + 1].uri!, currentIndex.value + 1);
    }
  }

  /// 🔹 Play previous song
  void previous() {
    if (currentIndex.value - 1 >= 0) {
      playSong(songs[currentIndex.value - 1].uri!, currentIndex.value - 1);
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
