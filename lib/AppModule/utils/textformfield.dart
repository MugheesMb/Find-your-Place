// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/controller.dart';

AuthController controller = Get.put(AuthController());
Widget textformfeild({
  required isObscureText,
  required boolTitleShowHide,
  required fieldName,
  hint_text,
  padding,
  Function? returnDatacall,

  // Function
}) {
  return Container(
    height: boolTitleShowHide ? 115 : 92,
    padding: padding ??
        const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boolTitleShowHide
            ? Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fieldName,
                style: GoogleFonts.poppins(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ],
          ),
        )
            : Container(
          height: 10,
        ),
        SizedBox(
          height: 80,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "$fieldName  Required";
              }
              return null;
            },
            obscureText:
            isObscureText == true ? controller.isObscureText.value : false,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              hintStyle:
              const TextStyle(fontSize: 14, color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide:BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: hint_text,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey)),
              helperStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onChanged: (val) {
              returnDatacall!(val);
            },
          ),
        )
      ],
    ),
  );
}
