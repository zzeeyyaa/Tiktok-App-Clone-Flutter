import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/comments_controller.dart';
import 'package:timeago/timeago.dart' as tago;

void showCommentBottomSheet(BuildContext context) {
  TextEditingController commentTextController = TextEditingController();
  CommentsController commentsController = Get.put(CommentsController());

  showModalBottomSheet(
    enableDrag: true,
    context: context,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 1,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //*display total comment - exit
                SizedBox(
                  height: 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${commentsController.listOfComments.length} comments',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                //*display comment
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: commentsController.listOfComments.length,
                      itemBuilder: (context, index) {
                        final eachCommentInfo =
                            commentsController.listOfComments[index];
                        print('object');
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage: NetworkImage(eachCommentInfo
                                      .userProfileImage
                                      .toString()),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      eachCommentInfo.userName.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      eachCommentInfo.commentText.toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      tago.format(eachCommentInfo
                                          .publishedDateTime
                                          .toDate()),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${eachCommentInfo.commentLikesList!.length} likes",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    commentsController.likeUnlikeComment(
                                        eachCommentInfo.commentID.toString());
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: eachCommentInfo.commentLikesList!
                                            .contains(FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                //*add new comment
                Container(
                  color: Colors.white24,
                  height: 80,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color: AppColors.primaryColor,
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: commentTextController,
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 13.5),
                            labelText: 'Add a Comment Here',

                            // enabledBorder:
                            //     OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (commentTextController.text.isNotEmpty) {
                            commentsController.saveNewCommentToDatabase(
                                commentTextController.text);
                            print('object');
                            commentTextController.clear();
                          }
                        },
                        child: const SizedBox(
                          height: 50,
                          width: 50,
                          child: Icon(
                            Icons.send,
                            size: 32,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
