import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/circular_image_animation.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/custom_video_player.dart';
import 'package:tiktok_app_clone_flutter/src/controller/following_video_controller.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/comments/comments_bottom_sheet.dart';

class FollowingVideoView extends StatefulWidget {
  const FollowingVideoView({super.key});

  @override
  State<FollowingVideoView> createState() => _FollowingVideoViewState();
}

class _FollowingVideoViewState extends State<FollowingVideoView> {
  final FollowingVideoController followingVideoController =
      Get.put(FollowingVideoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: followingVideoController.followingAllVideoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final eachVideoInfo =
                followingVideoController.followingAllVideoList[index];

            Uri uri = Uri.parse(eachVideoInfo.videoUrl!);
            return Stack(
              children: [
                CustomVideoPlayer(videoFileUrl: uri),
                Column(
                  children: [
                    const SizedBox(height: 110),
                    //*left right - panels
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //*left panel
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 18),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "@${eachVideoInfo.userName}",
                                    style: GoogleFonts.saira(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  //*description - tags
                                  Text(
                                    eachVideoInfo.descriptionTags.toString(),
                                    style: GoogleFonts.saira(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  //*artist - song name
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/music_note.png',
                                        width: 20,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '  ${eachVideoInfo.artistSongName}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //*right panel
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: context.height * .35),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //*profile
                                SizedBox(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          width: 52,
                                          height: 52,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image(
                                              image: NetworkImage(
                                                eachVideoInfo.userProfileImage
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //*like button
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        followingVideoController
                                            .likeOrUnlikeVideo(eachVideoInfo
                                                .videoID
                                                .toString());
                                      },
                                      icon: Icon(
                                        Icons.favorite_rounded,
                                        size: 32,
                                        color: eachVideoInfo.likesList!
                                                .contains(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? const Color.fromARGB(
                                                255, 200, 70, 61)
                                            : Colors.white,
                                      ),
                                    ),

                                    //*total likes
                                    Text(
                                      eachVideoInfo.likesList!.length
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                //*comment button - total comment
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Get.to(
                                        //   CommentsView(
                                        //     videoID: eachVideoInfo.videoID
                                        //         .toString(),
                                        //   ),
                                        // );
                                        showCommentBottomSheet(context);
                                      },
                                      icon: const Icon(
                                        Icons.add_comment,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),

                                    //total comment
                                    Text(
                                      eachVideoInfo.totalComments.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                //*share button - total shares
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      eachVideoInfo.totalShares.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                //*profile circular animation
                                CircularImageAnimation(
                                  wigetAnimation: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          height: 52,
                                          width: 52,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.deepPurple,
                                                Colors.white,
                                                Colors.yellow.shade200,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image(
                                              image: NetworkImage(
                                                eachVideoInfo.userProfileImage
                                                    .toString(),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      }),
    );
  }
}
