import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sos/login.dart';
import 'package:sos/map/Safehome/safehome.dart';
import 'package:sos/map/safezone/Safezone.dart';
import 'package:sos/police.dart';

class sosalert extends StatefulWidget {
  const sosalert({super.key});

  @override
  State<sosalert> createState() => _sosalertState();
}

class _sosalertState extends State<sosalert> {
  Timer? _timer;
  bool _isHolding = false;
  bool _isCardExpanded = false; // Track if the card is expanded
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _sendNotification() async {
    await _firestore.collection('notifications').add({
      'message': 'SOS Alert! Emergency help needed.',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _startTimer() {
    setState(() {
      _isHolding = true;
    });

    _timer = Timer(Duration(milliseconds: 1500), () {
      _callNumber('8056135060');
      _sendNotification();
      _cancelTimer();
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isHolding = false;
    });
  }

  void _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOS Alert',
          style: TextStyle(color: Colors.white), // Change title text color to white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Change logout button icon color to white
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // Text color
              backgroundColor: Colors.black54, // Button background color
            ),
            child: Text('Logout'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 85),
            child: Container(
              child: Text(
                'Emergency help',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70, left: 130),
            child: Container(
              child: Text(
                'Needed?',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 90),
            child: GestureDetector(
              onTapDown: (details) {
                _startTimer();
              },
              onTapUp: (details) {
                _cancelTimer();
              },
              onTapCancel: () {
                _cancelTimer();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 10.0, color: Colors.white24),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                  color: Colors.red,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.sos_rounded,
                    size: 150,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 370),
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Emergency SOS",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 20)),
                  police(),
                ],
              ),
            ),
          ),
          // Touch to expand card
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCardExpanded = !_isCardExpanded; // Toggle the expansion
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                // Smooth expansion/collapse
                curve: Curves.easeInOut,
                // Full width in both minimized and expanded states
                width: MediaQuery.of(context).size.width,
                height: _isCardExpanded
                    ? MediaQuery.of(context).size.height * 0.6
                    : 100,
                // Expand/collapse height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Card title when collapsed
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _isCardExpanded
                            ? "Safe Areas"
                            : "Tap to view Safe Areas",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_isCardExpanded) ...[
                      // Show Safe Areas when card is expanded
                      Expanded(
                        child: PageView(
                          children: [
                            // First page inside the expanded card (Safe Zones)
                            Safezone(),
                            // Second page inside the expanded card (Safe Homes)
                            safehome(),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
