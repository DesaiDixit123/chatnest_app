import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LabelMessage extends StatelessWidget {
  LabelMessage({
    super.key,
    required this.message,
  });

  String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Container(
            width: Get.width / 1.2,
            padding: Dimens.edgeInsets16_08_16_08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Dimens.five,
              ),
              color: ColorsValue.lightmainColor,
            ),
            child: Center(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Styles.black40012,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
