import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(
      milliseconds: 500,
    );
    return GetBuilder<ProductController>(initState: (state) {
      var controller = Get.find<ProductController>();
      controller.postfriendsproducts();
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: GradientAppBar(
         // shadowColor: ColorsValue.greyAAAAAA,
        //  backgroundColor: ColorsValue.white,
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
            'products'.tr,
            style: Styles.black70018,
          ),
        ),
        // bottomNavigationBar: SafeArea(
        //   child: Padding(
        //     padding: Dimens.edgeInsets20_0_20_0,
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //               backgroundColor: ColorsValue.whiteColor,
        //               fixedSize: Size(double.infinity, Dimens.fourtyFive),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(5.0),
        //                 side: BorderSide(
        //                   width: 1,
        //                   color: ColorsValue.greyAAAAAA,
        //                 ),
        //               ),
        //             ),
        //             onPressed: () {
        //               RouteManagement.goToProductDetailFilterScreen();
        //             },
        //             child: Text(
        //               "filter".tr,
        //               style: Styles.black50016,
        //             ),
        //           ),
        //         ),
        //         Dimens.boxWidth30,
        //         Expanded(
        //           child: ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //               backgroundColor: ColorsValue.whiteColor,
        //               fixedSize: Size(double.infinity, Dimens.fourtyFive),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(5.0),
        //                 side: BorderSide(
        //                   width: 1,
        //                   color: ColorsValue.greyAAAAAA,
        //                 ),
        //               ),
        //             ),
        //             onPressed: () {
        //               showModalBottomSheet(
        //                 context: context,
        //                 backgroundColor: ColorsValue.white,
        //                 builder: (context) {
        //                   return StatefulBuilder(
        //                     builder: (context, setState) {
        //                       return Container(
        //                         width: double.infinity,
        //                         decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.only(
        //                             topLeft: Radius.circular(Dimens.thirty),
        //                             topRight: Radius.circular(
        //                               Dimens.thirty,
        //                             ),
        //                           ),
        //                         ),
        //                         child: Padding(
        //                           padding: Dimens.edgeInsets20_10_20_30,
        //                           child: Column(
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                             mainAxisSize: MainAxisSize.min,
        //                             children: [
        //                               Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.center,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.center,
        //                                 children: [
        //                                   Container(
        //                                     height: Dimens.five,
        //                                     width: Dimens.seventy,
        //                                     decoration: BoxDecoration(
        //                                       color: ColorsValue.grey,
        //                                       borderRadius:
        //                                           BorderRadius.circular(
        //                                               Dimens.hundred),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                               Dimens.boxHeight20,
        //                               Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.spaceBetween,
        //                                 children: [
        //                                   Text(
        //                                     "sort_by".tr,
        //                                     style: Styles.black50020,
        //                                   ),
        //                                   InkWell(
        //                                     onTap: () {
        //                                       Get.back();
        //                                     },
        //                                     child: SvgPicture.asset(
        //                                         AssetConstants.cancleicon),
        //                                   ),
        //                                 ],
        //                               ),
        //                               Row(
        //                                 children: [
        //                                   Transform.scale(
        //                                     scale: 1.2,
        //                                     child: Checkbox(
        //                                       checkColor: ColorsValue.white,
        //                                       activeColor:
        //                                           ColorsValue.maincolor1,
        //                                       value: controller.isHightoLow,
        //                                       onChanged: (value) {
        //                                         setState(() {
        //                                           controller.isHightoLow =
        //                                               value!;
        //                                         });
        //                                       },
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     "low_to_high".tr,
        //                                     style: Styles.greyColor888850014,
        //                                   )
        //                                 ],
        //                               ),
        //                               Row(
        //                                 children: [
        //                                   Transform.scale(
        //                                     scale: 1.2,
        //                                     child: Checkbox(
        //                                       checkColor: ColorsValue.white,
        //                                       activeColor:
        //                                           ColorsValue.maincolor1,
        //                                       value: controller.isLowtoHigh,
        //                                       onChanged: (value) {
        //                                         setState(() {
        //                                           controller.isLowtoHigh =
        //                                               value!;
        //                                         });
        //                                       },
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     "high_to_low".tr,
        //                                     style: Styles.greyColor888850014,
        //                                   )
        //                                 ],
        //                               ),
        //                               Row(
        //                                 children: [
        //                                   Transform.scale(
        //                                     scale: 1.2,
        //                                     child: Checkbox(
        //                                       checkColor: ColorsValue.white,
        //                                       activeColor:
        //                                           ColorsValue.maincolor1,
        //                                       value: controller.isNewest,
        //                                       onChanged: (value) {
        //                                         setState(() {
        //                                           controller.isNewest = value!;
        //                                         });
        //                                       },
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     "newest_arrival".tr,
        //                                     style: Styles.greyColor888850014,
        //                                   )
        //                                 ],
        //                               ),
        //                               Row(
        //                                 children: [
        //                                   Transform.scale(
        //                                     scale: 1.2,
        //                                     child: Checkbox(
        //                                       checkColor: ColorsValue.white,
        //                                       activeColor:
        //                                           ColorsValue.maincolor1,
        //                                       value: controller.isTopratted,
        //                                       onChanged: (value) {
        //                                         setState(() {
        //                                           controller.isTopratted =
        //                                               value!;
        //                                         });
        //                                       },
        //                                     ),
        //                                   ),
        //                                   Text(
        //                                     "top_rated".tr,
        //                                     style: Styles.greyColor888850014,
        //                                   )
        //                                 ],
        //                               ),
        //                               Dimens.boxHeight10,
        //                               CustomBottomButton(
        //                                 firstOnPressed: () {},
        //                                 firstbtnText: 'clear'.tr.toUpperCase(),
        //                                 secondOnPressed: () {},
        //                                 secondbtnTxt: 'apply'.tr.toUpperCase(),
        //                                 firstStyle: Styles.hinttext50014,
        //                                 secondStyle: Styles.white50014,
        //                                 bordercolor: ColorsValue.greyColor8888,
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   );
        //                 },
        //               );
        //             },
        //             child: Text(
        //               "sort_by".tr,
        //               style: Styles.black50016,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: Padding(
          padding: Dimens.edgeInsets20,
          child: Column(
            children: [
              CustomTextFormField(
                controller: controller.productSearchController,
                hintText: 'search'.tr,
                fillColor: ColorsValue.textfildbackcolor,
                suffixIcon: Icon(
                  Icons.search,
                  size: Dimens.twentyFour,
                  color: ColorsValue.hookupHeaderGreyColor,
                ),
                onChanged: (value) {
                  _debouncer.run(() {
                    Future.sync(
                      () {
                        return controller.postfriendsproducts();
                      },
                    );
                  });
                },
              ),
              Dimens.boxHeight20,
              Expanded(
                child: controller.friendProductList?.isEmpty ?? false
                    ? Center(
                        child: SvgPicture.asset(
                          AssetConstants.ic_product_empty,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => Future.sync(
                          () => controller.postfriendsproducts(),
                        ),
                         color: ColorsValue.appColor,
                        child: GridView.builder(
                          itemCount: controller.friendProductList?.length ?? 0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: Dimens.twoHundredTwentyTwo,
                            crossAxisSpacing: Dimens.twenty,
                            mainAxisSpacing: Dimens.ten,
                          ),
                          itemBuilder: ((context, index) {
                            var item = controller.friendProductList?[index];
                            return InkWell(
                              onTap: () {
                                RouteManagement.goToProductDetailsScreen(controller.friendProductList?[index].id ??"");
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    height: Dimens.hundredFifty,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Dimens.five,
                                      ),
                                      border: Border.all(
                                        color: ColorsValue.greyAAAAAA,
                                        width: Dimens.one,
                                      ),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.five,
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
                                        )),
                                  ),
                                  Dimens.boxHeight5,
                                  Text(
                                    item?.name ?? "",
                                    style: Styles.black40014,
                                  ),
                                  Dimens.boxHeight2,
                                  Text(
                                    item?.description ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.greyColor888840012,
                                  ),
                                  Dimens.boxHeight2,
                                  Row(
                                    children: [
                                      Text(
                                        "₹${item?.price ?? ""}",
                                        style: Styles.main60012,
                                      ),
                                      Dimens.boxWidth6,
                                      // RatingBar(
                                      //   ratingWidget: RatingWidget(
                                      //     full: SvgPicture.asset(
                                      //         AssetConstants.ic_select_star),
                                      //     half: SvgPicture.asset(
                                      //         AssetConstants.ic_select_star),
                                      //     empty: SvgPicture.asset(
                                      //         AssetConstants.ic_unselect_star),
                                      //   ),
                                      //   ignoreGestures: true,
                                      //   initialRating: 4,
                                      //   minRating: 1.0,
                                      //   direction: Axis.horizontal,
                                      //   allowHalfRating: true,
                                      //   itemCount: 5,
                                      //   itemSize: Dimens.fifteen,
                                      //   unratedColor: ColorsValue.grey,
                                      //   glowColor: Colors.black,
                                      //   itemPadding: EdgeInsets.symmetric(
                                      //     horizontal: Dimens.two,
                                      //   ),
                                      //   onRatingUpdate: (rating) {},
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
