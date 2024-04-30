import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/input_text_field.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';

class AccountSettingView extends StatefulWidget {
  const AccountSettingView({super.key});

  @override
  State<AccountSettingView> createState() => _AccountSettingViewState();
}

class _AccountSettingViewState extends State<AccountSettingView> {
  String facebook = '';
  String youtube = '';
  String instagram = '';
  String twitter = '';
  String userImageUrl = '';

  TextEditingController fbController = TextEditingController();
  TextEditingController ytController = TextEditingController();
  TextEditingController igController = TextEditingController();
  TextEditingController twtController = TextEditingController();

  ProfileController profileController = Get.put(ProfileController());

  getCurrentUserData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserID)
        .get();

    facebook = documentSnapshot['facebook'];
    youtube = documentSnapshot['youtube'];
    instagram = documentSnapshot['instagram'];
    twitter = documentSnapshot['twitter'];
    userImageUrl = documentSnapshot['image'];

    setState(() {
      fbController.text = facebook ?? '';
      igController.text = instagram ?? '';
      ytController.text = youtube ?? '';
      twtController.text = twitter ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: true,
            title: const Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(profileController.userMap['userImage']),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Update your profile social links',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),
                  //facebook
                  Container(
                    width: context.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextField(
                      controller: fbController,
                      lableText: "facebook.com/username",
                      assetRefrence: "assets/icons/facebook.png",
                      isObscure: false,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 15),
                  //youtube,
                  Container(
                    width: context.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextField(
                      controller: ytController,
                      lableText: "youtube.com/username",
                      assetRefrence: "assets/icons/youtube.png",
                      isObscure: false,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 15),
                  //instagram,
                  Container(
                    width: context.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextField(
                      controller: igController,
                      lableText: "instagram.com/username",
                      assetRefrence: "assets/icons/instagram.png",
                      isObscure: false,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 15),
                  //twittter,
                  Container(
                    width: context.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextField(
                      controller: twtController,
                      lableText: "twitter.com/username",
                      assetRefrence: "assets/icons/twitter.png",
                      isObscure: false,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 15),
                  //update
                  ElevatedButton(
                    onPressed: () {
                      profileController.updateUserSocialAccountLinks(
                          fbController.text,
                          ytController.text,
                          twtController.text,
                          igController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Update Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
