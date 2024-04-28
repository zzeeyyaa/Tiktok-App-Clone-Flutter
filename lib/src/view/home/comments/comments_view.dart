// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/input_text_field.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';
import 'package:tiktok_app_clone_flutter/src/controller/profile_controller.dart';
import 'package:timeago/timeago.dart' as tago;

import 'package:tiktok_app_clone_flutter/src/controller/comments_controller.dart';

class CommentsView extends StatefulWidget {
  CommentsView({
    super.key,
    required this.videoID,
  });

  final String videoID;

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  TextEditingController commentTextController = TextEditingController();

  CommentsController commentsController = Get.put(CommentsController());

  AuthController authController = Get.find<AuthController>();

  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController
        .updateCurrentUserID(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    commentsController.updateCurrentVideoID(widget.videoID);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: context.width,
          height: context.height,
          child: Column(
            children: [
              //*display comment
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: commentsController.listOfComments.length,
                    itemBuilder: (context, index) {
                      final eachCommentInfo =
                          commentsController.listOfComments[index];

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
                width: context.width,
                height: context.height * .1,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          profileController.userMap["userImage"],
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
        ),
      ),
    );
  }
}
