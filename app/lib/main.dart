import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chirper/providers/auth.dart';

import 'package:chirper/app.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: const App(),
  ));
}
