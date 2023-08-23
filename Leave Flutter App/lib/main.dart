import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as CustomBadge;
import 'login_page.dart';
import 'leave_status.dart';
import 'approve_reject.dart';
import 'apply_leave.dart';
import 'view_profile.dart';
import 'dashboard.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  bool loggedIn = false;
  String? accessToken;
  int _empId = 0; // Initialize with a default value
  int get notificationCount {
    // Replace this with your logic to fetch the actual notification count
    return 3;
  }

  // Store instances of all pages
  final List<Widget> pages = [
    DashboardPage(),
    ApplyLeavePage(accessToken: "", empId: ""), // Initialize with empty values
    HomePage(),
    ApproveRejectPage(accessToken: ""),
    LeaveStatusPage(accessToken: ""),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void login(String token, int empId) {
    setState(() {
      loggedIn = true;
      accessToken = token;
      _empId = empId; // Store the received emp_id
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
      position: RelativeRect.fromLTRB(16, kToolbarHeight, 0,
          0), // Adjust the x-coordinate value for desired spacing
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: () {
              Navigator.pop(context); // Close the menu
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewProfilePage()));
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
        return ApplyLeavePage(
            accessToken: accessToken!, empId: _empId.toString());
      case 2:
        return HomePage();
      case 3:
        return ApproveRejectPage(accessToken: accessToken!);
      case 4:
        return LeaveStatusPage(accessToken: accessToken!);
      default:
        return DashboardPage(accessToken: accessToken!);
    }
  }

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
                    backgroundImage: AssetImage(
                        'assets/avatar-login.png'), // Replace with your avatar image
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewProfilePage()));
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

// Home Page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<bool> appStatusList = [
    true, // App 1 status
    false, // App 2 status
    true, // App 3 status
    true, // App 4 status
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
                                      color: appStatusList[index]
                                          ? Colors.green
                                          : Colors.red,
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
