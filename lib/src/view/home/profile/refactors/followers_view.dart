import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/profile/profile_view.dart';

class FollowersView extends StatefulWidget {
  FollowersView({required this.visitedProfileUserID, super.key});

  String visitedProfileUserID;

  @override
  State<FollowersView> createState() => _FollowersViewState();
}

class _FollowersViewState extends State<FollowersView> {
  List<String> followersKeysList = [];
  List followerUsersDataList = [];

  ProfileController profileController = Get.put(ProfileController());

  getFollowersListKeys() async {
    var followersDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.visitedProfileUserID)
        .collection('followers')
        .get();

    for (var i = 0; i < followersDocument.docs.length; i++) {
      followersKeysList.add(followersDocument.docs[i].id);
    }
    getFollowersKeysDataFromUsersCollection(followersKeysList);
  }

  getFollowersKeysDataFromUsersCollection(
      List<String> followersKeysList) async {
    var allUserDocument =
        await FirebaseFirestore.instance.collection('users').get();

    for (var i = 0; i < allUserDocument.docs.length; i++) {
      for (var j = 0; j < followersKeysList.length; j++) {
        if (((allUserDocument.docs[i].data() as dynamic)['uid']) ==
            followersKeysList[j]) {
          followerUsersDataList.add((allUserDocument.docs[i].data()));
        }
      }
    }
    setState(() {
      followerUsersDataList;
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowersListKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              profileController.userMap['userName'],
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Followers ${profileController.userMap['totalFollowers']}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: followerUsersDataList.isEmpty
          ? const Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.white,
                size: 60,
              ),
            )
          : ListView.builder(
              itemCount: followerUsersDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              followerUsersDataList[index]['image'].toString()),
                        ),
                        title: Text(
                          followerUsersDataList[index]['name'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          followerUsersDataList[index]['email'].toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Get.to(
                                ProfileView(
                                  visitUserID: followerUsersDataList[index]
                                      ['uid'],
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.navigate_next_outlined,
                              color: Colors.redAccent,
                            )),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
