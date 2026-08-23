import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChatProductScreen extends StatelessWidget {
  const ChatProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.postfriendsproducts();
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
            title: Text(
              'products'.tr,
              style: Styles.black70018,
            ),
          ),
          body: controller.friendProductList?.isNotEmpty ?? false
              ? ListView.builder(
                  itemCount: controller.friendProductList?.length ?? 0,
                  itemBuilder: (context, index) {
                    var item = controller.friendProductList?[index];
                    return Padding(
                      padding: Dimens.edgeInsets20_10_20_10,
                      child: ListTile(
                        onTap: () {
                          RouteManagement.goToChatProductDetailsScreen(
                              item?.id ?? "");
                        },
                        contentPadding: Dimens.edgeInsets0,
                        leading: Container(
                          height: Dimens.sixty,
                          width: Dimens.sixty,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              Dimens.five,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimens.five,
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  ApiWrapper.imageUrl + (item?.image ?? ""),
                              height: Dimens.sixty,
                              width: Dimens.sixty,
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
                        title: Text(
                          item?.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.black50014,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item?.description ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.greyColor888840012,
                            ),
                            Dimens.boxHeight3,
                            Text(
                              "${'currency_symbol'.tr} ${item?.price.toString()}",
                              style: Styles.greyColor888840012,
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () {
                            controller.sendMessageController.clear();
                            controller.isReplyChat = true;
                            controller.isProductSend = true;
                            controller.friendProductDoc = item;
                            controller.update();
                            if (Get.arguments ?? false) {
                              Get.back();
                              Get.back();
                            } else {
                              Get.back();
                            }
                          },
                          child: Container(
                            padding: Dimens.edgeInsets5,
                            decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius:
                                    BorderRadius.circular(Dimens.five)),
                            child: Text(
                              "inquiry_message".tr,
                              style: Styles.white40014,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: SvgPicture.asset(
                    AssetConstants.ic_product_empty,
                  ),
                ),
        );
      },
    );
  }
}
