import 'package:flutter/material.dart';
import 'booking_screen.dart'; // Import the BookingScreen class
import 'dashboard_screen.dart'; // Import the DashboardScreen class
import 'account_settings_screen.dart'; // Import the AccountSettingsScreen class

void main() => runApp(BookingApp());

class BookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book My Tickets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    BookingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 1) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book My Tickets'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Navigate to AccountSettingsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flight),
              label: 'Book Flight',
            ),
          ],
        ),
      ),
    );
  }
}
