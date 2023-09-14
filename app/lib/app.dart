import 'package:chirper/screens/home.dart';
import 'package:chirper/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

// Themes
import 'package:chirper/themes/dark.dart';
import 'package:chirper/themes/light.dart';

// Providers
import 'package:chirper/providers/auth.dart';

// Screens

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final storage = const FlutterSecureStorage();

  void attempt() async {
    String? token = await storage.read(key: 'token');
    // ignore: use_build_context_synchronously
    Provider.of<AuthProvider>(context, listen: false).attempt(token);
  }

  @override
  void initState() {
    super.initState();
    attempt();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Consumer<AuthProvider>(
        builder: (context, value, child) {
          if (value.isAuthenticated) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
