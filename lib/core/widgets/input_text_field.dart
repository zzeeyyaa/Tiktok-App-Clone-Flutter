// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.assetRefrence,
    required this.lableText,
    required this.isObscure,
  });

  final TextEditingController controller;
  final IconData? prefixIcon;
  final String? assetRefrence;
  final String lableText;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscure,
      controller: controller,
      decoration: InputDecoration(
          labelText: lableText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon)
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    assetRefrence!,
                    width: 10,
                  ),
                ),
          labelStyle: GoogleFonts.saira(
            fontSize: 18,
          ),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }
}
