// Apply leave page
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApplyLeavePage extends StatefulWidget {
  final String accessToken;
  final String empId;

  ApplyLeavePage({required this.accessToken, required this.empId});

  @override
  _ApplyLeavePageState createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  String? _selectedAmPm; // Add this line above the _ApplyLeavePageState class

  bool _isMultiDay = true;
  bool _isHalfDay = false;
  String _description = '';
  String leaveType =
      ''; // Change the variable name from '_leaveType' to 'leaveType'
  double _noOfDays = 0;

  // Function to fetch employee ID from login API
  late String _employeeId = ''; // Initialize with an empty string
  String? _employeeName = '';

  Future<String> fetchEmployeeId(String accessToken) async {
    if (accessToken == null) {
      throw Exception('Access token is null');
    }

    Uri url = Uri.parse('https://ipssapi.hrm.techgenzi.com/users/login');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String empId = data['user']['emp_id'].toString();
        return empId;
      } else {
        throw Exception('Failed to fetch employee ID');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

// Function to fetch employee name using employee ID
  Future<String> fetchEmployeeName(String accessToken, int empId) async {
    Uri url = Uri.parse('https://ipssapi.hrm.techgenzi.com/employees/$empId/');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String empName = data['aadhaarname'].toString();
        return empName;
      } else {
        throw Exception('Failed to fetch employee name');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

  Future<void> fetchEmployeeData() async {
    try {
      String empName =
          await fetchEmployeeName(widget.accessToken, int.parse(_employeeId));

      setState(() {
        _employeeName = empName;
      });
    } catch (error) {
      // Handle error
      print('Error fetching employee data: $error');
    }
  }

  //API Integration for Apply leave(POST Method)
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _applyLeave() async {
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "emp_id": int.parse(_employeeId), // Include employee ID
      // "emp_name": _employeeName ?? '', // Include employee name
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
                    _descriptionController
                        .clear(); // Clear the description field
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
    _employeeId = widget.empId; // Initialize _employeeId with empId
    fetchEmployeeData(); // This method fetches employee ID and name
    fetchLeaveTypes(); // Fetch leave types
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
              'Employee ID:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              _employeeId ?? '',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Employee Name:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              _employeeName ?? '', // Display the employee name if available
              style: TextStyle(fontSize: 18),
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
