import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/input_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'assets/images/tiktok.png',
                  width: 200,
                ),
                Text(
                  'Wellcome',
                  style: GoogleFonts.rubikMonoOne(
                    fontSize: 32,
                  ),
                ),
                Text(
                  'Glad to see you',
                  style: GoogleFonts.saira(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),
                InputTextField(
                  controller: emailController,
                  lableText: 'Email',
                  isObscure: false,
                  prefixIcon: Icons.email_outlined,
                ),
                InputTextField(
                  controller: passwordController,
                  lableText: 'Passwod',
                  isObscure: false,
                  prefixIcon: Icons.email_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
