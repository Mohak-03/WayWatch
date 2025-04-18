import 'package:flutter/material.dart';

class PeopleTab extends StatefulWidget {
  const PeopleTab({super.key});

  @override
  State<PeopleTab> createState() => _PeopleTabState();
}

class _PeopleTabState extends State<PeopleTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data for contacts and requests
  final List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Sarah Johnson',
      'phone': '+1 212-555-6789',
      'avatar': 'assets/images/avatar1.png',
      'isFavorite': true,
    },
    {
      'name': 'Mike Chen',
      'phone': '+1 310-555-8521',
      'avatar': 'assets/images/avatar2.png',
      'isFavorite': false,
    },
    {
      'name': 'Emily Williams',
      'phone': '+1 415-555-3690',
      'avatar': 'assets/images/avatar3.png',
      'isFavorite': true,
    },
    {
      'name': 'Jason Rodriguez',
      'phone': '+1 305-555-4729',
      'avatar': 'assets/images/avatar4.png',
      'isFavorite': false,
    },
  ];
  
  final List<Map<String, dynamic>> _requests = [
    {
      'name': 'Alex Thompson',
      'phone': '+1 415-555-9876',
      'avatar': 'assets/images/avatar5.png',
      'requestTime': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'name': 'Lisa Kim',
      'phone': '+1 650-555-4321',
      'avatar': 'assets/images/avatar6.png',
      'requestTime': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'People',
          style: TextStyle(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.indigo.shade900,
          labelColor: Colors.indigo.shade900,
          unselectedLabelColor: Colors.grey.shade600,
          tabs: const [
            Tab(text: 'Contacts'),
            Tab(text: 'Requests'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.indigo.shade900),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.indigo.shade900),
            onPressed: () {
              // Add new contact
              _showAddContactDialog();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Contacts Tab
          _buildContactsList(_contacts),
          
          // Requests Tab
          _buildRequestsList(_requests),
        ],
      ),
    );
  }

  Widget _buildContactsList(List<Map<String, dynamic>> contacts) {
    return contacts.isEmpty 
        ? _buildEmptyState('No contacts yet', 'Add contacts to share your location with them')
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: contact['avatar'] != null 
                      ? AssetImage(contact['avatar']) 
                      : null,
                  child: contact['avatar'] == null
                      ? Text(
                          contact['name'][0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  contact['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(contact['phone']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        contact['isFavorite'] ? Icons.star : Icons.star_border,
                        color: contact['isFavorite'] ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          contact['isFavorite'] = !contact['isFavorite'];
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_location, color: Colors.indigo),
                      onPressed: () {
                        // Share location with this contact
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing location with ${contact['name']}'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildRequestsList(List<Map<String, dynamic>> requests) {
    return requests.isEmpty 
        ? _buildEmptyState('No pending requests', 'When people request to connect, they will appear here')
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: request['avatar'] != null 
                      ? AssetImage(request['avatar']) 
                      : null,
                  child: request['avatar'] == null
                      ? Text(
                          request['name'][0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  request['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(request['phone']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Decline request
                        setState(() {
                          _requests.removeAt(index);
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Request from ${request['name']} declined'),
                          ),
                        );
                      },
                      child: Text(
                        'Decline',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Accept request
                        final newContact = {
                          'name': request['name'],
                          'phone': request['phone'],
                          'avatar': request['avatar'],
                          'isFavorite': false,
                        };
                        
                        setState(() {
                          _contacts.add(newContact);
                          _requests.removeAt(index);
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${request['name']} added to contacts'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900,
                      ),
                      child: const Text('Accept'),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Contact',
          style: TextStyle(color: Colors.indigo.shade900),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter contact name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add new contact logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact invitation sent'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade900,
            ),
            child: const Text('Send Invite'),
          ),
        ],
      ),
    );
  }
}
