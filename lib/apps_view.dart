import 'package:flutter/material.dart';

void main() => runApp(AppsViewApp());

class AppsViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppsViewScreen(),
      routes: {
        '/appsViewScreenWithoutAppBar': (context) => AppsViewScreen(),
      },
    );
  }
}

class AppsViewScreen extends StatelessWidget {
  final List<AppData> apps = [
    AppData(name: "Leave", icon: Icons.ac_unit, color: Colors.blue),
    AppData(name: "Skill", icon: Icons.access_alarm, color: Colors.green),
    AppData(name: "Timesheet", icon: Icons.access_time, color: Colors.orange),
    AppData(name: "CRM", icon: Icons.accessibility, color: Colors.red),
    AppData(name: "Asset", icon: Icons.account_balance, color: Colors.purple),
    AppData(name: "Attendence", icon: Icons.attach_file, color: Colors.orange),
    AppData(name: "CMS", icon: Icons.book_sharp, color: Colors.red),
    AppData(name: "Complaince", icon: Icons.comment_bank, color: Colors.purple),
    // Add more apps here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apps View"),
      ),
      body: Wrap(
        children: apps.map((app) => CircularAppIcon(app: app)).toList(),
      ),
    );
  }
}

class CircularAppIcon extends StatefulWidget {
  final AppData app;

  CircularAppIcon({required this.app});

  @override
  _CircularAppIconState createState() => _CircularAppIconState();
}

class _CircularAppIconState extends State<CircularAppIcon> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      _isTapped = true;
    });
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() {
      _isTapped = false;
    });
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    setState(() {
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: _isTapped ? Colors.grey : widget.app.color,
              shape: BoxShape.circle,
            ),
            child: Icon(widget.app.icon, size: 50.0, color: Colors.white),
          ),
          if (_isTapped)
            Positioned(
              top: 100.0, // Customize the position of the app name overlay
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                color: Colors.black,
                child: Text(
                  widget.app.name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class AppData {
  final String name;
  final IconData icon;
  final Color color;

  AppData({required this.name, required this.icon, required this.color});
}
