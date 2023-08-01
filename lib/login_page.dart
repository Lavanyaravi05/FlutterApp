//Login Page
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginPage extends StatefulWidget {
  final Function(String) login;

  LoginPage({required this.login});

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false; // Added variable to track password visibility

  Future<void> _performLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Create the request body
    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };

    // Encode the request body as JSON
    String requestBodyJson = jsonEncode(requestBody);

    // Set the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Make the login request
      http.Response response = await http.post(
        Uri.parse('https://ipssapi.hrm.techgenzi.com/users/login'),
        headers: headers,
        body: requestBodyJson,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Login successful
        String accessToken = json.decode(response.body)['access_token'];

        widget.login(accessToken); // Pass the accessToken to the login function
      } else {
        // Login failed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid username or password.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle the error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('An error occurred during login.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue, // Replace with your desired background color for the top area
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align widgets from the top
            children: [
              // Add the image with background color till the image
              Expanded(
                child: Container(
                  color: Colors.blue, // Set the background color for the top area
                  padding: EdgeInsets.all(50.0),
                  child: Image.asset(
                    'assets/image.png', // Replace with your image path
                    fit: BoxFit.cover, // Use BoxFit.cover to maintain the aspect ratio while fitting the image within the container
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(16.0),
                elevation: 5, // Add some elevation for a shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16.0),
                      Image.asset(
                        'assets/tgz-logo.png',
                        height: 80,
                        width: 200,
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(), // Add border to the input field
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: _passwordVisible
                                ? Icon(Icons.visibility, color: Colors.blue)
                                : Icon(Icons.visibility_off, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(), // Add border to the input field
                        ),
                        obscureText: !_passwordVisible,
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _performLogin,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text('Login', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
