import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as CustomBadge;
import 'login_page.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class ApplyLeavePage extends StatefulWidget {
  final String accessToken; // Add the access token parameter

  ApplyLeavePage({required this.accessToken}); // Update the constructor

  @override
  _ApplyLeavePageState createState() => _ApplyLeavePageState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  bool loggedIn = false;
  String? accessToken;
  int get notificationCount {
    // Replace this with your logic to fetch the actual notification count
    return 3;
  }
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void login(String token) {
    setState(() {
      loggedIn = true;
      accessToken = token;
    });
  }

  void logout() {
    setState(() {
      loggedIn = false;
      accessToken = null;
    });
  }

  void _showAccountMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(16, kToolbarHeight, 0, 0), // Adjust the x-coordinate value for desired spacing
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: () {
              Navigator.pop(context); // Close the menu
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfilePage()));
            },
          ),
        ),
        if (loggedIn)
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout tap
                logout();
                Navigator.pop(context); // Close the menu
              },
            ),
          ),
      ],
      elevation: 8,
    );
  }

  Widget getPage(int index) {
    if (!loggedIn) {
      return LoginPage(login: login);
    }
    switch (index) {
      case 0:
        return DashboardPage(accessToken: accessToken!);
      case 1:
        return ApplyLeavePage(accessToken: accessToken!);
      case 2:
        return HomePage();
      case 3:
        return ApproveRejectPage();
      case 4:
        return LeaveStatusPage();
      default:
        return DashboardPage(accessToken: accessToken!);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loggedIn
          ? AppBar(
        title: Text('Leave Management'),
        actions: [
          CustomBadge.Badge(
            position: CustomBadge.BadgePosition.topEnd(top: 2, end: 2),
            animationDuration: Duration(milliseconds: 300),
            animationType: CustomBadge.BadgeAnimationType.slide,
            badgeContent: Text(
              notificationCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Handle the notification icon tap
              },
            ),
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar-login.png'), // Replace with your avatar image
              radius: 15,
            ),
            offset: Offset(0, kToolbarHeight),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('View Profile'),
                  onTap: () {
                    Navigator.pop(context); // Close the menu
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfilePage()));
                  },
                ),
              ),
              if (loggedIn)
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      // Handle logout tap
                      logout();
                      Navigator.pop(context); // Close the menu
                    },
                  ),
                ),
            ],
          ),
        ],
      )
          : null,
      body: Stack(
        children: [
          Positioned.fill(
            child: getPage(_currentIndex),
          ),
        ],
      ),
      bottomNavigationBar: loggedIn
          ? BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _onTabTapped(index);
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Apply Leave',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Approve / Reject',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Leave Status',
          ),
        ],
      )
          : null,
    );
  }
}

// View profile page

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}
class _ViewProfilePageState extends State<ViewProfilePage> {
  bool isChangingPassword = false;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPasswordField(
                labelText: 'Current Password',
                controller: currentPasswordController,
                isVisible: isCurrentPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isCurrentPasswordVisible = !isCurrentPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 16),
              buildPasswordField(
                labelText: 'New Password',
                controller: newPasswordController,
                isVisible: isNewPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isNewPasswordVisible = !isNewPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 16),
              buildPasswordField(
                labelText: 'Confirm Password',
                controller: confirmPasswordController,
                isVisible: isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear the text field values and reset the visibility state
                currentPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
                setState(() {
                  isCurrentPasswordVisible = false;
                  isNewPasswordVisible = false;
                  isConfirmPasswordVisible = false;
                });

                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle change password logic here
                // Retrieve the entered values
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;

                // Validate the entered passwords and perform necessary actions
                if (newPassword == confirmPassword) {
                  // Passwords match, proceed with password change
                  // Implement your logic here
                  print('Changing password...');
                } else {
                  // Passwords do not match, show an error message
                  // Implement your logic here
                  print('Passwords do not match!');
                }

                // Clear the text field values and reset the visibility state
                currentPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
                setState(() {
                  isCurrentPasswordVisible = false;
                  isNewPasswordVisible = false;
                  isConfirmPasswordVisible = false;
                });

                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }

  Widget buildPasswordField({
    required String labelText,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
      obscureText: !isVisible,
      controller: controller,
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar-login.png'), // Replace with your avatar image
            ),
            SizedBox(height: 16),
            Text(
              'Lavanya Ravi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
              readOnly: true,
              controller: TextEditingController(text: 'Lavanya'), // Replace with actual first name
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
              readOnly: true,
              controller: TextEditingController(text: 'Ravi'), // Replace with actual last name
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email ID',
              ),
              readOnly: true,
              controller: TextEditingController(text: 'lavanya.ravi@techgenzi.com'), // Replace with actual email ID
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showChangePasswordDialog();
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}


// Dashboard page
class LeaveHistoryData {
  final String fromDate;
  final String toDate;
  final String leaveType;
  final String noOfDays;

  LeaveHistoryData(
      this.fromDate, this.toDate, this.leaveType, this.noOfDays);
}
class DashboardPage extends StatefulWidget {
  final String? accessToken;

  const DashboardPage({Key? key, this.accessToken}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage> {
  // Sample data for the donut chart
  List<PieChartSectionData> pieChartData = [
    PieChartSectionData(
      value: 10,
      title: 'Available Days',
      color: Colors.blue,
      radius: 50,
      titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
    PieChartSectionData(
      value: 5,
      title: 'Used Days',
      color: Colors.green,
      radius: 50,
      titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
  ];

  List<LeaveHistoryData> leaveHistoryData = [];
  bool isLoading = false;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Make the API request
      http.Response response = await http.get(
        Uri.parse('https://ipssapi.hrm.techgenzi.com/emp_apply_leave/employee_leave_report/history_report/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Parse the response JSON
        List<dynamic> data = jsonDecode(response.body);

        // Process leave history data
        leaveHistoryData = data.map((item) {
          return LeaveHistoryData(
            item['from_date'],
            item['to_date'],
            item['leavetype_name'],
            item['no_of_days'],
          );
        }).toList();
      } else {
        // Handle error response
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch data from the API.'),
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
      // Handle network error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while making the API request.'),
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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Calculate the total days
    int totalDays = pieChartData.fold(0, (sum, data) => sum + data.value.toInt());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    // Update the PieChartData initialization
                    PieChartData(
                      sections: List.generate(pieChartData.length, (index) {
                        final isTouched = index == touchedIndex;
                        final double fontSize = isTouched ? 16 : 12;
                        final double radius = isTouched ? 60 : 50;

                        return PieChartSectionData(
                          value: pieChartData[index].value,
                          title: '',
                          color: pieChartData[index].color,
                          radius: radius,
                          titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                        );
                      }),
                      centerSpaceRadius: 70,
                      sectionsSpace: 0,
                      borderData: FlBorderData(show: false),
                      startDegreeOffset: -90,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions || pieTouchResponse == null) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = pieTouchResponse.touchedSection?.touchedSectionIndex ?? -1;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Used Days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Available Days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Days',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      totalDays.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 16.0),
              child: Text(
                'Leave History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('From Date')),
            DataColumn(label: Text('To Date')),
            DataColumn(label: Text('Leave Type')),
            DataColumn(label: Text('No of Days')),
          ],
          rows: leaveHistoryData.map((data) {
            return DataRow(cells: [
              DataCell(Text(data.fromDate)),
              DataCell(Text(data.toDate)),
              DataCell(Text(data.leaveType)),
              DataCell(Text(data.noOfDays.toString())),
            ]);
          }).toList(),
        ),
      ),
          ],
        ),
      ),
    );
  }
}


// Home Page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final List<bool> appStatusList = [
    true,  // App 1 status
    false, // App 2 status
    true,  // App 3 status
    true,  // App 4 status
    // Add more app statuses as needed
  ];

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<EdgeInsets> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _positionAnimation = Tween<EdgeInsets>(
      begin: EdgeInsets.only(bottom: 100),
      end: EdgeInsets.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apps',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appStatusList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (BuildContext context, Widget? child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Padding(
                              padding: _positionAnimation.value,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.apps, // Replace with your app icon
                                      color: appStatusList[index] ? Colors.green : Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                  title: Text(
                                    'Leave',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    appStatusList[index] ? 'Online' : 'Offline',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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

// Apply leave page
class _ApplyLeavePageState extends State<ApplyLeavePage> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  String? _selectedAmPm; // Add this line above the _ApplyLeavePageState class

  bool _isMultiDay = true;
  bool _isHalfDay = false;
  String _description = '';
  String leaveType = ''; // Change the variable name from '_leaveType' to 'leaveType'
  double _noOfDays = 0;
  //API Integration for Apply leave(POST Method)
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _applyLeave() async {
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "leavetype": leaveTypes.indexOf(leaveType),
      "from_date": _selectedStartDate.toIso8601String(),
      "to_date": _selectedEndDate.toIso8601String(),
      "halfday": !_isMultiDay && _isHalfDay,
      "halfday_type": _selectedAmPm ?? '',
      "reason": _description,
      "leave_status": "Pending"
    };

    // Encode the request body as JSON
    String requestBodyJson = jsonEncode(requestBody);

    // Set the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.accessToken}'
    };

    try {
      // Make the apply leave request
      http.Response response = await http.post(
        Uri.parse('https://ipssapi.hrm.techgenzi.com/emp_apply_leave/'),
        headers: headers,
        body: requestBodyJson,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Leave applied successfully
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Leave Applied'),
            content: Text('Your leave application has been submitted.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Clear form data and navigate back
                  setState(() {
                    _selectedStartDate = DateTime.now();
                    _selectedEndDate = DateTime.now();
                    _selectedAmPm = null;
                    _isMultiDay = true;
                    _isHalfDay = false;
                    _description = '';
                    _descriptionController.clear(); // Clear the description field
                    leaveType = '';
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      } else {
        // Leave application failed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Leave Application Failed'),
            content: Text('An error occurred while applying for leave.'),
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
          title: Text('Leave Application Failed'),
          content: Text('An error occurred while applying for leave.'),
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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2098),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _selectedEndDate = picked;
        _calculateNoOfDays();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: _selectedStartDate,
      lastDate: DateTime(2098),
    );
    if (picked != null &&
        picked != _selectedEndDate &&
        picked.isBefore(DateTime(2098))) {
      setState(() {
        _selectedEndDate = picked;
      });
      _calculateNoOfDays();
    }
  }

  double _calculateNoOfDays() {
    if (_isMultiDay) {
      int noOfDays = _selectedEndDate.difference(_selectedStartDate).inDays + 1;
      return noOfDays.toDouble();
    } else {
      return _isHalfDay ? 0.5 : 1.0;
    }
  }


  Widget _buildDatePickerRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From Date:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectStartDate(context),
                        ),
                        TextButton(
                          onPressed: () => _selectStartDate(context),
                          child: Text(
                            '${_selectedStartDate.toLocal()}'.split(' ')[0],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To Date:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectEndDate(context),
                        ),
                        TextButton(
                          onPressed: () => _selectEndDate(context),
                          child: Text(
                            '${_selectedEndDate.toLocal()}'.split(' ')[0],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!_isMultiDay)
          Row(
            children: [
              Checkbox(
                value: _isHalfDay,
                onChanged: (value) {
                  setState(() {
                    _isHalfDay = value!;
                  });
                },
              ),
              Text(
                'Half day',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        if (!_isMultiDay && _isHalfDay)
          Row(
            children: [
              SizedBox(width: 16),
              DropdownButton<String>(
                value: 'AM', // Default value
                onChanged: (value) {
                  // Handle AM/PM selection
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'AM',
                    child: Text('AM'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'PM',
                    child: Text('PM'),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDateField() {
    String? _selectedAmPm; // Selected value

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date:',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        Container(
          width: 180, // Adjust the width as needed
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectStartDate(context),
              ),
              TextButton(
                onPressed: () => _selectStartDate(context),
                child: Text(
                  '${_selectedStartDate.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Checkbox(
                value: _isHalfDay,
                onChanged: (value) {
                  setState(() {
                    _isHalfDay = value ?? false;
                  });
                },
              ),
            ),
            Text(
              'Half day',
              style: TextStyle(fontSize: 18),
            ),
            if (_isHalfDay) ...[
              SizedBox(width: 16),
              Container(
                width: 120, // Adjust the width as needed
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: InputBorder.none,
                    ),
                    value: _selectedAmPm, // Selected value
                    onChanged: (newValue) {
                      setState(() {
                        _selectedAmPm = newValue; // Update selected value
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: 'AM',
                        child: Text('AM'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'PM',
                        child: Text('PM'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildNoOfDaysField() {
    double noOfDays = _calculateNoOfDays();
    String displayNoOfDays = noOfDays.toString();
    if (_isHalfDay && !_isMultiDay) {
      displayNoOfDays = '0.5';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No of Days:',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        Text(
          displayNoOfDays,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
  //Leave type dropdown integration

  List<String> leaveTypes = [];

  Future<void> fetchLeaveTypes() async {
    Uri url = Uri.parse('https://ipssapi.hrm.techgenzi.com/leavetype/');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> results = data['results'];
        setState(() {
          leaveTypes = results
              .map((result) => result['leavetype_name'].toString())
              .toSet() // Convert to Set to remove duplicates
              .toList(); // Convert back to List
        });
      } else {
        // Handle API error
      }
    } catch (error) {
      // Handle network error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLeaveTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apply Leave',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Leave Type:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Container(
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: leaveType.isNotEmpty ? leaveType : null,
                    onChanged: (value) {
                      setState(() {
                        leaveType = value!;
                      });
                    },
                    items: leaveTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                                color:
                                    Colors.black)), // Set text color to black
                      );
                    }).toList(),
                    isExpanded: true,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .black), // Set the selected item text color to black
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down),
                    underline: SizedBox(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Leave Duration:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: _isMultiDay,
                  onChanged: (value) {
                    setState(() {
                      _isMultiDay = value as bool;
                      _calculateNoOfDays();
                    });
                  },
                ),
                Text(
                  'Multi day',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 16),
                Radio(
                  value: false,
                  groupValue: _isMultiDay,
                  onChanged: (value) {
                    setState(() {
                      _isMultiDay = value as bool;
                      _calculateNoOfDays();
                    });
                  },
                ),
                Text(
                  'Single day',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),
            _isMultiDay ? _buildDatePickerRow() : _buildDateField(),
            SizedBox(height: 16),
            _buildNoOfDaysField(),
            SizedBox(height: 16),
            Text(
              'Reason:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Container(
              height: 120,
              child: TextField(
                controller: _descriptionController,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                maxLines: 20,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter reason...',
                ),
              ),

            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Logic to apply leave
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _applyLeave,
                    child: Text('Submit'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Approve & Reject page
class ApproveRejectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0), // Set preferred height to zero
            child: TabBar(
              tabs: [
                Tab(text: 'Leave Requests'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected'),
              ],
            ),
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: TabBarView(
            children: [
              ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow,
                      child: Text('P'),
                    ),
                    title: Text('Leave Application $index'),
                    subtitle: Text('Reason for leave'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.check,
                            color: Colors.green, // Green color for tick icon
                          ),
                          label: SizedBox.shrink(),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                        ),
                        SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close,
                            color: Colors.red, // Red color for cross icon
                          ),
                          label: SizedBox.shrink(),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text('A'),
                    ),
                    title: Text('Approved Leave $index'),
                    subtitle: Text('Reason for leave'),
                    trailing: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.check,
                        color: Colors.green, // Green color for tick icon
                      ),
                      label: SizedBox.shrink(),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text('R'),
                    ),
                    title: Text('Rejected Leave $index'),
                    subtitle: Text('Reason for leave'),
                    trailing: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        color: Colors.red, // Red color for cross icon
                      ),
                      label: SizedBox.shrink(),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Leave Status page
class LeaveStatusPage extends StatefulWidget {
  @override
  _LeaveStatusPageState createState() => _LeaveStatusPageState();
}

class _LeaveStatusPageState extends State<LeaveStatusPage> {
  final List<bool> leaveStatusList = [
    true,  // Leave 1 status
    false, // Leave 2 status
    true,  // Leave 3 status
    true,  // Leave 4 status
    // Add more leave statuses as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Leave Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: leaveStatusList.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: MediaQuery.of(context).size.width * 0.8, // Set a specific width value
                  height: 80,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Adjust the margin values
                  decoration: BoxDecoration(
                    color: leaveStatusList[index] ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text('L'),
                    ),
                    title: Text(
                      'Leave $index',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      leaveStatusList[index] ? 'Approved' : 'Rejected',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



