import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  ProfileView({this.visitUserID, super.key});

  String? visitUserID;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();

    profileController.updateCurrentUserID(widget.visitUserID.toString());
  }

  Future<void> launchUserSocialProfile(String socialLink) async {
    if (!await launchUrl(Uri.parse('https://$socialLink'))) {
      throw Exception('Could not launch$socialLink');
    }
  }

  handleClickEvent(String choiceClicked) {
    switch (choiceClicked) {
      case 'Settings':
        print('settings');
        break;
      case "Logout":
        FirebaseAuth.instance.signOut();
        Get.snackbar("Logged Out", "you are logged out from the app.");
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.userMap.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Text(
              controller.userMap["userName"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              widget.visitUserID.toString() == currentUserID
                  ? PopupMenuButton<String>(
                      onSelected: handleClickEvent,
                      itemBuilder: (BuildContext context) {
                        return {"Settings", "Logout"}
                            .map((String choiceClicked) {
                          return PopupMenuItem(
                            value: choiceClicked,
                            child: Text(choiceClicked),
                          );
                        }).toList();
                      },
                    )
                  : Container(),
            ],
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    profileController.userMap["userImage"],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Text(
                              profileController.userMap['totalFollowings'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Following',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 90,
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Text(
                              profileController.userMap['totalFollowers'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Followers',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 90,
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Text(
                              profileController.userMap['totalLikes'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Likes',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (profileController.userMap["userFacebook"] == "") {
                          Get.snackbar("Facebook Profile",
                              "This user has not connected his/her profile to facebook yet.");
                        } else {
                          launchUserSocialProfile(
                              profileController.userMap["userFacebook"]);
                        }
                      },
                      child: Image.asset(
                        "assets/icons/facebook.png",
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        if (profileController.userMap["userInstagram"] == "") {
                          Get.snackbar("Instagram Profile",
                              "This user has not connected his/her profile to instagram yet.");
                        } else {
                          launchUserSocialProfile(
                              profileController.userMap["userInstagram"]);
                        }
                      },
                      child: Image.asset(
                        "assets/icons/instagram.png",
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        if (profileController.userMap["userTwitter"] == "") {
                          Get.snackbar("Twitter Profile",
                              "This user has not connected his/her profile to twitter yet.");
                        } else {
                          launchUserSocialProfile(
                              profileController.userMap["userTwitter"]);
                        }
                      },
                      child: Image.asset(
                        "assets/icons/twitter.png",
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        if (profileController.userMap["userYoutube"] == "") {
                          Get.snackbar("Twitter Youtube",
                              "This user has not connected his/her profile to youtube yet.");
                        } else {
                          launchUserSocialProfile(
                              profileController.userMap["userYoutube"]);
                        }
                      },
                      child: Image.asset(
                        "assets/icons/youtube.png",
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
