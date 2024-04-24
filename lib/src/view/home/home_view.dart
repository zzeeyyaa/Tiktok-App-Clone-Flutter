import 'package:flutter/material.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/following/following_video_view.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/for_you/for_you_video_view.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/profile/profile_view.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/search/search_view.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/upload_video/upload_custom_icon.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/upload_video/upload_video_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int screenIndex = 0;
  List screenList = const [
    ForYouVideoView(),
    SearchView(),
    UploadVideoView(),
    FollowingVideoView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple.shade100,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: UploadCustomIcon(),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.inbox_sharp,
            ),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
