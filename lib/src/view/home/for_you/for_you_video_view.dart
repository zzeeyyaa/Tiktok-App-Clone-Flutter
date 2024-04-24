import 'package:flutter/material.dart';

class ForYouVideoView extends StatefulWidget {
  const ForYouVideoView({super.key});

  @override
  State<ForYouVideoView> createState() => _ForYouVideoViewState();
}

class _ForYouVideoViewState extends State<ForYouVideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('for you with your screen'),
      ),
    );
  }
}
