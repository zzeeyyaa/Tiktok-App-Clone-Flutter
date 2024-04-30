import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/profile/profile_view.dart';

class FollowingView extends StatefulWidget {
  FollowingView({required this.visitedProfileUserID, super.key});

  String visitedProfileUserID;

  @override
  State<FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView> {
  List<String> followingKeysList = [];
  List followingUsersDataList = [];

  ProfileController profileController = Get.put(ProfileController());

  getFollowingListKeys() async {
    var followingDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.visitedProfileUserID)
        .collection('following')
        .get();

    for (var i = 0; i < followingDocument.docs.length; i++) {
      followingKeysList.add(followingDocument.docs[i].id);
    }

    getFollowingKeysDataFromUsersCollection(followingKeysList);
  }

  getFollowingKeysDataFromUsersCollection(
      List<String> listOfFollowingKeys) async {
    var allUsersDocument =
        await FirebaseFirestore.instance.collection('users').get();

    for (var i = 0; i < allUsersDocument.docs.length; i++) {
      for (var j = 0; j < listOfFollowingKeys.length; j++) {
        if (((allUsersDocument.docs[i].data() as dynamic)['uid']) ==
            listOfFollowingKeys[j]) {
          followingUsersDataList.add((allUsersDocument.docs[i].data()));
        }
      }
    }
    setState(() {
      followingUsersDataList;
    });
  }

  @override
  void initState() {
    super.initState();

    getFollowingListKeys();
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
              'Following ${profileController.userMap['totalFollowings']}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: followingUsersDataList.isEmpty
          ? const Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.white,
                size: 60,
              ),
            )
          : ListView.builder(
              itemCount: followingUsersDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Get.to(ProfileView(
                          visitUserID: followingUsersDataList[index]['uid'],
                        ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              followingUsersDataList[index]['image']),
                        ),
                        title: Text(
                          followingUsersDataList[index]['name'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          followingUsersDataList[index]['email'].toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.navigate_next_outlined,
                            size: 24,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
