// Dashboard page
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
