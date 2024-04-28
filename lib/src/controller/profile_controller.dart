import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userMap => _userMap.value;
  Rx<String> _userID = ''.obs;

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
    String userYoutube = userInfo['youtube'] == null ? '' : userInfo['youtube'];
    String userInstagram =
        userInfo['instagram'] == null ? '' : userInfo['instagram'];
    String userTwitter = userInfo['twitter'] == null ? '' : userInfo['twitter'];
    String userFacebook =
        userInfo['facebook'] == null ? '' : userInfo['facebook'];
    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = true;
    List<String> thumbnailsList = [];

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
}
