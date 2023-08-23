import 'package:flutter/material.dart';
import 'booking_page.dart'; // Import the BookingPage class

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flight,
                size: 60.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Choose your flight destination',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
