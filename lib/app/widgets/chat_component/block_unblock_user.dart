import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BlockUnblockUser extends StatefulWidget {
  BlockUnblockUser({super.key, required this.isBlock});
  bool isBlock = false;

  @override
  State<BlockUnblockUser> createState() => _BlockUnblockUserState();
}

class _BlockUnblockUserState extends State<BlockUnblockUser> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isBlock
          ? () {
              Get.dialog(
                Padding(
                  padding: Dimens.edgeInsetsTop20,
                  child: Material(
                    color: ColorsValue.transparent,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: Dimens.edgeInsets20_0_20_0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsValue.white,
                                borderRadius:
                                    BorderRadius.circular(Dimens.fifteen),
                              ),
                              child: Padding(
                                padding: Dimens.edgeInsets25_30_25_30,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: SvgPicture.asset(
                                            AssetConstants.cancleicon,
                                          )),
                                    ),
                                    SvgPicture.asset(
                                      AssetConstants.canclepopupicon,
                                    ),
                                    Dimens.boxHeight18,
                                    Text(
                                      "unblock_user".tr,
                                      style: Styles.black70020,
                                    ),
                                    Dimens.boxHeight10,
                                    Text(
                                      "areYouSure_unblockUser".tr,
                                      style: Styles.greyColor888840014,
                                    ),
                                    Dimens.boxHeight18,
                                    CustomBottomButton(
                                        firstbtnText: "cancle".tr.toUpperCase(),
                                        secondbtnTxt:
                                            "unblock".tr.toUpperCase(),
                                        firstStyle: Styles.greyColor888850014,
                                        secondStyle: Styles.white50014,
                                        bordercolor: ColorsValue.greyColor8888,
                                        buttoncolor: ColorsValue.redColor,
                                        firstOnPressed: () {
                                          Get.back();
                                        },
                                        secondOnPressed: () {
                                          Get.back();
                                          setState(() {
                                            widget.isBlock = false;
                                          });
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsValue.lightmainColor,
          borderRadius: BorderRadius.circular(Dimens.five),
        ),
        child: Padding(
          padding: Dimens.edgeInsets8,
          child: Text(
            widget.isBlock
                ? "you_block_this_contact".tr
                : "you_unblock_this_contact".tr,
            style: Styles.black40012,
          ),
        ),
      ),
    );
  }
}
