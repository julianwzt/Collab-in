import 'package:flutter/material.dart';
import 'package:collabin/core/common/color_value.dart';
import 'package:collabin/core/gen/fonts.gen.dart';

/// Auth input field matching the Figma "Masuk" / "Daftar" screens:
/// a label row (icon + text) above a rounded box with a light outline.
/// Validation errors turn the border red and show an error icon + message
/// underneath the box.
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 16, color: ColorValue.placeholderGrey),
                const SizedBox(width: 8),
              ],
              Text(
                hintText,
                style: const TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ColorValue.placeholderGrey,
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: ColorValue.primaryColor,
          style: const TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: _border(ColorValue.inputBorder),
            enabledBorder: _border(ColorValue.inputBorder),
            focusedBorder: _border(ColorValue.primaryColor),
            errorBorder: _border(ColorValue.errorBorderRed),
            focusedErrorBorder: _border(ColorValue.errorBorderRed),
            errorBuilder: (context, errorText) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  const Icon(Icons.error,
                      size: 16, color: ColorValue.errorBorderRed),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      errorText,
                      style: const TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontSize: 12,
                        color: ColorValue.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
