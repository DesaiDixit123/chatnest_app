import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:chatnest/app/app.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../data/helpers/api_wrapper.dart';

class BlockUserScreen extends StatelessWidget {
  const BlockUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      builder: (controller) => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => controller.blockUserPagingController.refresh(),
        ),
        color: ColorsValue.appColor,
        child: PagedListView<int, BlockedUserDoc>(
          pagingController: controller.blockUserPagingController,
          builderDelegate: PagedChildBuilderDelegate<BlockedUserDoc>(
            noItemsFoundIndicatorBuilder: (_) => Center(
              child: SvgPicture.asset(
                AssetConstants.ic_block_user_empty,
              ),
            ),
            itemBuilder:
                (BuildContext context, BlockedUserDoc item, int index) {
              return Padding(
                padding: Dimens.edgeInsets20_05_20_05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: Dimens.edgeInsets0,
                      isThreeLine: false,
                      leading: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.hundred,
                          ),
                          color: ColorsValue.maincolor1,
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimens.hundred),
                          child: ApiWrapper.isValidImageUrl(item.profileimage)
                              ? CachedNetworkImage(
                                  imageUrl:
                                      ApiWrapper.imageUrl + item.profileimage,
                                  fit: BoxFit.cover,
                                  maxHeightDiskCache: 90,
                                  maxWidthDiskCache: 90,
                                  width: Dimens.fifty,
                                  height: Dimens.fifty,
                                  placeholder: (context, url) =>
                                      Image.asset(AssetConstants.usera),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(AssetConstants.usera),
                                )
                              : Image.asset(
                                  AssetConstants.usera,
                                  fit: BoxFit.cover,
                                  width: Dimens.fifty,
                                  height: Dimens.fifty,
                                ),
                        ),
                      ),
                      title: Text(
                        item.fullName.isNotEmpty
                            ? item.fullName
                            : item.nickName,
                        style: Styles.black50016,
                      ),
                      subtitle: item.nickName.isNotEmpty &&
                              item.nickName != item.fullName
                          ? Text(
                              item.nickName,
                              style: Styles.greyColor888840014,
                            )
                          : null,
                      trailing: _buildUnblockButton(context, controller, item),
                    ),
                    Dimens.boxHeight10,
                    Divider(
                      height: Dimens.ten,
                      color: ColorsValue.textfildbackcolor,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUnblockButton(
    BuildContext context,
    RequestController controller,
    BlockedUserDoc item,
  ) {
    return InkWell(
      onTap: () async {
        await Get.dialog(
          Padding(
            padding: Dimens.edgeInsetsTop20,
            child: Material(
              color: ColorsValue.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: Dimens.edgeInsets20_0_20_0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsValue.white,
                        borderRadius: BorderRadius.circular(Dimens.fifteen),
                      ),
                      child: Padding(
                        padding: Dimens.edgeInsets25_30_25_30,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () => Get.back(),
                                child: SvgPicture.asset(
                                  AssetConstants.cancleicon,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              AssetConstants.canclepopupicon,
                            ),
                            Dimens.boxHeight18,
                            Text(
                              'unblock_request'.tr,
                              style: Styles.black70020,
                            ),
                            Dimens.boxHeight10,
                            Text(
                              'are_you_sure_unblock'.tr,
                              style: Styles.greyColor888840014,
                            ),
                            Dimens.boxHeight18,
                            CustomBottomButton(
                              firstbtnText: 'cancle'.tr.toUpperCase(),
                              secondbtnTxt: 'unblock'.tr.toUpperCase(),
                              firstStyle: Styles.greyColor888850014,
                              secondStyle: Styles.white50014,
                              bordercolor: ColorsValue.greyColor8888,
                              buttoncolor: ColorsValue.redColor,
                              firstOnPressed: () => Get.back(),
                              secondOnPressed: () {
                                Get.back();
                                controller.unblockUser(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.five),
          border: Border.all(
            color: ColorsValue.redColor,
            width: Dimens.one,
          ),
        ),
        child: Padding(
          padding: Dimens.edgeInsets50_5_50_5,
          child: Text(
            'unblock'.tr.toUpperCase(),
            style: Styles.redcolor50012,
          ),
        ),
      ),
    );
  }
}
