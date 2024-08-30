import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppComponents {
  static Widget customFormField({
    required TextEditingController fieldController,
    required String hint,
    required String? validatorString(String val),
    required BuildContext context,
    required bool hiddenText,
    TextInputType? textInputType,
  }) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: 7),
        height: MediaQuery.of(context).size.height * 0.075,
        child: TextFormField(
          controller: fieldController,
          keyboardType: textInputType ?? TextInputType.name,
          validator: (value) {
            if (value == "") {
              return "Field cant be empty";
            } else {
              return validatorString(value.toString());
            }
          },
          decoration: InputDecoration(
              fillColor: AppColors.white,
              filled: true,
//border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: AppColors.borderLightGrey),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabled: true,
              hintText: hint,
              hintStyle: TextStyle(
                  color: AppColors.hintMediumGrey,
                  fontWeight: FontWeight.normal)),
          obscureText: hiddenText,
        ),
      );

  static Widget solidButton(
          {required VoidCallback fun,
          required Widget widget,
          required BuildContext context,
          double? widthPercent,
          Color? color}) =>
      InkWell(
        onTap: fun,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.6,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.darkPurple,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: widget,
        ),
      );

//static Widget spacer({required height}) => SizedBox();
  static Widget loadingIndicator({required BuildContext context}) => Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.withOpacity(0.3),
          ),
          Center(
            child: CircularProgressIndicator(
              color: AppColors.darkPurple,
            ),
          )
        ],
      );
}
