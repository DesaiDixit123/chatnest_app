import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ViewAllSelectContactScreen extends StatelessWidget {
  const ViewAllSelectContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        initState: (state) {},
        builder: (controller) {
          return Scaffold(
            backgroundColor: ColorsValue.white,
            appBar: AppBar(
              shadowColor: ColorsValue.greyAAAAAA,
              backgroundColor: ColorsValue.white,
              elevation: Dimens.two,
              centerTitle: false,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: Dimens.edgeInsets20_15_10_15,
                  child: SvgPicture.asset(
                    AssetConstants.appbarbackarrowicon,
                    colorFilter: const ColorFilter.mode(
                      ColorsValue.maincolor1,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              title: Text(
                "view_all".tr,
                style: Styles.black70018,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (Get.arguments[0] ?? false) {
                  controller.sendGroupMessage("", false, false);
                } else if (Get.arguments[1] ?? false) {
                  controller.postSendMessageBroadcast("", false);
                } else {
                  controller.sendMessage("", false, false);
                }
                controller.contactSelectList.clear();
                Get.back();
                Get.back();
              },
              backgroundColor: ColorsValue.maincolor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimens.hundred,
                ),
              ),
              child: Icon(
                Icons.done,
                color: ColorsValue.white,
                size: Dimens.thirty,
              ),
            ),
            body: Padding(
              padding: Dimens.edgeInsets20,
              child: ListView.builder(
                itemCount: controller.contactSelectList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: Dimens.edgeInsets0_10_0_10,
                    child: Container(
                      padding: Dimens.edgeInsets10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.five,
                        ),
                        color: ColorsValue.textfildbackcolor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: Dimens.fifty,
                                width: Dimens.fifty,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.hundred),
                                  border: Border.all(
                                    width: Dimens.one,
                                    color: ColorsValue.maincolor1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.hundred),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiWrapper.imageUrl +
                                        (controller.contactSelectList[index]
                                                .profileimage ??
                                            ""),
                                    maxWidthDiskCache: 90,
                                    maxHeightDiskCache: 90,
                                    placeholder: (context, url) {
                                      return Image.asset(AssetConstants.usera);
                                    },
                                    errorWidget: (context, url, error) {
                                      return Image.asset(AssetConstants.usera);
                                    },
                                  ),
                                ),
                              ),
                              Dimens.boxWidth12,
                              Text(
                                controller.contactSelectList[index].nickname ??
                                    "",
                                style: Styles.black60014,
                              )
                            ],
                          ),
                          Dimens.boxHeight10,
                          Divider(
                            height: 1,
                            color: ColorsValue.white,
                          ),
                          Dimens.boxHeight10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${controller.contactSelectList[index].countryCode ?? ""} ${controller.contactSelectList[index].mobile ?? ""}',
                                style: Styles.black60014,
                              ),
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: ColorsValue.maincolor1,
                                  checkColor: ColorsValue.white,
                                  value: controller
                                      .contactSelectList[index].isSelect,
                                  onChanged: (value) {
                                    if (controller.contactSelectList[index]
                                            .isSelect ??
                                        false) {
                                      controller.contactSelectList[index]
                                          .isSelect = false;
                                    } else {
                                      controller.contactSelectList[index]
                                          .isSelect = true;
                                    }
                                    controller.update();
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
