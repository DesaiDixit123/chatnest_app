import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddBusinessProductScreen extends GetWidget<ProfileController> {
  const AddBusinessProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) {
        controller.proId = Get.arguments ?? "";
        if (controller.proId != "") {
          controller.getOneProduct(controller.proId ?? "", true);
        } else {
          controller.clearAddProductValues();
        }
        controller.getProductCategory(isLoading: true);
      },
      builder: (controller) => Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                controller.proId != "" ? "update_product".tr : "add_product".tr,
                style: Styles.black70018,
              ),
            ],
          ),
          leading: Padding(
            padding: Dimens.edgeInsets15,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
              ),
            ),
          ),
        ),
        backgroundColor: ColorsValue.white,
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20,
            child: SingleChildScrollView(
              child: Form(
                key: controller.businessProductFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: 'product_name'.tr,
                      fillColor: ColorsValue.textfildbackcolor,
                      controller: controller.productNameController,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'enter_product_name'.tr;
                        }
                        return null;
                      },
                    ),
                    Dimens.boxHeight20,
                    DropdownMultipleTree(
                      isMultipleSelctionEnable: true,
                      hintText: 'category'.tr,
                      itemList: controller.productCatagoriesList
                          .map((e) => DropdownMultipleTreeModel(
                              name: e.name!.trim(),
                              subItems: e.subcategories
                                  ?.map((subItem) => DropdownItemModel(
                                      mainCatagoriesName: e.name!,
                                      mainCatagoriesId: e.id,
                                      name: subItem.name!,
                                      id: subItem.id))
                                  .toList()))
                          .toList(),
                      multipleSelectedList: controller.selectProductcategory,
                      onMultiSelected: (val) {
                        controller.selectProductcategory = val;
                        controller.update();
                      },
                      prefixIcon: Padding(
                        padding: Dimens.edgeInsets10,
                        child: Wrap(
                          runAlignment: WrapAlignment.center,
                          spacing: Dimens.ten,
                          runSpacing: Dimens.ten,
                          children: List.generate(
                            controller.selectProductcategory.length,
                            (index) => InkWell(
                              onTap: () {
                                controller.selectProductcategory
                                    .removeAt(index);
                                controller.update();
                              },
                              child: Container(
                                padding: Dimens.edgeInsets5,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: ColorsValue.appColor),
                                    borderRadius:
                                        BorderRadius.circular(Dimens.eight)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: controller
                                              .selectProductcategory[index]
                                              .mainCatagoriesName,
                                          style: Styles.black50014),
                                      TextSpan(
                                          text:
                                              ' (${controller.selectProductcategory[index].name}) ',
                                          style: Styles.grey9BA40012)
                                    ])),
                                    Dimens.boxWidth2,
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: ColorsValue.redColor,
                                      size: Dimens.ten,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      errorText: null,
                    ),
                    Dimens.boxHeight10,
                    CustomTextFormField(
                      hintText: 'product_discription'.tr,
                      maxLines: 2,
                      fillColor: ColorsValue.textfildbackcolor,
                      controller: controller.productDiscriptionController,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'enter_product_discription'.tr;
                        }
                        return null;
                      },
                    ),
                    Dimens.boxHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hintText: 'product_price'.tr,
                            fillColor: ColorsValue.textfildbackcolor,
                            controller: controller.productPriceController,
                            keybordtype: TextInputType.number,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return 'enter_product_price'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Dimens.boxWidth6,
                        Container(
                          height: Dimens.fourtyThree,
                          width: Dimens.fourtyThree,
                          decoration: BoxDecoration(
                            color: ColorsValue.maincolor1,
                            borderRadius: BorderRadius.circular(Dimens.five),
                          ),
                          child: Padding(
                            padding: Dimens.edgeInsets15,
                            child: SvgPicture.asset(AssetConstants.rupeeIcon),
                          ),
                        )
                      ],
                    ),
                    Dimens.boxHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hintText: 'offers'.tr,
                            controller: controller.productOfferController,
                            fillColor: ColorsValue.textfildbackcolor,
                            keybordtype: TextInputType.number,
                          ),
                        ),
                        Dimens.boxWidth6,
                        InkWell(
                          onTap: () {
                            controller.offerType = 'percentage';
                            controller.update();
                          },
                          child: Container(
                            height: Dimens.fourtyThree,
                            width: Dimens.fourtyThree,
                            decoration: BoxDecoration(
                                color: controller.offerType == 'percentage'
                                    ? ColorsValue.maincolor1
                                    : ColorsValue.maincoloropacity1,
                                borderRadius:
                                    BorderRadius.circular(Dimens.five),
                                border: Border.all(
                                  color: ColorsValue.maincolor1,
                                )),
                            child: Padding(
                              padding: Dimens.edgeInsets15,
                              child: SvgPicture.asset(
                                AssetConstants.multiplicationIcon,
                                colorFilter: ColorFilter.mode(
                                  controller.offerType == 'percentage'
                                      ? ColorsValue.white
                                      : ColorsValue.maincolor1,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Dimens.boxWidth6,
                        InkWell(
                          onTap: () {
                            controller.offerType = 'amount';
                            controller.update();
                          },
                          child: Container(
                            height: Dimens.fourtyThree,
                            width: Dimens.fourtyThree,
                            decoration: BoxDecoration(
                                color: controller.offerType == 'amount'
                                    ? ColorsValue.maincolor1
                                    : ColorsValue.maincoloropacity1,
                                borderRadius:
                                    BorderRadius.circular(Dimens.five),
                                border: Border.all(
                                  color: ColorsValue.maincolor1,
                                )),
                            child: Padding(
                              padding: Dimens.edgeInsets15,
                              child: SvgPicture.asset(
                                AssetConstants.rupeeIcon,
                                colorFilter: ColorFilter.mode(
                                  controller.offerType == 'amount'
                                      ? ColorsValue.white
                                      : ColorsValue.maincolor1,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Dimens.boxHeight20,
                    InkWell(
                      onTap: () async {
                        if (await controller.imagePermissionCheack(context)) {
                          controller.setMainImageProduct();
                        }
                      },
                      child: Container(
                        height: Dimens.twoHundred,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: ColorsValue.textfildbackcolor,
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        child: controller.mainInageProduct == ""
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      AssetConstants.bannerimageicon,
                                      height: Dimens.fifty),
                                  Text(
                                    "add_main_image".tr,
                                    style: Styles.greyColor888850014,
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.five),
                                child: CachedNetworkImage(
                                  imageUrl: ApiWrapper.imageUrl +
                                      (controller.mainInageProduct ?? ""),
                                  fit: BoxFit.cover,
                                  maxHeightDiskCache: 300,
                                  maxWidthDiskCache: 300,
                                  width: Dimens.ninty,
                                  height: Dimens.ninty,
                                  placeholder: (context, url) => Center(
                                    child: SvgPicture.asset(
                                        AssetConstants.bannerimageicon),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                          AssetConstants.bannerimageicon),
                                ),
                              ),
                      ),
                    ),
                    Dimens.boxHeight20,
                    Card(
                      elevation: 2,
                      color: ColorsValue.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UploadWidgets(
                            height: Dimens.fourtyFive,
                            txt: 'add_photos'.tr,
                            onTap: () async {
                              if (await controller
                                  .imagePermissionCheack(context)) {
                                controller.selectProductPhotos();
                              }
                            },
                            bgColor: ColorsValue.white,
                            svgPicture: AssetConstants.ic_image,
                          ),
                          Dimens.boxHeight10,
                          Padding(
                            padding: Dimens.edgeInsets20_0_20_5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: ColorsValue.grey9BA6A8,
                                  size: Dimens.fifteen,
                                ),
                                Dimens.boxWidth5,
                                Text(
                                  'max_5_images'.tr,
                                  style: Styles.grey9BA70012,
                                )
                              ],
                            ),
                          ),
                          controller.productPhotoList.isNotEmpty
                              ? GridView.builder(
                                  physics: const ScrollPhysics(),
                                  padding: Dimens.edgeInsets10,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: controller.productPhotoList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
                                      child: Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {},
                                            child: SizedBox(
                                              height: Dimens.hundred,
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.five),
                                                child: CachedNetworkImage(
                                                  imageUrl: ApiWrapper
                                                          .imageUrl +
                                                      controller
                                                              .productPhotoList[
                                                          index],
                                                  fit: BoxFit.cover,
                                                  maxHeightDiskCache: 300,
                                                  maxWidthDiskCache: 300,
                                                  width: Dimens.ninty,
                                                  height: Dimens.ninty,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Image.asset(
                                                      AssetConstants
                                                          .placeholder,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    AssetConstants.placeholder,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                                onTap: () {
                                                  controller.removeProductPhoto(
                                                      controller
                                                              .productPhotoList[
                                                          index],
                                                      index);
                                                },
                                                child: Padding(
                                                  padding: Dimens.edgeInsets5,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.ic_remove,
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              : const Visibility(
                                  visible: false,
                                  child: Icon(
                                    Icons.error,
                                  ),
                                )
                        ],
                      ),
                    ),
                    Dimens.boxHeight10,
                    Card(
                      elevation: 2,
                      color: ColorsValue.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UploadWidgets(
                            height: Dimens.fourtyFive,
                            txt: 'add_video'.tr,
                            onTap: () {
                              controller.selectProductVideos();
                            },
                            bgColor: ColorsValue.white,
                            svgPicture: AssetConstants.ic_video,
                          ),
                          Dimens.boxHeight10,
                          Padding(
                            padding: Dimens.edgeInsets20_0_20_5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: ColorsValue.grey9BA6A8,
                                  size: Dimens.fifteen,
                                ),
                                Dimens.boxWidth5,
                                Text(
                                  'max_2_video'.tr,
                                  style: Styles.grey9BA70012,
                                )
                              ],
                            ),
                          ),
                          controller.productVideoList.isNotEmpty
                              ? Padding(
                                  padding: Dimens.edgeInsets10,
                                  child: GridView.builder(
                                      physics: const ScrollPhysics(),
                                      padding: Dimens.edgeInsets10,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              crossAxisCount: 3),
                                      itemCount:
                                          controller.productVideoList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.five),
                                          child: Stack(
                                            children: <Widget>[
                                              ThumbNailImageFullpage(
                                                url: controller
                                                    .productVideoList[index],
                                              ),
                                              Center(
                                                  child: InkWell(
                                                onTap: () {
                                                  RouteManagement
                                                      .goToShowFullScareenImage(
                                                          controller
                                                                  .productVideoList[
                                                              index],
                                                          "Video");
                                                },
                                                child: SvgPicture.asset(
                                                  AssetConstants.ic_video_play,
                                                ),
                                              )),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                    onTap: () {
                                                      controller
                                                          .removeProductVideos(
                                                              controller
                                                                      .productVideoList[
                                                                  index],
                                                              index);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          Dimens.edgeInsets5,
                                                      child: SvgPicture.asset(
                                                        AssetConstants
                                                            .ic_remove,
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : const Visibility(
                                  visible: false,
                                  child: Icon(
                                    Icons.error,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Dimens.boxHeight30,
                    CustomButton(
                      text: controller.proId != ""
                          ? 'update'.tr.toUpperCase()
                          : 'save'.tr.toUpperCase(),
                      onTap: () {
                        if (controller.businessProductFormKey.currentState!
                            .validate()) {
                          if (controller.selectProductcategory.isEmpty) {
                            Utility.errorMessage(
                                'please_select_the_catagory'.tr);
                          } else if (controller.mainInageProduct == "") {
                            Utility.errorMessage(
                                'please_select_the_main_product_image'.tr);
                          } else {
                            controller.addProduct(
                                productId: controller.proId ?? '');
                          }
                        }
                      },
                      height: Dimens.fifty,
                    ),
                    Dimens.boxHeight20
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
