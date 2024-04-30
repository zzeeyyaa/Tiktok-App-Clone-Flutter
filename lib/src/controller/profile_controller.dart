import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/home_view.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userMap => _userMap.value;
  final Rx<String> _userID = ''.obs;

  updateCurrentUserID(String visitUserID) {
    _userID.value = visitUserID;

    retrieveUserInformation();
  }

  retrieveUserInformation() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .get();

    final userInfo = documentSnapshot.data() as dynamic;

    String userName = userInfo['name'];
    String userEmail = userInfo['email'];
    String userImage = userInfo['image'];
    String userUID = userInfo['uid'];
    String userYoutube = userInfo['youtube'] ?? '';
    String userInstagram = userInfo['instagram'] ?? '';
    String userTwitter = userInfo['twitter'] ?? '';
    String userFacebook = userInfo['facebook'] ?? '';
    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = false;
    List<String> thumbnailsList = [];

    //get user's videos info
    var currentUserVideos = await FirebaseFirestore.instance
        .collection("videos")
        .orderBy("publishedDateTime", descending: true)
        .where("userID", isEqualTo: _userID.value)
        .get();

    for (int i = 0; i < currentUserVideos.docs.length; i++) {
      thumbnailsList
          .add((currentUserVideos.docs[i].data() as dynamic)["thumbnailUrl"]);
    }

    //get total number of likes
    for (var eachVideo in currentUserVideos.docs) {
      totalLikes = totalLikes + (eachVideo.data()["likesList"] as List).length;
    }

    var followersNumberDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('followers')
        .get();
    totalFollowers = followersNumberDoc.docs.length;

    var followingNumberDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('following')
        .get();
    totalFollowings = followingNumberDoc.docs.length;

    FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('followers')
        .doc(currentUserID)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _userMap.value = {
      "userName": userName,
      "userEmail": userEmail,
      "userImage": userImage,
      "userUID": userUID,
      "userYoutube": userYoutube,
      "userInstagram": userInstagram,
      "userTwitter": userTwitter,
      "userFacebook": userFacebook,
      "totalLikes": totalLikes.toString(),
      "totalFollowers": totalFollowers.toString(),
      "totalFollowings": totalFollowings.toString(),
      "isFollowing": isFollowing,
      "thumbnailsList": thumbnailsList,
    };

    update();
  }

  followUnfollowUser() async {
    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .collection('followers')
        .doc(currentUserID)
        .get();

    if (document.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userID.value)
          .collection('followers')
          .doc(currentUserID)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .collection('following')
          .doc(_userID.value)
          .delete();
      _userMap.value.update(
          'totalFollowes', (value) => (int.parse(value) - 1).toString());
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userID.value)
          .collection('followers')
          .doc(currentUserID)
          .set({});

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection('following')
          .doc(_userID.value)
          .set({});

      _userMap.value.update(
          "totalFollowers", (value) => (int.parse(value) + 1).toString());
    }
    _userMap.value.update('isFollowing', (value) => !value);
    update();
  }

  updateUserSocialAccountLinks(
      String facebook, String youtube, String twitter, String instagram) async {
    try {
      final Map<String, dynamic> userSocialLinksMap = {
        "facebook": facebook,
        "youtube": youtube,
        "twitter": twitter,
        "instagram": instagram,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .update(userSocialLinksMap);

      Get.snackbar(
          "Social Links", "your social links are updated successfully.");

      Get.to(const HomeView());
    } catch (errorMsg) {
      Get.snackbar("Error Updating Account", "Please try again.");
    }
  }
}
