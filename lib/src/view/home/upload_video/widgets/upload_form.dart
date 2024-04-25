import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_app_clone_flutter/core/extensions/context_extension.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/input_text_field.dart';
import 'package:tiktok_app_clone_flutter/src/controller/upload_controller.dart';
import 'package:video_player/video_player.dart';

class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  UploadForm({
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  VideoPlayerController? playerController;
  UploadController uploadController = Get.put(UploadController());
  TextEditingController artistsongController = TextEditingController();
  TextEditingController descriptionTagsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });

    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
    print(widget.videoFile);

    // playerController = VideoPlayerController.file(widget.videoFile)
    //   ..initialize().then(
    //     (value) {
    //       setState(() {
    //         playerController!.play();
    //         // Atur volume dan looping
    //         playerController!.setVolume(2);
    //         playerController!.setLooping(true);
    //       });
    //     },
    //   );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //display video player
            SizedBox(
              width: context.width,
              height: context.height / 1.3,
              child: VideoPlayer(playerController!),
            ),

            const SizedBox(
              height: 30,
            ),

            //Upload Now btn if user clicked
            //circular progress bar
            //input fields
            showProgressBar == true
                ? SizedBox(
                    //show animation
                    height: 50,
                    width: 50,
                    child: SimpleCircularProgressBar(
                      progressColors: [
                        Colors.deepPurple,
                        Colors.purple.shade100,
                        Colors.purple.shade300,
                        Colors.deepPurple.shade200,
                        Colors.deepPurple,
                      ],
                      animationDuration: 1,
                      backColor: Colors.transparent,
                    ),
                  )
                : Column(
                    children: [
                      //artist-song
                      Container(
                        width: context.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextField(
                          controller: artistsongController,
                          lableText: "Artist - Song",
                          prefixIcon: Icons.music_video_sharp,
                          isObscure: false,
                          keyboardType: TextInputType.text,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //description tags
                      Container(
                        width: context.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: InputTextField(
                          keyboardType: TextInputType.text,
                          controller: descriptionTagsController,
                          lableText: "Description - Tags",
                          prefixIcon: Icons.slideshow_sharp,
                          isObscure: false,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //upload now button
                      Container(
                        width: context.width - 38,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (artistsongController.text.isNotEmpty &&
                                descriptionTagsController.text.isNotEmpty) {
                              uploadController
                                  .saveVideoInformationToFirestoreDatabase(
                                artistsongController.text.trim(),
                                descriptionTagsController.text.trim(),
                                widget.videoPath,
                                context,
                              );
                              setState(() {
                                showProgressBar = true;
                              });
                            }
                          },
                          child: const Center(
                            child: Text(
                              "Upload Now",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
