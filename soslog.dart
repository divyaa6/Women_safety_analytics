import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class soslog extends StatefulWidget {
  @override
  _soslogState createState() => _soslogState();
}

class _soslogState extends State<soslog> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _deleteOldNotifications();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _deleteOldNotifications() async {
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(seconds: 10));

    final querySnapshot = await _firestore
        .collection('notifications')
        .where('timestamp', isLessThan: Timestamp.fromDate(cutoff))
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOS alerts',
          style: TextStyle(color: Colors.white), // Change title text color to white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Change back arrow color to white
        backgroundColor: Colors.transparent, // Set background color to transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF00B8), // Starting color
                Color(0xFFFF017D), // Ending color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
              notifications[index].data() as Map<String, dynamic>;

              final timestamp = notification['timestamp'];
              final dateTime = (timestamp is Timestamp)
                  ? timestamp.toDate()
                  : DateTime.now();

              final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
              final time =
                  '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
