import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:chirper/providers/auth.dart';

// Models
import 'package:chirper/models/user.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    User user = auth.user!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              CircleAvatar(
                radius: 64,
                child: Text(
                  user.name.split(' ').map((n) => n[0]).toList().join(),
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                ),
              ),
              const SizedBox(height: 16),
              Text(user.email),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  auth.logout();
                  Navigator.of(context).pop();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
