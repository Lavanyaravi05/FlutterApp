import 'package:flutter/material.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<FlightTicketHistory> flightTicketHistory = [
    FlightTicketHistory('New York', 'London', 'ABC123', '2023-08-15'),
    FlightTicketHistory('Paris', 'Tokyo', 'XYZ789', '2023-08-10'),
    FlightTicketHistory('India', 'Mumbai', 'CYZ189', '2023-08-20'),
    FlightTicketHistory('UK', 'London', 'ABC123', '2023-04-15'),
    FlightTicketHistory('Italy', 'Tokyo', 'XYZ789', '2023-01-10'),
    FlightTicketHistory('Banaras', 'Mumbai', 'CYZ189', '2023-02-20'),
    // Add more entries as needed
  ];

  Color _backgroundColor = Colors.blue.shade300; // Initial background color

  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: _backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_pin_circle_rounded,
              size: 60.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'Welcome to your Flight Booking Dashboard!',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: flightTicketHistory.length,
              itemBuilder: (context, index) {
                final historyEntry = flightTicketHistory[index];
                final cardColor = index % 2 == 0
                    ? Colors.blue.shade100
                    : Colors.blue.shade200;
                return FlightTicketCard(historyEntry, cardColor);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _backgroundColor = _generateRandomColor();
          });
        },
        child: Icon(Icons.color_lens),
      ),
    );
  }

  Color _generateRandomColor() {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    return colors[_random.nextInt(colors.length)];
  }
}

class FlightTicketCard extends StatelessWidget {
  final FlightTicketHistory historyEntry;
  final Color cardColor;

  FlightTicketCard(this.historyEntry, this.cardColor);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text('${historyEntry.from} to ${historyEntry.to}'),
        subtitle: Text('Flight: ${historyEntry.flightNumber}'),
        trailing: Text('Date: ${historyEntry.date}'),
      ),
    );
  }
}

class FlightTicketHistory {
  final String from;
  final String to;
  final String flightNumber;
  final String date;

  FlightTicketHistory(this.from, this.to, this.flightNumber, this.date);
}

void main() {
  runApp(MaterialApp(
    home: DashboardScreen(),
  ));
}
