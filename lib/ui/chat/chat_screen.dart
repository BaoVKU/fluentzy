import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Chat'),
      ),
      body: Center(
        child: Text(
          'This feature is not available yet',
        ),
      ),
    );
  }
}