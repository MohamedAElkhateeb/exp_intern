// core/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_manager.dart';
import '../theme/app_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? !_isPasswordVisible : widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: LightAppStyle.labelStyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: ColorsManager.black,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsManager.greyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsManager.greyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsManager.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsManager.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsManager.error),
        ),
      ),
    );
  }
}