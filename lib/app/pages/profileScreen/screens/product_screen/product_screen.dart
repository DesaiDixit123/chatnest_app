import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BusinessProductScreen extends GetWidget<ProfileController> {
  const BusinessProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<ProfileController>(
      initState: (state) {
        controller.productPagingController = PagingController(firstPageKey: 1);
        controller.businessIds = Get.arguments ?? "";
        controller.productPagingController
            .addPageRequestListener((pageKey) async {
          await controller.getproductList(pageKey);
        });
        controller.getProductCategory(isLoading: true);
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
                "products".tr,
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
            RouteManagement.goToaddbusinessProductScreen("");
          },
          backgroundColor: ColorsValue.maincolor1,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: ColorsValue.transparent),
          ),
          child: const Icon(
            Icons.add,
            color: ColorsValue.white,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.productSearchController,
                        hintText: 'search'.tr,
                        onChanged: (value) {
                          _debouncer.run(() {
                            Future.sync(() {
                              return controller.productPagingController
                                  .refresh();
                            });
                          });
                        },
                        fillColor: ColorsValue.textfildbackcolor,
                        suffixIcon: Icon(
                          Icons.search,
                          size: Dimens.twentyFour,
                          color: ColorsValue.hookupHeaderGreyColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: Dimens.edgeInsets10_07_0_0,
                      child: InkWell(
                        onTap: () {
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
                                      padding: Dimens.edgeInsets20_10_20_30,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: Dimens.five,
                                                width: Dimens.seventy,
                                                decoration: BoxDecoration(
                                                  color: ColorsValue.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.hundred),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Dimens.boxHeight20,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "product_filter".tr,
                                                style: Styles.black50020,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  height: Dimens.thirty,
                                                  width: Dimens.thirty,
                                                  padding: Dimens.edgeInsets5,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.cancleicon,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Dimens.boxHeight20,
                                          Text(
                                            "select_product_category".tr,
                                            style: Styles.hookup40014,
                                          ),
                                          DropdownMultipleTree(
                                            isMultipleSelctionEnable: true,
                                            hintText: 'category'.tr,
                                            itemList: controller
                                                .productCatagoriesList
                                                .map((e) => DropdownMultipleTreeModel(
                                                    name:
                                                        e.categoryname!.trim(),
                                                    subItems: e.subcategories
                                                        ?.map((subItem) => DropdownItemModel(
                                                            mainCatagoriesName:
                                                                e.categoryname!,
                                                            mainCatagoriesId:
                                                                e.id,
                                                            name: subItem
                                                                .categoryname!,
                                                            id: subItem
                                                                .categoryid))
                                                        .toList()))
                                                .toList(),
                                            multipleSelectedList: controller
                                                .selectFilterProductcategory,
                                            onMultiSelected: (val) {
                                              controller
                                                      .selectFilterProductcategory =
                                                  val;
                                              setState(() {});
                                            },
                                            prefixIcon: Padding(
                                              padding: Dimens.edgeInsets10,
                                              child: Wrap(
                                                runAlignment:
                                                    WrapAlignment.center,
                                                spacing: Dimens.ten,
                                                runSpacing: Dimens.ten,
                                                children: List.generate(
                                                  controller
                                                      .selectFilterProductcategory
                                                      .length,
                                                  (index) => InkWell(
                                                    onTap: () {
                                                      controller
                                                          .selectFilterProductcategory
                                                          .removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding:
                                                          Dimens.edgeInsets5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: ColorsValue
                                                                  .appColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(Dimens
                                                                      .eight)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                TextSpan(
                                                                    text: controller
                                                                        .selectFilterProductcategory[
                                                                            index]
                                                                        .mainCatagoriesName,
                                                                    style: Styles
                                                                        .black50014),
                                                                TextSpan(
                                                                    text:
                                                                        ' (${controller.selectFilterProductcategory[index].name}) ',
                                                                    style: Styles
                                                                        .grey9BA40012)
                                                              ])),
                                                          Dimens.boxWidth2,
                                                          Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            color: ColorsValue
                                                                .redColor,
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
                                          CustomBottomButton(
                                            firstOnPressed: () {
                                              Get.back();
                                              controller
                                                  .selectFilterProductcategory
                                                  .clear();
                                              controller.productPagingController
                                                  .refresh();
                                              setState(() {});
                                            },
                                            firstbtnText:
                                                'clear'.tr.toUpperCase(),
                                            secondOnPressed: () {
                                              Get.back();
                                              controller.productPagingController
                                                  .refresh();
                                              setState(() {});
                                            },
                                            secondbtnTxt:
                                                'apply'.tr.toUpperCase(),
                                            firstStyle: Styles.hinttext50014,
                                            secondStyle: Styles.white50014,
                                            bordercolor: ColorsValue.grey,
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
                        child: Container(
                          width: Dimens.fourtyFive,
                          height: Dimens.fourtyFive,
                          decoration: BoxDecoration(
                            color: ColorsValue.maincolor1,
                            borderRadius: BorderRadius.circular(Dimens.five),
                          ),
                          child: Padding(
                            padding: Dimens.edgeInsets10,
                            child: SvgPicture.asset(
                              AssetConstants.filterIcon,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Dimens.boxHeight20,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.productPagingController.refresh(),
                    ),
                    color: ColorsValue.appColor,
                    child: PagedListView<int, GetProductListDoc>(
                      pagingController: controller.productPagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<GetProductListDoc>(
                        noItemsFoundIndicatorBuilder: (_) => Center(
                          child: Center(
                            child: Image.asset(
                              AssetConstants.emptyproductimage,
                            ),
                          ),
                        ),
                        itemBuilder: (BuildContext context, item, int index) {
                          return Padding(
                            padding: Dimens.edgeInsets0_5_0_5,
                            child: InkWell(
                              onTap: () {
                                RouteManagement.goTobusinessProductdetailScreen(
                                    item.id);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: Dimens.sixtyThree,
                                    width: Dimens.sixtyThree,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            ApiWrapper.imageUrl + item.image,
                                        fit: BoxFit.cover,
                                        maxHeightDiskCache: 300,
                                        maxWidthDiskCache: 300,
                                        width: Dimens.sixtyThree,
                                        height: Dimens.sixtyThree,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          AssetConstants.businessproduct,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          AssetConstants.businessproduct,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Dimens.boxWidth10,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.name,
                                              style: Styles.black50014,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controller.showdeletdilog(
                                                        item.id);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(Dimens
                                                                    .five),
                                                        border: Border.all(
                                                            width: Dimens.one,
                                                            color: ColorsValue
                                                                .redColor)),
                                                    child: Padding(
                                                      padding:
                                                          Dimens.edgeInsets5,
                                                      child: SvgPicture.asset(
                                                          AssetConstants
                                                              .deletIcon),
                                                    ),
                                                  ),
                                                ),
                                                Dimens.boxWidth10,
                                                InkWell(
                                                  onTap: () {
                                                    RouteManagement
                                                        .goToaddbusinessProductScreen(
                                                            item.id);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(Dimens
                                                                    .five),
                                                        border: Border.all(
                                                            width: Dimens.one,
                                                            color: ColorsValue
                                                                .maincolor1)),
                                                    child: Padding(
                                                      padding:
                                                          Dimens.edgeInsets5,
                                                      child: SvgPicture.asset(
                                                          AssetConstants
                                                              .editIcon),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Dimens.boxHeight3,
                                        Text(
                                          item.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.greyColor888840012,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: Dimens.edgeInsets5_2_5_2,
                                              decoration: BoxDecoration(
                                                color: ColorsValue.redColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.five),
                                              ),
                                              child: Text(
                                                item.offerType == "amount"
                                                    ? "${item.offer} ${'currency_off'.tr}"
                                                    : '${item.offer} ${'percent_off'.tr}',
                                                style: Styles.white40012,
                                              ),
                                            ),
                                            Dimens.boxWidth10,
                                            Text(
                                              "${'currency_symbol'.tr}${item.price}",
                                              style: Styles.main50014,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // CustomBottomButton(
                //   firstbtnText: 'addbusiness'.tr.toUpperCase(),
                //   secondbtnTxt: 'skip_for_now'.tr.toUpperCase(),
                //   firstOnPressed: () {
                //     RouteManagement.goToBusinessProfileScreen('');
                //   },
                //   secondOnPressed: () {
                //     Get.offAllNamed(Routes.homeScreen);
                //   },
                //   firstStyle: Styles.main50014,
                //   secondStyle: Styles.white50014,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
