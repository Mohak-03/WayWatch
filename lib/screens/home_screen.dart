import 'package:flutter/material.dart';

import 'tabs/home_tab.dart';
import 'tabs/people_tab.dart';
import 'tabs/emergency_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  
  const HomeScreen({
    super.key,
    this.userName = 'User', // Default name if not provided
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  // Mock data for user contacts
  final List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Sarah Johnson',
      'status': 'online',
      'lastSeen': DateTime.now().subtract(const Duration(minutes: 5)),
      'avatar': 'assets/images/avatar1.png',
    },
    {
      'name': 'Mike Chen',
      'status': 'away',
      'lastSeen': DateTime.now().subtract(const Duration(hours: 1)),
      'avatar': 'assets/images/avatar2.png',
    },
    {
      'name': 'Emily Williams',
      'status': 'online',
      'lastSeen': DateTime.now().subtract(const Duration(minutes: 15)),
      'avatar': 'assets/images/avatar3.png',
    },
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Share Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_location, color: Colors.blue),
                ),
                title: const Text('Share Live Location'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sharing live location...'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency, color: Colors.red),
                ),
                title: const Text('Emergency Alert'),
                onTap: () {
                  Navigator.pop(context);
                  _showEmergencyConfirmation();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showEmergencyConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Emergency Alert?'),
          content: const Text(
            'This will send an alert with your current location to all your emergency contacts.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Emergency alert sent!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Send Alert'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List of screens/tabs for the bottom navigation
    final List<Widget> tabs = [
      HomeTab(userName: widget.userName, contacts: _contacts),
      const PeopleTab(),
      const EmergencyTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'People',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emergency),
              label: 'Emergency',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.indigo.shade900,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade900,
        onPressed: _showShareOptions,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
