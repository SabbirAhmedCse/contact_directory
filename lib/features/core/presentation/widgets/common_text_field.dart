import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? helperText;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.helperText,
    this.enabled = true,
    this.contentPadding,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
       obscureText: obscureText,
       textInputAction: textInputAction,
       focusNode: focusNode,
       onChanged: onChanged,
       onSubmitted: onSubmitted,
       enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border ?? const OutlineInputBorder(),
        isDense: true,
        contentPadding: contentPadding,
      ),
    );
  }
}
