import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/model/video.dart';

class ForYouVideoController extends GetxController {
  final Rx<List<Video>> forYouVideosList = Rx<List<Video>>([]);
  List<Video> get forYouAllVideoList => forYouVideosList.value;

  @override
  void onInit() {
    super.onInit();

    forYouVideosList.bindStream(FirebaseFirestore.instance
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
}
