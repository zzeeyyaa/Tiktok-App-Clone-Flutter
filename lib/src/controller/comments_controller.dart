import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';
import 'package:tiktok_app_clone_flutter/src/model/comment.dart';

class CommentsController extends GetxController {
  String currentVideoID = '';
  final Rx<List<Comment>> commentsList = Rx<List<Comment>>([]);
  List<Comment> get listOfComments => commentsList.value;

  updateCurrentVideoID(String videoID) {
    currentVideoID = videoID;

    retrieveComments();
  }

  saveNewCommentToDatabase(String commentTextData) async {
    try {
      String commentID = DateTime.now().millisecondsSinceEpoch.toString();

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      Comment commentModel = Comment(
        userName: (documentSnapshot.data() as dynamic)['name'],
        userID: FirebaseAuth.instance.currentUser!.uid,
        userProfileImage: (documentSnapshot.data() as dynamic)['image'],
        commentText: commentTextData,
        commentID: commentID,
        commentLikesList: [],
        publishedDateTime: DateTime.now(),
      );

      //save new comment info to database
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .doc(commentID)
          .set(commentModel.toJson());

      //update comments counter
      DocumentSnapshot currentVideoSnapshotDocument = await FirebaseFirestore
          .instance
          .collection('videos')
          .doc(currentVideoID)
          .get();

      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .update({
        'totalComments':
            (currentVideoSnapshotDocument.data() as dynamic)['totalComments'] +
                1,
      });
    } catch (e) {
      Get.snackbar('Error Posting New Comment', 'Error Message: $e');
    }
  }

  likeUnlikeComment(String commentID) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .doc(currentVideoID)
        .collection('comments')
        .doc(commentID)
        .get();

    //unlike comment feature - red heart button
    if ((documentSnapshot.data() as dynamic)['commentLikesList']
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .doc(commentID)
          .update({
        'commentLikesList':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
    }

    //like comment feature - with heart button
    else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .doc(commentID)
          .update({
        'commentLikesList':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
    }
  }

  retrieveComments() async {
    commentsList.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .orderBy('publishedDateTime', descending: true)
          .snapshots()
          .map((QuerySnapshot commentsSnapshot) {
        List<Comment> commentListOfVideo = [];
        for (var eachComment in commentsSnapshot.docs) {
          commentListOfVideo.add(Comment.fromDocumentSnapshot(eachComment));
        }
        return commentListOfVideo;
      }),
    );
  }
}
