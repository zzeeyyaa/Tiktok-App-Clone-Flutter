import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_app_clone_flutter/core/enums/route_enum.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/input_text_field.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';

class RegistView extends StatefulWidget {
  const RegistView({super.key});

  static Widget page() => const RegistView();

  @override
  State<RegistView> createState() => _RegistViewState();
}

class _RegistViewState extends State<RegistView> {
  bool isObscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var authController = AuthController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'SignUp',
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    'Create your account',
                    style: GoogleFonts.saira(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      authController.chooseImageFromGallery();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/profile_default.jpeg',
                        height: 150,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  InputTextField(
                    controller: emailController,
                    lableText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    isObscure: false,
                    prefixIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 30),
                  InputTextField(
                    controller: usernameController,
                    lableText: 'Username',
                    keyboardType: TextInputType.name,
                    isObscure: false,
                    prefixIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 30),
                  InputTextField(
                    controller: passwordController,
                    lableText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    isObscure: isObscure,
                    suffixIcon: InkWell(
                      radius: 50,
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: isObscure
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                    prefixIcon: Icons.lock_outlined,
                  ),
                  const SizedBox(height: 30),

                  //*signup button
                  //*not have an account, show signup button

                  showProgressBar == false
                      ? Column(
                          children: [
                            Container(
                              width: context.width,
                              height: 54,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  )),
                              child: InkWell(
                                onTap: () {
                                  if (authController.profileImage != null &&
                                      emailController.text.isNotEmpty &&
                                      usernameController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    setState(() {
                                      showProgressBar == true;
                                    });
                                    authController.createNewAccount(
                                      authController.profileImage!,
                                      emailController.text.trim(),
                                      usernameController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                  } else if (authController.profileImage ==
                                      null) {
                                    Get.snackbar(
                                      'Your profile image is empty',
                                      'Filled your profile image first',
                                      backgroundColor:
                                          Colors.red.shade300.withOpacity(0.5),
                                    );
                                  }
                                  //signup user now
                                },
                                child: const Center(
                                  child: Text(
                                    'SignUp',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(RouteName.login.toString());
                                  },
                                  child: const Text(
                                    "Login here",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : SizedBox(
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
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
