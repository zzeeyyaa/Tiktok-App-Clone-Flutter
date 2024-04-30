import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/model/video.dart';

class VideoProfileController extends GetxController {
  final Rx<List<Video>> videoFileList = Rx<List<Video>>([]);
  List<Video> get clickedVideoFile => videoFileList.value;

  final Rx<String> _videoID = ''.obs;
  String get clickedVideoID => _videoID.value;

  setVideoID(String vID) {
    _videoID.value = vID;
  }

  getClickedVideoInfo() {
    videoFileList.bindStream(FirebaseFirestore.instance
        .collection('videos')
        .snapshots()
        .map((QuerySnapshot snapshotQuery) {
      List<Video> videosList = [];

      for (var eachVideo in snapshotQuery.docs) {
        if (eachVideo["videoID"] == clickedVideoID) {
          videosList.add(Video.fromDocumentSnapshot(eachVideo));
        }
      }

      return videosList;
    }));
  }

  @override
  void onInit() {
    super.onInit();

    getClickedVideoInfo();
  }

  likeOrUnlikeVideo(String videoID) async {
    var currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .get();

    if ((documentSnapshot.data() as dynamic)['likesList']
        .contains(currentUserID)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .update({
        'likesList': FieldValue.arrayRemove([currentUserID]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .update({
        'likesList': FieldValue.arrayUnion([currentUserID]),
      });
    }
  }
}
