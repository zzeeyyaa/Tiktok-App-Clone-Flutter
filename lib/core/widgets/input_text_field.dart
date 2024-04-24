// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.assetRefrence,
    required this.lableText,
    this.overrideValidator = false,
    required this.isObscure,
    required this.keyboardType,
    this.readOnly = false,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final String? assetRefrence;
  final String lableText;
  final bool isObscure;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? suffixIcon;
  final bool overrideValidator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: overrideValidator
          ? validator
          : (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return validator?.call(value);
            },
      decoration: InputDecoration(
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 13.5),
        suffixIcon: suffixIcon,
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
        // enabledBorder:
        //     OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
