import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditGroupDetailsScreen extends StatelessWidget {
  const EditGroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatController>(builder: (controller) {
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
            'edit_group'.tr,
            style: Styles.black70016,
          ),
        ),
        bottomNavigationBar: Padding(
          padding: Dimens.edgeInsets20,
          child: InkWell(
            onTap: () {
              controller.createGroupApi(true);
            },
            child: Container(
              height: Dimens.fourtyFive,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  Dimens.five,
                ),
                color: ColorsValue.maincolor1,
              ),
              child: Center(
                child: Text(
                  "save".tr,
                  style: Styles.whitebold18,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: Dimens.edgeInsets20,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: Dimens.hundredTwenty,
                  width: Dimens.hundredTwenty,
                  child: InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: ColorsValue.white,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Dimens.thirty),
                                    topRight: Radius.circular(
                                      Dimens.thirty,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: Dimens.edgeInsets20_20_20_30,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: SvgPicture.asset(
                                              AssetConstants.cancleicon),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              controller.uploadGroupProfile(
                                                  ImageSource.camera);
                                              Get.back();
                                            },
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  AssetConstants
                                                      .ic_select_camera,
                                                ),
                                                Dimens.boxHeight8,
                                                Text(
                                                  'camera'.tr,
                                                  style: Styles.main50014,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Dimens.boxWidth60,
                                          InkWell(
                                            onTap: () async {
                                              controller.uploadGroupProfile(
                                                  ImageSource.gallery);
                                              Get.back();
                                            },
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  AssetConstants
                                                      .ic_select_gallery,
                                                ),
                                                Dimens.boxHeight8,
                                                Text(
                                                  'gallery'.tr,
                                                  style: Styles.main50014,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: Dimens.hundredTwenty,
                          width: Dimens.hundredTwenty,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimens.hundred,
                            ),
                            color: ColorsValue.blackColor,
                            border: Border.all(
                              color: ColorsValue.maincolor1,
                              width: Dimens.three,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimens.hundred,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: ApiWrapper.imageUrl +
                                  (controller.uploadGroupPic ?? ""),
                              fit: BoxFit.cover,
                              maxHeightDiskCache: 300,
                              maxWidthDiskCache: 300,
                              width: Dimens.hundredTwenty,
                              height: Dimens.hundredTwenty,
                              placeholder: (context, url) => Center(
                                child: Image.asset(
                                  AssetConstants.usera,
                                  height: Dimens.hundredTwenty,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                AssetConstants.usera,
                                height: Dimens.hundredTwenty,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: Dimens.thirty,
                            width: Dimens.thirty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.maincolor1,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AssetConstants.ic_outline_edit,
                                height: Dimens.sixteen,
                                width: Dimens.sixteen,
                                colorFilter: const ColorFilter.mode(
                                  ColorsValue.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Dimens.boxHeight20,
              CustomTextFormField(
                controller: controller.titleController,
                hintText: 'group_title'.tr,
                fillColor: ColorsValue.textfildbackcolor,
              ),
              Dimens.boxHeight20,
              CustomTextFormField(
                controller: controller.descriptionController,
                hintText: 'description'.tr,
                fillColor: ColorsValue.textfildbackcolor,
                maxLines: 3,
              ),
            ],
          ),
        ),
      );
    });
  }
}
