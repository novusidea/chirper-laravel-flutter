import 'package:flutter/material.dart';

// Models
import 'package:chirper/models/chirp.dart';

class ChirpList extends StatelessWidget {
  const ChirpList({
    super.key,
    required this.chirps,
  });

  final List<Chirp> chirps;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chirps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(chirps[index].message),
          contentPadding: const EdgeInsets.all(20),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
    );
  }
}
