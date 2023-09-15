import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Themes
import 'package:chirper/themes/dark.dart';
import 'package:chirper/themes/light.dart';

// Providers
import 'package:chirper/providers/auth.dart';

// Screens
import 'package:chirper/screens/home.dart';
import 'package:chirper/screens/auth/login.dart';

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
      title: 'Chirper',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
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
