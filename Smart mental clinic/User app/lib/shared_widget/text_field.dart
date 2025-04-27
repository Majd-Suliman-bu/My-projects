import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customTextField(
    {Widget? prefix,
    Color? borderSideColor,
    required BuildContext context,
    required String label,
    bool? isPassWordInVisible,
    String? hintText,
    TextInputType? textInputType,
    Widget? suffixIcon,
    String? errorText,
    TextEditingController? controller,
    double? borderRadius,
    String? Function(String?)? validator,
    Function(String?)? onChanged,
    Function(String?)? onSaved,
    bool enable = true}) {
  return TextFormField(
    enabled: enable,
    keyboardType: textInputType,
    cursorColor: Colors.blue,
    onSaved: onSaved,
    onChanged: onChanged,
    controller: controller,
    obscureText: isPassWordInVisible ?? false,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      prefix: prefix,
      errorText: errorText,
      labelText: label.tr,
      labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.grey,
            fontSize: 12,
          ),
      hintText: hintText,
      hintStyle: const TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 12),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderSideColor ?? Color(0xff14181b),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(borderRadius ??
            10), //if you need to update this value just send it as a parameter.
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xff14181b),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xff14181b),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      filled: true,
      fillColor: Color(0xff14181b),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
    ),
    style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.grey,
        ),
    validator: validator,
  );
}

Widget editeProfileTextField(
    {IconData? prefix,
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    bool? isPassWordInVisible,
    GlobalKey? key,
    String? hintText,
    Widget? suffixIcon,
    String? errorText,
    TextInputType? textInputType,
    String? Function(String?)? validator,
    Function(String?)? onChanged,
    Function(String?)? onSaved}) {
  return TextFormField(
    key: key,
    keyboardType: textInputType,
    controller: controller,
    onSaved: onSaved,
    onChanged: onChanged,
    obscureText: isPassWordInVisible ?? false,
    decoration: InputDecoration(
      hoverColor: Colors.grey,
      suffixIcon: suffixIcon,
      errorText: errorText,
      labelText: label.tr,
      labelStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 12,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black45, // Rest state border color
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.blue, // Focus state border color
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      filled: true,
      fillColor: Color(0xff14181b),
    ),
    style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white,
        ),
    validator: validator,
  );
}
