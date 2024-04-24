import 'package:flutter/material.dart';

class FollowingVideoView extends StatefulWidget {
  const FollowingVideoView({super.key});

  @override
  State<FollowingVideoView> createState() => _FollowingVideoViewState();
}

class _FollowingVideoViewState extends State<FollowingVideoView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('following screen view')),
    );
  }
}
