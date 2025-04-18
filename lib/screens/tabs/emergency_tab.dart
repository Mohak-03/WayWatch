import 'package:flutter/material.dart';
import '../../services/emergency_service.dart';

class EmergencyTab extends StatefulWidget {
  const EmergencyTab({super.key});

  @override
  State<EmergencyTab> createState() => _EmergencyTabState();
}

class _EmergencyTabState extends State<EmergencyTab> {
  bool _isEmergencyModeActive = false;
  bool _isSendingAlert = false;
  final EmergencyService _emergencyService = EmergencyService();
  
  // Emergency contacts
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      'name': 'Sarah Johnson',
      'phone': '+1 212-555-6789',
      'relation': 'Sister',
      'avatar': 'assets/images/avatar1.png',
    },
    {
      'name': 'Mike Chen',
      'phone': '+1 310-555-8521',
      'relation': 'Friend',
      'avatar': 'assets/images/avatar2.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Emergency',
          style: TextStyle(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.indigo.shade900),
            onPressed: () {
              // Add emergency contact
              _showAddEmergencyContactDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Mode Card
            _buildEmergencyModeCard(),
            
            const SizedBox(height: 24),
            
            // Emergency Alert Button
            _buildEmergencyAlertButton(),
            
            const SizedBox(height: 24),
            
            // Emergency Contacts Section
            Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 12),
            
            // Emergency contacts list
            _emergencyContacts.isEmpty
                ? _buildEmptyContactsState()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _emergencyContacts.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final contact = _emergencyContacts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.shade100,
                          backgroundImage: contact['avatar'] != null 
                              ? AssetImage(contact['avatar']) 
                              : null,
                          child: contact['avatar'] == null
                              ? Text(
                                  contact['name'][0].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                )
                              : null,
                        ),
                        title: Text(
                          contact['name'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(contact['phone']),
                            Text(
                              contact['relation'],
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () {
                            // Edit contact
                          },
                        ),
                      );
                    },
                  ),
            
            const SizedBox(height: 24),
            
            // Emergency Services Section
            Text(
              'Emergency Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 12),
            
            // Emergency services list
            _buildEmergencyServicesTile(
              'Police',
              '911',
              Icons.local_police,
              Colors.blue,
            ),
            const Divider(),
            _buildEmergencyServicesTile(
              'Ambulance',
              '911',
              Icons.medical_services,
              Colors.red,
            ),
            const Divider(),
            _buildEmergencyServicesTile(
              'Fire Department',
              '911',
              Icons.fire_truck,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmergencyModeCard() {
    return Card(
      elevation: 0,
      color: _isEmergencyModeActive ? Colors.red.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: _isEmergencyModeActive 
              ? Colors.red.shade300 
              : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.emergency,
                  color: Colors.red.shade700,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Mode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEmergencyModeActive
                            ? 'Active - Continuously sharing your location with emergency contacts'
                            : 'Tap the button below to activate emergency mode',
                        style: TextStyle(
                          fontSize: 14,
                          color: _isEmergencyModeActive 
                              ? Colors.red.shade700 
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEmergencyModeActive = !_isEmergencyModeActive;
                  });
                  
                  if (_isEmergencyModeActive) {
                    _showEmergencyActivatedDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Emergency mode deactivated'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: Icon(
                  _isEmergencyModeActive ? Icons.cancel : Icons.warning_amber,
                  color: Colors.white,
                ),
                label: Text(
                  _isEmergencyModeActive 
                      ? 'Deactivate Emergency Mode' 
                      : 'Activate Emergency Mode',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEmergencyModeActive 
                      ? Colors.grey.shade700 
                      : Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmergencyServicesTile(
    String name,
    String number,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(number),
      trailing: IconButton(
        icon: Icon(Icons.call, color: color),
        onPressed: () {
          // Call emergency service
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Calling $name...'),
              backgroundColor: color,
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyContactsState() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.contacts,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No emergency contacts added yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add emergency contacts who will be notified automatically during an emergency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _showAddEmergencyContactDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Emergency Contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddEmergencyContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Emergency Contact',
          style: TextStyle(color: Colors.indigo.shade900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter contact name',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Relationship',
                hintText: 'Select relationship',
              ),
              items: ['Family', 'Friend', 'Partner', 'Colleague', 'Other']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {},
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
              // Add new emergency contact logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency contact added'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade900,
            ),
            child: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }
  
  void _showEmergencyActivatedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.red.shade700),
            const SizedBox(width: 8),
            const Text('Emergency Mode Activated'),
          ],
        ),
        content: const Text(
          'Your location is now being shared continuously with your emergency contacts. They have been notified of your situation.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmergencyAlertButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSendingAlert ? null : _showEmergencyAlertConfirmation,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.warning_amber,
                        color: Colors.red.shade700,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Alert',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Send an immediate alert with your location to all contacts in your circle',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSendingAlert ? null : _showEmergencyAlertConfirmation,
                    icon: _isSendingAlert
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.emergency),
                    label: Text(
                      _isSendingAlert ? 'Sending Alert...' : 'Send Emergency Alert',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.red.shade300,
                      disabledForegroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showEmergencyAlertConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.red.shade700),
            const SizedBox(width: 8),
            const Text('Send Emergency Alert?'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will immediately:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Send an alert to all contacts in your circle'),
            Text('• Share your current location'),
            Text('• Notify emergency contacts via SMS and app notifications'),
            SizedBox(height: 16),
            Text(
              'Only use this for genuine emergencies.',
              style: TextStyle(fontStyle: FontStyle.italic),
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
              Navigator.pop(context);
              _sendEmergencyAlert();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _sendEmergencyAlert() async {
    if (_isSendingAlert) return;
    
    setState(() {
      _isSendingAlert = true;
    });
    
    try {
      // Call emergency service to send alert
      final result = await _emergencyService.sendEmergencyAlert(context);
      
      setState(() {
        _isSendingAlert = false;
      });
      
      if (!mounted) return;
      
      if (result['success']) {
        // Show success notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Emergency alert sent to ${result['contactsNotified']} contacts'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
        
        // Show alert details
        _showAlertSentDialog(result);
      } else {
        // Show error notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send alert: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSendingAlert = false;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _showAlertSentDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.red.shade700),
            const SizedBox(width: 8),
            const Text('Alert Sent'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Emergency alert sent to ${result['contactsNotified']} contacts',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Alert details:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '• Alert sent at: ${result['alertSentAt']}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '• Contacts notified: ${result['contactsNotified']}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
