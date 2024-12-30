import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sos/auth.dart';
import 'package:sos/sos_alert.dart'; // Import AuthService class

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  // Initialize AuthService
  final auth = AuthService();

  // Text controllers for form fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController(); // fixed controller name
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set background to transparent
        centerTitle: true,
        title: Text(
          'Signup',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Change icon color to white
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
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _emailController, // fixed controller name
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_sharp),
                    ),
                    labelText: 'Password',
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 60.0),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF00B8), // Starting color
                        Color(0xFFFF017D), // Ending color
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Set background to transparent
                      elevation: 0, // Remove elevation
                    ),
                    onPressed: () {
                      _signup(); // Call the _signup function
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _signup() async {
    try {
      final user = await auth.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        log('User created successfully');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sosalert()),
        );
      } else {
        log('User creation failed');
      }
    } catch (e) {
      log('Error during signup: $e');
    }
  }
}
