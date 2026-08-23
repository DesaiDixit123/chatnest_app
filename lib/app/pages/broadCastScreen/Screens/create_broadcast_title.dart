import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddBroadcastTitle extends StatelessWidget {
  const AddBroadcastTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadCastController>(
      initState: (state) {
        var controller = Get.find<BroadCastController>();
        if (Get.arguments ?? false) {
          controller.titleController.text =
              controller.getOneBroadcastData?.broadcasttitle ?? "";
        }
      },
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Broadcast'.tr,
                  style: Styles.black70016,
                ),
                Dimens.boxHeight5,
                Text(
                  'Add Title'.tr,
                  style: Styles.greyColor888840012,
                ),
              ],
            ),
          ),
          body: Padding(
            padding: Dimens.edgeInsets20,
            child: Form(
              key: controller.titleKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: controller.titleController,
                    hintText: 'type_broadcast_title'.tr,
                    fillColor: ColorsValue.textfildbackcolor,
                    validation: (value) {
                      if (value!.isEmpty) {
                        return "Enter Brodcast Title";
                      }
                      return null;
                    },
                  ),
                  Dimens.boxHeight20,
                  Text(
                    "${"broadcast_members".tr} ${controller.brodcastSelectedMemberList.length}"
                        .tr,
                    style: Styles.black70020,
                  ),
                  Dimens.boxHeight15,
                  Expanded(
                    child: GridView.builder(
                      itemCount: controller.brodcastSelectedMemberList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: Dimens.edgeInsets7_0_7_0,
                          child: InkWell(
                            onTap: () {
                              controller.brodcastSelectedMemberList
                                  .removeAt(index);
                              controller.update();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Dimens.fifty,
                                  width: Dimens.fifty,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: Dimens.fifty,
                                        width: Dimens.fifty,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          color: ColorsValue.blackColor,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: ApiWrapper.imageUrl +
                                                (controller
                                                        .brodcastSelectedMemberList[
                                                            index]
                                                        .profileimage ??
                                                    ""),
                                            fit: BoxFit.cover,
                                            maxHeightDiskCache: 300,
                                            maxWidthDiskCache: 300,
                                            width: Dimens.fifty,
                                            height: Dimens.fifty,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Image.asset(
                                                AssetConstants.usera,
                                                height: Dimens.fifty,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        AssetConstants.usera),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          height: Dimens.eighteen,
                                          width: Dimens.eighteen,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              Dimens.hundred,
                                            ),
                                            color: ColorsValue.maincolor1,
                                            border: Border.all(
                                              color: ColorsValue.white,
                                              width: Dimens.one,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.close,
                                              size: Dimens.twelve,
                                              color: ColorsValue.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Dimens.boxHeight5,
                                Text(
                                  controller.brodcastSelectedMemberList[index]
                                          .nickname ??
                                      "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Styles.greyColor888840010,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    text: 'submit'.tr,
                    onTap: () {
                      if (controller.titleKey.currentState!.validate()) {
                        if (controller.brodcastSelectedMemberList.isEmpty) {
                          Utility.errorMessage("please_select_member".tr);
                        } else {
                          controller.postAddBroadcast(Get.arguments ?? false);
                        }
                      }
                    },
                    height: Dimens.fifty,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
