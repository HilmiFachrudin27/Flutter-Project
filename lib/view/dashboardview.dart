import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/distribution_screen.dart';
import 'addview.dart';
import 'distribution_list_screen.dart'; // Import the Distribution List Page
import 'profile_view.dart';
import 'surveykematangan_view.dart';
import 'distribution_detail_screen.dart'; // Import the Distribution Detail Page

class Dashboardview extends StatefulWidget {
  const Dashboardview({super.key, required this.token});
  final String token;

  @override
  State<Dashboardview> createState() => _DashboardviewState();
}

class _DashboardviewState extends State<Dashboardview> {
  int _selectedIndex = 0;

  // Define the list of widgets for different pages
  static List<Widget> _widgetOptions = <Widget>[
    DistributionListScreen(), // Index 0 is DistributionListScreen
    SurveyListScreen(),   // Index 1 is SurveyKematanganView
  ];
  
  // Handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Build the Scaffold with conditional AppBar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _shouldShowAppBar()
          ? AppBar(
              title: const Text(
                'Survey Pisang',
                style: TextStyle(
                  color: Color(0xFFFFD245),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.person, color: Color(0xFFFFD245)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileView(token: widget.token),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          if (_selectedIndex != 1) // Hide FloatingActionButton on SurveyKematanganView
            Positioned(
              bottom: 70,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddView()),
                  );
                },
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFFFD245),
                child: const Icon(Icons.add),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cable),
            label: 'Distribusi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Survey Kematangan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFFD245),
        onTap: _onItemTapped,
      ),
    );
  }

  // Determine whether to show the AppBar based on current index
  bool _shouldShowAppBar() {
    return _selectedIndex == 0 || _selectedIndex == 1; // Show AppBar for DistributionListScreen and DistributionDetailScreen
  }
}
