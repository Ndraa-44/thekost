import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya')),
      body: const Center(
        child: Text('Belum ada pesanan aktif.', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
