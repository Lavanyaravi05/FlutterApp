import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) {
    runApp(BookingApp());
  });
}

class BookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap BookingForm with SingleChildScrollView
          child: BookingForm(),
        ),
      ),
    );
  }
}

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  String passengerName = '';
  int age = 0;
  String departureCity = '';
  String arrivalCity = '';
  String flightClass = '';
  DateTime? travelDate;
  String paymentMethod = 'Credit Card'; // Default payment method

  String formattedDate(DateTime? date) {
    if (date == null) {
      return 'Select a date';
    }
    return DateFormat.yMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Passenger Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter passenger name';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                passengerName = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Age'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter age';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                age = int.parse(value);
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Departure City'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter departure city';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                departureCity = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Arrival City'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter arrival city';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                arrivalCity = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Flight Class'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter flight class';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                flightClass = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (selectedDate != null) {
                setState(() {
                  travelDate = selectedDate;
                });
              }
            },
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Travel Date',
                suffixIcon: Icon(Icons.date_range),
              ),
              controller: TextEditingController(
                text: formattedDate(travelDate),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          // Payment Method selection
          DropdownButtonFormField<String>(
            value: paymentMethod,
            onChanged: (newValue) {
              setState(() {
                paymentMethod = newValue!;
              });
            },
            items: <String>['Credit Card', 'PayPal', 'Bank Transfer', 'Cash']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Payment Method',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a payment method';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid, perform booking logic
                // Here, you would typically implement payment processing logic
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
