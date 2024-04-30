import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/model/video.dart';

class FollowingVideoController extends GetxController {
  final Rx<List<Video>> followingVideosList = Rx<List<Video>>([]);
  List<Video> get followingAllVideoList => followingVideosList.value;

  @override
  void onInit() {
    super.onInit();

    followingVideosList.bindStream(FirebaseFirestore.instance
        .collection('videos')
        .orderBy("totalComments", descending: true)
        .snapshots()
        .map((QuerySnapshot snapshotQuery) {
      List<Video> videoList = [];

      for (var eachVideo in snapshotQuery.docs) {
        videoList.add(Video.fromDocumentSnapshot(eachVideo));
      }

      return videoList;
    }));
  }

  likeOrUnlikeVideo(String videoID) async {
    var currentUserID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .get();

    //already like
    if ((documentSnapshot.data() as dynamic)['likesList']
        .contains(currentUserID)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .update({
        "likesList": FieldValue.arrayRemove([currentUserID]),
      });
    }
    //not like
    else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .update({
        "likesList": FieldValue.arrayUnion([currentUserID]),
      });
    }
  }
}
