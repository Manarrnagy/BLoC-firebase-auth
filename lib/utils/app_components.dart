import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppComponents {
  ///---------------------------form---------------------------
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

  ///------------------------------oval button ----------------------------------
  static Widget solidButton(
          {required VoidCallback fun,
          required Widget widget,
          required BuildContext context,
          double? widthPercent,
          double? heightPercent,
          Color? color}) =>
      InkWell(
        onTap: fun,
        child: Container(
          height: heightPercent != null
              ? MediaQuery.of(context).size.height * heightPercent
              : MediaQuery.of(context).size.height * 0.08,
          width: widthPercent != null
              ? MediaQuery.of(context).size.width * widthPercent
              : MediaQuery.of(context).size.width * 0.6,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color ?? AppColors.darkPurple,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: widget,
        ),
      );

//static Widget spacer({required height}) => SizedBox();
  ///------------------- loading indicator ------------------------------------
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

  ///-------------------- drawer list tile --------------------------------
  static Widget drawerListTile(
          {required BuildContext context,
          Color? tilecolor,
          required Icon icon,
          required Text text,
          required VoidCallback fun}) =>
      ListTile(
        minVerticalPadding: 50,
        tileColor: tilecolor ?? Colors.blue,
        leading: icon,
        title: text,
        onTap: fun,
      );
}
