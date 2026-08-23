// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../app.dart';

class CustomTextFormField extends StatefulWidget {
  String? hintText;
  TextEditingController? controller;
  bool obscure;
  bool autofocus;
  Widget? suffixIcon;
  Widget? prefixIcon;
  int? maxLength;
  int? maxLines;
  TextInputType? keybordtype;
  String? Function(String?)? validation;
  Color? fillColor;
  bool isCompulsoryText;
  bool readOnly;
  bool isleading;
  void Function()? onTap;
  void Function()? onTapped;
  ValueChanged<String>? onChanged;
  TextInputAction? textInputAction;
  List selected = [];
  List<TextInputFormatter>? inputFormatters;
  void Function()? onEditingComplete;
  Function(PointerDownEvent)? onTapOutside;
  FocusNode? focusNode;

  CustomTextFormField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.obscure = false,
      this.autofocus = false,
      this.isCompulsoryText = false,
      this.readOnly = false,
      this.suffixIcon,
      this.prefixIcon,
      this.keybordtype,
      this.textInputAction,
      this.maxLength,
      this.maxLines,
      this.validation,
      this.onChanged,
      this.onTapped,
      this.isleading = false,
      required this.fillColor,
      this.inputFormatters,
      this.onEditingComplete,
      this.focusNode,
      this.onTapOutside})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dimens.boxHeight7,
        widget.isleading
            ? Row(
                children: [
                  Container(
                    height: Dimens.fifty,
                    width: Dimens.fifty,
                    decoration: BoxDecoration(
                      color: ColorsValue.maincolor1,
                      borderRadius: BorderRadius.circular(Dimens.five),
                    ),
                    child: Padding(
                      padding: Dimens.edgeInsets15,
                      child: SvgPicture.asset(AssetConstants.hashtagicon),
                    ),
                  ),
                  Dimens.boxWidth6,
                  Expanded(
                    child: TextFormField(
                      focusNode: widget.focusNode,
                      controller: widget.controller,
                      cursorColor: ColorsValue.maincolor1,
                      obscureText: widget.obscure,
                      readOnly: widget.readOnly,
                      onChanged: widget.onChanged,
                      maxLength: widget.maxLength,
                      maxLines: widget.maxLines,
                      autofocus: widget.autofocus,
                      textInputAction: widget.textInputAction,
                      keyboardType: widget.keybordtype,
                      validator: widget.validation,
                      inputFormatters: widget.inputFormatters,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onEditingComplete: widget.onEditingComplete,
                      onTapOutside: widget.onTapOutside,
                      decoration: InputDecoration(
                        suffixIcon: widget.suffixIcon,
                        counterText: '',
                        contentPadding: EdgeInsets.all(Dimens.ten),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: Dimens.zero, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: Dimens.zero, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: Dimens.zero, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: Dimens.zero, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        fillColor: widget.fillColor,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: Dimens.zero, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        hintStyle: Styles.greyAAA40014,
                        hintText: widget.isCompulsoryText
                            ? '${widget.hintText}' ' *'
                            : widget.hintText,
                      ),
                    ),
                    // TextFormField(
                    //   controller: widget.controller,
                    //   cursorColor: ColorsValue.maincolor1,
                    //   obscureText: widget.obscure,
                    //   readOnly: widget.readOnly,
                    //   onChanged: widget.onChanged,
                    //   maxLength: widget.maxLength,
                    //   maxLines: widget.maxLines,
                    //   autofocus: widget.autofocus,
                    //   textInputAction: widget.textInputAction,
                    //   keyboardType: widget.keybordtype,
                    //   validator: widget.validation,
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   decoration: InputDecoration(
                    //     suffixIcon: widget.suffixIcon,
                    //     counterText: '',
                    //     contentPadding: EdgeInsets.all(Dimens.ten),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           width: Dimens.zero, style: BorderStyle.none),
                    //       borderRadius: BorderRadius.circular(Dimens.five),
                    //     ),
                    //     disabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           width: Dimens.zero, style: BorderStyle.none),
                    //       borderRadius: BorderRadius.circular(Dimens.five),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           width: Dimens.zero, style: BorderStyle.none),
                    //       borderRadius: BorderRadius.circular(Dimens.five),
                    //     ),
                    //     focusedErrorBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           width: Dimens.zero, style: BorderStyle.none),
                    //       borderRadius: BorderRadius.circular(Dimens.five),
                    //     ),
                    //     fillColor: widget.fillColor,
                    //     filled: true,
                    //     errorBorder: InputBorder.none,
                    //     hintStyle: Styles.bold14,
                    //     // errorStyle: Styles.red12,
                    //     hintText: widget.isCompulsoryText
                    //         ? '${widget.hintText}' ' *'
                    //         : widget.hintText,
                    //   ),
                    // ),
                  ),
                ],
              )
            : TextFormField(
                focusNode: widget.focusNode,
                onTap: widget.onTapped,
                controller: widget.controller,
                cursorColor: ColorsValue.maincolor1,
                obscureText: widget.obscure,
                readOnly: widget.readOnly,
                onChanged: widget.onChanged,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines == null ? 1 : widget.maxLines,
                autofocus: widget.autofocus,
                textInputAction: widget.textInputAction,
                keyboardType: widget.keybordtype,
                validator: widget.validation,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                  counterText: '',
                  contentPadding: EdgeInsets.all(Dimens.ten),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: Dimens.zero, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(Dimens.five),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: Dimens.zero, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(Dimens.five),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: Dimens.zero, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(Dimens.five),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: Dimens.zero, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(Dimens.five),
                  ),
                  fillColor: widget.fillColor,
                  filled: true,
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: Dimens.zero, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(Dimens.five),
                  ),
                  hintStyle: Styles.greyAAA40014,
                  // errorStyle: Styles.red12,
                  hintText: widget.isCompulsoryText
                      ? '${widget.hintText}' ' *'
                      : widget.hintText,
                ),
              ),
      ],
    );
  }
}
