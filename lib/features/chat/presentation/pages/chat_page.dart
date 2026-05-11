import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navChat)
      ),
      body: Center(
        child: Text(
          AppStrings.comingSoon('Chat'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
