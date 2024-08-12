import 'package:flutter/material.dart';
import 'package:test/calendar/calendar_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Homepage")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the CalendarScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarScreen()),
            );
          },
          child: Text('Go to Calendar'),
        ),
      ),
    );
  }
}
