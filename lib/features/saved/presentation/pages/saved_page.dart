import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tersimpan')),
      body: const Center(
        child: Text('Belum ada properti yang disimpan.', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
