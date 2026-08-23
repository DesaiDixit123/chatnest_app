import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SentRequestDialog extends StatefulWidget {
  Key? formKey;
  String? title;
  TextEditingController? textEditingController;
  Function()? onTap;
  SentRequestDialog({
    super.key,
    required this.formKey,
    required this.title,
    required this.textEditingController,
    required this.onTap,
  });

  @override
  State<SentRequestDialog> createState() => _SentRequestDialogState();
}

class _SentRequestDialogState extends State<SentRequestDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsTop20,
      child: Material(
        color: ColorsValue.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: Dimens.edgeInsets30_0_30_0,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsValue.white,
                  borderRadius: BorderRadius.circular(Dimens.five),
                ),
                child: Padding(
                  padding: Dimens.edgeInsets10,
                  child: Form(
                    key: widget.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.title ?? "",
                              style: Styles.black70014,
                            ),
                            SizedBox(
                              height: Dimens.fifteen,
                              width: Dimens.fifteen,
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                  AssetConstants.cancleicon,
                                ),
                              ),
                            )
                          ],
                        ),
                        Dimens.boxHeight10,
                        TextFormField(
                          controller: widget.textEditingController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please_enter_msg'.tr;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
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
                            fillColor: ColorsValue.textfildbackcolor,
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: Dimens.zero, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(Dimens.five),
                            ),
                            hintStyle: Styles.greyAAA40014,
                            hintText: 'type_message_here'.tr,
                          ),
                          maxLines: 2,
                          maxLength: 100,
                        ),
                        Dimens.boxHeight10,
                        CustomButton(
                          height: Dimens.fourty,
                          text: "send_request".tr.toUpperCase(),
                          onTap: widget.onTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
