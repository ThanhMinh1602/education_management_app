import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.prefixIcon,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.isPassword = false,
    this.textInputAction,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.grey),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    );

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,

      obscureText: _obscureText,

      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppColors.primary)
            : null,

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,

        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: focusedBorder,
        labelStyle: TextStyle(color: Colors.grey[600]),
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
      ),
    );
  }
}
