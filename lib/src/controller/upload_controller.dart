import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/core/utils/typedefs.dart';
import 'package:tiktok_app_clone_flutter/src/model/video.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/home_view.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController {
  compressedVideoFile(String videoFilePath) async {
    final compressedVideoPath = await VideoCompress.compressVideo(videoFilePath,
        quality: VideoQuality.LowQuality);
    return compressedVideoPath!.file;
  }

  uploadCompressedVideoFileToFirebaseStorage(
      String videoID, String videoFilePath) async {
    UploadTask videoUploadTask = FirebaseStorage.instance
        .ref()
        .child('All Video')
        .child(videoID)
        .putFile(await compressedVideoFile(videoFilePath));

    TaskSnapshot snapshot = await videoUploadTask;

    String downloadUrlOfUploadVideo = await snapshot.ref.getDownloadURL();

    return downloadUrlOfUploadVideo;
  }

  getThumbnailImage(String videoFilePath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);

    return thumbnailImage;
  }

  uploadThumbnailImageToFirebaseStorage(
      String videoID, String videoFilePath) async {
    UploadTask thumbnailUploadTask = FirebaseStorage.instance
        .ref()
        .child('All Thumbnails')
        .child(videoID)
        .putFile(await getThumbnailImage(videoFilePath));

    TaskSnapshot snapshot = await thumbnailUploadTask;

    String downloadUrlOfUploadedThumbnail = await snapshot.ref.getDownloadURL();

    return downloadUrlOfUploadedThumbnail;
  }

  saveVideoInformationToFirestoreDatabase(
      String artissongName,
      String descriptionTags,
      String videoFilePath,
      BuildContext context) async {
    try {
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      String videoID = DateTime.now().microsecondsSinceEpoch.toString();

      //1. upload video to storage
      String videoDownloadUrl =
          await uploadCompressedVideoFileToFirebaseStorage(
              videoID, videoFilePath);

      //2. upload thumbnail to storage
      String thumbnailDownloadUrl =
          await uploadThumbnailImageToFirebaseStorage(videoID, videoFilePath);

      //3. save overall video info to firestore database
      Video videoObject = Video(
        userID: FirebaseAuth.instance.currentUser!.uid,
        userName: (userDocumentSnapshot.data() as Map<String, dynamic>)["name"],
        userProfileImage:
            (userDocumentSnapshot.data() as Map<String, dynamic>)["image"],
        videoID: videoID,
        totalComments: 0,
        totalShares: 0,
        likesList: [],
        artistSongName: artissongName,
        descriptionTags: descriptionTags,
        videoUrl: videoDownloadUrl,
        thumbnailUrl: thumbnailDownloadUrl,
        publishedDateTime: DateTime.now().millisecondsSinceEpoch,
      );

      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoID)
          .set(videoObject.toJson());

      showProgressBar = false;
      Get.to(const HomeView());
      Get.snackbar(
          'New Video', 'You have successfully uploaded your new video');
    } catch (e) {
      Get.snackbar("Video Upload Unsuccessfull",
          "Error occurred, your video is not uploaded. Try Again.");
      showProgressBar = false;
    }
  }
}
