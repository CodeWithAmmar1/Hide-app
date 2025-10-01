import 'package:app/scr/mapscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Newscreen extends StatelessWidget {
  const Newscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Fetch Screen",style: TextStyle(color: Colors.white),)),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final lat = docs[index]['latitude'];
              final lng = docs[index]['longitude'];

              // ✅ Convert Firestore timestamp to DateTime
              final timestamp = docs[index]['timestamp'];
              DateTime dateTime;

              if (timestamp is Timestamp) {
                dateTime = timestamp.toDate();
              } else if (timestamp is int) {
                // in case timestamp is stored as milliseconds
                dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              } else {
                dateTime = DateTime.now(); // fallback
              }

              // Format DateTime into readable string
              final formattedTime =
                  "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

              return ListTile(
                title: Text("Lat: $lat, Lng: $lng, Time: $formattedTime"),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.person_pin_circle_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => MapScreen(latitude: lat, longitude: lng),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
