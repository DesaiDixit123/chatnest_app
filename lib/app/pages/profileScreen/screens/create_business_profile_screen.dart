import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateBusinessProfileScreen extends GetWidget<ProfileController> {
  const CreateBusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.businessprofileFormKey = GlobalKey<FormState>();
          controller.currentBusStep = 1;
          controller.isValid = true;
          controller.isValidForBusinessWAMobile = true;
          controller.getBusinessCategories(isLoading: true);
          controller.editBusinessId = Get.arguments ?? "";
          if (controller.editBusinessId != "") {
            controller.getOneBusiness(controller.editBusinessId ?? '', true);
          } else {
            controller.clearBusinessProfileValues();
          }
        });
      },
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorsValue.white,
            appBar: AppBar(
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.4),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Get.arguments != ""
                        ? "edit_business_profile".tr
                        : "createBusinessProfile".tr,
                    style: Styles.black70018,
                  ),
                ],
              ),
              leading: Padding(
                padding: Dimens.edgeInsets15,
                child: InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "alert".tr,
                          style: Styles.black50020,
                        ),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "are_you_sure_back_home".tr,
                            style: Styles.black40016,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text(
                              "no".tr,
                              style: Styles.main50016,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "yes".tr,
                              style: Styles.main50016,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    AssetConstants.appbarbackarrowicon,
                  ),
                ),
              ),
            ),
            body: ListView(
              padding: Dimens.edgeInsets20_0_20_0,
              children: [
                Dimens.boxHeight10,
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "${controller.currentBusStep} of 3",
                    style: Styles.main40016,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsValue.maincolor1,
                          borderRadius: BorderRadius.circular(Dimens.two),
                        ),
                        height: Dimens.five,
                      ),
                    ),
                    Dimens.boxWidth10,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.currentBusStep >= 2
                              ? ColorsValue.maincolor1
                              : ColorsValue.grey,
                          borderRadius: BorderRadius.circular(Dimens.two),
                        ),
                        height: Dimens.five,
                      ),
                    ),
                    Dimens.boxWidth10,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.currentBusStep >= 3
                              ? ColorsValue.maincolor1
                              : ColorsValue.grey,
                          borderRadius: BorderRadius.circular(Dimens.two),
                        ),
                        height: Dimens.five,
                      ),
                    ),
                  ],
                ),
                Dimens.boxHeight10,
                controller.currentBusStep == 1
                    ? Form(
                        key: controller.businessprofileFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: Dimens.edgeInsets20,
                              child: Center(
                                child: ProfileWidget(
                                  imagePath: ApiWrapper.imageUrl +
                                      (controller.businessProfilePic),
                                  isEdit: true,
                                  isSelected: false,
                                  onClicked: () async {
                                    if (await controller
                                        .imagePermissionCheack(context)) {
                                      controller.setBusinessProfilePic();
                                    }
                                  },
                                ),
                              ),
                            ),
                            CustomTextFormField(
                              controller: controller.businessNameController,
                              isCompulsoryText: true,
                              hintText: 'business_name'.tr,
                              fillColor: ColorsValue.textfildbackcolor,
                              validation: (value) {
                                return controller.enterbusiness(value!);
                              },
                            ),
                            Dimens.boxHeight20,
                            Text(
                              'business_category'.tr,
                              style: Styles.black50014,
                            ),
                            Dimens.boxHeight6,
                            DropdownMultipleTree(
                              isMultipleSelctionEnable: true,
                              hintText: 'select'.tr,
                              itemList: controller.catagoriesList
                                  .map((e) => DropdownMultipleTreeModel(
                                      name: e.categoryname.trim(),
                                      subItems: e.subcategories != null
                                          ? e.subcategories
                                              ?.map(
                                                (subItem) => DropdownItemModel(
                                                    mainCatagoriesName:
                                                        e.categoryname,
                                                    mainCatagoriesId: e.id,
                                                    name: subItem.categoryname,
                                                    id: subItem.id),
                                              )
                                              .toList()
                                          : []))
                                  .toList(),
                              multipleSelectedList:
                                  controller.selectedBusinessCategory,
                              onMultiSelected: (val) {
                                controller.selectedBusinessCategory = val;
                                controller.update();
                              },
                              prefixIcon: Padding(
                                padding: Dimens.edgeInsets10,
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  spacing: Dimens.ten,
                                  runSpacing: Dimens.ten,
                                  children: List.generate(
                                    controller.selectedBusinessCategory.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        controller.selectedBusinessCategory
                                            .removeAt(index);
                                        controller.update();
                                      },
                                      child: Container(
                                        padding: Dimens.edgeInsets5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorsValue.appColor),
                                            borderRadius: BorderRadius.circular(
                                                Dimens.eight)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                  text: controller
                                                      .selectedBusinessCategory[
                                                          index]
                                                      .mainCatagoriesName,
                                                  style: Styles.black50014),
                                              TextSpan(
                                                  text:
                                                      ' (${controller.selectedBusinessCategory[index].name}) ',
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
                            Dimens.boxHeight20,
                            CustomTextFormField(
                              controller: controller.aboutController,
                              isCompulsoryText: false,
                              maxLines: 3,
                              maxLength: 2000,
                              onChanged: (value) {
                                controller
                                    .update(); // if you're using GetBuilder
                              },
                              hintText: 'about_business'.tr,
                              fillColor: ColorsValue.textfildbackcolor,
                            ),
                            Dimens.boxHeight5,
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '${controller.aboutController.text.length} / 2000',
                                style: Styles.greyAAA40014,
                              ),
                            ),
                            Dimens.boxHeight20,
                            CustomInternationalPhoneFild(
                              hintText: 'phone_number'.tr,
                              text: 'business_mobile_number'.tr,
                              initialvalue: PhoneNumber(
                                isoCode: PhoneNumber.getISO2CodeByPrefix(
                                  controller.dailcode,
                                ),
                              ),
                              onInputChanged: (PhoneNumber number) {
                                controller.dailcode = number.dialCode ?? '';
                              },
                              oninitialValidation: (bool value) {
                                controller.isValid = value;
                                controller.update();
                              },
                              textEditingController:
                                  controller.mobileNumController,
                              validation: (value) {
                                return controller.businessMobile(value!);
                              },
                            ),
                            Dimens.boxHeight20,
                            CustomInternationalPhoneFild(
                              hintText: 'phone_number'.tr,
                              text: 'business_wb_mobile_number'.tr,
                              initialvalue: PhoneNumber(
                                isoCode: PhoneNumber.getISO2CodeByPrefix(
                                  controller.dailWSCode,
                                ),
                              ),
                              onInputChanged: (PhoneNumber number) {
                                controller.dailWSCode = number.dialCode ?? '';
                              },
                              oninitialValidation: (bool value) {
                                controller.isValidForBusinessWAMobile = value;
                                controller.update();
                              },
                              textEditingController:
                                  controller.mobileWsController,
                              validation: (value) {
                                return controller.businessWAMobile(value!);
                              },
                            ),
                            Dimens.boxHeight20,
                            CustomTextFormField(
                              controller: controller.emailIdController,
                              isCompulsoryText: true,
                              hintText: 'business_emailId'.tr,
                              keybordtype: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              fillColor: ColorsValue.textfildbackcolor,
                              validation: (value) {
                                return controller.businessEmail(value!);
                              },
                            ),
                            Dimens.boxHeight20,
                            CustomTextFormField(
                              controller: controller.businessweblink,
                              isCompulsoryText: true,
                              hintText: 'enter_business_weblink'.tr,
                              fillColor: ColorsValue.textfildbackcolor,
                              validation: (value) {
                                return controller.businessWeblink(value!);
                              },
                            ),
                            Dimens.boxHeight20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'interest_business_category'.tr,
                                  style: Styles.black50014,
                                ),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    value: controller.isIntrestBusiness,
                                    checkColor: ColorsValue.white,
                                    activeColor: ColorsValue.maincolor1,
                                    onChanged: (value) {
                                      controller.isIntrestBusiness = value!;
                                      controller.update();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (controller.isIntrestBusiness) ...[
                              Dimens.boxHeight6,
                              DropdownMultipleTree(
                                isMultipleSelctionEnable: true,
                                hintText: 'select'.tr,
                                itemList: controller.catagoriesList
                                    .map((e) => DropdownMultipleTreeModel(
                                        name: e.categoryname.trim(),
                                        subItems: e.subcategories
                                            ?.map((subItem) =>
                                                DropdownItemModel(
                                                    mainCatagoriesName:
                                                        e.categoryname,
                                                    mainCatagoriesId: e.id,
                                                    name: subItem.categoryname,
                                                    id: subItem.id))
                                            .toList()))
                                    .toList(),
                                multipleSelectedList: controller
                                    .selectedIntrestedBusinessCategory,
                                onMultiSelected: (val) {
                                  controller.selectedIntrestedBusinessCategory =
                                      val;
                                  controller.update();
                                },
                                prefixIcon: Padding(
                                  padding: Dimens.edgeInsets10,
                                  child: Wrap(
                                    runAlignment: WrapAlignment.center,
                                    spacing: Dimens.ten,
                                    runSpacing: Dimens.ten,
                                    children: List.generate(
                                      controller
                                          .selectedIntrestedBusinessCategory
                                          .length,
                                      (index) => InkWell(
                                        onTap: () {
                                          controller
                                              .selectedIntrestedBusinessCategory
                                              .removeAt(index);
                                          controller.update();
                                        },
                                        child: Container(
                                          padding: Dimens.edgeInsets5,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ColorsValue.appColor),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.eight)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                    text: controller
                                                        .selectedIntrestedBusinessCategory[
                                                            index]
                                                        .mainCatagoriesName,
                                                    style: Styles.black50014),
                                                TextSpan(
                                                    text:
                                                        ' (${controller.selectedIntrestedBusinessCategory[index].name}) ',
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
                            ],
                            Dimens.boxHeight30,
                            CustomButton(
                              height: Dimens.fifty,
                              text: 'next'.tr.toUpperCase(),
                              onTap: () {
                                if (controller
                                    .businessprofileFormKey.currentState!
                                    .validate()) {
                                  if (controller
                                      .selectedBusinessCategory.isEmpty) {
                                    Utility.errorMessage(
                                        'please_select_the_business_catagory'
                                            .tr);
                                  } else if (controller
                                          .selectedIntrestedBusinessCategory
                                          .isEmpty &&
                                      controller.isIntrestBusiness) {
                                    Utility.errorMessage(
                                        'please_select_the_interested_business_catagory'
                                            .tr);
                                  } else {
                                    controller.currentBusStep += 1;
                                    controller.update();
                                  }
                                }
                              },
                            ),
                            Dimens.boxHeight30,
                          ],
                        ),
                      )
                    : controller.currentBusStep == 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'add_brochure'.tr,
                                style: Styles.black50014,
                              ),
                              Dimens.boxHeight6,
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
                                      txt: 'add_brochure'.tr,
                                      onTap: () async {
                                        var data = await Utility
                                            .filePickPermissionCheack();
                                        if (data) {
                                          controller.selectBrochure();
                                        }
                                      },
                                      bgColor: ColorsValue.white,
                                    ),
                                    Dimens.boxHeight10,
                                    Padding(
                                      padding: Dimens.edgeInsets20_0_20_0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: ColorsValue.grey9BA6A8,
                                            size: Dimens.fifteen,
                                          ),
                                          Dimens.boxWidth5,
                                          Text(
                                            'max_5_brochure'.tr,
                                            style: Styles.grey9BA70012,
                                          )
                                        ],
                                      ),
                                    ),
                                    controller.imageBrochureList.isNotEmpty
                                        ? Padding(
                                            padding: Dimens.edgeInsets10,
                                            child: GridView.builder(
                                                physics: const ScrollPhysics(),
                                                padding: Dimens.edgeInsets10,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  crossAxisCount: 3,
                                                ),
                                                itemCount: controller
                                                    .imageBrochureList.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.five),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        controller.imageBrochureList[
                                                                        index]
                                                                    .split(".")
                                                                    .last !=
                                                                "pdf"
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  if (controller
                                                                          .imageBrochureList[
                                                                              index]
                                                                          .split(
                                                                              ".")
                                                                          .last !=
                                                                      "pdf") {
                                                                    RouteManagement.goToShowFullScareenImage(
                                                                        controller
                                                                            .imageBrochureList[index],
                                                                        "image".tr);
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                  height: Dimens
                                                                      .hundred,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Dimens.five),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: ApiWrapper
                                                                              .imageUrl +
                                                                          controller
                                                                              .imageBrochureList[index],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      maxHeightDiskCache:
                                                                          300,
                                                                      maxWidthDiskCache:
                                                                          300,
                                                                      width: Dimens
                                                                          .ninty,
                                                                      height: Dimens
                                                                          .ninty,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              Center(
                                                                        child: Image
                                                                            .asset(
                                                                          AssetConstants
                                                                              .placeholder,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image
                                                                              .asset(
                                                                        AssetConstants
                                                                            .placeholder,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (await canLaunchUrl(Uri.parse(ApiWrapper
                                                                          .imageUrl +
                                                                      controller
                                                                              .imageBrochureList[
                                                                          index]))) {
                                                                    await launchUrl(Uri.parse(ApiWrapper
                                                                            .imageUrl +
                                                                        controller
                                                                            .imageBrochureList[index]));
                                                                  } else {
                                                                    throw 'Could not open the map.';
                                                                  }
                                                                },
                                                                child: Center(
                                                                  child:
                                                                      Container(
                                                                    height: Dimens
                                                                        .hundred,
                                                                    width: double
                                                                        .infinity,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              Dimens.five,
                                                                            ),
                                                                            color: ColorsValue.white),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      AssetConstants
                                                                          .ic_pdf,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: InkWell(
                                                              onTap: () {
                                                                controller.removeBrochure(
                                                                    controller
                                                                            .imageBrochureList[
                                                                        index],
                                                                    index);
                                                              },
                                                              child: Padding(
                                                                padding: Dimens
                                                                    .edgeInsets5,
                                                                child: SvgPicture.asset(
                                                                    AssetConstants
                                                                        .ic_remove),
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              Dimens.boxHeight20,
                              Text(
                                'add_photos'.tr,
                                style: Styles.black50014,
                              ),
                              Dimens.boxHeight6,
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
                                          controller.selectPhotos();
                                        }
                                      },
                                      bgColor: ColorsValue.white,
                                      svgPicture: AssetConstants.ic_image,
                                    ),
                                    Dimens.boxHeight10,
                                    Padding(
                                      padding: Dimens.edgeInsets20_0_20_0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                    controller.photosList.isNotEmpty
                                        ? Padding(
                                            padding: Dimens.edgeInsets10,
                                            child: GridView.builder(
                                                physics: const ScrollPhysics(),
                                                padding: Dimens.edgeInsets10,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  crossAxisCount: 3,
                                                ),
                                                itemCount: controller
                                                    .photosList.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.five),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            RouteManagement
                                                                .goToShowFullScareenImage(
                                                                    controller
                                                                            .photosList[
                                                                        index],
                                                                    "Image");
                                                          },
                                                          child: SizedBox(
                                                            height:
                                                                Dimens.hundred,
                                                            width:
                                                                double.infinity,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          Dimens
                                                                              .five),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: ApiWrapper
                                                                        .imageUrl +
                                                                    controller
                                                                            .photosList[
                                                                        index],
                                                                fit: BoxFit
                                                                    .cover,
                                                                maxHeightDiskCache:
                                                                    300,
                                                                maxWidthDiskCache:
                                                                    300,
                                                                width: Dimens
                                                                    .ninty,
                                                                height: Dimens
                                                                    .ninty,
                                                                placeholder:
                                                                    (context,
                                                                            url) =>
                                                                        Center(
                                                                  child: Image
                                                                      .asset(
                                                                    AssetConstants
                                                                        .placeholder,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  AssetConstants
                                                                      .placeholder,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: InkWell(
                                                              onTap: () {
                                                                controller.removePhoto(
                                                                    controller
                                                                            .photosList[
                                                                        index],
                                                                    index);
                                                              },
                                                              child: Padding(
                                                                padding: Dimens
                                                                    .edgeInsets5,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
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
                                          )
                                  ],
                                ),
                              ),
                              Dimens.boxHeight20,
                              Text(
                                'add_video'.tr,
                                style: Styles.black50014,
                              ),
                              Dimens.boxHeight6,
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
                                      onTap: () async {
                                        if (await controller
                                            .imagePermissionCheack(context)) {
                                          controller.selectVideos();
                                        }
                                      },
                                      bgColor: ColorsValue.white,
                                      svgPicture: AssetConstants.ic_video,
                                    ),
                                    Dimens.boxHeight10,
                                    Padding(
                                      padding: Dimens.edgeInsets20_0_20_0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: ColorsValue.grey9BA6A8,
                                            size: Dimens.fifteen,
                                          ),
                                          Dimens.boxWidth5,
                                          Text(
                                            'max_3_video'.tr,
                                            style: Styles.grey9BA70012,
                                          )
                                        ],
                                      ),
                                    ),
                                    controller.videoList.isNotEmpty
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
                                                    controller.videoList.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.five),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        ThumbNailImageFullpage(
                                                          url: controller
                                                              .videoList[index],
                                                        ),
                                                        Center(
                                                          child: InkWell(
                                                            onTap: () {
                                                              RouteManagement
                                                                  .goToShowFullScareenImage(
                                                                      controller
                                                                              .videoList[
                                                                          index],
                                                                      "Video");
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              AssetConstants
                                                                  .ic_video_play,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: InkWell(
                                                              onTap: () {
                                                                controller.removeVideos(
                                                                    controller
                                                                            .videoList[
                                                                        index],
                                                                    index);
                                                              },
                                                              child: Padding(
                                                                padding: Dimens
                                                                    .edgeInsets5,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
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
                                          )
                                  ],
                                ),
                              ),
                              Dimens.boxHeight20,
                              CustomBottomButton(
                                firstbtnText: "back".tr,
                                secondbtnTxt: "next".tr,
                                firstStyle: Styles.main50016,
                                secondStyle: Styles.white50016,
                                firstOnPressed: () {
                                  controller.currentBusStep = 1;
                                  controller.update();
                                },
                                secondOnPressed: () async {
                                  controller.currentBusStep = 3;
                                  controller.isLocation =
                                      await Utility.locationPermissionCheack();
                                  controller.update();
                                },
                              ),
                              Dimens.boxHeight20,
                            ],
                          )
                        : Form(
                            key: controller.businessprofileFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Location",
                                  style: Styles.black50014,
                                ),
                                Dimens.boxHeight5,
                                Container(
                                  height: Dimens.ninty,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.six),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.six),
                                    child: Stack(
                                      children: [
                                        GoogleMap(
                                          mapToolbarEnabled: false,
                                          zoomGesturesEnabled: false,
                                          scrollGesturesEnabled: false,
                                          tiltGesturesEnabled: true,
                                          rotateGesturesEnabled: false,
                                          zoomControlsEnabled: false,
                                          myLocationButtonEnabled: false,
                                          myLocationEnabled: false,
                                          onMapCreated: controller.onMapCreated,
                                          initialCameraPosition: CameraPosition(
                                            target: controller
                                                    .businessProfileLatLag ??
                                                const LatLng(
                                                    21.170240, 72.831062),
                                            zoom: 14,
                                          ),
                                          markers: controller.markers.isEmpty
                                              ? {
                                                  Marker(
                                                    markerId:
                                                        const MarkerId("mark"),
                                                    position: controller
                                                            .businessProfileLatLag ??
                                                        const LatLng(21.170240,
                                                            72.831062),
                                                    draggable: true,
                                                    onDragEnd: (value) {},
                                                  ),
                                                }
                                              : controller.markers,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (await Utility
                                                .locationPermissionCheack()) {
                                              await RouteManagement
                                                      .goToLocationScreen()
                                                  .then((value) {
                                                controller.moveToLocation(
                                                    controller.profileLatLag ??
                                                        const LatLng(21.170240,
                                                            72.831062));
                                              });
                                            }
                                          },
                                          child: SizedBox(
                                            width: double.maxFinite,
                                            height: Dimens.ninty,
                                          ),
                                        ),
                                        Visibility(
                                          visible: controller.isLocation
                                              ? false
                                              : true,
                                          child: Container(
                                            width: double.infinity,
                                            height: Dimens.ninty,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black12
                                                  .withOpacity(0.5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "location_msg_error".tr,
                                                textAlign: TextAlign.center,
                                                style: Styles.redcolor70016,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Dimens.boxHeight20,
                                Text(
                                  "business_address".tr,
                                  style: Styles.black50014,
                                ),
                                Dimens.boxHeight5,
                                CustomTextFormField(
                                  isCompulsoryText: false,
                                  hintText: 'flat_no'.tr,
                                  fillColor: ColorsValue.textfildbackcolor,
                                  controller: controller.flatNoController,
                                ),
                                Dimens.boxHeight12,
                                CustomTextFormField(
                                  isCompulsoryText: false,
                                  hintText: 'street_name'.tr,
                                  fillColor: ColorsValue.textfildbackcolor,
                                  controller: controller.streetController,
                                ),
                                Dimens.boxHeight12,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        isCompulsoryText: true,
                                        hintText: 'city'.tr,
                                        fillColor:
                                            ColorsValue.textfildbackcolor,
                                        controller: controller.cityController,
                                        validation: (value) {
                                          return controller
                                              .entercityname(value!);
                                        },
                                      ),
                                    ),
                                    Dimens.boxWidth12,
                                    Expanded(
                                      child: CustomTextFormField(
                                        isCompulsoryText: true,
                                        hintText: 'state'.tr,
                                        fillColor:
                                            ColorsValue.textfildbackcolor,
                                        controller: controller.stateController,
                                        validation: (value) {
                                          return controller.enterstate(value!);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Dimens.boxHeight12,
                                CustomTextFormField(
                                  isCompulsoryText: true,
                                  hintText: 'enter_pincode'.tr,
                                  fillColor: ColorsValue.textfildbackcolor,
                                  controller: controller.pincodeController,
                                  validation: (value) {
                                    return controller.enterpincode(value!);
                                  },
                                ),
                                Dimens.boxHeight20,
                                controller.businessHoursList
                                        .any((element) => element.open == true)
                                    ? Container(
                                        padding: Dimens.edgeInsets15_0_15_0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.five,
                                          ),
                                          color: ColorsValue.textfildbackcolor,
                                        ),
                                        child: ExpansionTile(
                                          childrenPadding: Dimens.edgeInsets0,
                                          tilePadding: Dimens.edgeInsets0,
                                          backgroundColor: Colors.transparent,
                                          collapsedBackgroundColor:
                                              ColorsValue.textfildbackcolor,
                                          collapsedShape:
                                              BeveledRectangleBorder(
                                            side: BorderSide(
                                              width: Dimens.zero,
                                              color:
                                                  ColorsValue.textfildbackcolor,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: Dimens.zero,
                                              color:
                                                  ColorsValue.textfildbackcolor,
                                            ),
                                          ),
                                          leading: SvgPicture.asset(
                                            AssetConstants.businesscategoryicon,
                                          ),
                                          title: Text(
                                            'businessCategory'.tr,
                                            style: Styles.black50014,
                                          ),
                                          onExpansionChanged: (value) {
                                            if (controller.isCategory) {
                                              controller.isCategory = false;
                                            } else {
                                              controller.isCategory = true;
                                            }
                                            controller.update();
                                          },
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  RouteManagement
                                                      .goTochangeBusinessHoursView();
                                                },
                                                child: SvgPicture.asset(
                                                  AssetConstants
                                                      .ic_edit_detalis,
                                                  height: Dimens.twenty,
                                                  width: Dimens.twenty,
                                                ),
                                              ),
                                              Dimens.boxWidth15,
                                              SvgPicture.asset(
                                                controller.isCategory
                                                    ? AssetConstants.ic_up_arrow
                                                    : AssetConstants
                                                        .ic_down_arrow,
                                              ),
                                            ],
                                          ),
                                          children: controller.businessHoursList
                                              .asMap()
                                              .entries
                                              .map((e) {
                                            controller
                                                .businessHoursList[e.key].time
                                                .asMap()
                                                .entries
                                                .map((e) => controller
                                                    .timeIndex = e.key);
                                            return Padding(
                                              padding:
                                                  Dimens.edgeInsets0_10_0_10,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      e.value.day,
                                                      style: Styles
                                                          .greyColor888840014,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      "-",
                                                      style: Styles
                                                          .greyColor888840014,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 5,
                                                      child: Wrap(
                                                        children: e.value.time
                                                            .map((ev) {
                                                          return Padding(
                                                            padding: Dimens
                                                                .edgeInsetsTopt05,
                                                            child: Text(
                                                              e.value.open
                                                                  ? "${ev.starttime} - ${ev.endtime}"
                                                                  : "cloased"
                                                                      .tr,
                                                              style: Styles
                                                                  .greyColor888840014,
                                                            ),
                                                          );
                                                        }).toList(),
                                                      )),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          RouteManagement
                                              .goTochangeBusinessHoursView();
                                        },
                                        child: Text(
                                          "add_business_hours".tr,
                                          style: Styles.main50014,
                                        ),
                                      ),
                                // controller.businessHoursList
                                //         .any((element) => element.open == true)
                                //     ? Container(
                                //         padding: Dimens.edgeInsets15_10_15_10,
                                //         decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(
                                //             Dimens.five,
                                //           ),
                                //           color: ColorsValue.textfildbackcolor,
                                //         ),
                                //         child: Column(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: [
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.spaceBetween,
                                //               children: [
                                //                 Text(
                                //                   'business_hours'.tr,
                                //                   style: Styles.black50014,
                                //                 ),
                                //                 InkWell(
                                //                   onTap: () {
                                //                     RouteManagement
                                //                         .goTochangeBusinessHoursView();
                                //                   },
                                //                   child: Container(
                                //                     padding: Dimens
                                //                         .edgeInsets15_07_15_07,
                                //                     decoration: BoxDecoration(
                                //                         borderRadius:
                                //                             BorderRadius.circular(
                                //                           Dimens.three,
                                //                         ),
                                //                         color: ColorsValue
                                //                             .maincolor1),
                                //                     child: Text(
                                //                       'change'.tr.toUpperCase(),
                                //                       style: Styles.white70010,
                                //                     ),
                                //                   ),
                                //                 )
                                //               ],
                                //             ),
                                //             Wrap(
                                //               children: controller
                                //                   .businessHoursList
                                //                   .asMap()
                                //                   .entries
                                //                   .map((e) {
                                //                 controller
                                //                     .businessHoursList[e.key].time
                                //                     .asMap()
                                //                     .entries
                                //                     .map((e) => controller
                                //                         .timeIndex = e.key);
                                //                 return Padding(
                                //                   padding:
                                //                       Dimens.edgeInsets0_10_0_10,
                                //                   child: Row(
                                //                     children: [
                                //                       Expanded(
                                //                         flex: 3,
                                //                         child: Text(
                                //                           e.value.day,
                                //                           style: Styles
                                //                               .greyColor888840014,
                                //                         ),
                                //                       ),
                                //                       Expanded(
                                //                         flex: 1,
                                //                         child: Text(
                                //                           "-",
                                //                           style: Styles
                                //                               .greyColor888840014,
                                //                         ),
                                //                       ),
                                //                       Expanded(
                                //                           flex: 5,
                                //                           child: Wrap(
                                //                             children: e.value.time
                                //                                 .map((ev) {
                                //                               return Padding(
                                //                                 padding: Dimens
                                //                                     .edgeInsetsTopt05,
                                //                                 child: Text(
                                //                                   e.value.open
                                //                                       ? "${ev.starttime} - ${ev.endtime}"
                                //                                       : "cloased"
                                //                                           .tr,
                                //                                   style: Styles
                                //                                       .greyColor888840014,
                                //                                 ),
                                //                               );
                                //                             }).toList(),
                                //                           )),
                                //                     ],
                                //                   ),
                                //                 );
                                //               }).toList(),
                                //             )
                                //           ],
                                //         ),
                                //       )
                                //     : InkWell(
                                //         onTap: () {
                                //           RouteManagement
                                //               .goTochangeBusinessHoursView();
                                //         },
                                //         child: Text(
                                //           "add_business_hours".tr,
                                //           style: Styles.main50014,
                                //         ),
                                //       ),
                                Dimens.boxHeight20,
                                Text(
                                  "social_media_link".tr,
                                  style: Styles.black50014,
                                ),
                                Dimens.boxHeight10,
                                Wrap(
                                  children: controller.businessSocialMediaLink
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    return Padding(
                                      padding: Dimens.edgeInsets5,
                                      child: Container(
                                        height: e.value.size,
                                        width: e.value.size,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: controller.indexBusiness ==
                                                    e.key
                                                ? ColorsValue.maincolor1
                                                : Colors.transparent,
                                            width: Dimens.two,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              controller.indexBusiness = e.key;
                                              controller.update();
                                            },
                                            child: Image.asset(
                                              e.value.icon ?? "",
                                              height: e.value.size,
                                              width: e.value.size,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                CustomTextFormField(
                                  controller: controller
                                      .businessSocialMediaLink[
                                          controller.indexBusiness]
                                      .textEditingController,
                                  hintText: controller
                                      .businessSocialMediaLink[
                                          controller.indexBusiness]
                                      .hintText,
                                  fillColor: ColorsValue.textfildbackcolor,
                                  onChanged: (value) {
                                    controller
                                        .businessSocialMediaLink[
                                            controller.indexBusiness]
                                        .url = value;
                                    controller.update();
                                  },
                                ),
                                Dimens.boxHeight30,
                                CustomBottomButton(
                                  firstbtnText: "back".tr,
                                  secondbtnTxt: "submit".tr,
                                  firstStyle: Styles.main50016,
                                  secondStyle: Styles.white50016,
                                  firstOnPressed: () {
                                    controller.currentBusStep = 2;
                                    controller.update();
                                  },
                                  secondOnPressed: () async {
                                    if (controller.businessProfileLatLag ==
                                        null) {
                                      Utility.errorMessage(
                                          'please_select_location'.tr);
                                    } else if (controller
                                        .businessprofileFormKey.currentState!
                                        .validate()) {
                                      await controller.setBusinessProfile();
                                    }
                                  },
                                ),
                                Dimens.boxHeight30,
                              ],
                            ),
                          )
              ],
            ),
          ),
        );
      },
    );
  }
}
