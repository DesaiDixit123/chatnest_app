import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:page_indicator/page_indicator.dart';

class BusinessProductDetailScreen extends GetWidget<ProfileController> {
  const BusinessProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) {
        controller.getOneProduct(Get.arguments ?? "", false);
      },
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                controller.oneProductDetail?.name ?? '-',
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RouteManagement.goToaddbusinessProductScreen(
                controller.oneProductDetail?.id ?? "");
          },
          backgroundColor: ColorsValue.maincolor1,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              Dimens.fifty,
            ),
            borderSide: BorderSide.none,
          ),
          child: SvgPicture.asset(
            AssetConstants.editIcon,
            fit: BoxFit.fill,
            height: Dimens.twentyFive,
            colorFilter: const ColorFilter.mode(
              ColorsValue.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        body: controller.oneProductDetail != null
            ? SafeArea(
                child: Padding(
                  padding: Dimens.edgeInsets20_20_20_0,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorsValue.textfildbackcolor,
                            borderRadius: BorderRadius.circular(
                              Dimens.five,
                            ),
                          ),
                          child: Padding(
                            padding: Dimens.edgeInsets5,
                            child: ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              isThreeLine: true,
                              dense: true,
                              leading: Container(
                                height: Dimens.fifty,
                                width: Dimens.fifty,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                  child: CachedNetworkImage(
                                    height: Dimens.fifty,
                                    width: Dimens.fifty,
                                    imageUrl: ApiWrapper.imageUrl +
                                        (controller.oneProductDetail?.businessid
                                                ?.profileimage ??
                                            ""),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: Image.asset(
                                        AssetConstants.usera,
                                        height: Dimens.hundredThirty,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      AssetConstants.usera,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                controller.oneProductDetail?.businessid?.name ??
                                    "",
                                style: Styles.black70016,
                              ),
                              subtitle: Text(
                                controller
                                        .oneProductDetail?.businessid?.about ??
                                    "",
                                style: Styles.grey9BA40014,
                              ),
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        Container(
                          width: double.infinity,
                          height: Dimens.twoHundred,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimens.six)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: ApiWrapper.imageUrl +
                                  (controller.oneProductDetail?.image ?? ""),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Dimens.boxHeight20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.oneProductDetail?.name ?? "",
                              style: Styles.black70020,
                            ),
                            Container(
                              height: Dimens.thirty,
                              padding: Dimens.edgeInsets15_05_15_05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimens.three,
                                ),
                                color: ColorsValue.redColor,
                              ),
                              child: Text(
                                controller.oneProductDetail?.offerType ==
                                        'amount'
                                    ? "${controller.oneProductDetail?.offer} ${'currency_off'.tr}"
                                    : '${controller.oneProductDetail?.offer} ${'percent_off'.tr}',
                                style: Styles.white40014,
                              ),
                            )
                          ],
                        ),
                        Dimens.boxHeight20,
                        Row(
                          children: [
                            Text(
                              "price".tr,
                              style: Styles.black50014,
                            ),
                            Text(
                              " ${'currency_symbol'.tr}${controller.oneProductDetail?.price}",
                              style: Styles.main40014,
                            ),
                          ],
                        ),
                        Dimens.boxHeight20,
                        Row(
                          children: [
                            Text(
                              "productcode".tr,
                              style: Styles.black50014,
                            ),
                            Text(
                              " ${controller.oneProductDetail?.code}",
                              style: Styles.greyColor888840014,
                            ),
                          ],
                        ),
                        Dimens.boxHeight20,
                        Text(
                          controller.oneProductDetail?.description ?? "",
                          style: Styles.greyColor888840014,
                        ),
                        Dimens.boxHeight20,
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
