import 'package:chatnest/domain/domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Quick test widget to verify FCM token and notification setup
/// Add this to your app temporarily for testing
class NotificationDebugScreen extends StatefulWidget {
  const NotificationDebugScreen({Key? key}) : super(key: key);

  @override
  State<NotificationDebugScreen> createState() =>
      _NotificationDebugScreenState();
}

class _NotificationDebugScreenState extends State<NotificationDebugScreen> {
  String? fcmToken;
  List<String> receivedMessages = [];

  @override
  void initState() {
    super.initState();
    _setupNotificationListener();
    _getFCMToken();
  }

  Future<void> _getFCMToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() {
      fcmToken = token;
    });
    print('🔥 FCM Token: $token');
  }

  void _setupNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        receivedMessages.add(
            '${DateTime.now().toString().substring(11, 19)} - ${message.data['type'] ?? 'unknown'}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Debug'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FCM Token Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔥 FCM Token',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      fcmToken ?? 'Loading...',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (fcmToken != null) {
                          // Copy to clipboard would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Token logged to console'),
                            ),
                          );
                          print('📋 Copy this token: $fcmToken');
                        }
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Log Token'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Received Messages Section
            const Text(
              '📩 Received Messages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Card(
                child: receivedMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'No messages received yet.\nSend a test notification!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: receivedMessages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.notifications,
                                color: Colors.green),
                            title: Text(receivedMessages[
                                receivedMessages.length - 1 - index]),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📝 Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('1. Copy the FCM token above'),
                  Text('2. Send a test notification from Firebase Console'),
                  Text('3. Or have someone send you a message/call'),
                  Text('4. Watch this screen for incoming messages'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
