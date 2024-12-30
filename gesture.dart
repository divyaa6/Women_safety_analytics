import 'package:flutter/material.dart';
import 'dart:async';

class TimerButtonExample extends StatefulWidget {
  @override
  _TimerButtonExampleState createState() => _TimerButtonExampleState();
}

class _TimerButtonExampleState extends State<TimerButtonExample> {
  Timer? _timer;
  bool _isHolding = false;

  void _startTimer() {
    setState(() {
      _isHolding = true;
    });

    _timer = Timer(Duration(milliseconds: 1500), () {
      _showMessageDialog();
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

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text('Message sent'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer Button Example')),
      body: Center(
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
          child: IconButton(
            icon: Icon(Icons.play_arrow),
            iconSize: 64.0,
            onPressed: () {
              _showMessageDialog();

            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
