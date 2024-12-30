import 'package:flutter/material.dart';
import 'package:sos/cctvlog.dart';
import 'package:sos/map/crowd.dart';
import 'package:sos/soslog.dart';

class selectpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log Selection',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 35, right: 35), // Remove padding to apply gradient properly
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => soslog()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25, left: 70, right: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, color: Colors.black), // SOS icon
                      SizedBox(width: 10), // Spacing between icon and text
                      Text(
                        'SOS log',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Spacing between buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.only(left: 30, right: 30), // Remove padding to apply gradient properly
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => cctv()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25, left: 70, right: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera, color: Colors.black), // CCTV icon
                    SizedBox(width: 10), // Spacing between icon and text
                    Text(
                      'CCTV log',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0), // Remove padding to apply gradient properly
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => gen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25, left: 70, right: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group, color: Colors.black), // Crowd count icon
                    SizedBox(width: 10), // Spacing between icon and text
                    Text(
                      'Crowd count log',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: selectpage(),
  ));
}
