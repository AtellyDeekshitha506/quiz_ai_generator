import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_ai/models/user_model.dart';
import 'package:quiz_ai/providers/app_provider.dart';
import 'package:quiz_ai/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              appProvider.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              appProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                user?.name[0] ?? 'U',
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'User',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'user@example.com',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                user?.role == UserRole.teacher ? 'Teacher' : 'Student',
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.key),
                    title: const Text('Connect AI API Key'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showAPIKeyDialog(context);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            appProvider.logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showAPIKeyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect AI API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your API key to use custom AI models for quiz generation.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
                hintText: 'sk-...',
              ),
              obscureText: true,
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('API Key saved successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
