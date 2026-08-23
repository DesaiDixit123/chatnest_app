import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:page_indicator/page_indicator.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(initState: (state) {
      var controller = Get.find<ProductController>();
      controller.getOneFriendData = null;
      controller.postFriendProductGetOne(Get.arguments ?? "");
    }, builder: (controller) {
      final productData = controller.getOneFriendData?.productdata;
      final businessData = productData?.businessid;
      final showOffer = (productData?.offer ?? 0) > 0;

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
            productData?.name ?? 'products'.tr,
            style: Styles.black70018,
          ),
        ),
        bottomNavigationBar: Padding(
          padding: Dimens.edgeInsets20,
          child: ElevatedButton(
            onPressed: () {
              if (controller.getOneFriendData?.userdata?.isfriend != "no") {
                Get.find<ChatController>().sendMessageController.clear();
                Get.find<ChatController>().isReplyChat = true;
                Get.find<ChatController>().isProductSend = true;
                Get.find<ChatController>().friendProductDoc =
                    controller.getOneFriendData?.productdata;
                controller.update();
                RouteManagement.gooffAndToNamedChatScreen(
                    controller.getOneFriendData?.productdata?.userid?.id ?? "",
                    true);
              } else {
                Get.dialog(SentRequestDialog(
                  formKey: controller.sendRequestKey,
                  title: controller
                          .getOneFriendData?.productdata?.userid?.nickname ??
                      " -- ",
                  textEditingController: controller.messageController,
                  onTap: () {
                    if (controller.sendRequestKey.currentState!.validate()) {
                      Get.back();
                      controller.sendNewFriendRequest(
                          controller
                                  .getOneFriendData?.productdata?.userid?.id ??
                              "",
                          controller.messageController.text);
                    }
                  },
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                double.maxFinite,
                Dimens.fifty,
              ),
              backgroundColor: ColorsValue.appColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimens.five,
                ),
              ),
            ),
            child: Text(
              'inquiry_message'.tr,
              style: Styles.white50018,
            ),
          ),
        ),
        body: productData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: Dimens.edgeInsets20_20_20_0,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (businessData != null) ...[
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
                                        (businessData.profileimage ?? ""),
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
                                businessData.name ?? "",
                                style: Styles.black70016,
                              ),
                              subtitle: Text(
                                businessData.about ?? "",
                                style: Styles.grey9BA40014,
                              ),
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                      ],
                      controller.allVideoList.isNotEmpty
                          ? SizedBox(
                              height: Dimens.twoHundredFifty,
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    itemCount: controller.allVideoList.length,
                                    onPageChanged: (index) {
                                      controller.productMediaIndex = index;
                                      controller.update();
                                    },
                                    itemBuilder: (context, index) {
                                      var type = controller.allVideoList[index]
                                          .split('.')
                                          .last;
                                      return Utility.videoTypeList.every(
                                              (element) => element != type)
                                          ? Padding(
                                              padding:
                                                  Dimens.edgeInsets0_10_0_30,
                                              child: InkWell(
                                                onTap: () {
                                                  RouteManagement
                                                      .goToShowFullScareenImage(
                                                          controller
                                                                  .allVideoList[
                                                              index],
                                                          "Images");
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ApiWrapper
                                                            .imageUrl +
                                                        (controller
                                                                .allVideoList[
                                                            index]),
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) {
                                                      return Image.asset(
                                                        AssetConstants
                                                            .placeholder,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  Dimens.edgeInsets0_10_0_30,
                                              child: InkWell(
                                                onTap: () {
                                                  RouteManagement
                                                      .goToShowFullScareenImage(
                                                          controller
                                                                  .allVideoList[
                                                              index],
                                                          "Video");
                                                },
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      width: double.maxFinite,
                                                      height: Dimens
                                                          .twoHundredFifty,
                                                      child:
                                                          ThumbNailImageFullpage(
                                                        url: controller
                                                                .allVideoList[
                                                            index],
                                                      ),
                                                    ),
                                                    Center(
                                                      child: SvgPicture.asset(
                                                        AssetConstants
                                                            .ic_video_play,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        controller.allVideoList.length,
                                        (index) => Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                controller.productMediaIndex ==
                                                        index
                                                    ? ColorsValue.maincolor1
                                                    : ColorsValue.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: Dimens.twoHundred,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.six)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: ApiWrapper.imageUrl +
                                      (productData.image ?? ""),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                      AssetConstants.placeholder,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                      Dimens.boxHeight20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              productData.name ?? "",
                              style: Styles.black70020,
                            ),
                          ),
                          if (showOffer) ...[
                            Dimens.boxWidth10,
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
                                productData.offerType == "percentage"
                                    ? "${productData.offer} ${'percent_off'.tr}"
                                    : "${productData.offer} ${'currency_off'.tr}",
                                style: Styles.white40014,
                              ),
                            ),
                          ],
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
                            " ${'currency_symbol'.tr}${productData.price}",
                            style: Styles.main40014,
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     RatingBar.builder(
                      //       ignoreGestures: true,
                      //       initialRating: 4,
                      //       minRating: 1.0,
                      //       direction: Axis.horizontal,
                      //       allowHalfRating: true,
                      //       itemCount: 5,
                      //       itemSize: Dimens.twenty,
                      //       unratedColor: ColorsValue.grey,
                      //       itemPadding: EdgeInsets.symmetric(horizontal: Dimens.two),
                      //       itemBuilder: (context, _) => const Icon(
                      //         Icons.star,
                      //         color: Colors.amber,
                      //       ),
                      //       onRatingUpdate: (rating) {},
                      //     ),
                      //   ],
                      // ),
                      Dimens.boxHeight20,
                      Row(
                        children: [
                          Text(
                            "productcode".tr,
                            style: Styles.black50014,
                          ),
                          Text(
                            " ${productData.code ?? ""}",
                            style: Styles.greyColor888840014,
                          ),
                        ],
                      ),
                      Dimens.boxHeight20,
                      Text(
                        productData.description ?? "",
                        style: Styles.greyColor888840014,
                      ),
                      Dimens.boxHeight20,
                      if (controller
                              .getOneFriendData?.otherproductdata?.isNotEmpty ??
                          false) ...[
                        Text(
                          "Other Products",
                          style: Styles.black50014,
                        ),
                        Dimens.boxHeight10,
                        SizedBox(
                          height: Dimens.hundredFifty,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller
                                .getOneFriendData?.otherproductdata?.length,
                            itemBuilder: (context, index) {
                              var item = controller
                                  .getOneFriendData?.otherproductdata?[index];
                              return InkWell(
                                onTap: () {
                                  controller
                                      .postFriendProductGetOne(item?.id ?? "");
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: Dimens.edgeInsetsRight10,
                                      height: Dimens.hundred,
                                      width: Dimens.hundred,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.six)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.six,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: ApiWrapper.imageUrl +
                                              (item?.image ?? ""),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return Image.asset(
                                              AssetConstants.placeholder,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              AssetConstants.placeholder,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Dimens.boxHeight5,
                                    Text(
                                      item?.name ?? "",
                                      style: Styles.black40014,
                                    ),
                                    Dimens.boxHeight2,
                                    Text(
                                      "${'currency_symbol'.tr}${item?.price ?? ""}",
                                      style: Styles.main60012,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: InkWell(
                      //     onTap: () {
                      //       showModalBottomSheet(
                      //         context: context,
                      //         backgroundColor: ColorsValue.white,
                      //         builder: (context) {
                      //           return StatefulBuilder(
                      //             builder: (context, setState) {
                      //               return Container(
                      //                 width: double.infinity,
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.only(
                      //                     topLeft: Radius.circular(Dimens.thirty),
                      //                     topRight: Radius.circular(
                      //                       Dimens.thirty,
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 child: Padding(
                      //                   padding: Dimens.edgeInsets20_10_20_30,
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.center,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.center,
                      //                         children: [
                      //                           Container(
                      //                             height: Dimens.five,
                      //                             width: Dimens.seventy,
                      //                             decoration: BoxDecoration(
                      //                               color: ColorsValue.grey,
                      //                               borderRadius:
                      //                                   BorderRadius.circular(
                      //                                       Dimens.hundred),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       Dimens.boxHeight20,
                      //                       Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.spaceBetween,
                      //                         children: [
                      //                           Text(
                      //                             "Ratings",
                      //                             style: Styles.black50020,
                      //                           ),
                      //                           InkWell(
                      //                             onTap: () {
                      //                               Get.back();
                      //                             },
                      //                             child: SvgPicture.asset(
                      //                                 AssetConstants.cancleicon),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       Dimens.boxHeight20,
                      //                       Center(
                      //                         child: Container(
                      //                           child: RatingBar.builder(
                      //                             // ignoreGestures: true,
                      //                             initialRating: controller.ratting,
                      //                             minRating: 1,
                      //                             direction: Axis.horizontal,
                      //                             allowHalfRating: true,
                      //                             itemCount: 5,
                      //                             itemSize: 50,
                      //                             unratedColor: ColorsValue.grey,
                      //                             itemPadding:
                      //                                 const EdgeInsets.symmetric(
                      //                                     horizontal: 0.0),
                      //                             itemBuilder: (context, _) =>
                      //                                 const Icon(
                      //                               Icons.star,
                      //                               color: Colors.amber,
                      //                             ),
                      //                             onRatingUpdate: (rating) {
                      //                               controller.ratting = rating;
                      //                             },
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       Dimens.boxHeight30,
                      //                       CustomBottomButton(
                      //                         firstOnPressed: () {
                      //                           Get.back();
                      //                         },
                      //                         firstbtnText: 'Calcel'.tr.toUpperCase(),
                      //                         secondOnPressed: () {
                      //                           setState(() {
                      //                             controller.update();
                      //                             Get.back();
                      //                           });
                      //                         },
                      //                         secondbtnTxt: 'Submit'.tr.toUpperCase(),
                      //                         firstStyle: Styles.hinttext50014,
                      //                         secondStyle: Styles.white50014,
                      //                         bordercolor: ColorsValue.grey,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //           );
                      //         },
                      //       );
                      //     },
                      //     child: Text(
                      //       'write_rating'.tr,
                      //       style: Styles.main70016,
                      //     ),
                      //   ),
                      // ),
                      // Dimens.boxHeight20,
                      // SingleChildScrollView(
                      //   child: ListView.builder(
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemCount: 1,
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding: Dimens.edgeInsetsBottom10,
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: ColorsValue.textfildbackcolor,
                      //             borderRadius: BorderRadius.circular(
                      //               Dimens.five,
                      //             ),
                      //           ),
                      //           child: Padding(
                      //             padding: Dimens.edgeInsets0_5_0_5,
                      //             child: ListTile(
                      //               title: Text(
                      //                 "data",
                      //                 style: Styles.black70016,
                      //               ),
                      //               subtitle: Container(
                      //                 child: RatingBar.builder(
                      //                   ignoreGestures: true,
                      //                   initialRating: controller.ratting,
                      //                   minRating: 1,
                      //                   direction: Axis.horizontal,
                      //                   allowHalfRating: true,
                      //                   itemCount: 5,
                      //                   itemSize: 20,
                      //                   unratedColor: ColorsValue.grey,
                      //                   itemPadding: const EdgeInsets.symmetric(
                      //                       horizontal: 0.0),
                      //                   itemBuilder: (context, _) => const Icon(
                      //                     Icons.star,
                      //                     color: Colors.amber,
                      //                   ),
                      //                   onRatingUpdate: (rating) {},
                      //                 ),
                      //               ),
                      //               leading: Container(
                      //                 height: Dimens.fifty,
                      //                 width: Dimens.fifty,
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(
                      //                     Dimens.hundred,
                      //                   ),
                      //                   color: ColorsValue.maincolor1,
                      //                 ),
                      //                 child: Image.asset(
                      //                   AssetConstants.usera,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      // CustomButton(
                      //   text: "inquiry_message".tr,
                      //   onTap: () {},
                      //   height: Dimens.fifty,
                      // ),
                      // Dimens.boxHeight30
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
