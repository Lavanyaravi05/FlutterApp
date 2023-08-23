import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flight Booking Settings',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select Your Preferred Flight Class:',
              style: TextStyle(fontSize: 18.0),
            ),
            DropdownButton<String>(
              value: 'Economy',
              onChanged: (newValue) {
                // Handle dropdown value change
              },
              items: <String>['Economy', 'Business', 'First Class']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Notification Preferences:',
              style: TextStyle(fontSize: 18.0),
            ),
            NotificationPreferenceRow(
              text: 'Receive flight booking notifications',
              value: true,
              onChanged: (newValue) {
                // Handle checkbox value change
              },
            ),
            NotificationPreferenceRow(
              text: 'Receive special offers and promotions',
              value: false,
              onChanged: (newValue) {
                // Handle checkbox value change
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Language Preference:',
              style: TextStyle(fontSize: 18.0),
            ),
            LanguagePreferenceRow(
              text: 'English',
              isSelected: true,
              onPressed: () {
                // Handle language selection
              },
            ),
            LanguagePreferenceRow(
              text: 'French',
              isSelected: false,
              onPressed: () {
                // Handle language selection
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Currency Preference:',
              style: TextStyle(fontSize: 18.0),
            ),
            CurrencyPreferenceRow(
              text: 'US Dollar',
              isSelected: true,
              onPressed: () {
                // Handle currency selection
              },
            ),
            CurrencyPreferenceRow(
              text: 'Euro',
              isSelected: false,
              onPressed: () {
                // Handle currency selection
              },
            ),
            CurrencyPreferenceRow(
              text: 'INR',
              isSelected: false,
              onPressed: () {
                // Handle currency selection
              },
            ),
            SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save settings
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                ),
                child: Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationPreferenceRow extends StatelessWidget {
  final String text;
  final bool value;
  final ValueSetter<bool?> onChanged;

  const NotificationPreferenceRow({
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(text),
      ],
    );
  }
}

class LanguagePreferenceRow extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const LanguagePreferenceRow({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }
}

class CurrencyPreferenceRow extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const CurrencyPreferenceRow({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountSettingsScreen(),
  ));
}
