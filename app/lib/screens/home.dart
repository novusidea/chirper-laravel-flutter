import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// Helpers
import 'package:chirper/helpers/dio.dart';

// Models
import 'package:chirper/models/chirp.dart';

// Widgets
import 'package:chirper/widgets/chirps/list.dart';

// Screens
import 'package:chirper/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Chirp>> fetchChirps() async {
    Response response = await dio().get('/chirps');

    Map<String, dynamic> parsed = json.decode(response.toString());
    List<dynamic> data = parsed['data'];

    return data.map((json) => Chirp.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchChirps(),
          builder: (context, snapshot) {
            final Widget content;

            if (snapshot.hasData) {
              content = ChirpList(chirps: snapshot.data!);
            } else if (snapshot.hasError) {
              content = SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              content = const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Fetching chirps...'),
                  ),
                ],
              );
            }

            return content;
          },
        ),
      ),
    );
  }
}
