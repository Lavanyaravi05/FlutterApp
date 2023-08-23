import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApproveRejectPage extends StatefulWidget {
  final String accessToken;

  ApproveRejectPage({required this.accessToken});

  @override
  _ApproveRejectPageState createState() => _ApproveRejectPageState();
}

class _ApproveRejectPageState extends State<ApproveRejectPage> {
  //Approval status
  Future<List<dynamic>> fetchApprovedLeaves() async {
    final response = await http.get(
      Uri.parse(
          'https://ipssapi.hrm.techgenzi.com/emp_apply_leave/manager_report/manager/'),
      headers: {'Authorization': 'Bearer ${widget.accessToken}'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> allLeaves = data['data'];

      // Filter approved leaves
      List<dynamic> approvedLeaves = allLeaves
          .where((leave) => leave['leave_status'] == 'Approved')
          .toList();

      return approvedLeaves;
    } else {
      throw Exception('Failed to fetch approved leaves');
    }
  }
  //Rejected leave

  Future<List<dynamic>> fetchRejectedLeaves() async {
    final response = await http.get(
      Uri.parse(
          'https://ipssapi.hrm.techgenzi.com/emp_apply_leave/manager_report/manager/'),
           headers: {'Authorization': 'Bearer ${widget.accessToken}'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> allLeaves = data['data'];

      // Filter rejected leaves
      List<dynamic> rejectedLeaves = allLeaves
          .where((leave) => leave['leave_status'] == 'Rejected')
          .toList();

      return rejectedLeaves;
    } else {
      throw Exception('Failed to fetch rejected leaves');
    }
  }

  //Leave Requests
  Future<List<dynamic>> fetchLeaveRequests(String accessToken) async {
    final response = await http.get(
      Uri.parse(
          'https://ipssapi.hrm.techgenzi.com/emp_apply_leave/manager_approve/report/'),
           headers: {'Authorization': 'Bearer ${widget.accessToken}'},

    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to fetch leave requests');
    }
  }

  //Update the status Approve or Reject
  // Update the status Approve or Reject
  Future<void> updateLeaveStatus(String leaveId, String status, String reason) async {
    final apiUrl =
        'https://ipssapi.hrm.techgenzi.com/emp_apply_leave/manager_approve/report/$leaveId/';

    final headers = {
      'Authorization': 'Bearer ${widget.accessToken}',
      'Content-Type': 'application/json',
    };

    final payload = {
      'leave_status': status,
      'reason': reason,
    };

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('Leave status updated successfully');
    } else {
      throw Exception('Failed to update leave status');
    }
  }
  //Reject popup
  void _showRejectReasonDialog(String leaveId) {
    String? reason;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reject Leave'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Reason'),
                onChanged: (value) {
                  reason = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Reject'),
              onPressed: () {
                if (reason != null && reason!.isNotEmpty) {
                  updateLeaveStatus(leaveId, 'Rejected', reason!).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Leave has been rejected successfully.'),
                      duration: Duration(seconds: 2),
                    ));
                    setState(() {
                      // Update UI here if needed
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  }).catchError((error) {
                    // Handle error here
                    Navigator.of(context).pop(); // Close the dialog
                  });
                } else {
                  // Show an error message if the reason is not provided
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please provide a reason.'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: TabBar(
                tabs: [
                  Tab(text: 'Leave Requests'),
                  Tab(text: 'Approved'),
                  Tab(text: 'Rejected'),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 16), // Add desired top padding here
            child: TabBarView(
              children: [
                //Leave Request Tab
                FutureBuilder<List<dynamic>>(
                  future: fetchLeaveRequests(widget.accessToken),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No leave requests available.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var request = snapshot.data![index];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: Text(request['emp_name'][0]),
                            ),
                            title: Text(request['emp_name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text(
                                    "${request['from_date']} - ${request['to_date']}"),
                                Text("No of Days: ${request['no_of_days']}"),
                                Text(request['reason'],
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    updateLeaveStatus(request['leave_id'].toString(), 'Approved', '')
                                        .then((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Leave has been approved successfully.'),
                                        duration: Duration(seconds: 2),
                                      ));
                                      setState(() {
                                        snapshot.data!.removeAt(index);
                                      });
                                    }).catchError((error) {
                                      // Handle error here
                                    });
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  label: SizedBox.shrink(),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(CircleBorder()),
                                  ),
                                ),
                                SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        String reason = '';
                                        return AlertDialog(
                                          title: Text('Reject Leave'),
                                          content: TextField(
                                            onChanged: (value) {
                                              reason = value;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Reason',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (reason != null && reason.isNotEmpty) {
                                                  updateLeaveStatus(
                                                      request['leave_id'].toString(), 'Rejected', reason)
                                                      .then((_) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text('Leave has been rejected successfully.'),
                                                      duration: Duration(seconds: 2),
                                                    ));
                                                    setState(() {
                                                      snapshot.data!.removeAt(index);
                                                    });
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  }).catchError((error) {
                                                    // Handle error here
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  });
                                                } else {
                                                  // Show an error message if the reason is not provided
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text('Please provide a reason.'),
                                                    duration: Duration(seconds: 2),
                                                  ));
                                                }
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
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
                      );
                    }
                  },
                ),
                //Approved Tab
                FutureBuilder<List<dynamic>>(
                  future: fetchApprovedLeaves(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('No approved leaves available.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var approvedLeave = snapshot.data![index];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(approvedLeave['emp_name'][
                                  0]), // Display the first letter of employee name
                            ),
                            title: Text(approvedLeave['emp_name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${approvedLeave['from_date']} - ${approvedLeave['to_date']}'),
                                Text(
                                    'No of Days: ${approvedLeave['no_of_days']}'),
                                Text(
                                  approvedLeave['reason'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),

                //Rejected Tab
                FutureBuilder<List<dynamic>>(
                  future: fetchRejectedLeaves(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('No rejected leaves available.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var rejectedLeave = snapshot.data![index];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(rejectedLeave['emp_name'][
                                  0]), // Display the first letter of employee name
                            ),
                            title: Text(rejectedLeave['emp_name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${rejectedLeave['from_date']} - ${rejectedLeave['to_date']}'),
                                Text(
                                    'No of Days: ${rejectedLeave['no_of_days']}'),
                                Text(
                                  rejectedLeave['reason'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}
