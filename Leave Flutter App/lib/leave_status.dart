import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaveStatusPage extends StatefulWidget {
  final String accessToken;

  LeaveStatusPage({required this.accessToken});

  @override
  _LeaveStatusPageState createState() => _LeaveStatusPageState();
}

class _LeaveStatusPageState extends State<LeaveStatusPage> {
  Future<List<dynamic>> fetchLeaveStatuses() async {
    final response = await http.get(
      Uri.parse(
          'https://ipssapi.hrm.techgenzi.com/emp_apply_leave/manager_report/manager/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}'
      }, // Include the access token in the headers
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> leaveStatuses = data['data'];

      return leaveStatuses;
    } else {
      throw Exception('Failed to fetch leave statuses');
    }
  }

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
            child: FutureBuilder<List<dynamic>>(
              future: fetchLeaveStatuses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No leave statuses available.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var leaveStatus = snapshot.data![index];

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 80,
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: leaveStatus['leave_status'] == 'Approved'
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(leaveStatus['emp_name'][
                                0]), // Display the first letter of employee name
                          ),
                          title: Text(
                            ' ${leaveStatus['emp_name']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            leaveStatus['leave_status'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
